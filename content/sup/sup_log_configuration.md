+++
title = "Supervisor log configuration"
description = "Dynamically adjust the logging configuration of a running Supervisor"


[menu.sup]
    title = "Supervisor log configuration"
    identifier = "supervisors/sup-log-configuration"
    parent = "supervisors"
    weight = 90
+++

The two main ways to configure logging are with environment variables and with a configuration file. Each has its own strengths and weaknesses.

## Environment variable configuration

You can still configure logging with the `RUST_LOG` environment variable. This approach is often useful for quickly reconfiguring logging (which requires a restart), or for easily configuring logging in container-based deployments.

The configuration scheme is essentially the same as the one described in the Rust [env_logger](https://docs.rs/env_logger/0.6.1/env_logger/#enabling-logging) crate documentation, except that additional regular expression-based filtering isn't supported. The configuration values the Supervisor recognizes are described below:

## Simple logging levels

The recognized values are, in increasing verbosity (or, equivalently, in decreasing severity): `error`, `warn`, `info`, `debug`, and `trace`.

Setting `RUST_LOG` to one of these values will cause all log messages at that verbosity and below (equivalently, that severity and above) to be printed. This includes log messages from Habitat, as well as any libraries that it uses.

## Rust logging levels

This is much finer-grained than the simple logging levels above, and fully using it requires some knowledge of Habitat's internal code structure and how Rust code is organized. Even so, it lets you target specific subsystems, which can be very helpful for troubleshooting.

For example, `RUST_LOG=habitat_sup::manager=info` will cause all log messages at the `info` level or more severe (`error`, `warn`, and `info`) originating anywhere in the module hierarchy rooted at `habitat_sup::manager`.

Note that Rust modules are identified first by the crate (or library) they come from, followed by a `::`-delimited path of module names.

## Variations

You can specify multiple logging specifiers, separated by commas. A simple logging level acts as the default, and additional module-targeted levels refine logging for specific code. If you supply multiple simple logging levels, only the last one applies. You can include any number of targeted logging levels.

For example, `RUST_LOG=info,habitat_sup::manager=debug,tokio_reactor=error` will limit logs generally to the `info` level, while additionally allowing `debug` messages coming from the `habitat_sup::manager` module hierarchy, and restricting log messages from the `tokio_reactor` library to only `error`.

## Dynamic, file-based configuration

For more control over logging output, and to change the configuration of a running Supervisor, use a configuration file. This file is processed by the [log4rs](https://docs.rs/log4rs/) crate and shares many concepts with the Log4J logging system in the Java ecosystem. You can find `log4rs` configuration documentation [here](https://docs.rs/log4rs/1.4.0/log4rs/#configuration).

To use this configuration style, place an appropriate YAML configuration file at `/hab/sup/default/config/log.yml` when the Supervisor starts. If this file is present, it takes priority over any `RUST_LOG` environment variable that is also set.

Here is an example configuration file that mimics the default Supervisor logging configuration. It emits UTC-timestamped message lines to standard output at the `error` level.

```yaml
# ALWAYS keep this key in the configuration; removing it means changes
# to config won't get picked up without a restart.
#
# Uses humantime to parse the duration; see
# https://docs.rs/humantime/1.2.0/humantime/fn.parse_duration.html
refresh_rate: 5 seconds

appenders:
  stdout:
    kind: console
    encoder:
      # See https://docs.rs/log4rs/1.4.0/log4rs/#configuration for
      # formatting options
      pattern: "[{d(%Y-%m-%dT%H:%M:%SZ)(utc)} {l} {module}] {message}{n}"

root:
  level: error
  appenders:
    - stdout
```

The `refresh_rate` configuration is very important. If it's present when the Supervisor starts, the file is checked periodically for updates (according to the value of `refresh_rate`; in the above example, the file is checked every 5 seconds). If the file changes, its current content becomes the active configuration. This allows you to, for example, increase the logging level of a running Supervisor if you suspect problems.

This dynamism has a catch: you can also change the refresh rate, or remove it entirely. If you remove it, the Supervisor stops checking the file for updates. Any later changes require a Supervisor restart to be recognized. Work is planned to make this behavior more flexible.

You can also target individual module hierarchies with this configuration scheme, just as you can with the `RUST_LOG` environment variable. For this, you will need to add a new top-level `loggers` key to the file, like so:

```yaml
loggers:
  habitat_sup::manager:
    level: debug
  tokio_reactor:
    level: error
```

Here, `loggers` is a map of maps. Map keys are module paths (as described above in the `RUST_LOG` environment variable documentation), while the values are maps with additional configuration. In this example, only the logging level is set, but more advanced configurations are possible.

For more details, review the [log4rs configuration documentation](https://docs.rs/log4rs/1.4.0/log4rs/#configuration).
