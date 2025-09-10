+++
title = "Install Chef Habitat"
description = "Download and install the Chef Habitat CLI and configure your workstation for Chef Habitat development"
linkTitle = "Install"

[menu.install]
    title = "Install Chef Habitat"
    identifier = "install/installing-packages"
    parent = "install"
    weight = 10
+++

Chef Habitat provides a command-line interface (CLI) tool called `hab` that you use to build packages, manage services, and interact with Chef Habitat Builder. This section provides installation instructions for Linux, macOS, and Windows.

## Quick Start

Choose your operating system to get started:

- **Linux**: [Install from command line](#install-chef-habitat-from-the-command-line-recommended) (recommended) or [manual download](#chef-habitat-for-linux)
- **macOS**: [Install with Homebrew](#install-chef-habitat-using-homebrew) (recommended) or [manual download](#chef-habitat-for-mac)
- **Windows**: [Install with Chocolatey](#chef-habitat-for-windows) (recommended) or [manual download](#installing-habitat-for-windows-using-the-downloaded-chef-habitat-package)

## System Requirements

Before installing Chef Habitat, ensure your system meets these requirements:

| Platform | Requirements |
|----------|-------------|
| **Linux** | 64-bit processor, modern kernel versions (see note below) |
| **macOS** | 64-bit processor, the latest release of macOS or one of Apple's actively supported versions |
| **Windows** | 64-bit processor, versions of Windows receiving Active or Security support by Microsoft |

{{< note >}}
Modern kernel version means Linux kernel versions still supported the Linux kernel team or found within a distribution for which a vendor is actively providing support for.
{{< /note >}}

### Additional Requirements for Container Export

- **Linux**: Docker Engine, Docker Desktop for Linux
- **macOS**: Docker for Mac
- **Windows**: Docker for Windows

{{< note >}}
Use of the official Docker distribution is required.
{{< /note >}}

## Chef Habitat for Linux

On Linux, exporting your Chef Habitat artifact to a Docker image requires the Docker Engine supplied by Docker. Packages from distribution-specific or otherwise alternative providers are currently not supported.

Once you have downloaded the package, extract the hab binary with tar to `/usr/local/bin` or add its location to your `PATH` (for example, `tar -xvzf hab.tgz -C /usr/local/bin --strip-components 1`).

[Download Chef Habitat for Linux](https://www.chef.io/downloads)

### Install Chef Habitat from the Command Line (Recommended)

The easiest way to install Chef Habitat on Linux is using the installation script:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

## Chef Habitat for Mac

### Install Chef Habitat from the Command Line (Recommended)

The easiest way to install Chef Habitat on macOS is using the installation script:

```shell
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

### Install Chef Habitat Using Homebrew

Chef Habitat can also be installed with Homebrew, by running the following commands:

```bash
brew tap habitat-sh/habitat
brew install hab
```

### Manual Installation

[Download Chef Habitat for Mac](https://www.chef.io/downloads)

Once you have downloaded the `hab` CLI, unzip it onto your machine. Unzipping to `/usr/local/bin` should place it on your `PATH`. In order to use the Chef Habitat Studio, you'll also need to install Docker for Mac.

[Install Docker Desktop for Mac](https://docs.docker.com/desktop/setup/install/mac-install/)

## Chef Habitat for Windows

Chocolatey is a package manager for Windows. You can use it to easily install, configure, upgrade, and even uninstall Windows software packages. We recommend using Chocolatey for installing Chef Habitat.

Install Chef Habitat with Chocolatey, by running the following command:

```powershell
choco install habitat
```

### Install Chef Habitat using a PowerShell install script

Alternatively, you can install Chef Habitat by downloading and running the installation script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1'))
```

### Installing Habitat for Windows using the downloaded Chef Habitat package

If you prefer to download the `hab` CLI manually, unzip it onto your machine. We suggest unzipping to `C:\habitat`, so that the full path to Chef Habitat is similar to `C:\habitat\hab-0.79.1-20190410221450-x86_64-windows`. If you've downloaded a more recent version of Chef Habitat, you'll see a different set of numbers following `hab-`. Replace the package name used in these examples with the filename you see on your computer. Next, add that folder to your `PATH` variable so your computer will know where to find it. Here's how to do that with PowerShell:

```powershell
$env:PATH += ";C:\habitat\hab-0.79.1-20190410221450-x86_64-windows\"
```

To use a Docker Chef Habitat Studio as an isolated environment, you'll also need to install Docker Desktop for Windows.

[Download Chef Habitat for Windows](https://www.chef.io/downloads)

[Download Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
