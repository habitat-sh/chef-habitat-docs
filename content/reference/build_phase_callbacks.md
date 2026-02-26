+++
title = "Build phase callbacks"
description = "Override default buildtime behavior with build phase callbacks"


[menu.reference]
    title = "Build phase callbacks"
    identifier = "reference/build-phase-callbacks"
    parent = "reference"
+++

When defining your plan, you can override Chef Habitat's default behavior in each build phase through a callback. To define a callback, create a shell function of the same name in your plan file, and then write your script. If you don't want to use the default callback behavior, you must override the callback and `return 0` in the function definition, or provide no implementation in a `plan.ps1`.

These callbacks are listed in the order they're executed by the package build script.

{{< note >}}

Bash callbacks are prefixed with `do_` and use an underscore convention. PowerShell plans prefix callbacks with `Invoke-` and use a PascalCase convention.

{{< /note >}}

You can also use [plan variables](plan_variables) in your plans to place binaries, libraries, and files in their correct locations during package compilation or when running as a service.

Additionally, [plan helper functions](build_helpers) can help you build your package correctly. They're mostly used for package builds, while `attach()` is used for debugging.

do_begin()/Invoke-Begin
: Used to execute arbitrary commands before anything else happens. At this phase of the build, no dependencies are resolved, the `$PATH` and environment aren't set, and no external source has been downloaded. For a phase that's more fully set up, see the `do_before()` phase.

do_begin_default()/Invoke-BeginDefault
: There's an empty default implementation of this callback.

do_setup_environment()/Invoke-SetupEnvironment
: Use this to declare build-time and runtime environment variables that overwrite or add to the default environment variables created by Chef Habitat during the build process. Common variables you might add or modify include `JAVA_HOME` and `GEM_PATH`.

{{< note >}}

You don't have to override this callback if you don't wish to modify your environment variables. The build system will always set up your environment according to your dependencies. For example, it will ensure that dependency binaries are always present on your `PATH` variable.

{{< /note >}}

Runtime environments of dependencies are layered together in the order they're declared in your `pkg_deps` array, followed by modifications made in this callback. In turn, these computed values will be made available to packages that use the current package as a dependency.

The build-time environment is assembled by processing the *runtime* environments of your `pkg_build_deps` dependencies (because they run in your build) in a similar manner. The final environment in which your package is built consists of:

- The system environment of your Studio as the base layer
- The assembled runtime environment of your package on top of the base
- Any build-time environment information on top of the assembled runtime environment

Only the runtime portion of this combined build-time environment is made available to your package when it's running in a Supervisor (or when it's used as a dependency of another Chef Habitat package).

To add or modify your environment variables, there are special functions to call within this callback to ensure that the variables are set up appropriately.

{{< foundation_tabs tabs-id="bash-powershell-panel1" >}}
  {{< foundation_tab active="true" panel-link="bash-panel1" tab-text="Bash">}}
  {{< foundation_tab panel-link="powershell-panel1" tab-text="Powershell" >}}
{{< /foundation_tabs >}}

{{< foundation_tabs_panels tabs-id="bash-powershell-panel1" >}}
  {{< foundation_tabs_panel active="true" panel-id="bash-panel1" >}}

  ```bash
  set_runtime_env [-f] VARIABLE_NAME VALUE
  set_buildtime_env [-f] VARIABLE_NAME VALUE
  ```

  {{< /foundation_tabs_panel >}}

  {{< foundation_tabs_panel panel-id="powershell-panel1" >}}

  ```powershell
  Set-RuntimeEnv VARIABLE_NAME VALUE [-force] [-IsPath]
  Set-BuildtimeEnv VARIABLE_NAME VALUE [-force] [-IsPath]
  ```

  {{< /foundation_tabs_panel >}}
{{< /foundation_tabs_panels >}}

