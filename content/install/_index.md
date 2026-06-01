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

You need Docker Desktop only if you want to use the Docker-based Habitat Studio, which you invoke with the `-D` flag.

If you do need Docker Desktop, install it for your platform:

- [Docker Desktop for Linux](https://docs.docker.com/desktop/setup/install/linux/)
- [Docker Desktop for macOS](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

On Linux, you must have [Docker Engine installed](https://docs.docker.com/engine/install/) to export a Chef Habitat artifact to a Docker image.

Chef Habitat doesn't support alternative containerization platforms.

## Install on Linux

### Install from the command line

Progress Chef recommends installing Chef Habitat on Linux with the install script.

To install Chef Habitat with the install script, run the following command:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

You can install a specific Chef Habitat version with `-v <HABITAT_VERSION>`, for example:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
    | sudo bash -s -- -v 2.0.504
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

To install Chef Habitat with the install script, run the following command:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

You can install a specific Chef Habitat version with `-v <HABITAT_VERSION>`, for example:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
    | sudo bash -s -- -v 2.0.504
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

### Additional setup to build Habitat packages

If you plan to [build Habitat packages](/packages/pkg_build/) in [Chef Habitat Studio](/studio) on macOS, you must also install or configure the following dependencies.

#### Virtual machine environment

The macOS-native Habitat Studio uses `sandbox-exec` for isolation but shares the `/opt/hab` filesystem with your host.
Packages installed during a build persist on the host, and builds aren't guaranteed to be clean between sessions in the same way as Linux chroot-based studios.
To avoid affecting your host Habitat environment, run the macOS native studio inside a virtual machine (for example, UTM or Parallels on Apple Silicon).

#### Download and enable Xcode

Habitat Studio on macOS uses the Clang compiler and linker toolkit provided by Xcode.
The Xcode Command Line Tools package doesn't include the full SDK headers and frameworks that Habitat Studio requires, so you need the full Xcode application.

1. Download the Xcode version appropriate for your macOS release and save it to your `Applications` folder.

    You need Xcode 15 or later for macOS 14 (Sonoma) and later.
    See [Xcode Releases](https://xcodereleases.com/) for a list of Xcode versions and their supported macOS releases.

1. Point macOS build tools to the full Xcode SDK and accept the license agreement:

    ```shell
    # Default xcode-select -p may show /Library/Developer/CommandLineTools
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

    # Accept the Xcode license
    sudo xcodebuild -license accept
    ```

#### Install the latest Bash shell

Habitat plan files use features available in Bash 5.0 and later.
Most macOS systems ship with Bash 3.2 due to licensing constraints.
You can install a compatible version using the `core/bash` Habitat package.

1. Install and configure the `core/bash` Habitat package:

    ```shell
    # Install core Bash
    hab pkg install core/bash --binlink --force

    # Make the latest Bash available for build scripts
    export PATH=/usr/local/bin:$PATH

    # Verify the version---it should show 5.2.x or later
    bash --version
    ```

1. To persist this `PATH` change across terminal sessions, add the following line to your shell profile (typically `~/.zshrc` on macOS):

    ```shell
    export PATH=/usr/local/bin:$PATH
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
