+++
title = "Build packages"
description = "Build packages in Chef Habitat Studio"


[menu.packages]
    title = "Build packages"
    identifier = "packages/pkg-build Build your Package"
    parent = "packages"
    weight = 10
+++

A Chef Habitat package artifact is a self-contained, signed artifact that bundles an application or library with everything it needs to run---its binaries, runtime dependencies, libraries, and configuration. The build process transforms a plan (a set of build instructions you write) into a `.hart` file: a compressed, cryptographically signed tarball that Chef Habitat can install, run, and distribute.

## macOS system requirements

To build Habitat packages on macOS, make sure you have the following installed and configured:

- [macOS requirements](/install#additional-setup-to-build-habitat-packages)

## How a package is built

When you've finished creating your plan and call `build` in Chef Habitat Studio, the build script does the following:

1. Checks that Habitat Studio has the private origin key available to sign the artifact.
1. Downloads the source code from the location in `pkg_source`, if specified.
1. Validates the checksum of the downloaded file using the `pkg_shasum` value, if it's specified.
1. Extracts the source into a temporary cache.
1. Builds and installs the binary or library using `make` and `make install` for Linux-based builds.

    <!--- TODO: WHAT DOES WINDOWS USE? Invoke-Unpack function with Start-Process? Invoke-Install & Copy-Item? unless the callback methods are overridden in the plan. --->

1. Compresses the package contents (binaries, runtime dependencies, libraries, assets, etc.) into a tarball.
1. Signs the tarball with your private origin key and gives it a `.hart` file extension.

After the build script completes, you can upload your package to Chef Habitat Builder, or install and start your package locally.

## Prerequisites

Before building your packages, create a key pair for your origin and share the private key with the Habitat Studio where you'll build the package.

### Generate an origin key pair

Packages need to be signed with a private origin key at build time.
Generate an origin key pair manually by running the following command on your host machine:

```shell
hab origin key generate <ORIGIN>
```

This command places the origin key files, `<ORIGIN>-<TIMESTAMP>.sig.key` (the private key) and `<ORIGIN>-<TIMESTAMP>.pub` (the public key), in your `$HOME/.hab/cache/keys` directory.

If you're creating origin keys in the Studio container, or if you're running as root on a Linux machine, your keys are stored in `/hab/cache/keys`.
On macOS, your keys are stored in `/opt/hab/cache/keys`.

Because the private key is used to sign your artifact, it shouldn't be shared freely; however, if anyone wants to download and use your Habitat artifact, they must have your public key (`.pub`) installed in their local `$HOME/.hab/cache/keys` or `/hab/cache/keys` directory (`/opt/hab/cache/keys` on macOS). If the origin's public key isn't present, Chef Habitat attempts to download it from the Builder endpoint specified by the `--url` argument (<https://bldr.habitat.sh> by default) to `hab pkg install`.

### Pass origin keys into Habitat Studio

The Habitat Studio is a self-contained, minimal environment, which means you'll need to share your private origin keys with the Studio to sign artifacts.

To share your private origin keys with Habitat Studio, do one of the following:

- Before entering Habitat Studio, set `HAB_ORIGIN` to the name of the origin you intend to use:

    ```shell
    export HAB_ORIGIN=originname
    ```

    This approach overrides the `HAB_ORIGIN` environment variable and imports your public and private origin keys into the Studio environment. It also overrides any `pkg_origin` values in the packages that you build. This is useful because you can use it to build your own artifact, as well as to build your own artifacts from other packages' source code, for example, `originname/node` or `originname/glibc`.

- Set `HAB_ORIGIN_KEYS` to the names of your origins. If you're using more than one origin, separate them with commas:

    ```shell
    export HAB_ORIGIN_KEYS=originname-internal,originname-test,originname
    ```

    This imports the private origin keys, which must exactly match the origin names for the plans you intend to build.

- Use the `-k` flag (short for "keys") which accepts one or more key names separated by commas with:

    ```shell
    hab studio -k originname-internal,originname-test enter
    ```

    This imports the private origin keys, which must exactly match the origin names for the plans you intend to build.

After you create or receive your private origin key, you can start up the Studio and build your artifact.

## Build a package

### Run an interactive build

Any build that you perform from a Chef Habitat Studio is an interactive build.
Habitat Studio interactive builds allow you to examine the build environment before, during, and after the build.

The directory where your plan is located is known as the plan context.

1. Change to the parent directory of the plan context.
1. Create and enter a new Chef Habitat Studio.

    If you defined an origin and origin key during `hab cli setup`, or by explicitly setting the `HAB_ORIGIN` and `HAB_ORIGIN_KEYS` environment variables, run the following command:

    ```shell
    hab studio enter
    ```

    The directory you were in is now mounted as `/src` inside the Studio. By default, a Supervisor runs in the background for iterative testing. You can see the streaming output by running `sup-log`. Type `Ctrl-C` to exit the streaming output and `sup-term` to terminate the background Supervisor. If you terminate the background Supervisor, then running `sup-run` will restart it along with every service that was previously loaded. You have to explicitly run `hab svc unload origin/package` to remove a package from the "loaded" list.

1. Enter the following command to create the package.

    ```shell
    build /src/planname
    ```

1. If the package builds successfully, it's placed into a `results` directory at the same level as your plan.

#### Manage the Habitat Studio type (Docker/Linux/Windows)

Depending on the platform of your host and your Docker configuration, the behavior of `hab studio enter` may vary. Here is the default behavior listed by host platform:

- **Linux** - A local chrooted Linux Studio. You can force a Docker-based studio by adding the `-D` flag to the `hab studio enter` command.
- **macOS** - A local macOS Studio using `sandbox-exec`. You can request a Docker container-based Linux Studio by passing the `-D` flag to the `hab studio enter` command.
- **Windows** - A local Windows studio. You can force a Docker-based studio by adding the `-D` flag to the `hab studio enter` command. The platform of the spawned container depends on the mode your Docker service is running, which can be toggled between Linux Containers and Windows Containers. Make sure your Docker service is running in the correct mode for the kind of studio you want to enter.

{{< note >}}

For more details related to Windows containers see [Running Chef Habitat Windows Containers](../containers/running_habitat_windows_containers.md).

{{< /note >}}

#### Build interdependent packages

If you're developing and building multiple packages where one package is dependent on one or more other packages,
use a single Habitat Studio to build your packages instead of running multiple Habitat Studios.
This lets you quickly test your changes and is less cumbersome than entering a separate Habitat Studio for each package.

To do this, follow these steps:

1. Organize packages together in folder structure like this:

    ```text
    projects/
    ├── project-a
    └── project-b
    ```

1. From the `projects/` directory, run `hab studio enter`.
1. Build your packages in dependency order, for example:

    ```shell
    build project-a && build project-b
    ```

### Run a non-interactive build

A non-interactive build is one in which Chef Habitat creates a Studio for you, builds the package inside it, and then destroys the Studio, leaving the resulting `.hart` on your computer.
Use a non-interactive build when you're sure the build will succeed, or together with a continuous integration system.

1. Change to the parent directory of the plan context.
1. Build the artifact in an unattended fashion, passing the name of the origin key to the command.

    ```shell
    hab pkg build <PACKAGE_NAME> -k <HAB_ORIGIN_KEYS>
    ```

    Similar to the `hab studio enter` command above, the type of studio where the build runs is determined by your host platform and `hab pkg build` takes the same `-D` flag to force a Docker environment if desired.

1. The resulting artifact is inside a directory called `results`, along with any build logs and a build report (`last_build.env`) that includes machine-parsable metadata about the build.

By default, the Studio resets to a clean state after the package is built.
However, _if you're using the Linux version of `hab`_, you can reuse a previous Studio when building your package by specifying the `-R` option when calling the `hab pkg build` subcommand.

For information on the contents of an installed package, see [Package contents](../reference/package_contents.md).

## Build packages with core origin dependencies from a specific channel

By default, when Habitat builds a plan, it pulls all `core` origin dependencies from the `base` channel. The `base` channel includes all lower level packages from the most recent package refresh. You can change the channel that Habitat pulls `core` origin dependencies from using either the `--refresh-channel` argument in the `hab pkg build` command or by using the `-f` option when entering an interactive studio.

{{< note >}}

The default channel for non-`core` origin dependencies is the `stable` channel. You can change this channel using the `HAB_BLDR_CHANNEL` environment variable.

{{< /note >}}

For information on supported package channels, see the [Habitat package refresh strategy documentation](https://docs.chef.io/habitat/supported_packages/package_refresh_strategy/).

## Troubleshooting builds

### Bash plans: `attach`

While working on plans, you may wish to stop the build and inspect the environment at any point during a build phase (for example download, build, unpack, etc.). In Bash-based plans, Chef Habitat provides an `attach` function for use in your `plan.sh` that functions like a debugging breakpoint and provides an easy read-evaluate-print loop (REPL) at that point. For PowerShell-based plans, you can use the PowerShell built-in `Set-PSBreakpoint` cmdlet prior to running your build.

To use `attach`, insert it into your plan at the point where you want to use it, for example:

```shell
 do_build() {
   attach
   make
 }
```

Now, perform a [build](pkg_build)---we recommend using an interactive studio so you don't need to set up the environment from scratch for every build.

```shell
hab studio enter
```

```shell
build yourapp
```

The build system proceeds until the point where the `attach` function is invoked, and then drops you into a limited shell:

```shell
# Attaching to debugging session
From: /src/yourapp/plan.sh @ line 15 :

    5: pkg_maintainer="The Chef Habitat Maintainers <humans@habitat.sh>"
    6: pkg_source=http://download.yourapp.io/releases/${pkg_name}-${pkg_version}.tar.gz
    7: pkg_shasum=c2a791c4ea3bb7268795c45c6321fa5abcc24457178373e6a6e3be6372737f23
    8: pkg_bin_dirs=(bin)
    9: pkg_build_deps=(core/make core/gcc)
    10: pkg_deps=(core/glibc)
    11: pkg_exports=(
    12:   [port]=srv.port
    13: )
    14:
    15: do_build() {
 => 16:   attach
    17:   make
    18: }

[1] yourapp(do_build)>
```

You can use basic Linux commands like `ls` in this environment. You can also use the `help` command the Chef Habitat build system provides in this context to see what other functions can help you debug the plan.

```shell
[1] yourapp(do_build)> help
Help
  help          Show a list of command or information about a specific command.

Context
  whereami      Show the code surrounding the current context
                (add a number to increase the lines of context).

Environment
  vars          Prints all the environment variables that are currently in scope.

Navigating
  exit          Pop to the previous context.
  exit-program  End the /hab/pkgs/core/hab-plan-build/0.6.0/20160604180818/bin/hab-plan-build program.

Aliases
  @             Alias for `whereami`.
  quit          Alias for `exit`.
  quit-program  Alias for `exit-program`.
```

Type `quit` when you're done with the debugger, and the remainder of the build will continue.
If you want to abort the build entirely, type `quit-program`.

### PowerShell plans: `Set-PSBreakpoint`

While there is no `attach` function exposed in a `plan.ps1` file, you can use the native PowerShell cmdlet `Set-PSBreakpoint` to access almost the same functionality.
Instead of adding `attach` to your `Invoke-Build` function, enter the following from inside your studio shell:

```powershell
[HAB-STUDIO] Habitat:\src> Set-PSBreakpoint -Command Invoke-Build
```

When you run `build`, enter the interactive prompt inside the context of the Invoke-Build function:

```powershell
   habitat-aspnet-sample: Building
Entering debug mode. Use h or ? for help.

Hit Command breakpoint on 'Invoke-Build'

At C:\src\habitat\plan.ps1:26 char:23
+ function Invoke-Build {
+                       ~
[HAB-STUDIO] C:\hab\cache\src\habitat-aspnet-sample-0.2.0>>
```

You can now call PowerShell commands to inspect variables (like `Get-ChildItem variable:\`) or files to debug your build.

### Troubleshoot sandbox permission errors on macOS

On macOS, Habitat uses `sandbox-exec` for isolation.
This mechanism is configured through _sandbox scripts_ that start with all access disabled and then selectively grant the permissions required for each build.
A set of standard rules is pre-configured in the studio's _sandbox configuration_.
Because plan files are shell scripts that can invoke arbitrary external commands, the full set of permissions required isn't known in advance.
The `buildtime_sandbox` shell function lets you extend the studio's sandbox configuration with additional permissions for your specific plan.

If you observe permission errors during a build, the sandbox is likely blocking required access.
To diagnose this, run the following command in a separate terminal while your build runs and watch for denied operations:

```shell

log stream --predicate 'sender="Sandbox"'

...
2026-05-15 11:08:24.741500+0530 0x85533    Error       0x0                  0      0    kernel: (Sandbox) Sandbox: git(30931) deny(1) file-read-data /dev/autofs_nowait
2026-05-15 11:08:24.741542+0530 0x85533    Error       0x0                  0      0    kernel: (Sandbox) Sandbox: git(30931) deny(1) file-read-data /private/var/root/.CFUserTextEncoding
2026-05-15 11:08:24.741604+0530 0x85533    Error       0x0                  0      0    kernel: (Sandbox) Sandbox: git(30931) deny(1) file-read-data /dev/autofs_nowait
2026-05-15 11:08:24.741615+0530 0x85533    Error       0x0                  0      0    kernel: (Sandbox) Sandbox: git(30931) deny(1) file-read-data /private/var/root/.CFUserTextEncoding
2026-05-15 11:08:24.750081+0530 0x85533    Error       0x0                  0      0    kernel: (Sandbox) Sandbox: git(30931) deny(1) file-read-metadata /Users/seq-test
...

```

The above errors show that `git` is being denied access while running in the studio.
You can resolve these errors by providing a buildtime configuration using the `buildtime_sandbox` function in your plan file, as shown in the following example.

```shell
## Contents of plan.sh

....

buildtime_sandbox() {
   echo '(version 1)
;; Enable read permissions across file-system
;; It is possible to enable fine grained access control using
;; (allow file-read-metadata (subpath "/private/var"))
(allow file-read*)
'
}

...

```
