+++
title = "Environment variables"
description = "Customize and configure your Chef Habitat Studio and Supervisor environments"


[menu.reference]
    title = "Environment variables"
    identifier = "reference/environment-variables"
    parent = "reference"

+++

This page lists environment variables you can use to modify the behavior of the Chef Habitat Studio and Supervisor.

`HAB_AUTH_TOKEN`
: Authorization token used to perform privileged operations against the depot, for example uploading packages or keys.

  Context: build system

  Default value: no default

`HAB_BINLINK_DIR`
: Allows you to change the target directory for the symlink created when you run `hab pkg binlink`. The default value is already included in the `$PATH` variable inside the Studio.

  Context: build system

  Default value: `/hab/bin`

`HAB_BLDR_CHANNEL`
: Sets the Chef Habitat Builder channel to subscribe to. Defaults to `stable`.

  Context: build system, Supervisor

  Default value: `stable`

`HAB_BLDR_URL`
: Sets an alternate default endpoint for communicating with Builder. Used by the Chef Habitat build system and the Supervisor.

  Context: build system, Supervisor

  Default value: `https://bldr.habitat.sh`

`HAB_CACHE_KEY_PATH`
: Cache directory for origin signing keys.

  Context: build system, Supervisor

  Default value: `/hab/cache/keys` if running as root; `$HOME/.hab/cache/keys` if running as non-root

`HAB_CTL_SECRET`
: Shared secret used for [communicating with a Supervisor](../sup/sup_remote_control.md).

  Context: Supervisor

  Default value: no default

`HAB_DOCKER_OPTS`
: When running a Studio on a platform that uses Docker (macOS), additional command line options to pass to the `docker` command.

  Context: build system

  Default value: no default

`HAB_GLYPH_STYLE`
: Used to customize the rendering of unicode glyphs in UI messages. Valid values are `full`, `limited`, or `ascii`.

  Context: build system

  Default value: `full` (`limited` on Windows)

`HAB_LICENSE`
: Used to accept the [Chef EULA](https://docs.chef.io/licensing/accept/#accept-the-chef-eula). See [Accepting the Chef License](https://docs.chef.io/licensing/accept/) for valid values.

  Context: build system, Supervisor, exporters

  Default value: no default

`HAB_LISTEN_CTL`
: The listen address for the Control Gateway. This also affects `hab` commands that interact with the Supervisor with the Control Gateway, for example: `hab svc status`.

  Context: Supervisor

  Default value: `127.0.0.1:9632`

`HAB_LISTEN_GOSSIP`
: The listen address for the Gossip System Gateway.

  Context: Supervisor

  Default value: `0.0.0.0:9638`

`HAB_LISTEN_HTTP`
: The listen address for the HTTP Gateway.

  Context: Supervisor

  Default value: `0.0.0.0:9631`

`HAB_NOCOLORING`
: If set to the lowercase string `"true"`, this environment variable unconditionally disables text coloring where possible.

  Context: build system

  Default value: no default

`HAB_NONINTERACTIVE`
: If set to the lowercase string `"true"`, this environment variable unconditionally disables interactive progress bars ("spinners") where possible.

  Context: build system

  Default value: no default

`HAB_ORG`
: Organization to use when running with [service group encryption](/sup/sup_secure).

  Context: Supervisor

  Default value: no default

`HAB_ORIGIN`
: Origin used to build packages. The signing key for this origin is passed to the build system.

  Context: build system

  Default value: no default

`HAB_ORIGIN_KEYS`
: Comma-separated list of origin keys to automatically share with the build system.

  Context: build system

  Default value: no default

`HAB_REFRESH_CHANNEL`
: Channel used to retrieve plan dependencies for Chef supported origins.

  Context: build system

  Default value: `base`

`HAB_RING`
: The name of the ring used by the Supervisor when running with [wire encryption](/sup/sup_secure).

  Context: Supervisor

  Default value: no default

`HAB_RING_KEY`
: The contents of the ring key when running with [wire encryption](/sup/sup_secure). Useful when running in a container.

  Context: Supervisor

  Default value: no default

`HAB_STUDIO_BACKLINE_PKG`
: Overrides the default package identifier for the "backline" package which installs the Studio baseline package set.

  Context: build system

  Default value: `core/hab-backline/{{studio_version}}`

`HAB_STUDIO_NOSTUDIORC`
: When set to a non-empty value, a `.studiorc` won't be sourced when entering an interactive Studio with `hab studio enter`.

  Context: build system

  Default value: no default

`HAB_STUDIO_ROOT`
: Root of the current Studio under `$HAB_STUDIOS_HOME`. Infrequently overridden.

  Context: build system

  Default value: no default

`HAB_STUDIO_SECRET_<VARIABLE>`
: Prefix to allow environment variables into the Studio. The prefix will be removed and your variable will be passed into the Studio at build time.

  Context: build system

  Default value: no default

`HAB_STUDIO_SUP`
: Used to customize the arguments passed to an automatically launched Supervisor, or to disable the automatic launching by setting it to `false`, `no`, or `0`.

  Context: build system

  Default value: no default

`HAB_STUDIOS_HOME`
: Directory in which to create build Studios.

  Context: build system

  Default value: `/hab/studios`

`HAB_SUP_UPDATE_MS`
: Interval in milliseconds governing how often to check for Supervisor updates when running with the [`--auto-update`](habitat_cli/#hab-sup-run) flag. Note: This variable overrides the [`--auto-update-period`](habitat_cli/#hab-sup-run) flag.

  Context: Supervisor

  Default value: `60000`

`HAB_UPDATE_STRATEGY_PERIOD_MS`
: Interval in milliseconds governing how often to check for service updates when running with an [update strategy](../services/service_updates). Note: This variable overrides the [--service-update-period](habitat_cli/#hab-sup-run) flag.

  Context: Supervisor

  Default value: `60000`

`HAB_USER`
: User key to use when running with [service group encryption](/sup/sup_secure).

  Context: Supervisor

  Default value: no default

`http_proxy`
: A URL of a local HTTP proxy server optionally supporting basic authentication.

  Context: build system, Supervisor

  Default value: no default

`https_proxy`
: A URL of a local HTTPS proxy server optionally supporting basic authentication.

  Context: build system, Supervisor

  Default value: no default

`NO_INSTALL_DEPS`
: Set this variable to prevent dependencies install during build.

  Context: build system

  Default value: no default

`no_proxy`
: A comma-separated list of domain exclusions for the `http_proxy` and `https_proxy` environment variables.

  Context: build system, Supervisor

  Default value: no default

`SSL_CERT_FILE`
: Standard OpenSSL environment variable to override the system certificate file. This is particularly important for the secure HTTPS connection with a Builder instance. Can be used to help you navigate corporate firewalls.

  Context: system

  Default value: no default