In PowerShell plans, if your variable contains file paths pointing inside the Chef Habitat `/hab` directory, you can use the `-IsPath` flag to ensure the path remains portable across different Chef Habitat environments. For example, in a local (non-Docker) Windows Studio, the following line:

```powershell
Set-RuntimeEnv SSL_CERT_FILE "$(Get-HabPackagePath cacerts)/ssl/cert.pem"
```

sets `SSL_CERT_FILE` to the `ssl/cert.pem` file inside the `cacerts` package path. This path is located inside `c:/hab/studios`, which won't be valid in a non-Studio Supervisor or in a Docker Studio. Instead, use the following code:

```powershell
Set-RuntimeEnv SSL_CERT_FILE "$(Get-HabPackagePath cacerts)/ssl/cert.pem" -IsPath
```

This hints to the packaging system that this path should be properly rooted inside the Chef Habitat filesystem of the current running environment.

These functions allow you to *set* an environment variable's value. If one of your dependencies has already declared a value for this, it will result in a build failure, protecting you from inadvertently breaking anything. If you really do want to replace the value, you can supply the `-f` or `-force` flag.

For pushing new values onto a multi-valued environment variable (like `PATH`), use the following functions:

{{< foundation_tabs tabs-id="bash-powershell-panel2" >}}
  {{< foundation_tab active="true" panel-link="bash-panel2" tab-text="Bash">}}
  {{< foundation_tab panel-link="powershell-panel2" tab-text="Powershell" >}}
{{< /foundation_tabs >}}

{{< foundation_tabs_panels tabs-id="bash-powershell-panel2" >}}
  {{< foundation_tabs_panel active="true" panel-id="bash-panel2" >}}

  ```bash
  push_runtime_env VARIABLE_NAME VALUE
  push_buildtime_env VARIABLE_NAME VALUE
  ```

  {{< /foundation_tabs_panel >}}

  {{< foundation_tabs_panel panel-id="powershell-panel2" >}}

  ```powershell
  Push-RuntimeEnv VARIABLE_NAME VALUE [-IsPath]
  Push-BuildtimeEnv VARIABLE_NAME VALUE [-IsPath]
  ```

  {{< /foundation_tabs_panel >}}
{{< /foundation_tabs_panels >}}

These functions allow you to push a new value onto a multi-valued environment variable without overwriting the existing values. These multi-valued variables are referred to as "aggregate" variables in Chef Habitat. Single-value environment variables are known as "primitive" variables.

By default, Chef Habitat treats all variables as "primitive" variables. If you are working with a value that's actually an "aggregate" type, you must set the following special environment variable somewhere in the top level of your plan.

{{< foundation_tabs tabs-id="bash-powershell-panel3" >}}
  {{< foundation_tab active="true" panel-link="bash-panel3" tab-text="Bash">}}
  {{< foundation_tab panel-link="powershell-panel3" tab-text="Powershell" >}}
{{< /foundation_tabs >}}

{{< foundation_tabs_panels tabs-id="bash-powershell-panel3" >}}
  {{< foundation_tabs_panel active="true" panel-id="bash-panel3" >}}

  ```bash
  export HAB_ENV_FOO_TYPE=aggregate
  ```

  {{< /foundation_tabs_panel >}}

  {{< foundation_tabs_panel panel-id="powershell-panel3" >}}

  ```powershell
  $env:HAB_ENV_FOO_TYPE="aggregate"
  ```

  {{< /foundation_tabs_panel >}}
{{< /foundation_tabs_panels >}}

Similarly, Chef Habitat defaults to using the colon (`:`) as a separator for aggregate variables on Linux. If the hypothetical `FOO` variable uses a semicolon (`;`) as a separator instead, then you must add `export HAB_ENV_FOO_SEPARATOR=;` at the top level of the plan. On Windows, `;` is the default separator.

In all cases, when Chef Habitat is assuming a default strategy, it will emit log messages to notify you of that along with instructions on how to change the behavior.

{{< note >}}

