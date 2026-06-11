+++
title = "Install the Chef Habitat CLI"
description = "Download and install the Chef Habitat CLI"
linkTitle = "Install"

[menu.install]
    title = "Install Chef Habitat"
    identifier = "install/installing-packages"
    parent = "install"
    weight = 10
+++

Chef Habitat provides a command-line interface (CLI) tool called `hab` that you use to build packages, manage services, and interact with Chef Habitat Builder.
This section includes installation instructions for Linux, macOS, and Windows.

## System requirements

Before you install Chef Habitat, confirm that your system meets these requirements.

### Operating system and architecture requirements

- Modern Linux kernels on a 64-bit x86_64 processor (Intel or AMD)
- Modern Linux kernels on a 64-bit ARM processor
- Windows Server 2012 or later, or Windows 8 or later on a 64-bit processor
- macOS 14 or later on a 64-bit Apple Silicon or Intel processor

### Docker requirements

You need Docker Desktop only if you want to use the [Docker-based Chef Habitat Studio](/studio/), which you invoke with the `-D` flag.

If you do need Docker Desktop, install it for your platform:

- [Docker Desktop for Linux](https://docs.docker.com/desktop/setup/install/linux/)
- [Docker Desktop for macOS](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

On Linux, you must have [Docker Engine installed](https://docs.docker.com/engine/install/) to export a Chef Habitat artifact to a Docker image.

Chef Habitat doesn't support alternative containerization platforms.

## Install on Linux

### Install from the command line

Progress Chef recommends installing Chef Habitat on Linux with the install script.

To install Chef Habitat with the install script:

1. Export your Chef Habitat Builder auth token:

    ```shell
    export HAB_AUTH_TOKEN=<your-token>
    ```

1. Run the install script:

    ```shell
    curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo -E bash
    ```

    To install a specific Chef Habitat version,  `-v <HABITAT_VERSION>`, for example:

    ```shell
    curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
        | sudo -E bash -s -- -v 2.0.504
    ```

### Install manually

1. [Download Chef Habitat for Linux](https://www.chef.io/downloads)

1. Extract the `hab.tgz` binary to `/usr/local/bin` or add its location to your `PATH`, for example:

    ```shell
    tar -xvzf hab.tgz -C /usr/local/bin --strip-components 1
    ```

## Install on macOS

The following list summarizes what's supported when running Chef Habitat on macOS:

| Feature                                             | Supported                     |
| --------------------------------------------------- | ----------------------------- |
| `hab` CLI                                           | Yes                           |
| `hab pkg install` and package downloads             | Yes                           |
| Build packages (native macOS studio)                | Yes                           |
| Build Linux packages (Docker studio with `-D` flag) | Yes (requires Docker Desktop) |
| Upload packages to Chef Habitat Builder             | Yes                           |
| Habitat Supervisor                                  | No                            |
| Habitat Services                                    | No                            |

### Install from the command line

Progress Chef recommends installing Chef Habitat on macOS with the install script.

To install Chef Habitat with the install script, follow these steps:

1. Export your Chef Habitat Builder auth token:

    ```shell
    export HAB_AUTH_TOKEN=<your-token>
    ```

1. Run the install script:

    ```shell
    curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo -E bash
    ```

    To install a specific Habitat version pass the version number to the install script with `-v <HABITAT_VERSION>`, for example:

    ```shell
    curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
        | sudo -E bash -s -- -v 2.0.504
    ```

### Install with Homebrew

To install Chef Habitat with Homebrew, run the following commands:

```shell
brew tap habitat-sh/habitat
brew install hab
```

### Install manually

1. [Download Chef Habitat for macOS](https://www.chef.io/downloads)

1. Unzip the Chef Habitat binary to `/usr/local/bin` to add it to your system `PATH`.

1. Remove the quarantine attribute that macOS sets on files downloaded through a browser:

    ```shell
    xattr -d com.apple.quarantine /usr/local/bin/hab
    ```

### Additional setup to build Chef Habitat packages

If you plan to [build Chef Habitat packages](/packages/pkg_build/) in [Habitat Studio](/studio) on macOS, you must also install or configure the following dependencies.

#### Virtual machine environment

The macOS-native Chef Habitat Studio uses `sandbox-exec` for isolation but shares the `/opt/hab` filesystem with your host.
Packages installed during a build persist on the host, and builds aren't guaranteed to be clean between sessions in the same way as Linux chroot-based studios.
To avoid affecting your host Chef Habitat environment, run the macOS native studio inside a virtual machine (for example, UTM or Parallels on Apple Silicon).

#### Install Xcode Command Line Tools

Chef Habitat Studio on macOS uses the Clang compiler and linker toolkit provided by the Xcode Command Line Tools.

- To install the Xcode Command Line Tools, run the following command:

    ```shell
    xcode-select --install
    ```

## Install on Windows

### Install with Chocolatey

Progress Chef recommends installing Chef Habitat on Windows with Chocolatey.

To install Chef Habitat with Chocolatey, run the following command:

```powershell
choco install habitat
```

### Install from the command line

You can install Chef Habitat by downloading and running the installation script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1'))
```

You can install a specific Chef Habitat version with `-Version <HABITAT_VERSION>`, for example:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1) } -Version 2.0.504
```

### Install manually

1. [Download Chef Habitat for Windows](https://www.chef.io/downloads)

1. Unzip the Chef Habitat binary on your computer to `C:\habitat` so that the full path to Chef Habitat looks like `C:\habitat\hab-<HABITAT_VERSION>-<YYYYMMDDHHMMSS>-x86_64-windows`.

    For example, `C:\habitat\hab-0.79.1-20190410221450-x86_64-windows`.

1. Add that directory to your `PATH` variable:

    ```powershell
    $env:PATH += ";C:\habitat\hab-0.79.1-20190410221450-x86_64-windows\"
    ```

## Verify installation

To verify your installation, run the following commands:

```shell
hab --version
hab cli setup --help
```

## See also

- [install.sh script reference](install_script_reference)
- [troubleshooting](/troubleshooting/)

## Next steps

- [Configure the Chef Habitat CLI](hab_setup)
