+++
title = "Configuration templates"
description = "Using templates and tags to tune your application configuration files"


[menu.reference]
    title = "Configuration templates"
    identifier = "reference/configuration-templates Customize Chef Habitat Packages Configuration"
    parent = "reference"

+++

Chef Habitat allows you to template your application's native configuration files using [Handlebars](https://handlebarsjs.com/) syntax. The following sections describe how to create tunable configuration elements for your application or service.

Template variables, also referred to as tags, are indicated by double curly braces: `{{a_variable}}`. In Chef Habitat, tunable configuration elements are prefixed with `cfg.` to indicate that the value is user-tunable.

Here's an example of how to make a configuration element user-tunable. Assume that there is a native configuration file named `service.conf`. In `service.conf`, the following configuration element is defined:

```plain
recv_buffer 128
```

You can make this user-tunable like this:

```plain
recv_buffer {{cfg.recv_buffer}}
```

Chef Habitat can read values used to render templated configuration files in three ways:

1. `default.toml` - Each plan includes a `default.toml` file that specifies default values to use when users don't provide inputs. These files are written in [TOML](https://github.com/toml-lang/toml), a simple configuration format.
1. At runtime - You can change configuration at runtime with `hab config apply`. The input for this command also uses TOML format.
1. Environment variables - At startup, tunable configuration values can be passed to Chef Habitat through environment variables.

{{< note >}}

When building packages, prefer supplying values in `default.toml`, then at runtime, and last through environment variables. Environment variables override `default.toml`, and runtime configuration set with `hab config apply` overrides both default settings and settings provided in environment variables.

Changing settings with environment variables requires you to restart the Supervisor so it can pick up the new or changed environment variable.

{{< /note >}}

The following example shows what to add to your project's `default.toml` file to provide a default value for the `recv_buffer` tunable:

```toml
recv_buffer = 128
```

All templates located in a package's `config` folder are rendered to a configuration directory, `/hab/svc/<pkg_name>/config`, for the running service. The templates are rewritten whenever configuration values change.
The path to this directory is available at build time in the plan as the variable `$pkg_svc_config_path` and available at runtime in templates and hooks as `{{pkg.svc_config_path}}`.

All templates located in a package's `config_install` folder are rendered to a `config_install` directory, `/hab/svc/<pkg_name>/config_install`. These templates are only accessible during execution of an `install` hook, and runtime changes to values referenced by these templates won't rerender the template.
The path to this directory is available at build time in the plan as the variable `$pkg_svc_config_install_path` and available at runtime in templates and `install` hooks as `{{pkg.svc_config_install_path}}`.

Chef Habitat not only allows you to use Handlebars-based tunables in your plan, but you can also use built-in Handlebars helpers and Chef Habitat-specific helpers to define your configuration logic. See [Reference](build_helpers) for more information.
