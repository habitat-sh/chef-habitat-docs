+++
title = "Plans, hooks, and configuration guide"
description = "A comprehensive guide to writing Chef Habitat plans, lifecycle hooks, and configuration templates"
summary = "Everything you need to know about writing plans, defining lifecycle hooks, and templating configuration—including platform-specific packages, the install hook, and config_install."

[menu.plans]
    title = "Plans, hooks, and config guide"
    identifier = "plans/plans-hooks-config-guide"
    parent = "plans"
    weight = 20
+++

This guide brings together everything you need to write a complete Chef Habitat plan, including lifecycle hooks and configuration templates. It covers topics that span multiple reference pages and fills in gaps around platform-specific plans, the `install` and `uninstall` hooks, and the `config_install` directory.

If you're looking for a quick start, see [Plan writing](plan_writing). For detailed reference on individual topics, see [Plan settings](../reference/plan_settings.md), [Application lifecycle hooks](../reference/application_lifecycle_hooks.md), and [Configuration templates](../reference/config_templates.md).

## Anatomy of a plan

A plan is a directory containing everything Chef Habitat needs to build, configure, and run your application. At minimum it contains a `plan.sh` (Linux/ARM) or `plan.ps1` (Windows) file. A fully-featured plan looks like this:

```plain
my-app/
├── habitat/
│   ├── plan.sh              # Build instructions (required)
│   ├── default.toml         # Default configuration values
│   ├── config/              # Runtime configuration templates
│   │   └── app.conf
│   ├── config_install/      # Install-time configuration templates
│   │   └── setup.conf
│   └── hooks/               # Lifecycle hook scripts
│       ├── install
│       ├── uninstall
│       ├── init
│       ├── run
│       ├── post-run
│       ├── post-stop
│       ├── health-check
│       ├── reconfigure
│       ├── file-updated
│       └── suitability
```

### Plan files

The plan file (`plan.sh` or `plan.ps1`) is the only **required** file. It declares your package metadata and build logic. Everything else—hooks, config templates, and `default.toml`—is optional.

```bash plan.sh
pkg_name=my-app
pkg_origin=myorigin
pkg_version=1.0.0
pkg_maintainer="Your Name <you@example.com>"
pkg_license=('Apache-2.0')
pkg_deps=(core/glibc core/openssl)
pkg_build_deps=(core/gcc core/make)
pkg_bin_dirs=(bin)
pkg_svc_run="my-app --config {{pkg.svc_config_path}}/app.conf"
```

For the complete list of plan settings, see [Plan settings](../reference/plan_settings.md).

### default.toml

