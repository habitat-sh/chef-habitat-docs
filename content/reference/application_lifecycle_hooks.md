+++
title = "Application lifecycle hooks"
description = "Control service runtime actions with application lifecycle hooks"


[menu.reference]
    title = "Application lifecycle hooks"
    identifier = "reference/application-lifecycle-hooks plan Lifecycle Hooks"
    parent = "reference"

+++

Each plan can specify lifecycle event handlers, or hooks, to perform actions during a service's runtime. Each hook is a script with a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) at the top that specifies the interpreter to use. On Windows, PowerShell Core is the only interpreter used.

To define a hook, create a file of the same name in `/my_plan_name/hooks/`, for example, `/postgresql/hooks/health-check`.

Optionally, you can add an extension to the hook file. For example, you might create `/postgresql/hooks/health-check.sh`, which can help some editors apply syntax highlighting automatically. Note that having two files for the same hook with different extensions is supported only when you target different platforms. For example, you might create `run.sh` and `run.ps1` to support both Linux and Windows packages. To create different hooks for different platforms, use [target directories](../plans/plan_writing.md#writing-a-plan-for-multiple-platform-targets).

{{< warning >}}
You can't block the thread in a hook unless it's in the `run` hook. Never call `hab` or `sleep` in a hook that isn't the `run` hook.
{{< /warning >}}

## Runtime settings

[Chef Habitat's runtime configuration settings](service_templates) can be used in any plan hook and in any templated configuration file for your application or service.

### file-updated

File location: `<plan>/hooks/file-updated`. This hook runs whenever a configuration file that isn't related to a user or the state of service instances is updated.

### health-check

**File location**: `<plan>/hooks/health-check`. **Default**: 30 seconds

This hook repeats at a configured interval. The following are two exceptions to the interval between `health-check` runs:

- If the `health-check` hook exits with a non-`ok` status, the next `health-check` runs after the default `health-check` interval (30 seconds). This only happens when the configured interval is greater than the default interval.
- If the `health-check` hook returns an `ok` status for the first time, the next `health-check` runs after a randomly chosen delay between 0 and the configured `health-check` interval. This introduces a splay---a degree of difference---in timing between the first and second `health-check` runs. All following `health-check` hooks run at the configured interval. The splay prevents more than one `health-check` hook from starting at the same time by giving each one a unique starting point.

The `health-check` script must return a valid exit code from the list below.

- **0** - ok
- **1** - warning
- **2** - critical
- **3** - unknown
- Any other code - failed health check with additional output taken from `health-check` stdout.

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

File location: `<plan>/hooks/init`. This hook runs when a Chef Habitat topology starts.

{{< note >}}

If the init hook fails with a non-zero exit code, the service will be restarted with the [configured service backoff](service_restarts).

{{< /note >}}

### install

File location: `<plan>/hooks/install`. This hook runs when a package is first installed.

An `install` hook may be triggered by `hab pkg install` or by a Supervisor loading a new package. Any package can define an `install` hook, and it isn't limited to packages loaded as services into a Supervisor. A package may have dependencies defined in `pkg_deps` or `pkg_build_deps` that define their own `install` hook. An `install` hook defined in a dependent package that hasn't yet been installed runs when the parent package is installed. However, `install` hooks in a runtime dependency (`pkg_deps`) won't run when loaded with a package `build` in a Studio.

The exit code returned from an `install` hook is remembered. If a previously installed package is installed again with `hab pkg install` or loaded into a Supervisor, its `install` hook reruns if it previously failed (exited with a non-`0` result) or hasn't run before (for example, because `--ignore-install-hook` was passed to `hab pkg install`).

Unlike other hooks, an `install` hook won't have access to census data exposed through binds or the `svc` namespace. Also, configuration in `svc_config_path` isn't accessible to an `install` hook. If an `install` hook needs to use templated configuration files, it may reference templates in `svc_config_install_path`. This location contains rendered templates in a package's `config_install` folder. Finally, configuration updates made during a service's runtime that alter an `install` hook or any configuration template in `svc_config_install_path` won't cause a service to reload.

### reconfigure

File location: `<plan>/hooks/reconfigure`. You can write a `reconfigure` hook for services that can respond to changes in `<plan>/config` without requiring a restart. This hook executes **instead** of the default behavior of restarting the process. `{{pkg.svc_pid_file}}` can be used to get the `PID` of the service.

Habitat doesn't support changing the `PID` of the underlying service in any lifecycle hook. If part of a service's reconfiguration relies on changing the `PID`, don't provide a `reconfigure` hook, and instead use the default behavior of restarting the service.

The `reconfigure` hook doesn't necessarily run on every change to `<plan>/config`. The `reconfigure` hook won't run if the service restarts before the `reconfigure` hook runs. The restart is considered sufficient for reconfiguring the service. For example, when applying a configuration that changes both the `run` hook and `<plan>/config`, the change to the `run` hook triggers a restart. Therefore, the `reconfigure` hook won't run. In other words, the `reconfigure` hook responds only to changes in `<plan>/config` after the service has started.

### suitability

File location: `<plan>/hooks/suitability`. The suitability hook allows a service to report a priority that determines leader election. The hook is called when a new election is triggered, and the last line it outputs to `stdout` must be a number that can be parsed as a `u64`. If a leader goes down and an election starts, the service with the highest reported suitability becomes the new leader.

### run

File location: `<plan>/hooks/run`. This hook runs when one of the following conditions occurs:

- The main topology starts, after the `init` hook has been called.
- A package is updated, after the `init` hook has been called.
- The package config changes, after the `init` hook has been called, but before a `reconfigure` hook is called.

You can use this hook in place of `$pkg_svc_run` when you need more complex behavior such as setting environment variables or command options that are based on dynamic configuration.

Services run using this hook should do two things:

- Redirect stderr to stdout (for example with `exec 2>&1` at the start of the hook)
- Call the command to execute with `exec <command> <options>` rather than running the command directly. This ensures the command is executed in the same process and that the service will restart correctly on configuration changes.

It's important to consider side effects of the command you execute. For example, does the command spin off other processes in separate process groups? If so, they may not be cleaned up automatically when the system is reconfigured. In general, the command should behave similarly to a daemon, clean up properly when it receives `SIGTERM`, and forward signals to other processes it creates. For a specific example, if you're trying to start a Node.js service, use `node server.js` directly instead of `npm start`.

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

If the run hook exits, it's considered a run failure. The service restarts with the [configured service backoff](service_restarts), regardless of the exit code returned by the hook.

{{< /note >}}

### post-run

File location: `<plan>/hooks/post-run`. The post-run hook executes after initial startup. For many data services, creating specific users, roles, or datastores is required. This needs to happen after the service has started.

### post-stop

File location: `<plan>/hooks/post-stop`. The post-stop hook executes after a service has stopped successfully. You can use this hook to undo what the `init` hook has done.

### uninstall

File location: `<plan>/hooks/uninstall`. This hook runs when a package is uninstalled.

The `uninstall` hook runs when the last package of an `origin/package` is uninstalled. If there are other versions or revisions installed for the package, the `uninstall` hook is skipped. When more than one revision of an origin are uninstalled at the same time, the process removes them from oldest to newest. This ensures that the uninstall hook of the latest revision is the version that runs.

Like the `install` hook, the `uninstall` hook isn't limited to packages loaded as services into a Supervisor. Also like the `install` hook, configuration in `svc_config_path` isn't accessible to an `uninstall` hook. If an `uninstall` hook needs to use templated configuration files, it may reference templates in `svc_config_install_path`. This location contains rendered templates in a package's `config_install` folder. Finally, configuration updates made during a service's runtime that alter an `uninstall` hook or any configuration template in `svc_config_install_path` won't cause a service to reload.
