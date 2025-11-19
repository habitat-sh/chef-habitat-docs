+++
title = "Chef Habitat Command-Line Interface (CLI) Reference"
draft= false
linkTitle = "Chef Habitat Command-Line Interface (CLI) Reference"
summary = "Chef Habitat Command-Line Interface (CLI) Reference"

[menu.reference]
    title = "Habitat CLI Reference"
    identifier = "reference/habitat_cli"
    parent = "reference"
    weight = 1
+++

<!-- markdownlint-disable-file -->
<!-- This is a generated file, do not edit it directly. See https://github.com/habitat-sh/habitat/blob/main/.expeditor/scripts/release_habitat/generate-cli-docs.js -->


The commands for the Chef Habitat CLI (`hab`) are listed below.

| Applies to Version | Last Updated |
| ------- | ------------ |
| hab 2.0.293/20251016114829 (linux) | 17 Oct 2025 |

## hab





**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab bldr](#hab-bldr) | Commands relating to Habitat Builder |
| [hab cli](#hab-cli) | Commands relating to Habitat runtime config |
| [hab config](#hab-config) | Commands relating to a Service's runtime config |
| [hab file](#hab-file) | Commands relating to Habitat files |
| [hab license](#hab-license) | Commands relating to Habitat license agreements |
| [hab origin](#hab-origin) | Commands relating to Habitat Builder origins |
| [hab pkg](#hab-pkg) | Commands relating to Habitat packages |
| [hab plan](#hab-plan) | Commands relating to plans and other app-specific configuration |
| [hab ring](#hab-ring) | Commands relating to Habitat rings |
| [hab studio](#hab-studio) | Commands relating to Habitat Studios |
| [hab sup](#hab-sup) | The Habitat Supervisor |
| [hab supportbundle](#hab-supportbundle) | Create a tarball of Habitat Supervisor data to send to support |
| [hab svc](#hab-svc) | Commands relating to Habitat Services |
| [hab user](#hab-user) | Commands relating to Habitat users |
---

## hab bldr

Commands relating to Habitat Builder

**USAGE**

```
hab bldr <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab bldr channel](#hab-bldr-channel) | Commands relating to Habitat Builder channels |
---

### hab bldr channel

Commands relating to Habitat Builder channels

**USAGE**

```
hab bldr channel <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab bldr channel create](#hab-bldr-channel-create) | Creates a new channel |
| [hab bldr channel destroy](#hab-bldr-channel-destroy) | Destroys a channel |
| [hab bldr channel list](#hab-bldr-channel-list) | Lists origin channels |
| [hab bldr channel promote](#hab-bldr-channel-promote) | Atomically promotes all packages in channel |
| [hab bldr channel demote](#hab-bldr-channel-demote) | Atomically demotes selected packages in a target channel |
---

### hab bldr channel create

Creates a new channel

**USAGE**

```
hab bldr channel create [OPTIONS] <CHANNEL>
```


**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint [env: HAB_BLDR_URL=] [default: https://bldr.habitat.sh]
-o, --origin <ORIGIN>    Sets the origin to which the channel will belong. Default is from HAB_ORIGIN' or cli.toml
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<CHANNEL>  The channel name
```



---

### hab bldr channel destroy

Destroys a channel

**USAGE**

```
hab bldr channel destroy [OPTIONS] <CHANNEL>
```


**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint [env: HAB_BLDR_URL=] [default: https://bldr.habitat.sh]
-o, --origin <ORIGIN>    Sets the origin to which the channel belongs. Default is from HAB_ORIGIN' or cli.toml
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<CHANNEL>  The channel name
```



---

### hab bldr channel list

Lists origin channels

**USAGE**

```
hab bldr channel list [OPTIONS] [ORIGIN]
```


**OPTIONS**

```
-s, --sandbox         Include sandbox channels for the origin
-u, --url <BLDR_URL>  Specify an alternate Builder endpoint [env: HAB_BLDR_URL=] [default: https://bldr.habitat.sh]
-h, --help            Print help
-V, --version         Print version
```

**ARGUMENTS**

```
[ORIGIN]  Sets the origin to which the channel belongs. Default is from 'HAB_ORIGIN' or cli.toml
```



---

### hab bldr channel promote

Atomically promotes all packages in channel

**USAGE**

```
hab bldr channel promote [OPTIONS] <SOURCE_CHANNEL> <TARGET_CHANNEL>
```


**OPTIONS**

```
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint [env: HAB_BLDR_URL] [default: https://bldr.habitat.sh] [env: HAB_BLDR_URL=] [default: https://bldr.habitat.sh]
-o, --origin <ORIGIN>    Sets the origin to which the channel belongs. Default is from HAB_ORIGIN' or cli.toml
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<SOURCE_CHANNEL>  The channel from which all packages will be selected for promotion
<TARGET_CHANNEL>  The channel to which packages will be promoted
```



---

### hab bldr channel demote

Atomically demotes selected packages in a target channel

**USAGE**

```
hab bldr channel demote [OPTIONS] <SOURCE_CHANNEL> <TARGET_CHANNEL>
```


**OPTIONS**

```
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint [env: HAB_BLDR_URL] [default: https://bldr.habitat.sh] [env: HAB_BLDR_URL=] [default: https://bldr.habitat.sh]
-o, --origin <ORIGIN>    Sets the origin to which the channel belongs. Default is from HAB_ORIGIN' or cli.toml
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<SOURCE_CHANNEL>  The channel from which all packages will be selected for demotion
<TARGET_CHANNEL>  The channel selected packages will be removed from
```



---

## hab cli

Commands relating to Habitat runtime config

**USAGE**

```
hab cli <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab cli setup](#hab-cli-setup) | Sets up the CLI with reasonable defaults |
| [hab cli completers](#hab-cli-completers) | Creates command-line completers for your shell |
---

### hab cli setup

Sets up the CLI with reasonable defaults

**USAGE**

```
hab cli setup [OPTIONS]
```


**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```




---

### hab cli completers

Creates command-line completers for your shell

**USAGE**

```
hab cli completers --shell <SHELL>
```


**OPTIONS**

```
-s, --shell <SHELL>  The name of the shell you want to generate the command-completion [possible values: bash, elvish, fish, powershell, zsh]
-h, --help           Print help
-V, --version        Print version
```




---

## hab config

Commands relating to a Service's runtime config

**USAGE**

```
hab config <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab config apply](#hab-config-apply) | Apply a configuration to a running service |
| [hab config show](#hab-config-show) | Show the current config of a running service |
---

### hab config apply

Apply a configuration to a running service



**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-r, --remote-sup <REMOTE_SUP> Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-u, --user <USER> Name of a user key to use for encryption
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<SERVICE_GROUP>   Target service group service.group[@organization] (ex: redis.default or foo.default@bazcorp)
<VERSION_NUMBER>  A version number (positive integer) for this configuration (ex: 42)
[FILE]            Path to local file on disk (ex: /tmp/config.toml, "-" for stdin) [default: -]
```



---

### hab config show

Show the current config of a running service



**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP>  Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-h, --help                     Print help
-V, --version                  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

## hab file

Commands relating to Habitat files

**USAGE**

```
hab file <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab file upload](#hab-file-upload) | Uploads a file to be shared between members of a Service Group |
---

### hab file upload

Uploads a file to be shared between members of a Service Group



**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-r, --remote-sup <REMOTE_SUP> Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-u, --user <USER> Name of the user key
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<SERVICE_GROUP>   Target service group service.group[@organization] (ex: redis.default or foo.default@bazcorp)
<VERSION_NUMBER>  A version number (positive integer) for this file (ex: 42)
<FILE>            Path to local file on disk
```



---

## hab license





**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab license accept](#hab-license-accept) | Accept the Chef Binary Distribution Agreement without prompting |
---

### hab license accept





**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```




---

## hab origin





**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab origin create](#hab-origin-create) | Creates a new Builder origin |
| [hab origin delete](#hab-origin-delete) | Removes an unused/empty origin |
| [hab origin depart](#hab-origin-depart) | Departs membership from selected origin |
| [hab origin info](#hab-origin-info) | Displays general information about an origin |
| [hab origin invitations](#hab-origin-invitations) | Manage origin member invitations |
| [hab origin key](#hab-origin-key) | Commands relating to Habitat origin key maintenance |
| [hab origin rbac](#hab-origin-rbac) | Role Based Access Control for origin members |
| [hab origin transfer](#hab-origin-transfer) | Transfers ownership of an origin to another member of that origin |
---

### hab origin create

Creates a new Builder origin



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>  The origin to be created
```



---

### hab origin delete

Removes an unused/empty origin



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>  The origin to be deleted
```



---

### hab origin depart

Departs membership from selected origin



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>  The origin name
```



---

### hab origin info

Displays general information about an origin



**OPTIONS**

```
-j, --json               Output will be rendered in json
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>  The origin to be deleted
```



---

### hab origin invitations

Manage origin member invitations



**OPTIONS**

```
-h, --help  Print help
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab origin invitations accept](#hab-origin-invitations-accept) | Accept an origin member invitation |
| [hab origin invitations ignore](#hab-origin-invitations-ignore) | Ignore an origin member invitation |
| [hab origin invitations list](#hab-origin-invitations-list) | List origin invitations sent to your account |
| [hab origin invitations pending](#hab-origin-invitations-pending) | List pending invitations for a particular origin. Requires that you are the origin owner |
| [hab origin invitations rescind](#hab-origin-invitations-rescind) | Rescind an existing origin member invitation |
| [hab origin invitations send](#hab-origin-invitations-send) | Send an origin member invitation |
---

### hab origin invitations accept





**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>         The origin name the invitation applies to
<INVITATION_ID>  The id of the invitation to accept
```



---

### hab origin invitations ignore





**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>         The origin name the invitation applies to
<INVITATION_ID>  The id of the invitation to ignore
```



---

### hab origin invitations list





**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```




---

### hab origin invitations pending





**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>  The name of the origin you wish to list invitations for
```



---

### hab origin invitations rescind





**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>         The origin name the invitation applies to
<INVITATION_ID>  The id of the invitation to rescind
```



---

### hab origin invitations send





**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>           The origin name the invitation applies to
<INVITEE_ACCOUNT>  The account name to invite into the origin
```



---

### hab origin key

Commands relating to Habitat origin key maintenance



**OPTIONS**

```
-h, --help  Print help
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab origin key download](#hab-origin-key-download) | Download origin key(s) |
| [hab origin key export](#hab-origin-key-export) | Outputs the latest origin key contents to stdout |
| [hab origin key generate](#hab-origin-key-generate) | Generates a Habitat origin key pair |
| [hab origin key import](#hab-origin-key-import) | Reads a stdin stream containing a public or private origin key contents and writes the key to disk |
| [hab origin key upload](#hab-origin-key-upload) | Upload origin keys to Builder |
---

### hab origin key download





**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN> Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-s, --secret Download origin private key instead of origin public key
-e, --encryption Download public encryption key instead of origin public key
-h, --help Print help
```

**ARGUMENTS**

```
<ORIGIN>    The origin name
[REVISION]  The origin key revision
```



---

### hab origin key export





**OPTIONS**

```
-t, --type <KEY_TYPE> Export either the 'public' or 'secret' key. The 'secret' key is the origin private key
    --cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
```

**ARGUMENTS**

```
<ORIGIN>  The origin name
```



---

### hab origin key generate





**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
```

**ARGUMENTS**

```
[ORIGIN]  The origin name
```



---

### hab origin key import





**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
```




---

### hab origin key upload





**OPTIONS**

```
--pubfile <PUBLIC_FILE> Path to a local public origin key file on disk
    --cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-s, --secret Upload origin private key in addition to the public key
    --secfile <SECRET_FILE> Path to a local origin private key file on disk
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN> Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help Print help
```

**ARGUMENTS**

```
[ORIGIN]  The origin name
```



---

### hab origin rbac

Role Based Access Control for origin members



**OPTIONS**

```
-h, --help  Print help
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab origin rbac show](#hab-origin-rbac-show) | Display an origin member's current role |
| [hab origin rbac set](#hab-origin-rbac-set) | Change an origin member's role |
---

### hab origin rbac show





**OPTIONS**

```
-o, --origin <ORIGIN>    The Builder origin name to target
-j, --json               Output will be rendered in json
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<MEMBER_ACCOUNT>  The account name of the role to display
```



---

### hab origin rbac set





**OPTIONS**

```
-o, --origin <ORIGIN>    The Builder origin name to target
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-n, --no-prompt          Do not prompt for confirmation
-h, --help               Print help
```

**ARGUMENTS**

```
<MEMBER_ACCOUNT>  The account name whose role will be changed
<ROLE>            [possible values: READONLY_MEMBER, MEMBER, MAINTAINER, ADMINISTRATOR, OWNER]
```



---

### hab origin transfer

Transfers ownership of an origin to another member of that origin



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
```

**ARGUMENTS**

```
<ORIGIN>             The origin name
<NEW_OWNER_ACCOUNT>
```



---

## hab pkg





**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab pkg binds](#hab-pkg-binds) | Displays the binds for a service |
| [hab pkg binlink](#hab-pkg-binlink) | Creates a binlink for a package binary in a common 'PATH' location |
| [hab pkg build](#hab-pkg-build) | Builds a plan using Habitat Studio |
| [hab pkg bulkupload](#hab-pkg-bulkupload) | Bulk uploads Habitat artifacts to builder depot from a local directory |
| [hab pkg channels](#hab-pkg-channels) | Find out what channels a package belongs to |
| [hab pkg config](#hab-pkg-config) | Displays the default configuration options for a service |
| [hab pkg delete](#hab-pkg-delete) | Removes a package from Builder |
| [hab pkg demote](#hab-pkg-demote) | Demote a package from a specified channel |
| [hab pkg dependencies](#hab-pkg-dependencies) | Returns Habitat Artifact dependencies, by default the direct dependencies of the package |
| [hab pkg download](#hab-pkg-download) | Download Habitat artifacts (including dependencies and keys) from Builder |
| [hab pkg env](#hab-pkg-env) | Prints the runtime environment of a specific installed package |
| [hab pkg exec](#hab-pkg-exec) | Execute a command using the 'PATH' context of an installed package |
| [hab pkg export](#hab-pkg-export) | Exports the package to the specified format |
| [hab pkg hash](#hab-pkg-hash) | Generates a blake2b hashsum from a target at any given filepath |
| [hab pkg header](#hab-pkg-header) | Returns the Habitat Artifact header |
| [hab pkg info](#hab-pkg-info) | Returns the Habitat Artifact information |
| [hab pkg install](#hab-pkg-install) | Installs a Habitat package from Builder or locally from a Habitat Artifact |
| [hab pkg list](#hab-pkg-list) | List all versions of installed packages |
| [hab pkg path](#hab-pkg-path) | Prints the path to a specific installed release of a package |
| [hab pkg promote](#hab-pkg-promote) | Promote a package to a specified channel |
| [hab pkg provides](#hab-pkg-provides) | Search installed Habitat packages for a given file |
| [hab pkg search](#hab-pkg-search) | Search for a package in Builder |
| [hab pkg sign](#hab-pkg-sign) | Signs an archive with an origin key, generating a Habitat Artifact |
| [hab pkg uninstall](#hab-pkg-uninstall) | Safely uninstall a package and dependencies from a local filesystem |
| [hab pkg upload](#hab-pkg-upload) | Uploads a local Habitat Artifact to Builder |
| [hab pkg verify](#hab-pkg-verify) | Verifies a Habitat Artifact with an origin key |
---

### hab pkg binds

Displays the binds for a service



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg binlink

Creates a binlink for a package binary in a common 'PATH' location



**OPTIONS**

```
-d, --dest <DEST_DIR>  Set the destination directory [env: HAB_BINLINK_DIR=] [default: /bin]
-f, --force            Overwrite existing binlinks
-h, --help             Print help
-V, --version          Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
[BINARY]     The command to binlink (ex: bash)
```



---

### hab pkg build

Builds a plan using Habitat Studio



**OPTIONS**

```
-k, --keys <HAB_ORIGIN_KEYS> Installs secret origin keys (ex: "unicorn", "acme,other,acme-ops")
-r, --root <HAB_STUDIO_ROOT> Sets the Studio root (default: /hab/studios/<DIR_NAME>)
-s, --src <SRC_PATH> Sets the source path [default: $PWD]
    --cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-N, --native-package Build a native package on the host system without a studio
-R, --reuse Reuses a previous Studio for the build (default: clean up before building)
-D, --docker Uses a Dockerized Studio for the build
-f, --refresh-channel <REFRESH_CHANNEL> Channel used to retrieve plan dependencies for Chef supported origins [env: HAB_REFRESH_CHANNEL=] [default: base]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<PLAN_CONTEXT>  A directory containing a plan file or a habitat/ directory which contains the plan file
```



---

### hab pkg bulkupload

Bulk uploads Habitat artifacts to builder depot from a local directory



**OPTIONS**

```
-u, --url <BLDR_URL>       Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>    Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-c, --channel <CHANNEL>    Optional additional release channel to upload package to. Packages are always uploaded to unstable, regardless of the value of this option
    --force                Skip checking availability of package and force uploads, potentially overwriting a stored copy of a package
    --auto-create-origins  Skip the confirmation prompt and automatically create origins that do not exist in the target Builder
-h, --help                 Print help
-V, --version              Print version
```

**ARGUMENTS**

```
<UPLOAD_DIRECTORY>  Directory Path from which artifacts will be uploaded
```



---

### hab pkg channels

Find out what channels a package belongs to



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<PKG_IDENT>   A fully qualified package identifier (ex: core/busybox-static/1.42.2/20170513215502)
[PKG_TARGET]  A package target (ex: x86_64-windows) (default: system appropriate target) [env: HAB_PACKAGE_TARGET=]
```



---

### hab pkg config

Displays the default configuration options for a service



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg delete

Removes a package from Builder



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<PKG_IDENT>   A fully qualified package identifier (ex: core/busybox-static/1.42.2/20170513215502)
[PKG_TARGET]  A package target (ex: x86_64-windows) (default: system appropriate target) [env: HAB_PACKAGE_TARGET=]
```



---

### hab pkg demote

Demote a package from a specified channel



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<PKG_IDENT>   A fully qualified package identifier (ex: core/busybox-static/1.42.2/20170513215502)
<CHANNEL>     Demote from the specified release channel
[PKG_TARGET]  A package target (ex: x86_64-windows) (default: system appropriate target) [env: HAB_PACKAGE_TARGET=]
```



---

### hab pkg dependencies

Returns Habitat Artifact dependencies, by default the direct dependencies of the package



**OPTIONS**

```
-t, --transitive  Show transitive dependencies
-r, --reverse     Show packages which are dependant on this one
-h, --help        Print help
-V, --version     Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg download

Download Habitat artifacts (including dependencies and keys) from Builder



**OPTIONS**

```
-z, --auth <AUTH_TOKEN> Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-c, --channel <CHANNEL> Download from the specified release channel. Overridden if channel is specified in toml file [env: HAB_BLDR_CHANNEL=]
    --download-directory <DOWNLOAD_DIRECTORY> The path to store downloaded artifacts
    --file <PKG_IDENT_FILE>... File with newline separated package identifiers, or TOML file (ending with .toml extension)
-t, --target <PKG_TARGET> A package target (ex: x86_64-windows) (default: system appropriate target) [env: HAB_PACKAGE_TARGET=]
    --verify Verify package integrity after download (Warning: this can be slow)
    --ignore-missing-seeds Ignore packages specified that are not present on the target Builder
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
[PKG_IDENT]...  One or more Package Identifiers to download (eg. core/redis)
```



---

### hab pkg env

Prints the runtime environment of a specific installed package



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg exec

Execute a command using the 'PATH' context of an installed package



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
<CMD>        Command to execute (eg. ls)
[ARGS]...    Arguments to the command
```



---

### hab pkg export

Exports the package to the specified format



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab pkg export container](#hab-pkg-export-container) | Container Exporter |
| [hab pkg export tar](#hab-pkg-export-tar) | Tar Exporter |
---

### hab pkg export container





**OPTIONS**

```
-i, --image-name <IMAGE_NAME> Image name template: supports {{pkg_origin}}, {{pkg_name}}, {{pkg_version}}, {pkg_release}}, {{channel}} variables. [default template: {{pkg_origin}}/{{pkg_name}}]
    --hab-pkg <HAB_PKG> Habitat CLI package identifier (ex: chef/hab) or filepath to a Habitat artifact (ex: home/chef-hab-2.0.100-20250416101002-x86_64-linux.hart) to install [default: chef/hab]
    --launcher-pkg <HAB_LAUNCHER_PKG> Launcher package identifier (ex: chef/hab-launcher) or filepath to a Habitat artifact (ex: home/chef-hab-launcher-19633-20250610094807-x86_64-linux.hart) to install [default: chef/hab-launcher]
    --sup-pkg <HAB_SUP_PKG> Supervisor package identifier (ex: chef/hab-sup) or filepath to a Habitat artifact (ex: home/chef-hab-sup-2.0.134-20250610093735-x86_64-linux.hart) to install [default: chef/hab-sup]
-u, --url <BLDR_URL> Install packages from Builder at the specified URL [default: https://bldr.habitat.sh]
-c, --channel <CHANNEL> Install packages from the specified release channel [default: stable]
    --base-pkgs-url <BASE_PKGS_BLDR_URL> Install base packages from Builder at the specified URL [default: https://bldr.habitat.sh]
    --base-pkgs-channel <BASE_PKGS_CHANNEL> Install base packages from the specified release [default: stable]
-z, --auth <BLDR_AUTH_TOKEN> Provide a Builder auth token for private pkg export [env: HAB_AUTH_TOKEN]
    --tag-version-release Tag image with :"{{pkg_version}}-{{pkg_release}}"
    --no-tag-version-release Do not tag image with :"{{pkg_version}}-{{pkg_release}}"
    --tag-version Tag image with :"{{pkg_version}}"
    --no-tag-version Do not tag image with :"{{pkg_version}}"
    --tag-latest Tag image with :"latest"
    --no-tag-latest Do not tag image with :"latest"
    --tag-custom <TAG_CUSTOM> Tag image with additional custom tag (supports: {{pkg_origin}}, {{pkg_name}}, {pkg_version}}, {{pkg_release}}, {{channel}})
    --push-image Push image to remote registry (default: no)
    --no-push-image Do not push image to remote registry (default: yes)
-U, --username <REGISTRY_USERNAME> Remote registry username, required for pushing image to remote registry
-P, --password <REGISTRY_PASSWORD> Remote registry password, required for pushing image to remote registry
-R, --registry-type <REGISTRY_TYPE> Remote registry type (default: docker) [default: docker] [possible values: amazon, azure, docker]
-G, --registry-url <REGISTRY_URL> Remote registry url
    --rm-image Remove local image from engine after build and/or push (default: no)
-m, --memory <MEMORY_LIMIT> Memory limit passed to docker build's --memory arg (ex: 2gb)
    --multi-layer If specified, creates an image where each Habitat package is added in its own layer, in dependency order (that is, low-level dependencies are added first, with user packages added last). This will allow for reusable layers, reducing storage and network transmission costs. If the resulting image can't be built because there are too many layers, re-build without specifying this option to add all Habitat packages in a single layer (which is the default behavior).
    --engine <ENGINE> The name of the container creation engine to use. [env: HAB_PKG_EXPORT_CONTAINER_ENGINE=] default: docker] [possible values: docker, buildah]
-h, --help Print help (see more with '--help')
-V, --version Print version
```

**ARGUMENTS**

```
<PKG_IDENT_OR_ARTIFACT>...  One or more Habitat package identifiers (ex: acme/redis) and/or filepaths to a Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg export tar





**OPTIONS**

```
--hab-pkg <HAB_PKG> Habitat CLI package identifier (ex: chef/hab) or filepath to a Habitat artifact (ex: home/chef-hab-2.0.100-20250416101002-x86_64-linux.hart) to install [default: chef/hab]
    --launcher-pkg <HAB_LAUNCHER_PKG> Launcher package identifier (ex: chef/hab-launcher) or filepath to a Habitat artifact (ex: home/chef-hab-launcher-19633-20250610094807-x86_64-linux.hart) to install [default: chef/hab-launcher]
    --sup-pkg <HAB_SUP_PKG> Supervisor package identifier (ex: chef/hab-sup) or filepath to a Habitat artifact (ex: home/chef-hab-sup-2.0.134-20250610093735-x86_64-linux.hart) to install [default: chef/hab-sup]
-u, --url <BLDR_URL> Builder URL to Install packages from [default: https://bldr.habitat.sh]
-c, --channel <CHANNEL> Channel to install packages from [default: stable]
    --base-pkgs-url <BASE_PKGS_BLDR_URL> URL to install base packages from [default: https://bldr.habitat.sh]
    --base-pkgs-channel <BASE_PKGS_CHANNEL> Channel to install base packages from [default: stable]
-z, --auth <BLDR_AUTH_TOKEN> Provide a Builder auth token for private pkg export [env: HAB_AUTH_TOKEN]
    --no-hab-bin Exclude the hab bin directory from the exported tar
    --no-hab-sup Exclude supervisor and launcher packages from the exported tar
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<PKG_IDENT_OR_ARTIFACT>  A Habitat package identifier (ex: acme/redis) and/or filepath to a Habitat artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg hash

Generates a blake2b hashsum from a target at any given filepath



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
[SOURCE]  Filepath to the Habitat Package file
```



---

### hab pkg header

Returns the Habitat Artifact header



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<SOURCE>  A path to a Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg info

Returns the Habitat Artifact information



**OPTIONS**

```
-j, --json     Output will be rendered in json. (Includes extended metadata)
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<SOURCE>  A path to a Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg install

Installs a Habitat package from Builder or locally from a Habitat Artifact



**OPTIONS**

```
-u, --url <BLDR_URL>             Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-c, --channel <CHANNEL>          Install from the specified release channel. Uses default channel as 'base' for 'core' origin packages and 'stable' for all other packages [env: HAB_BLDR_CHANNEL=]
-b, --binlink                    Binlink all binaries from installed package(s) into BINLINK_DIR
    --binlink-dir <BINLINK_DIR>  Binlink all binaries from installed package(s) into BINLINK_DIR env: HAB_BINLINK_DIR=] [default: /bin]
-f, --force                      Overwrite existing binlinks
-z, --auth <AUTH_TOKEN>          Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
    --ignore-install-hook        Do not run any install hooks
    --ignore-local               Do not use locally-installed packages when a corresponding package can't be installed from Builder
-h, --help                       Print help
-V, --version                    Print version
```

**ARGUMENTS**

```
<PKG_IDENT_OR_ARTIFACT>...  One or more Habitat package identifiers (ex: acme/redis) and/or filepaths to a Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg list

List all versions of installed packages



**OPTIONS**

```
-a, --all              List all installed packages
-o, --origin <ORIGIN>  An origin to list
-h, --help             Print help
-V, --version          Print version
```

**ARGUMENTS**

```
[PKG_IDENT]  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg path

Prints the path to a specific installed release of a package



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg promote

Promote a package to a specified channel



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<PKG_IDENT>   A fully qualified package identifier (ex: core/busybox-static/1.42.2/20170513215502)
<CHANNEL>     Promote to the specified release channel
[PKG_TARGET]  A package target (ex: x86_64-windows) (default: system appropriate target) [env: HAB_PACKAGE_TARGET=]
```



---

### hab pkg provides

Search installed Habitat packages for a given file



**OPTIONS**

```
-r             Show fully qualified package names (ex: core/busybox-static/1.24.2/20160708162350)
-p             Show full path to file
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
<FILE>  File name to find
```



---

### hab pkg search

Search for a package in Builder



**OPTIONS**

```
-u, --url <BLDR_URL>     Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN>  Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-l, --limit <LIMIT>      Limit how many packages to retrieve [default: 50]
-h, --help               Print help
-V, --version            Print version
```

**ARGUMENTS**

```
<SEARCH_TERM>  Search term
```



---

### hab pkg sign

Signs an archive with an origin key, generating a Habitat Artifact



**OPTIONS**

```
--origin <ORIGIN> Origin key used to create signature
    --cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<SOURCE>  A path to a source archive file (ex: /home/acme-redis-3.0.7-21120102031201.tar.xz)
<DEST>    The destination path to the signed Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg uninstall

Safely uninstall a package and dependencies from a local filesystem



**OPTIONS**

```
-d, --dryrun                     Just show what would be uninstalled, don't actually do it
    --keep-latest <KEEP_LATEST>  Only keep this number of latest packages uninstalling all others
    --exclude <EXCLUDE>          Identifier of one or more packages that should not be uninstalled. (ex: core/redis, core/busybox-static/1.42.2/21120102031201)
    --no-deps                    Don't uninstall dependencies
    --ignore-uninstall-hook      Do not run any uninstall hooks
-h, --help                       Print help
-V, --version                    Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab pkg upload

Uploads a local Habitat Artifact to Builder



**OPTIONS**

```
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
-z, --auth <AUTH_TOKEN> Authentication token for Builder. Uses value from the HAB_AUTH_TOKEN env variable if set or from the config file if specified
-c, --channel <CHANNEL> Optional additional release channel to upload package to. Packages are always uploaded to unstable, regardless of the value of this option
    --force Skips checking availability of package and force uploads, potentially overwriting a stored copy of a package. (default: false)
    --cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<HART_FILE>...  One or more filepaths to a Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

### hab pkg verify

Verifies a Habitat Artifact with an origin key



**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<SOURCE>  A path to a Habitat Artifact (ex: home/acme-redis-3.0.7-21120102031201-x86_64-linux.hart)
```



---

## hab plan

Commands relating to plans and other app-specific configuration



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab plan init](#hab-plan-init) | Generates common package specific configuration files |
| [hab plan render](#hab-plan-render) | Renders plan config files |
---

### hab plan init

Generates common package specific configuration files



**OPTIONS**

```
-o, --origin <ORIGIN>            Origin for the new app
-m, --min                        Create a minimal plan file
-s, --scaffolding <SCAFFOLDING>  Specify explicit Scaffolding for your app (ex: node, ruby)
-h, --help                       Print help (see more with '--help')
-V, --version                    Print version
```

**ARGUMENTS**

```
[PKG_NAME]  Name for the new app
```



---

### hab plan render

Renders plan config files



**OPTIONS**

```
-d, --default-toml <DEFAULT_TOML>  Path to default.toml [default: ./default.toml]
-u, --user-toml <USER_TOML>        Path to user.toml, defaults to none
-m, --mock-data <MOCK_DATA>        Path to json file with mock data for template, defaults to none
-p, --print                        Prints config to STDOUT
-r, --render-dir <RENDER_DIR>      Path to render templates [default: ./results]
-n, --no-render                    Don't write anything to disk, ignores --render-dir
-q, --quiet                        Don't print any helper messages.  When used with --print will only print config file
-h, --help                         Print help
-V, --version                      Print version
```

**ARGUMENTS**

```
<TEMPLATE_PATH>  Path to config to render
```



---

## hab ring

Commands relating to Habitat rings

**USAGE**

```
hab ring <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab ring key](#hab-ring-key) | Commands relating to Habitat ring keys |
---

### hab ring key

Commands relating to Habitat ring keys

**USAGE**

```
hab ring key <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab ring key export](#hab-ring-key-export) | Outputs the latest ring key contents to stdout |
| [hab ring key import](#hab-ring-key-import) | Reads a stdin stream containing ring key contents and writes the key to disk |
| [hab ring key generate](#hab-ring-key-generate) | Generates a Habitat ring key |
---

### hab ring key export

Outputs the latest ring key contents to stdout

**USAGE**

```
hab ring key export [OPTIONS] <RING>
```


**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<RING>  Ring key name
```



---

### hab ring key import

Reads a stdin stream containing ring key contents and writes the key to disk

**USAGE**

```
hab ring key import [OPTIONS]
```


**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```




---

### hab ring key generate

Generates a Habitat ring key

**USAGE**

```
hab ring key generate [OPTIONS] <RING>
```


**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<RING>  Ring key name
```



---

## hab studio









---

## hab sup

The Habitat Supervisor

**USAGE**

```
hab sup <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab sup depart](#hab-sup-depart) | Depart a Supervisor from the gossip ring; kicking and banning the target from joining again with the same member-id |
| [hab sup restart](#hab-sup-restart) | Restart a Supervisor without restarting its services |
| [hab sup secret](#hab-sup-secret) | Commands relating to a Habitat Supervisor's Control Gateway secret |
| [hab sup sh](#hab-sup-sh) | Start an interactive Bourne-like shell |
| [hab sup bash](#hab-sup-bash) | Start an interactive Bash-like shell |
| [hab sup term](#hab-sup-term) | Gracefully terminate the Habitat Supervisor and all of its running services |
| [hab sup run](#hab-sup-run) | Run the supervisor (load config and start services) |
---

### hab sup depart

Depart a Supervisor from the gossip ring; kicking and banning the target from joining again with the



**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP>  Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-h, --help                     Print help
```

**ARGUMENTS**

```
<MEMBER_ID>  The member-id of the Supervisor to depart
```



---

### hab sup restart

Restart a Supervisor without restarting its services



**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP>  Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-h, --help                     Print help
```




---

### hab sup secret

Commands relating to a Habitat Supervisor's Control Gateway secret



**OPTIONS**

```
-h, --help  Print help
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab sup secret generate](#hab-sup-secret-generate) | Generate a secret key to use as a Supervisor's Control Gateway secret |
| [hab sup secret generate-tls](#hab-sup-secret-generate-tls) | Generate a private key and certificate for the Supervisor's Control Gateway TLS connection |
---

### hab sup secret generate





**OPTIONS**

```
-h, --help  Print help
```




---

### hab sup secret generate-tls





**OPTIONS**

```
--subject-alternative-name <SUBJECT_ALTERNATIVE_NAME> The DNS name to use in the certificates subject alternative name extension
-h, --help Print help
```

**ARGUMENTS**

```
[path]  The directory to store the generated private key and certificate [default: hab/cache/keys/ctl]
```



---

### hab sup sh

Start an interactive Bourne-like shell



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
[ARGS]...
```



---

### hab sup bash

Start an interactive Bash-like shell



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
[ARGS]...
```



---

### hab sup term

Gracefully terminate the Habitat Supervisor and all of its running services



**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```

**ARGUMENTS**

```
[ARGS]...
```



---

### hab sup run

Run the supervisor (load config and start services)



**OPTIONS**

```
--listen-gossip <LISTEN_GOSSIP> The listen address for the Gossip Gateway [env: HAB_LISTEN_GOSSIP=] [default: 0.0.0.0:9638]
    --peer <PEER>... Initial peer addresses (IP[:PORT])
    --peer-watch-file <PEER_WATCH_FILE> File to watch for connecting to the ring
    --local-gossip-mode Start in local gossip mode
    --listen-http <LISTEN_HTTP> The listen address for the HTTP Gateway [env: HAB_LISTEN_HTTP=] [default: 0.0.0.0:9631]
-D, --http-disable Disable the HTTP Gateway
    --listen-ctl <LISTEN_CTL> The listen address for the Control Gateway [env: HAB_LISTEN_CTL=] [default: 127.0.0.1:9632]
    --ctl-server-certificate [<CTL_SERVER_CERTIFICATE>...] The control gateway server’s TLS certificate
    --ctl-server-key [<CTL_SERVER_KEY>...] The control gateway server’s private key
    --ctl-client-ca-certificate [<CTL_CLIENT_CA_CERTIFICATE>...] Enable client authentication for the control gateway and set the certificate authority to use when authenticating the client
    --org <ORGANIZATION> Organization the Supervisor and it's services are part of
-I, --permanent-peer Mark the Supervisor as a permanent peer
    --cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-r, --ring <RING> The name of the ring used by the Supervisor when running with wire encryption [env: HAB_RING=]
-A, --auto-update Enable automatic updates for the Supervisor itself
    --auto-update-period <AUTO_UPDATE_PERIOD> Time (seconds) between Supervisor update checks [default: 60]
    --service-update-period <SERVICE_UPDATE_PERIOD> Time (seconds) between service update checks [default: 60]
    --service-min-backoff-period <SERVICE_MIN_BACKOFF_PERIOD> The minimum period of time in seconds to wait before attempting to restart a service that failed to start up [default: 0]
    --service-max-backoff-period <SERVICE_MAX_BACKOFF_PERIOD> The maximum period of time in seconds to wait before attempting to restart a service that failed to start up [default: 0]
    --service-restart-cooldown-period <SERVICE_RESTART_COOLDOWN_PERIOD> The period of time in seconds to wait before assuming that a service started up successfully after a restart [default: 300]
    --key <KEY_FILE> The private key for HTTP Gateway TLS encryption
    --certs <CERT_FILE> The server certificates for HTTP Gateway TLS encryption
    --ca-certs <CA_CERT_FILE> The CA certificate for HTTP Gateway TLS encryption
-v Verbose output showing file and line/column numbers
    --no-color Disable ANSI color
    --json-logging Use structured JSON logging for the Supervisor
    --sys-ip-address <SYS_IP_ADDRESS> The IPv4 address to use as the sys.ip template variable
    --event-stream-application <EVENT_STREAM_APPLICATION> The name of the application for event stream purposes
    --event-stream-environment <EVENT_STREAM_ENVIRONMENT> The name of the environment for event stream purposes
    --event-stream-connect-timeout <EVENT_STREAM_CONNECT_TIMEOUT> Event stream connection timeout before exiting the Supervisor [env: HAB_EVENT_STREAM_CONNECT_TIMEOUT=] [default: 0]
    --event-stream-token <EVENT_STREAM_TOKEN> The authentication token for connecting the event stream to Chef Automate [env: HAB_AUTOMATE_AUTH_TOKEN]
    --event-stream-url <EVENT_STREAM_URL> The event stream connection url used to send events to Chef Automate
    --event-stream-site <EVENT_STREAM_SITE> The name of the site where this Supervisor is running for event stream purposes
    --event-meta <EVENT_META>... An arbitrary key-value pair to add to each event generated by this Supervisor
    --event-stream-server-certificate <EVENT_STREAM_SERVER_CERTIFICATE> The certificate should be in PEM format
    --keep-latest-packages <KEEP_LATEST_PACKAGES> Automatically cleanup old packages [env: HAB_KEEP_LATEST_PACKAGES=]
    --config-files <CONFIG_FILES>... Paths to config files to Read
    --generate-config Generate a TOML Config
    --channel <CHANNEL> Receive updates from the specified release channel
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable if defined. (default: https://bldr.habitat.sh)
    --group <GROUP> The service group with shared config and topology [default: default]
-t, --topology <TOPOLOGY> Service topology [possible values: leader, standalone]
-s, --strategy <STRATEGY> The update strategy [default: none] [possible values: none, at-once, rolling]
    --update-condition <UPDATE_CONDITION> The condition dictating when this service should update [default: latest] [possible values: latest, track-channel]
    --bind <BIND>... One or more service groups to bind to a configuration
    --binding-mode <BINDING_MODE> Governs how the presence or absence of binds affects service startup [default: strict] possible values: strict, relaxed]
    --health-check-interval <HEALTH_CHECK_INTERVAL> The interval in seconds on which to run health checks [default: 30]
    --shutdown-timeout <SHUTDOWN_TIMEOUT> The delay in seconds after sending the shutdown signal to wait before killing the service process
    --config-from <CONFIG_FROM> Use the package config from this path rather than the package itself
-h, --help Print help (see more with '--help')
```

**ARGUMENTS**

```
[PKG_IDENT_OR_ARTIFACT]  Load a Habitat package as part of the Supervisor startup
```



---

## hab supportbundle

Create a tarball of Habitat Supervisor data to send to support

**USAGE**

```
hab supportbundle
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```




---

## hab svc

Commands relating to Habitat Services

**USAGE**

```
hab svc <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab svc key](#hab-svc-key) | Commands relating to Habitat service keys |
| [hab svc load](#hab-svc-load) | Load a service to be started and supervised by Habitat from a package identifier If an installed package doesn't satisfy the given package identifier, a suitable package will be installed from Builder |
| [hab svc start](#hab-svc-start) | Start a loaded, but stopped, Habitat service |
| [hab svc status](#hab-svc-status) | Query the status of Habitat services |
| [hab svc stop](#hab-svc-stop) | Stop a running Habitat service |
| [hab svc unload](#hab-svc-unload) | Unload a service loaded by the Habitat Supervisor. If the service is running, it will be stopped first |
| [hab svc update](#hab-svc-update) | Update how the Supervisor manages an already-running service. Depending on the given changes, they may be able to be applied without restarting the service |
---

### hab svc key





**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab svc key generate](#hab-svc-key-generate) | Generates a Habitat service key |
---

### hab svc key generate





**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<SERVICE_GROUP>  Target service group service.group[@organization] (ex: redis.default or foo.default@bazcorp)
<ORG>            The service organization [env: HABITAT_ORG=]
```



---

### hab svc load





**OPTIONS**

```
-f, --force Load or reload an already loaded service. If the service was previously loaded and running this operation will also restart the service
-r, --remote-sup <REMOTE_SUP> Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
    --channel <CHANNEL> Receive updates from the specified release channel
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable if defined. (default: https://bldr.habitat.sh)
    --group <GROUP> The service group with shared config and topology [default: default]
-t, --topology <TOPOLOGY> Service topology [possible values: leader, standalone]
-s, --strategy <STRATEGY> The update strategy [default: none] [possible values: none, at-once, rolling]
    --update-condition <UPDATE_CONDITION> The condition dictating when this service should update [default: latest] [possible values: latest, track-channel]
    --bind <BIND>... One or more service groups to bind to a configuration
    --binding-mode <BINDING_MODE> Governs how the presence or absence of binds affects service startup [default: strict] possible values: strict, relaxed]
    --health-check-interval <HEALTH_CHECK_INTERVAL> The interval in seconds on which to run health checks [default: 30]
    --shutdown-timeout <SHUTDOWN_TIMEOUT> The delay in seconds after sending the shutdown signal to wait before killing the service process
    --config-from <CONFIG_FROM> Use the package config from this path rather than the package itself
-h, --help Print help (see more with '--help')
```

**ARGUMENTS**

```
[PKG_IDENT]  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab svc start





**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP>  Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-h, --help                     Print help
-V, --version                  Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab svc status





**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP>  Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
-h, --help                     Print help
-V, --version                  Print version
```

**ARGUMENTS**

```
[PKG_IDENT]  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab svc stop





**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP> Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
    --shutdown-timeout <SHUTDOWN_TIMEOUT> The delay in seconds after sending the shutdown signal to wait before killing the service process
-h, --help Print help (see more with '--help')
-V, --version Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab svc unload





**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP> Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
    --shutdown-timeout <SHUTDOWN_TIMEOUT> The delay in seconds after sending the shutdown signal to wait before killing the service process
-h, --help Print help (see more with '--help')
-V, --version Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

### hab svc update





**OPTIONS**

```
-r, --remote-sup <REMOTE_SUP> Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
    --channel <CHANNEL> Receive updates from the specified release channel
-u, --url <BLDR_URL> Specify an alternate Builder endpoint. If not specified, the value will be taken from the HAB_BLDR_URL environment variable or from the config file if specified
    --group <GROUP> The service group with shared config and topology
-t, --topology <TOPOLOGY> Service topology [possible values: leader, standalone]
-s, --strategy <STRATEGY> The update strategy [possible values: none, at-once, rolling]
    --update-condition <UPDATE_CONDITION> The condition dictating when this service should update [default: latest] [possible values: latest, track-channel]
    --bind [<BIND>...] One or more service groups to bind to a configuration
    --binding-mode <BINDING_MODE> Governs how the presence or absence of binds affects service startup [possible values: strict, relaxed]
-i, --health-check-interval <HEALTH_CHECK_INTERVAL> The interval in seconds on which to run health checks
    --shutdown-timeout <SHUTDOWN_TIMEOUT> The delay in seconds after sending the shutdown signal to wait before killing the service process
-h, --help Print help (see more with '--help')
-V, --version Print version
```

**ARGUMENTS**

```
<PKG_IDENT>  A package identifier (ex: core/redis, core/busybox-static/1.42.2)
```



---

## hab user

Commands relating to Habitat users

**USAGE**

```
hab user <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab user key](#hab-user-key) | Commands relating to Habitat user keys |
---

### hab user key

Commands relating to Habitat user keys

**USAGE**

```
hab user key <COMMAND>
```


**OPTIONS**

```
-h, --help     Print help
-V, --version  Print version
```



**SUBCOMMANDS**

| Command | Description |
| ------- | ----------- |
| [hab user key generate](#hab-user-key-generate) | Generates a Habitat user key |
---

### hab user key generate

Generates a Habitat user key

**USAGE**

```
hab user key generate [OPTIONS] <USER>
```


**OPTIONS**

```
--cache-key-path <CACHE_KEY_PATH> Cache for creating and searching for encryption keys [env: HAB_CACHE_KEY_PATH=] [default: home/admin/.hab/cache/keys]
-h, --help Print help
-V, --version Print version
```

**ARGUMENTS**

```
<USER>  Name of the user key
```



---