The `default.toml` file provides default values for any configuration elements you templatize in `config/` or `hooks/`. It uses [TOML](https://toml.io/) format.

```toml default.toml
# Network configuration
[server]
port = 8080
host = "0.0.0.0"

# Application settings
log_level = "info"
max_connections = 100
```

These values can be overridden at runtime with `hab config apply` or through environment variables.

## Writing hooks

Hooks are scripts that run at different points in a service's lifecycle. Each hook is a file in the `hooks/` directory named after the lifecycle event it handles. Hooks are Handlebars templates—they are rendered with your configuration data before execution.

Every hook must begin with a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line specifying its interpreter. On Windows, PowerShell Core is always used regardless of the shebang.

```bash hooks/init
#!/bin/bash

exec 2>&1
echo "Initializing {{pkg.name}} version {{pkg.version}}"
mkdir -p {{pkg.svc_data_path}}/cache
```

You may optionally add a file extension to hook files (e.g., `run.sh` or `health-check.sh`) for editor syntax highlighting. However, you **cannot** have two files for the same hook with different extensions (e.g., `run.sh` and `run.ps1` in the same `hooks/` directory). For multi-platform support, use [target directories](#platform-specific-plans) instead.

### Complete list of hooks

Chef Habitat supports the following lifecycle hooks. They are listed in the order they typically execute during a service's lifecycle:

| Hook | File name | When it runs | Can block? |
|------|-----------|--------------|------------|
| [install](#install) | `hooks/install` | When a package is first installed | No |
| [init](#init) | `hooks/init` | When the Supervisor starts a service | No |
| [run](#run) | `hooks/run` | After init; the main service process | **Yes** |
| [post-run](#post-run) | `hooks/post-run` | After the run hook starts | No |
| [reconfigure](#reconfigure) | `hooks/reconfigure` | When configuration changes (if defined) | No |
| [file-updated](#file-updated) | `hooks/file-updated` | When a non-service configuration file changes | No |
| [health-check](#health-check) | `hooks/health-check` | Periodically (default: every 30s) | No |
| [suitability](#suitability) | `hooks/suitability` | During leader elections | No |
| [post-stop](#post-stop) | `hooks/post-stop` | After the service stops | No |
| [uninstall](#uninstall) | `hooks/uninstall` | When the last version of a package is uninstalled | No |

{{< warning >}}
You **cannot** block the thread in any hook except the `run` hook. Never call `hab` or `sleep` in a hook that isn't the `run` hook.
{{< /warning >}}

### install

**File**: `hooks/install`

The `install` hook runs when a package is first installed on a system. Unlike other hooks, it is **not** part of the Supervisor's service lifecycle—it runs during package installation, triggered by `hab pkg install` or when the Supervisor loads a new package.

Key characteristics:

- **Any package** can define an install hook, not just packages loaded as services.
- **Dependencies' install hooks** also run. If a package in `pkg_deps` or `pkg_build_deps` has its own `install` hook and hasn't been installed yet, that hook executes when the parent package is installed. However, `install` hooks in runtime dependencies (`pkg_deps`) won't run during a `build` inside a Studio.
- **Exit code is remembered.** The exit code is written to an `INSTALL_HOOK_STATUS` file in the package directory. If a previously installed package is installed again or loaded into a Supervisor, its `install` hook only re-runs if it previously failed (non-zero exit) or was skipped (e.g., `--ignore-install-hook` was passed).
- **No census data.** The `install` hook doesn't have access to binds, the `svc` namespace, or runtime configuration in `svc_config_path`. If your install hook needs templated configuration, use the `config_install/` directory (see [config_install](#the-config_install-directory) below).

```bash hooks/install
#!/bin/bash

exec 2>&1
echo "Running install hook for {{pkg.name}}"

# Example: create required system directories
mkdir -p /var/log/{{pkg.name}}
chown {{pkg.svc_user}}:{{pkg.svc_group}} /var/log/{{pkg.name}}
```

### uninstall

**File**: `hooks/uninstall`

The `uninstall` hook runs when the **last** version/revision of a package (`origin/name`) is removed from the system. If other versions remain installed, the hook is skipped. When multiple revisions are uninstalled simultaneously, they are removed oldest-to-newest so that the latest revision's hook is the one that executes.

Like the `install` hook, the `uninstall` hook doesn't have access to `svc_config_path` or census data. Use `config_install/` for any templated configuration it needs.

```bash hooks/uninstall
#!/bin/bash

exec 2>&1
echo "Cleaning up {{pkg.name}}"

# Example: remove data directories created by install hook
rm -rf /var/log/{{pkg.name}}
```

### init

**File**: `hooks/init`

Runs once when the Supervisor first starts a service (or after a package update). Use it to perform one-time setup such as creating directories, initializing databases, or setting file permissions.

If the init hook fails (non-zero exit code), the service will be restarted with the [configured service backoff](../reference/service_restarts.md).

```bash hooks/init
#!/bin/bash

exec 2>&1
echo "Initializing {{pkg.name}}"

# Create data directories
mkdir -p {{pkg.svc_data_path}}/db
mkdir -p {{pkg.svc_var_path}}/run

# Set permissions
chown -R {{pkg.svc_user}}:{{pkg.svc_group}} {{pkg.svc_data_path}}
```

### run

**File**: `hooks/run`

The `run` hook is the **main process** for your service. It runs after `init` completes and is the only hook that **should** block—it should remain running for the lifetime of your service.

You can use the `run` hook instead of `pkg_svc_run` when you need more complex startup behavior. If neither is defined, your package won't run as a service.

Best practices:

- **Redirect stderr to stdout** with `exec 2>&1` at the top of the hook.
- **Use `exec`** to replace the shell process with your service command. This ensures proper signal handling and clean restarts.
- **Don't use `exec` with pipes.** If you need piping, run the command directly.
- Avoid commands that spawn child processes in separate process groups, as they may not be cleaned up on reconfiguration.

```bash hooks/run
#!/bin/bash

exec 2>&1

# Set environment variables
export APP_CONFIG={{pkg.svc_config_path}}/app.conf
export APP_DATA={{pkg.svc_data_path}}

# Start the service (exec replaces the shell process)
exec {{pkg.path}}/bin/my-app \
  --port {{cfg.server.port}} \
  --host {{cfg.server.host}} \
  --log-level {{cfg.log_level}}
```

{{< note >}}
If the run hook exits for **any reason** (including exit code 0), it is treated as a run failure. The service will be restarted with the [configured service backoff](../reference/service_restarts.md).
{{< /note >}}

### post-run

**File**: `hooks/post-run`

Runs after the `run` hook has started the service. Use it for tasks that require the service to already be running, such as creating database users, seeding data, or registering with a service discovery system.

If the `post-run` hook returns a non-zero exit code, it will be retried.

```bash hooks/post-run
#!/bin/bash

exec 2>&1
echo "Running post-start tasks for {{pkg.name}}"

# Wait for service to be ready
{{pkg.path}}/bin/my-app-cli wait-for-ready --port {{cfg.server.port}}

# Create default admin user
{{pkg.path}}/bin/my-app-cli create-user --name admin --role admin
```

### reconfigure

**File**: `hooks/reconfigure`

Runs when service configuration changes at runtime (via `hab config apply` or gossip). If this hook is defined, it executes **instead of** the default behavior of restarting the service. Use it for services that can reload their configuration without a full restart.

The `reconfigure` hook **won't** run if the service restarts before it has a chance to execute (for example, if a `run` hook change triggers a restart simultaneously). The restart is considered sufficient.

{{< warning >}}
Habitat doesn't support changing the PID of the underlying service in any lifecycle hook. If reconfiguration requires a PID change, don't define a `reconfigure` hook—let the default restart behavior handle it.
{{< /warning >}}

```bash hooks/reconfigure
#!/bin/bash

exec 2>&1
echo "Reconfiguring {{pkg.name}}"

# Send SIGHUP to reload configuration
kill -HUP "$(cat {{pkg.svc_pid_file}})"
```

### file-updated

**File**: `hooks/file-updated`

Runs when a configuration file that isn't related to a user or about the state of the service instances is updated.

```bash hooks/file-updated
#!/bin/bash

exec 2>&1
echo "Configuration file updated for {{pkg.name}}"
```

### health-check

**File**: `hooks/health-check`

Runs periodically (default: every 30 seconds) to report service health. The Supervisor exposes health status through its HTTP API at `/health`.

The hook must return one of these exit codes:

| Exit code | Status |
|-----------|--------|
| 0 | OK |
| 1 | Warning |
| 2 | Critical |
| 3 | Unknown |
| Any other | Failed health check (stdout is captured as additional output) |

```bash hooks/health-check
#!/bin/bash

exec 2>&1

# Check if the service responds
response=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:{{cfg.server.port}}/healthz)

case "$response" in
  200)
    exit 0  # OK
    ;;
  503)
    exit 1  # Warning - service degraded
    ;;
  *)
    echo "Health check failed with HTTP status: $response"
    exit 2  # Critical
    ;;
esac
```

### suitability

**File**: `hooks/suitability`

Runs during leader elections to report a priority value. The last line printed to **stdout** must be a number (parsable as an unsigned 64-bit integer). The service with the highest suitability becomes the leader.

```bash hooks/suitability
#!/bin/bash

# Report suitability based on available disk space
disk_free=$(df -k {{pkg.svc_data_path}} | tail -1 | awk '{print $4}')
echo "$disk_free"
```

### post-stop

**File**: `hooks/post-stop`

Runs after a service has been stopped successfully. Use it to undo what the `init` hook set up, or to perform cleanup tasks.

```bash hooks/post-stop
#!/bin/bash

exec 2>&1
echo "Cleaning up after {{pkg.name}}"

# Remove PID file
rm -f {{pkg.svc_var_path}}/run/*.pid
```

## Configuration templates

Configuration templates let you create dynamic configuration files for your service using [Handlebars](https://handlebarsjs.com/) syntax. Place template files in the `config/` directory of your plan.

At runtime, the Supervisor renders these templates to `{{pkg.svc_config_path}}` (typically `/hab/svc/<pkg_name>/config/`). Templates are re-rendered whenever configuration values change.

### Template variables

Use double curly braces to reference template variables:

- **`{{cfg.*}}`** — User-tunable values from `default.toml` and runtime configuration
- **`{{pkg.*}}`** — Package metadata (name, version, paths, etc.)
- **`{{sys.*}}`** — System information (IP, hostname, ports)
- **`{{svc.*}}`** — Service group information (members, leader, etc.)
- **`{{bind.*}}`** — Bound service group information

For a complete reference of available template data, see [Service template data](../reference/service_templates.md).

### Example: full config template workflow

**1. Define defaults in `default.toml`:**

```toml default.toml
[server]
port = 8080
host = "0.0.0.0"
workers = 4

[logging]
level = "info"
format = "json"

[database]
pool_size = 10
```

**2. Create a template in `config/`:**

```plain config/app.conf
# Managed by Chef Habitat - do not edit
server {
  listen {{cfg.server.host}}:{{cfg.server.port}};
  workers {{cfg.server.workers}};
}

logging {
  level {{cfg.logging.level}};
  format {{cfg.logging.format}};
}

database {
  pool_size {{cfg.database.pool_size}};
  {{#if bind.database}}
  host {{bind.database.first.sys.ip}};
  port {{bind.database.first.cfg.port}};
  {{/if}}
}
```

**3. Reference the rendered config in your `run` hook or `pkg_svc_run`:**

```bash hooks/run
#!/bin/bash
exec 2>&1
exec {{pkg.path}}/bin/my-app --config {{pkg.svc_config_path}}/app.conf
```

### Using Handlebars helpers in templates

Habitat supports standard Handlebars helpers (`if`, `unless`, `each`, `with`, `lookup`, partials, and `log`) plus custom Habitat helpers. Some common patterns:

```handlebars
{{! Conditional configuration }}
{{#if cfg.ssl.enabled}}
ssl_certificate {{cfg.ssl.cert_path}};
ssl_certificate_key {{cfg.ssl.key_path}};
{{/if}}

{{! Iterating over service group members }}
{{#each svc.members}}
server {{sys.ip}}:{{../cfg.server.port}};
{{/each}}

{{! Using bind data }}
{{#if bind.cache}}
cache_host = "{{bind.cache.first.sys.ip}}"
cache_port = {{bind.cache.first.cfg.port}}
{{/if}}
```

{{< note >}}
When using `each` in a block expression, reference the parent context with `../` to access `cfg` values within the block.
{{< /note >}}

For the full list of helpers, see [Configuration helpers](../reference/plan_helpers.md).

### The config_install directory

The `config_install/` directory works like `config/`, but its templates are rendered **only during package installation** and are available exclusively to the `install` and `uninstall` hooks. Place templates here when your install hook needs access to configuration values.

Templates in `config_install/` are rendered to `{{pkg.svc_config_install_path}}` (typically `/hab/svc/<pkg_name>/config_install/`).

Key differences from `config/`:

| | `config/` | `config_install/` |
|---|---|---|
| Rendered when | Service starts and on config changes | Package installation only |
| Available to | All hooks and running service | `install` and `uninstall` hooks only |
| Re-rendered on config change | Yes | No |
| Has access to census/bind data | Yes | No |

Example:

```plain config_install/setup.conf
# Install-time configuration
data_directory = "{{pkg.svc_data_path}}"
log_directory = "/var/log/{{pkg.name}}"
```

```bash hooks/install
#!/bin/bash
exec 2>&1

# Read install-time config
source {{pkg.svc_config_install_path}}/setup.conf

mkdir -p "$data_directory" "$log_directory"
```

## Platform-specific plans

When your application targets multiple platforms (e.g., Linux on x86_64, Linux on ARM/aarch64, Windows), you can create platform-specific directories that contain the plan, hooks, and configuration for each target.

### Directory structure

Create a directory named after the platform target under your project root or under a `habitat/` directory:

```plain
my-app/
├── habitat/
│   ├── x86_64-linux/
│   │   ├── plan.sh
│   │   ├── default.toml
│   │   ├── config/
│   │   │   └── app.conf
│   │   └── hooks/
│   │       ├── init
│   │       ├── run
│   │       └── health-check
│   ├── aarch64-linux/
│   │   ├── plan.sh
│   │   ├── default.toml
│   │   ├── config/
│   │   │   └── app.conf
│   │   └── hooks/
│   │       ├── init
│   │       ├── run
│   │       └── health-check
│   └── x86_64-windows/
│       ├── plan.ps1
│       ├── default.toml
│       ├── config/
│       │   └── app.conf
│       └── hooks/
│           ├── init
│           ├── run
│           └── health-check
```

Each target directory is **self-contained**—it has its own plan file, hooks, config templates, and `default.toml`. This means you can have completely different hooks for different platforms.

### Supported target platforms

| Target | Description |
|--------|-------------|
| `x86_64-linux` | 64-bit Linux on x86 |
| `aarch64-linux` | 64-bit Linux on ARM |
| `x86_64-windows` | 64-bit Windows |

### Build resolution order

The build script searches for your plan in this order:

1. `<app_root>/<target>/`
2. `<app_root>/habitat/<target>/`
3. `<app_root>/`
4. `<app_root>/habitat/`

If a plan exists both inside and outside a target folder, the target-specific plan is used when building for that target. However, it's **strongly recommended** to avoid this—place each plan in its own target folder.

### When to use target directories

- **Always use target directories** when you need different hooks or config templates per platform.
- **Always use target directories** when you need different plan logic per platform (different build steps, dependencies, etc.).
- **You can skip target directories** if your plan has no hooks or config templates and you only need `plan.sh` + `plan.ps1` side-by-side.
- **You must use target directories** if you need separate plans for `x86_64-linux` and `aarch64-linux`, even if neither has hooks or config.

{{< note >}}
On Windows, only `plan.ps1` is used. On Linux and Linux on ARM, only `plan.sh` is used.
{{< /note >}}

### Platform-specific hook example

Here is a Linux run hook and a Windows run hook for the same application:

**`x86_64-linux/hooks/run`:**

```bash
#!/bin/bash
exec 2>&1
export LD_LIBRARY_PATH="{{pkg.path}}/lib:$LD_LIBRARY_PATH"
exec {{pkg.path}}/bin/my-app --port {{cfg.server.port}}
```

**`x86_64-windows/hooks/run`:**

```powershell
$env:PATH = "{{pkg.path}}\bin;$env:PATH"
& "{{pkg.path}}\bin\my-app.exe" --port {{cfg.server.port}}
```

## Template data available in hooks

All hooks (except `install` and `uninstall`) have access to the full set of [service template data](../reference/service_templates.md):

| Namespace | Description | Available in install/uninstall? |
|-----------|-------------|---------------------------------|
| `cfg` | User-tunable configuration from `default.toml` | Yes |
| `pkg` | Package metadata and paths | Yes |
| `sys` | System information (IP, hostname, ports) | No |
| `svc` | Service group membership and topology | No |
| `bind` | Bound service group information | No |

The `install` and `uninstall` hooks are limited because they run outside the Supervisor's service lifecycle—there is no running service group, no binds, and no census data.

## Putting it all together: a complete example

Here's a complete plan for a web application with all the pieces:

### Plan file

```bash habitat/plan.sh
pkg_name=my-web-app
pkg_origin=myorigin
pkg_version=1.0.0
pkg_maintainer="Your Name <you@example.com>"
pkg_license=('Apache-2.0')
pkg_description="A sample web application"
pkg_upstream_url="https://github.com/example/my-web-app"

pkg_deps=(core/glibc core/openssl core/curl)
pkg_build_deps=(core/gcc core/make core/pkg-config)
pkg_bin_dirs=(bin)

pkg_exports=(
  [port]=server.port
  [host]=server.host
)
pkg_exposes=(port)

pkg_binds_optional=(
  [database]="port host"
)

do_build() {
  ./configure --prefix="$pkg_prefix"
  make
}

do_install() {
  make install
}
```

### Default configuration

```toml habitat/default.toml
[server]
port = 8080
host = "0.0.0.0"
workers = 4

[logging]
level = "info"

[database]
pool_size = 10
```

### Configuration template

```plain habitat/config/app.conf
bind {{cfg.server.host}}:{{cfg.server.port}}
workers {{cfg.server.workers}}
log_level {{cfg.logging.level}}

{{#if bind.database}}
db_host {{bind.database.first.sys.ip}}
db_port {{bind.database.first.cfg.port}}
db_pool {{cfg.database.pool_size}}
{{/if}}
```

### Hooks

```bash habitat/hooks/install
#!/bin/bash
exec 2>&1
echo "Installing {{pkg.name}}"
mkdir -p /var/log/{{pkg.name}}
```

```bash habitat/hooks/init
#!/bin/bash
exec 2>&1
echo "Initializing {{pkg.name}}"
mkdir -p {{pkg.svc_data_path}}/sessions
chown {{pkg.svc_user}}:{{pkg.svc_group}} {{pkg.svc_data_path}}/sessions
```

```bash habitat/hooks/run
#!/bin/bash
exec 2>&1
exec {{pkg.path}}/bin/my-web-app \
  --config {{pkg.svc_config_path}}/app.conf
```

```bash habitat/hooks/health-check
#!/bin/bash
result=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:{{cfg.server.port}}/health)
if [ "$result" = "200" ]; then
  exit 0
else
  echo "Health check failed: HTTP $result"
  exit 2
fi
```

```bash habitat/hooks/post-stop
#!/bin/bash
exec 2>&1
rm -f {{pkg.svc_var_path}}/run/*.pid
```

## Hook best practices

### Do's

- **Redirect stderr to stdout** (`exec 2>&1`) in every hook.
- **Use `exec`** to start your main process in the `run` hook.
- **Keep hooks idempotent.** They may run multiple times.
- **Use template variables** (`{{pkg.*}}`, `{{cfg.*}}`) instead of hardcoded paths.
- **Write to the service directories** (`svc_data_path`, `svc_var_path`, `svc_static_path`) rather than arbitrary filesystem locations.

### Don'ts

- **Don't call `hab`** from within a hook. Use [runtime configuration settings](../reference/service_templates.md) instead.
- **Don't call `sleep`** or block in any hook except `run`.
- **Don't use `exec` with pipes.** Use direct commands instead.
- **Don't run commands as root** or use `sudo`.
- **Don't edit Supervisor-rendered templates** or write directly to `/hab/`.
- **Don't have two hook files with different extensions** for the same hook (e.g., `run.sh` and `run.ps1`). Use [target directories](#platform-specific-plans) for multi-platform support.

## Related resources

- [Plan settings reference](../reference/plan_settings.md) — All `pkg_*` variables
- [Plan variables reference](../reference/plan_variables.md) — Build-time path variables
- [Build phase callbacks](../reference/build_phase_callbacks.md) — Override build steps
- [Application lifecycle hooks](../reference/application_lifecycle_hooks.md) — Hook reference
- [Configuration templates](../reference/config_templates.md) — Template syntax
- [Service template data](../reference/service_templates.md) — Available template variables
- [Configuration helpers](../reference/plan_helpers.md) — Handlebars helpers
- [Service restarts](../reference/service_restarts.md) — Restart backoff behavior
