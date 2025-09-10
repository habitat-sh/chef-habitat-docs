+++
title = "Installation Troubleshooting"
description = "Common installation issues and solutions for Chef Habitat"

[menu.install]
    title = "Troubleshooting"
    identifier = "install/troubleshooting"
    parent = "install"
    weight = 40
+++

This page provides solutions to common installation and setup issues with Chef Habitat.

## Installation Issues

### Permission Errors on Linux/macOS

**Problem**: Permission denied when running installation scripts or accessing `/usr/local/bin`.

**Solution**:

```bash
# Use sudo for system-wide installation
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash

# Or install to a user directory
mkdir -p ~/bin
export PATH="$HOME/bin:$PATH"
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | bash -s -- -b ~/bin
```

### Docker Issues

**Problem**: Cannot use Studio because Docker is not installed or accessible.

**Solution**:

- **Linux**: Install Docker Engine from the official Docker repository
- **macOS**: Install [Docker Desktop for Mac](https://docs.docker.com/desktop/mac/install/)
- **Windows**: Install [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/install/)

Verify Docker is running:

```bash
docker --version
docker run hello-world
```

### Windows PowerShell Execution Policy

**Problem**: PowerShell script execution is blocked.

**Solution**:

```powershell
# Temporarily bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Then run the installation script
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1'))
```

## Setup Issues

### Origin Key Generation Errors

**Problem**: `hab cli setup` fails to generate origin keys.

**Solution**:

1. Ensure you have write permissions to the hab cache directory
2. Check disk space availability
3. Manually generate keys:

   ```bash
   hab origin key generate YOUR_ORIGIN_NAME
   ```

### Builder Connection Issues

**Problem**: Cannot connect to Chef Habitat Builder during setup.

**Solution**:

1. Check internet connectivity
2. Verify firewall settings allow HTTPS traffic
3. If behind a corporate firewall, configure proxy settings:

   ```bash
   export https_proxy=http://your-proxy:port
   export HAB_BLDR_URL=https://bldr.habitat.sh
   ```

### Access Token Issues

**Problem**: Personal access token is rejected during setup.

**Solution**:

1. Verify the token was copied correctly (no extra spaces)
2. Check that the token hasn't expired
3. Ensure the token has the correct permissions in Builder
4. Generate a new token from your [Builder profile](https://bldr.habitat.sh/#/profile)

## Runtime Issues

### Command Not Found

**Problem**: `hab: command not found` after installation.

**Solution**:

1. **Linux/macOS**: Add hab to your PATH

   ```bash
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **Windows**: Add hab directory to system PATH

   ```powershell
   $env:PATH += ";C:\habitat\hab-VERSION-x86_64-windows\"
   ```

### Studio Won't Start

**Problem**: `hab studio enter` fails or hangs.

**Solution**:

1. Verify Docker is running
2. Check for conflicting containers:

   ```bash
   docker ps -a | grep hab-studio
   docker rm -f $(docker ps -a -q --filter ancestor=habitat/default-studio)
   ```

3. Clear studio cache:

   ```bash
   sudo rm -rf /hab/studios
   ```

## Getting Help

If you continue to experience issues:

1. Check the [Chef Habitat Discourse forum](https://discourse.chef.io/c/habitat/12)
2. File an issue on [GitHub](https://github.com/habitat-sh/habitat/issues)
3. Contact [Chef Support](https://www.chef.io/support) if you have a support contract

When reporting issues, include:

- Your operating system and version
- Chef Habitat version (`hab --version`)
- Complete error messages
- Steps to reproduce the problem