If you discover common environment variables that Chef Habitat doesn't currently treat appropriately, feel free to request an addition to the codebase, or even to submit a pull request yourself.

{{< /note >}}

do_before()/Invoke-Before
: At this phase of the build, the origin key has been checked for, all package dependencies have been resolved and downloaded, and the `$PATH` and environment are set, but this is just before any source downloading would occur (if `$pkg_source` is set). This could be a suitable phase in which to compute a dynamic version of a package given the state of a Git repository, fire an API call, start timing something, etc.

do_before_default()/Invoke-BeforeDefault
: There's an empty default implementation of this callback.

do_download()/Invoke-Download
: If `$pkg_source` is being used, download the software and place it in `$HAB_CACHE_SRC_PATH/$pkg_filename`. If the source already exists in the cache, verify that the checksum is what we expect, and skip the download. Delegates most of the implementation to the `do_default_download()` function.

do_download_default()/Invoke-DownloadDefault
: The default implementation downloads the software specified in `$pkg_source`, verifies its checksum, and places it in `$HAB_CACHE_SRC_PATH/$pkg_filename`, which resolves to a path like `/hab/cache/src/filename.tar.gz`. You should override this behavior if you need to change how your binary source is downloaded, if you aren't downloading any source code, or if you are cloning from Git. If you clone a repo from Git, you must override `do_verify()` to return 0.

do_verify()/Invoke-Verify
: If `$pkg_source` is being used, verify that the package in `$HAB_CACHE_SRC_PATH/$pkg_filename` has the expected `$pkg_shasum`. Delegates most of the implementation to the `do_default_verify()` function.

  If you clone a repo from Git, you must override `do_verify()` to return 0.

do_verify_default()/Invoke-VerifyDefault
: The default implementation tries to verify the checksum specified in the plan against the computed checksum after downloading the source tarball to disk. If the specified checksum doesn't match the computed checksum, then an error and a message specifying the mismatch will be printed to stderr. You shouldn't need to override this behavior unless your package doesn't download any files.

do_clean()/Invoke-Clean
: Cleans up remnants of any previous build job, ensuring they can't pollute new output. Delegates most of the implementation to the `do_default_clean()` function.

do_default_clean()/Invoke-DefaultClean
: The default implementation removes the `HAB_CACHE_SRC_PATH/$pkg_dirname` folder in case there was a previously-built version of your package installed on disk. This ensures you start with a clean build environment.

do_unpack()/Invoke-Unpack
: If `$pkg_source` is being used, this phase takes `$HAB_CACHE_SRC_PATH/$pkg_filename` from the download step and unpacks it, as long as the extraction method can be determined. This takes place in the `$HAB_CACHE_SRC_PATH` directory. Delegates most of the implementation to the `do_default_unpack()` function.

do_default_unpack()/Invoke-DefaultUnpack
: The default implementation extracts your tarball source file into `$HAB_CACHE_SRC_PATH`. The supported archive extensions on Linux are: `.tar`, `.tar.bz2`, `.tar.gz`, `.tar.xz`, `.rar`, `.zip`, `.Z`, and `.7z`. Only `.zip` is supported on Windows. If the file archive can't be found or has an unsupported extension, a message is printed to stderr with additional information.

do_prepare()/Invoke-Prepare
: There's no default implementation of this callback. At this point in the build process, the tarball source has been downloaded and unpacked, and build environment variables have been set, so you can use this callback to perform actions before the package starts building, such as exporting variables or adding symlinks.

  This step exists to be overridden. Use it to do what you need before running build steps.

do_default_prepare()/Invoke-DefaultPrepare
: There's an empty default implementation of this callback.

do_build()/Invoke-Build
: You should override this behavior if you have additional configuration changes to make or other software to build and install as part of building your package. This step builds the software; assumes the GNU pattern. Delegates most of the implementation to the `do_default_build()` function.

