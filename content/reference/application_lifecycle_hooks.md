+++
title = "Application lifecycle hooks"
description = "Control service runtime actions with application lifecycle hooks"


[menu.reference]
    title = "Application lifecycle hooks"
    identifier = "reference/application-lifecycle-hooks plan Lifecycle Hooks"
    parent = "reference"

+++

Each plan can specify lifecycle event handlers, or hooks, to perform certain actions during a service's runtime. Each hook is a script with a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) defined at the top to specify the interpreter to be used. On Windows, PowerShell Core is the only interpreter ever used.

To define a hook, create a file of the same name in `/my_plan_name/hooks/`, for example, `/postgresql/hooks/health-check`.

Optionally you may add an extension to the hook file. For example, you might create `/postgresql/hooks/health-check.sh` which can be useful in some editors to automatically take advantage of syntax highlighting. Note that having two files for the same hook but with different extensions isn't permitted. For example you might create a `run.sh` and `run.ps1` to support both Linux and Windows packages. If you would like to create different hooks for different platforms, you must use [target directories](../plans/plan_writing.md#writing-a-plan-for-multiple-platform-targets).

{{< warning >}}
You can't block the thread in a hook unless it's in the `run` hook. Never call `hab` or `sleep` in a hook that isn't the `run` hook.
{{< /warning >}}

## Hooks and templates

