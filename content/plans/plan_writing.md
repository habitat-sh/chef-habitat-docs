+++
title = "Write a Chef Habitat package plan"
description = "Documentation for writing Chef Habitat plan files including configuration templates, binds, and exporting"
summary = "How to write Chef Habitat plans, including configuration templates, binds, exporting, and multi-platform support."



[menu.plans]
    title = "Plan writing"
    identifier = "plans/plan-writing Chef Habitat plan Overview"
    parent = "plans"
    weight = 10
+++

In Chef Habitat, the unit of automation is the application itself. This chapter explains the process and workflow for developing a plan that tells Chef Habitat how to build, deploy, and manage your application.

## Write a plan

Artifacts are the cryptographically-signed tarballs that are uploaded, downloaded, unpacked, and installed in Chef Habitat. They're built from shell scripts known as plans, but may also include application lifecycle hooks and service configuration files that describe the behavior and configuration of a running service.

At the center of Chef Habitat packaging is the plan. This is a directory made up of shell scripts and optional configuration files that define how you download, configure, compile, install, and manage the lifecycle of the software in the artifact. For more conceptual information on artifacts, see [Package identifiers](../reference/pkg_ids.md).

To understand plans, review the following example `plan.sh` for [SQLite](https://www.sqlite.org/):

```shell
pkg_name=sqlite
pkg_version=3130000
pkg_origin=core
pkg_license=('Public Domain')
pkg_maintainer="The Chef Habitat Maintainers <humans@habitat.sh>"
pkg_description="A software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
pkg_upstream_url=https://www.sqlite.org/
pkg_source=https://www.sqlite.org/2016/${pkg_name}-autoconf-${pkg_version}.tar.gz
pkg_filename=${pkg_name}-autoconf-${pkg_version}.tar.gz
pkg_dirname=${pkg_name}-autoconf-${pkg_version}
pkg_shasum=e2797026b3310c9d08bd472f6d430058c6dd139ff9d4e30289884ccd9744086b
pkg_deps=(core/glibc core/readline)
pkg_build_deps=(core/gcc core/make core/coreutils)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
```

{{< note >}}

On Windows, create a `plan.ps1` file instead. All variable names are the same, but you use PowerShell syntax. For example, `pkg_deps=(core/glibc core/readline)` becomes `$pkg_deps=@("core/glibc", "core/readline")`.

{{< /note >}}

This plan defines the software name, version, download location, and checksum used to verify the source. It also defines runtime dependencies on `core/glibc` and `core/readline`, build dependencies on `core/coreutils`, `core/make`, and `core/gcc`, library files in `lib`, header files in `include`, and binaries in `bin`.
Because this is a core plan, it also includes a description and the source project's upstream URL.

{{< note >}}

The `core` prefix is the origin of those dependencies. For more information, see [Create an Origin](https://docs.chef.io/habitat/builder/saas/builder_origins/)

{{< /note >}}

After you finish creating your plan and call `build` in the Chef Habitat Studio, the following occurs:

1. The build script ensures that the private origin key is available to sign the artifact.
2. If specified in `pkg_source`, a compressed file containing the source code is downloaded.
3. The checksum of that file, specified in `pkg_shasum`, is validated.
4. The source is extracted into a temporary cache.
5. Unless they're overridden, callback methods build and install the binary or library with `make` and `make install`, respectively, for Linux-based builds.
6. Your package contents (binaries, runtime dependencies, libraries, assets, etc.) are then compressed into a tarball.
7. The tarball is signed with your private origin key and given a `.hart` file extension.

After the build script completes, you can upload your package to Chef Habitat Builder, or install and start your package locally.

{{< note >}}

The `plan.sh` or `plan.ps1` file is the only required file to create a package. Configuration files, runtime hooks, and other source files are optional.

{{< /note >}}

## Write your first plan

All plans must include a `plan.sh` or `plan.ps1` at the root of the plan context. They can include both files if a package targets both Windows and Linux. The `hab-plan-build` command uses this file to build your package. To create a plan, do the following:

1. If you haven't done so already, [download the `hab` CLI](/install/) and install it according to the instructions on the download page.

2. Run `hab cli setup` and follow the instructions in the setup script.

3. The easiest way to create a plan is to use the `hab plan init` subcommand. This subcommand creates a directory, known as the plan context, that contains your plan file and any runtime hooks or templated configuration data.

    To use `hab plan init` as part of your project repo, go to the root of your project repo and run `hab plan init`. It creates a new `habitat` subdirectory with a `plan.sh` (or `plan.ps1` on Windows) based on the name of the parent directory, and includes a `default.toml` file, plus `config` and `hooks` directories for you to populate as needed.
    For example:

    ```shell
    cd /path/to/<reponame>
    hab plan init
    ```

    This creates a new `habitat` directory at `/path/to/<reponame>/habitat`. A plan file is created, and the `pkg_name` variable is set to _\<reponame\>_.
    Any environment variables that you previously set (such as `HAB_ORIGIN`) are used to populate the related `pkg_*` variables.

    If you want to autopopulate more of the `pkg_*` variables, you also have the option of setting them when calling `hab plan init`, as shown in the following example:

    ```shell
    env pkg_svc_user=someuser pkg_deps="(core/make core/coreutils)" \
       pkg_license="('MIT' 'Apache-2.0')" pkg_bin_dirs="(bin sbin)" \
       pkg_version=1.0.0 pkg_description="foo" pkg_maintainer="you" \
       hab plan init yourplan
    ```

     See [hab plan init](../reference/habitat_cli.md#hab-plan-init) for more information on how to use this subcommand.

4. Now that you have stubbed out your plan file in your plan context, open it and begin modifying it to suit your needs.

When writing a plan, it's important to understand that you're defining both how the package is built and the actions Chef Habitat takes when the Supervisor starts and manages the child processes in the package. The following sections explain what you need to do for each phase.

## Write a plan for multiple platform targets

You can create a plan for an application that runs on multiple platform targets.

The build script looks for the base of your plan in the following locations:

- `<APP_ROOT>/<PLATFORM_TARGET>/`
- `<APP_ROOT>/habitat/<PLATFORM_TARGET>/`
- `<APP_ROOT>/`
- `<APP_ROOT>/habitat/`

### Create a basic plan

If you want to create a basic plan for Windows, macOS, and Linux that doesn't include hooks or configuration templates and just requires a plan file, you can use this simpler structure:

```plain
app_root/
└── habitat/
        plan.sh
        plan.ps1
```

The build script uses the `plan.ps1` to build your package for Windows, and the `plan.sh` to build your package for Linux on x86-64 processors, Linux on ARM, and macOS. If your application requires different plans for macOS, Linux on ARM processors, or Linux on x86-64 processors---even without hooks and configuration templates---create platform-specific folders that target each platform.

### Create a plan with platform-specific folders

To create a build script that targets specific platforms, follow these steps:

1. Create platform-specific folders one of the following locations:

    - In the root of your project (for example, `<APP_ROOT>/<PLATFORM_TARGET>/`)
    - In the top-level `habitat` folder (for example, `<APP_ROOT>/habitat/<PLATFORM_TARGET>/`)

      Use the `habitat` folder if you need to create a clean separation between your application and source code.
      You may not need or want the `habitat` folder if you maintain a separate repository that just contains Habitat plans.

    Replace `<PLATFORM_TARGET>` with one of the following platform-specific folders:

    - `x86_64-linux`
    - `aarch64-linux`
    - `aarch64-darwin`
    - `x86_64-windows`

1. In each platform folder, add the plan file, hooks, and configuration templates for each platform.

For example, you can use the following structure to create plans for an application targeting Linux on x86-64, Linux on ARM, macOS (Apple Silicon), and Windows:

```plain
app_root/
├── x86_64-linux/
|   |   plan.sh
|   └── hooks/
|           run
├── aarch64-linux/
|   |   plan.sh
|   └── hooks/
|           run
├── aarch64-darwin/
|   |   plan.sh
|   └── hooks/
|           run
└── x86_64-windows/
    |   plan.ps1
    └── hooks/
            run
```

{{< note >}}

If the build script finds a plan both inside and outside of a platform-specific folder, it uses the target-specific plan when the package is built for that platform. Defining plans both inside and outside of a target folder is only allowed for backward compatibility with existing plans---future Habitat releases will fail builds where a plan exists in both places.

{{< /note >}}

{{< note >}}

On macOS, the Habitat native studio uses `sandbox-exec` for isolation rather than the `chroot` mechanism used on Linux.
This means macOS builds have access to host-system libraries and tools through Xcode and aren't as fully isolated as Linux builds.
Be explicit about build dependencies in your plan to avoid inadvertently relying on host-provided libraries that won't be available in other environments.

{{< /note >}}

### Buildtime workflow

For build-time installation and configuration, include workflow steps in the plan file that define how to install your application source files into a package. Before writing your plan, understand how your application binaries are currently built and installed, what their dependencies are, and where your application or software library expects to find those dependencies.

The main steps in the buildtime workflow are the following:

1. Create your fully-qualified package identifier.
2. Add licensing and contact information.
3. Download and unpack your source files.
4. Define your dependencies.
5. (Optional) Override any default build phases you need to using callbacks.

The following sections describe each of these steps in more detail.

#### Create your package identifier

An origin is where a team sets default privacy rules, stores packages, and collaborates with teammates. For example, the "core" origin is where the core maintainers of Chef Habitat share packages that are foundational to building other packages. To browse them, go to [Chef Habitat Builder's Core Origin](https://bldr.habitat.sh/#/pkgs/core).

Creating artifacts for a specific origin requires access to that origin's private key. The private origin key signs the artifact when the `hab plan build` command builds it.
Chef Habitat stores origin keys in `$HOME/.hab/cache/keys` on the host machine when running `hab` as a non-root user, and in `/hab/cache/keys` when running as root (including in the Studio).
For more information on origin keys, see [Keys](../reference/keys.md).

The next important part of your package identifier is the package name. A standard naming convention is to base the package name on the source or project you download and install.

#### Add licensing and contact information

You should enter your contact information in your plan.

Most importantly, you should update the `pkg_license` value to indicate the type of license (or licenses) that your source files are licensed under. You can find valid license types at [https://spdx.org/licenses/](https://spdx.org/licenses/). You can include multiple licenses as an array.

{{< note >}}

Because all arrays in the pkg_* settings are shell arrays, they're whitespace delimited.

{{< /note >}}

#### Download and unpack your source files

Add the `pkg_source` value that points to your source files. Any `wget` URL works. However, unless you're downloading a tarball from a public endpoint, you may need to modify how you download your source files and where your `plan.sh` performs the download operation.

Chef Habitat supports retrieving source files from [GitHub](https://github.com). When cloning from GitHub, use HTTPS URIs because they're proxy-friendly, while `git@github` or `git://` URIs aren't. To download source from a GitHub repository, implement `do_download()` in your `plan.sh` (or `Invoke-Download` in a `plan.ps1`) and add `core/git` as a build dependency.
Because Chef Habitat doesn't include a system-wide CA cert bundle, use `core/cacerts` and export the `GIT_SSL_CAINFO` environment variable to the Linux path in `core/cacerts`.
The following example shows this in the `do_download()` callback.

```shell
do_download() {
  export GIT_SSL_CAINFO="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
  git clone https://github.com/chef/chef
  pushd chef
  git checkout $pkg_version
  popd
  tar -cjvf $HAB_CACHE_SRC_PATH/${pkg_name}-${pkg_version}.tar.bz2 \
      --transform "s,^\./chef,chef-${pkg_version}," ./chef \
      --exclude chef/.git --exclude chef/spec
  pkg_shasum=$(trim $(sha256sum $HAB_CACHE_SRC_PATH/${pkg_filename} | cut -d " " -f 1))
}
```

The `plan.ps1` equivalent would be:

```powershell
Function Invoke-Download {
  git clone https://github.com/chef/chef
  pushd chef
  git checkout $pkg_version
  popd
  Compress-Archive -Path chef/* -DestinationPath $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version.zip -Force
  $script:pkg_shasum = (Get-FileHash -path $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version.zip -Algorithm SHA256).Hash.ToLower()
}
```

After you specify your source in `pkg_source` or override the **do_download()** or **Invoke-Download** callback, create a SHA-256 checksum for your source archive and enter it as the `pkg_shasum` value. The build script verifies this after it downloads the archive.

{{< note >}}

If your computed value doesn't match the value calculated by the `hab-plan-build` script, the `hab-plan-build` script returns an error with the expected value when you execute your plan.

{{< /note >}}

If your package doesn't download any application or service source files, you need to override the **do_download()**, **do_verify()**, and **do_unpack()** callbacks.
See [Callbacks](../reference/build_phase_callbacks.md) for details.

#### Define your dependencies

Applications have two types of dependencies: buildtime and runtime.

Declare any build dependencies in `pkg_build_deps` and any run dependencies in `pkg_deps`. You can include version and release information when declaring dependencies if your application is bound to a particular version.

The package `core/glibc` is typically listed as a run dependency and `core/coreutils` as a build dependency, however, you shouldn't take any inference from this. There aren't standard dependencies that every package must have. For example, the `mytutorialapp` package only includes the `core/node` as a run dependency. You should include dependencies that would natively be part of the build or runtime dependencies your application or service would normally depend on.

The third type is transitive dependencies, which are runtime dependencies of the build or runtime dependencies listed in your plan. You don't need to explicitly declare transitive dependencies, but they're included in the file list when your package is built.
See [Package contents](../reference/package_contents.md) for more information.

#### Override build phase defaults with callbacks

As shown in the earlier example, there are times when you need to override the default behavior of the `hab-plan-build` script. The plan syntax guide lists the default implementations for [build phase callbacks](../reference/build_phase_callbacks.md). If you need to reference specific packages while building your applications or services, override the default implementations, as in the following example.

```shell
pkg_name=httpd
pkg_origin=core
pkg_version=2.4.18
pkg_maintainer="The Chef Habitat Maintainers <humans@habitat.sh>"
pkg_license=('apache')
pkg_source=http://www.apache.org/dist/${pkg_name}/${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=1c39b55108223ba197cae2d0bb81c180e4db19e23d177fba5910785de1ac5527
pkg_deps=(core/glibc core/expat core/libiconv core/apr core/apr-util core/pcre core/zlib core/openssl)
pkg_build_deps=(core/patch core/make core/gcc)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_exports=(
  [port]=serverport
)
pkg_svc_run="httpd -DFOREGROUND -f $pkg_svc_config_path/httpd.conf"
pkg_svc_user="root"

do_build() {
  ./configure --prefix=$pkg_prefix \
              --with-expat=$(pkg_path_for expat) \
              --with-iconv=$(pkg_path_for libiconv) \
              --with-pcre=$(pkg_path_for pcre) \
              --with-apr=$(pkg_path_for apr) \
              --with-apr-util=$(pkg_path_for apr-util) \
              --with-z=$(pkg_path_for zlib) \
              --enable-ssl --with-ssl=$(pkg_path_for openssl) \
              --enable-modules=most --enable-mods-shared=most
  make
}
```

In this example, the `core/httpd` plan references several other core packages using the `pkg_path_for` function before `make` is called. You can use a similar pattern if you need to reference a binary or library when building your source files.

Or consider this override from a plan.ps1:

```powershell
function Invoke-Build {
    Push-Location "$PLAN_CONTEXT"
    try {
        cargo build --release --verbose
        if($LASTEXITCODE -ne 0) {
            Write-Error "Cargo build failed!"
        }
    }
    finally { Pop-Location }
}
```

Here the plan is building an application written in Rust, so it overrides `Invoke-Build` and uses the `cargo` utility included in its buildtime dependency on `core/rust`.

{{< note >}}

PowerShell plan function names differ from their Bash counterparts because they use the `Invoke` verb instead of the `do_` prefix.

{{< /note >}}

When overriding any callbacks, you may use any of the [variables](../reference/plan_variables.md), [settings](../reference/plan_settings.md), or [functions](../reference/build_helpers.md), except for the [runtime template data](../reference/service_templates.md). Those can only be used in Application Lifecycle hooks once a Chef Habitat service is running.

### Runtime workflow

Like build-time setup and installation, you must define runtime behavior for your application or service for the Supervisor. You define this at runtime with Application lifecycle hooks.
See [Application lifecycle hooks](../reference/application_lifecycle_hooks.md) for more information and examples.

If you only need to start the application or service when the Chef Habitat service starts, you can instead use the `pkg_svc_run` setting and specify the command as a string. When your package is created, Chef Habitat creates a basic run hook.

You can use any of the [runtime configuration settings](../reference/service_templates.md), either defined by you in your config file, or defined by Chef Habitat.

When you're done writing your plan, use the studio to [build your package](../packages/pkg_build.md).

### Related resources

- [Write plans](#write-a-plan): Describes what a plan is and how to create one.
- [Add configuration to plans](../reference/config_templates.md): Learn how to make your running service configurable by templatizing configuration files in your plan.
- [Binary-only packages](binary_wrapper.md): Learn how to create packages from software that comes only in binary form, like off-the-shelf or legacy programs.

You may also find the [settings](../reference/plan_settings.md), [variables](../reference/plan_variables.md), and [functions](../reference/build_helpers.md) documentation useful when creating your plan.