do_default_build()/Invoke-DefaultBuild
: The default implementation is to update the prefix path for the configure script to use `$pkg_prefix` and then run `make` to compile the downloaded source. This means the script in the default implementation does `./configure --prefix=$pkg_prefix && make`.

do_check()/Invoke-Check
: Runs post-compile tests and checks, provided two conditions are true:

1. A `do_check()` function has been declared. By default, no such function exists, so the plan author must add one explicitly---there's no reasonably good default here.
1. A `$DO_CHECK` environment variable is set to some non-empty value. As tests can dramatically inflate the build time of a plan, this has been left as an opt-in option.

   Here's an example of a vanilla plan such as `sed`:

   ```bash
   core-plans/sed/plan.sh
   pkg_name=sed
   # other plan metadata...

   do_check() {
     make check
   }
   ```

do_install()/Invoke-Install
: Installs the software. Delegates most of the implementation to the `do_default_install()` function. You should override this behavior if you need to perform custom installation steps, such as copying files from `HAB_CACHE_SRC_PATH` to specific directories in your package, or installing pre-built binaries into your package.

do_default_install()/Invoke-DefaultInstall
: The default implementation runs `make install` on source files and places compiled binaries or libraries in `HAB_CACHE_SRC_PATH/$pkg_dirname`, which resolves to a path like `/hab/cache/src/packagename-version/`. It uses this location because `do_build()` uses the `--prefix` option when calling the configure script.

do_build_config()/Invoke-BuildConfig
: Copy the `./config` directory, relative to the Plan, to `$pkg_prefix/config`. Do the same with `default.toml`. Delegates most of the implementation to the `do_default_build_config()` function.

  Allows users to depend on a core plan and pull in its configuration but set their own unique configurations at build time.

do_default_build_config()/Invoke-DefaultBuildConfig
: Default implementation for the `do_build_config()` phase.

do_build_service()/Invoke-BuildService
: Writes the `$pkg_prefix/run` file. If a file named `hooks/run` exists, this step is skipped. Otherwise, it looks for `$pkg_svc_run` and uses that. This assumes that the binary used in the `$pkg_svc_run` command is set in `$PATH`.

  This writes a `run` script that uses `chpst` to run the command as `$pkg_svc_user` and `$pkg_svc_group`. These are `hab` by default.

  Delegates most of the implementation to the `do_default_build_server()` function.

do_default_build_service()/Invoke-DefaultBuildService
: Default implementation of the `do_build_service()` phase.

do_strip()
: `plan.sh` only. You should override this behavior if you want to change how the binaries are stripped, which additional binaries located in subdirectories might also need to be stripped, or whether you don't want the binaries stripped at all.

do_default_strip()
: `plan.sh` only. The default implementation strips debugging symbols from binaries in `$pkg_prefix`. The goal of this step is to reduce total size.

do_after()/Invoke-After
: At this phase, the package has been built, installed, and stripped, but package metadata hasn't been written yet and the artifact hasn't been created or signed.

do_default_after()/Invoke-DefaultAfter
: There's an empty default implementation of this callback.

do_end()/Invoke-End
: A function for cleanup that's called after the package artifact is created. You can use this callback to remove temporary files or perform other post-build cleanup actions.

do_default_end()/Invoke-DefaultEnd
: There's an empty default implementation of this callback.

do_after_success()
: `plan.sh` only. A function called at the end of a successful build process. You can use this to provide integration points with external systems, among other uses, particularly if you aren't using Builder. Failure of this callback won't fail your build, nor will it trigger a `do_after_failure` call.

do_after_failure()
: `plan.sh` only. A function called at the end of a failed build process. You can use this to provide integration points with external systems, among other uses, particularly if you aren't using Builder. The result of this callback can't affect the overall build result; once the build has failed, it's failed. Keep in mind that because a build can fail at any time, certain variables or data structures may not be present or initialized when this callback is called, so code accordingly.