All hooks are [Handlebars](https://handlebarsjs.com/) templates, rendered with configuration data before execution. You can use template variables like `{{cfg.port}}`, `{{pkg.svc_data_path}}`, and `{{sys.ip}}` in your hooks. See [Service template data](service_templates) for the full list of available template variables.

Most hooks have access to the complete set of template data (`cfg`, `pkg`, `sys`, `svc`, `bind`). The exceptions are the `install` and `uninstall` hooks, which don't have access to `sys`, `svc`, or `bind` data because they run outside of the Supervisor's service lifecycle.

## Platform-specific hooks

To create different hooks for different platforms (e.g., Linux vs. Windows, or x86_64 vs. aarch64), place each platform's hooks inside a target-specific directory structure:

```plain
my-app/
├── x86_64-linux/
│   ├── plan.sh
│   └── hooks/
│       ├── init
│       └── run
├── aarch64-linux/
│   ├── plan.sh
│   └── hooks/
│       ├── init
│       └── run
└── x86_64-windows/
    ├── plan.ps1
    └── hooks/
        ├── init
        └── run
```

Each target directory is self-contained with its own plan file, hooks, config, and `default.toml`. See [Writing a plan for multiple platform targets](../plans/plan_writing.md#writing-a-plan-for-multiple-platform-targets) for full details on directory layout and build resolution order.

## Hook summary

The following table lists all available hooks in the order they typically execute during a service's lifecycle:

| Hook | File name | When it runs | Can block? |
|------|-----------|--------------|------------|
| [install](#install) | `hooks/install` | Package installation | No |
| [init](#init) | `hooks/init` | Service start (one-time setup) | No |
| [run](#run) | `hooks/run` | After init; main service process | **Yes** |
| [post-run](#post-run) | `hooks/post-run` | After run hook starts | No |
| [reconfigure](#reconfigure) | `hooks/reconfigure` | On config change (replaces restart) | No |
| [file-updated](#file-updated) | `hooks/file-updated` | Non-service config file changes | No |
| [health-check](#health-check) | `hooks/health-check` | Periodically (default: 30s) | No |
| [suitability](#suitability) | `hooks/suitability` | During leader elections | No |
| [post-stop](#post-stop) | `hooks/post-stop` | After service stops | No |
| [uninstall](#uninstall) | `hooks/uninstall` | Last version of package removed | No |

For a comprehensive guide that ties plans, hooks, and configuration together, see [Plans, hooks, and configuration guide](../plans/plans_hooks_config_guide.md).

## Runtime settings

[Chef Habitat's runtime configuration settings](service_templates) can be used in any of the plan hooks and also in any templatized configuration file for your application or service.

### file-updated

File location: `<plan>/hooks/file-updated`. This hook is run whenever a configuration file that isn't related to a user or about the state of the service instances is updated.

### health-check

**File location**: `<plan>/hooks/health-check`. **Default**: 30 seconds

This hook repeats at a configured interval. The following are two exceptions to the interval used between `health-check` runs:

- If the `health-check` hook exits with a non-`ok` status the next `health-check` will run after the default `health-check` interval (thirty seconds). This is only done when the configured interval is greater than the default interval.
- If the `health-check` hook returns an `ok` status for the first time, then the next `health-check` will run after a randomly chosen delay between 0 and the configured `health-check` interval. This introduces a splay - a degree of difference - in the timing between the first and second `health-check` runs. All following health-check hooks run at the configured interval. The splay prevents more than one health-check hook from starting at the same time by giving each of them a unique starting point.

The `health-check` script must return a valid exit code from the list below.

- **0**- ok
- **1**- warning
- **2**- critical
- **3**- unknown
- any other code - failed health check with additional output taken from `health-check` stdout.

A `health-check` hook can use the following as a template:

```bash hooks/health-check
#!/bin/sh

# define default return code as 0
rc=0
program_that_returns_a_status
case $? in
  0)
    rc=1 ;;
  3)
    rc=0 ;;
  4)
    rc=2 ;;
  *)
    rc=3 ;;
esac

exit $rc
```

### init

File location: `<plan>/hooks/init`. This hook is run when a Chef Habitat topology starts.

{{< note >}}

If the init hook fails with a non-zero exit code, the service will be restarted with the [configured service backoff](service_restarts).

{{< /note >}}

### install

File location: `<plan>/hooks/install`. This hook is run when a package is initially installed.

An `install` hook may be triggered by `hab pkg install` or by a Supervisor loading a new package. Note that any package can define an `install` hook and it isn't limited to packages that are loaded as services into a Supervisor. A package may have dependencies defined in `pkg_deps` or `pkg_build_deps` that define their own `install` hook. An `install` hook defined in an dependant package that hasn't yet been installed will run when the parent package is installed. However `install` hooks in a runtime dependency (`pkg_deps`) won't run when loaded with a package `build` inside of a Studio.

The exit code returned from an `install` hook will be remembered. If a previously installed package is either installed again with `hab pkg install` or loaded into a Supervisor, its `install` hook will be rerun if it previously failed (exited with a non `0` result) or hasn't been previously run (perhaps because `--ignore-install-hook` was passed to `hab pkg install`).

An `install` hook, unlike other hooks, won't have access to any census data exposed with binds or the `svc` namespace. Also, configuration in `svc_config_path`isn't accessible to an `install` hook. If an `install` hook needs to use templated configuration files, templates located in the `svc_config_install_path` may be referenced. This location will contain rendered templates in a package's `config_install` folder. Finally, any configuration updates made during a service's runtime that would alter an `install` hook or any configuration template in `svc_config_install_path` won't cause a service to reload.

An `install` hook can use the following as a template:

```bash hooks/install
#!/bin/bash

exec 2>&1
echo "Installing {{pkg.name}}"

# Create required system directories
mkdir -p /var/log/{{pkg.name}}
chown {{pkg.svc_user}}:{{pkg.svc_group}} /var/log/{{pkg.name}}

# Use config_install templates for install-time configuration
if [ -f "{{pkg.svc_config_install_path}}/setup.conf" ]; then
  source "{{pkg.svc_config_install_path}}/setup.conf"
fi
```

{{< note >}}
The exit code of the install hook is written to an `INSTALL_HOOK_STATUS` file in the package directory. This file is checked on subsequent installs to determine whether the hook needs to re-run.
{{< /note >}}

### reconfigure

File location: `<plan>/hooks/reconfigure`. A `reconfigure` hook can be written for services that can respond to changes in `<plan>/config` without requiring a restart. This hook will execute **instead** of the default behavior of restarting the process. `{{pkg.svc_pid_file}}` can be used to get the `PID` of the service.

Habitat doesn't support changing the `PID` of the underlying service in any lifecycle hook. If part of a service's reconfiguration relies on changing the `PID`, you shouldn't provide a `reconfigure` hook, and instead, use the default behavior of restarting the service for reconfiguration.

The `reconfigure` hook isn't necessarily run on every change to `<plan>/config`. The `reconfigure` hook won't be run if the service restarts before the `reconfigure` hook has run. The restart is considered sufficient for reconfiguring the service. For example, when applying a configuration that changes both the `run` hook and `<plan>/config`, the change to the `run` hook will trigger a restart. Therefore, the `reconfigure` hook won't be run. To put it another way, the `reconfigure` hook will only respond to changes in `<plan>/config` after the service has started.

### suitability

File location: `<plan>/hooks/suitability`. The suitability hook allows a service to report a priority by which it should be elected leader. The hook is called when a new election is triggered and the last line it outputs to `stdout` should be a number parsable as a `u64`. In the event that a leader goes down and an election is started the service with the highest reported suitability will become the new leader.

### run

File location: `<plan>/hooks/run`. This hook is run when one of the following conditions occur:

- The main topology starts, after the `init` hook has been called.
- When a package is updated, after the `init` hook has been called.
- When the package config changes, after the `init` hook has been called, but before a `reconfigure` hook is called.

You can use this hook in place of `$pkg_svc_run` when you need more complex behavior such as setting environment variables or command options that are based on dynamic configuration.

Services run using this hook should do two things:

- Redirect stderr to stdout (for example with `exec 2>&1` at the start of the hook)
- Call the command to execute with `exec <command> <options>` rather than running the command directly. This ensures the command is executed in the same process and that the service will restart correctly on configuration changes.

It's important to also consider what side effects the command to execute will have. For example, does the command spin off other processes in separate process groups? If so, they may not be cleaned up automatically when the system is reconfigured. In general, the command executed should behave in a manner similar to a daemon, and be able to clean up properly after itself when it receives a SIGTERM, and properly forward signals to other processes that it creates. For an even more specific example: let's say you are trying to start a node.js service. Instead of your command being `npm start`, you should use `node server.js` directly.

A run hook can use the following as a template:

```bash hooks/run
#!/bin/sh

#redirect stderr
exec 2>&1

# Set some environment variables
export MY_ENVIRONMENT_VARIABLE=1
export MY_OTHER_ENVIRONMENT_VARIABLE=2

# Run the command
exec my_command --option {{cfg.option}} --option2 {{cfg.option2}}
```

{{< note >}}

If the run hook exits it will be considered as a run failure. The service will be restarted with the [configured service backoff](service_restarts) regardless of the exit code that
was returned by the hook.

{{< /note >}}

### post-run

File location: `<plan>/hooks/post-run`. The post run hook will get executed after initial startup. For many data services creation of specific users / roles or datastores is required. This needs to happen once the service has already started.

If the `post-run` hook returns a non-zero exit code, it will be retried.

A `post-run` hook can use the following as a template:

```bash hooks/post-run
#!/bin/bash

exec 2>&1
echo "Running post-start tasks for {{pkg.name}}"

# Wait for the service to become available
for i in $(seq 1 30); do
  if curl -s http://127.0.0.1:{{cfg.port}}/health > /dev/null 2>&1; then
    break
  fi
  sleep 1
done

# Create default database/user if needed
{{pkg.path}}/bin/my-app-cli setup --defaults
```

### post-stop

File location: `<plan>/hooks/post-stop`. The post-stop hook will get executed after service has been stopped successfully. You may use this hook to undo what the `init` hook has done.

A `post-stop` hook can use the following as a template:

```bash hooks/post-stop
#!/bin/bash

exec 2>&1
echo "Cleaning up after {{pkg.name}}"

# Remove PID files and temporary state
rm -f {{pkg.svc_var_path}}/run/*.pid
rm -rf {{pkg.svc_var_path}}/tmp
```

### uninstall

File location: `<plan>/hooks/uninstall`. This hook is run when a package is uninstalled.

The `uninstall` hook runs when the last package of an `origin/package` is uninstalled. If there are other versions or revisions installed for the package, the `uninstall` hook is skipped. When more than one revision of an origin are uninstalled at the same time, the process removes them from oldest to newest. This ensures that the uninstall hook of the latest revision is the version that runs.

Like the `install` hook, the `uninstall` hook isn't limited to packages that are loaded as services into a Supervisor. Also like the `install` hook, configuration in `svc_config_path`isn't accessible to an `uninstall` hook. If an `uninstall` hook needs to use templated configuration files, templates located in the `svc_config_install_path` may be referenced. This location will contain rendered templates in a package's `config_install` folder. Finally, any configuration updates made during a service's runtime that would alter an `uninstall` hook or any configuration template in `svc_config_install_path` won't cause a service to reload.

An `uninstall` hook can use the following as a template:

```bash hooks/uninstall
#!/bin/bash

exec 2>&1
echo "Uninstalling {{pkg.name}}"

# Clean up directories created by the install hook
rm -rf /var/log/{{pkg.name}}
```
