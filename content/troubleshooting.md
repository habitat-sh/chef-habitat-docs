+++
title = "Chef Habitat Troubleshooting"
description = "Troubleshooting common issues with Chef Habitat"

[menu.troubleshooting]
    title = "Troubleshooting"
    identifier = "troubleshooting"
+++

This page provides solutions to common installation and setup issues with Chef Habitat.

## Installation issues

### Installation fails

#### Problem

The `install.sh` or `install.ps1` script fails to install Chef Habitat on your system.

#### Solution

- Check system requirements
- Run with elevated privileges if needed

Download failures:

- Verify internet connectivity
- Check if a corporate firewalls blocks `packages.chef.io`
- Set `SSL_CERT_FILE` if using custom certificates

Permission errors:

- Ensure you have appropriate privileges (sudo on Linux, admin on macOS)
- Check that target directories are writable

macOS volume creation failures:

- Verify sufficient disk space for the new volume
- Ensure the root disk has available space
- Check that FileVault setup is complete if encryption is enabled

### Permission errors on Linux/macOS

#### Problem

You get a permission denied error when running installation scripts or accessing `/usr/local/bin`.

#### Solution

Use one of the following solutions:

- Use sudo for system-wide installation:

  ```bash
  curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
  ```

- Install to a user directory:

  ```sh
  mkdir -p ~/bin
  export PATH="$HOME/bin:$PATH"
  curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | bash -s -- -b ~/bin
  ```

### Docker issues

#### Problem

You can't use Habitat Studio because Docker isn't installed or accessible.

#### Solution

- **Linux**: Install Docker Engine from the official Docker repository.
- **macOS**: Install [Docker Desktop for Mac](https://docs.docker.com/desktop/setup/install/mac-install/).
- **Windows**: Install [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/).

To verify that Docker is running:

```bash
docker --version
docker run hello-world
```

### Windows PowerShell execution policy

#### Problem

PowerShell blocks script execution.

#### Solution

```powershell
# Temporarily bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Then run the installation script
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1'))
```

## Setup issues

### Origin key generation errors

#### Problem

`hab cli setup` fails to generate origin keys.

#### Solution

1. Ensure that you have write permissions to the hab cache directory.
1. Check that you have available disk space.
1. Manually generate keys:

   ```bash
   hab origin key generate YOUR_ORIGIN_NAME
   ```

### Builder connection issues

#### Problem

You can't connect to Chef Habitat Builder during setup.

#### Solution

1. Check your internet connection.
1. Verify that your firewall settings allow HTTPS traffic.
1. If you're behind a corporate firewall, configure proxy settings:

   ```bash
   export https_proxy=http://your-proxy:port
   export HAB_BLDR_URL=https://bldr.habitat.sh
   ```

### Access token issues

#### Problem

Your personal access token is rejected during setup.

#### Solution

1. Verify that you copied the complete token with no extra spaces.
1. Check that the token hasn't expired.
1. Ensure that the token has the correct permissions in Builder.
1. Generate a new token from your [Builder profile](https://bldr.habitat.sh/#/profile).

## Runtime issues

### Command not found

#### Problem

You get a `hab: command not found` error after installation.

#### Solution

On Linux and macOS, add Habitat to your system `PATH`:

```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

On Windows, add the Habitat directory to your system `PATH`:

```powershell
$env:PATH += ";C:\habitat\hab-VERSION-x86_64-windows\"
```

### Studio won't start

#### Problem

`hab studio enter` fails or hangs.

#### Solution

1. Verify that Docker is running.
1. Check for conflicting containers:

   ```bash
   docker ps -a | grep hab-studio
   docker rm -f $(docker ps -a -q --filter ancestor=habitat/default-studio)
   ```

1. Clear the studio cache:

   ```bash
   sudo rm -rf /hab/studios
   ```

## Contact us for help

If you continue to have issues:

1. Check the [Chef Habitat Discourse forum](https://discourse.chef.io/c/habitat/12).
1. If you have a support contract, contact [Chef Support](https://www.chef.io/support).
1. File an issue on [GitHub](https://github.com/habitat-sh/habitat/issues).

When reporting issues, include:

- Your operating system and version
- Your Chef Habitat version (`hab --version`)
- Complete error messages
- Steps to reproduce the problem
