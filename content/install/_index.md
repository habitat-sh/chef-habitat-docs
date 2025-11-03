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

Chef Habitat provides a command-line interface (CLI) tool called `hab` that you use to build packages, manage services, and interact with Chef Habitat Builder. This section provides installation instructions for Linux, macOS, and Windows.

## System requirements

Before installing Chef Habitat, ensure your system meets these requirements.

### Install script requirements

Requirements on all platforms:

- Internet connectivity to `packages.chef.io`

Linux requirements:

- `curl` or `wget` with SSL support
- `tar` and `gzip` for archive extraction
- `sha256sum` for checksum verification
- Root or sudo access for system installation

macOS requirements:

- `curl` or `wget` with SSL support
- `diskutil` for volume management
- `security` command for keychain operations
- `launchctl` for daemon management
- Administrative privileges for system configuration

### Operating system and architecture requirements

- Linux kernel 2.6.32 or later on a 64-bit processor
- Modern Linux kernels on a 64-bit ARM processor
- Windows Server 2012 or later, or Windows 8 or later on a 64-bit processor
- macOS 10.9 or later on a 64-bit processor

### Docker requirements

To run Chef Habitat Studio, you must have Docker Desktop installed:

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

You can install a specific Habitat version with `-v <HABITAT_VERSION>`. For example:

```sh
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
    | sudo bash -s -- -v 1.6.1245
```

### Install manually

1. [Download Chef Habitat for Linux](https://www.chef.io/downloads)

1. Extract the `hab.tgz` binary to `/usr/local/bin` or add its location to your `PATH`. For example:

   ```sh
   tar -xvzf hab.tgz -C /usr/local/bin --strip-components 1
   ```

## Install on macOS

### Install from the command line

Progress Chef recommends installing Chef Habitat on macOS with the install script.

To install Chef Habitat with the install script, run the following command:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

You can install a specific Habitat version with `-v <HABITAT_VERSION>`. For example:

```sh
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
    | sudo bash -s -- -v 1.6.1245
```

### Install using Homebrew

To install Chef Habitat with Homebrew, run the following commands:

```bash
brew tap habitat-sh/habitat
brew install hab
```

### Install manually

1. [Download Chef Habitat for macOS](https://www.chef.io/downloads)

1. Unzip Habitat binary to `/usr/local/bin` to add it to your system `PATH`.

## Install on Windows

### Install using Chocolatey

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

You can install a specific Habitat version with `-Version <HABITAT_VERSION>`. For example:

```ps1
iex "& { $(irm https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1) } -Version 1.6.1245"
```

### Install manually

1. [Download Chef Habitat for Windows](https://www.chef.io/downloads)

1. Unzip the Habitat binary on your computer to `C:\habitat` so that the full path to Chef Habitat is similar to `C:\habitat\hab-<HABITAT_VERSION>-<YYYYMMDDHHMMSS>-x86_64-windows`

    For example: `C:\habitat\hab-0.79.1-20190410221450-x86_64-windows`.

1. Add that directory to your `PATH` variable:

    ```powershell
    $env:PATH += ";C:\habitat\hab-0.79.1-20190410221450-x86_64-windows\"
    ```

## Verify installation

To verify that Habitat is installed, you can run the following commands:

```bash
hab --version
hab cli setup --help
```

## See also

- [install.sh script reference](install_script_reference)
- [troubleshooting](/troubleshooting/)

## Next steps

- [Configure the Chef Habitat CLI](hab_setup)
