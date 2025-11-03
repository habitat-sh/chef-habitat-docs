+++
title = "Chef Habitat install.sh script reference"
draft = false

[menu.install]
    title = "install.sh script reference"
    identifier = "install/install-sh"
    parent = "install"
    weight = 500
+++

The Habitat install script (`install.sh`) provides an automated way to download and install the Habitat CLI (`hab`) on Linux and macOS systems. This script handles platform detection, package verification, and system-specific configuration.

The install script performs these main tasks:

- Downloads the appropriate Habitat CLI package for your platform
- Verifies package integrity using checksums and GPG signatures
- Installs the CLI with proper system integration
- Configures platform-specific requirements (especially on macOS)

## System requirements

Requirements on all platforms:

- `curl` or `wget` with SSL support
- Internet connectivity to `packages.chef.io`

Linux requirements:

- `tar` and `gzip` for archive extraction
- `sha256sum` for checksum verification
- Root or sudo access for system installation

macOS requirements:

- `diskutil` for volume management
- `security` command for keychain operations
- `launchctl` for daemon management
- Administrative privileges for system configuration

## Usage

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash [options]
```

## Options

`-c CHANNEL`
: Specifies the release channel.

  Possible values: `stable`, `unstable`.

  Default value: `stable`.

`-h`
: Prints help information

`-v VERSION`
: Specifies a Habitat version. For example: `1.6.1245` or `1.6.1245/20250905140900`.

`-t TARGET`
: Specifies the target architecture of the 'hab' program to download.

  Possible values: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`.

  Default value: `x86_64-linux`.

`-u URL`
: Specifies a custom Habitat Builder URL.

`-b CHANNEL`
: Specifies a Habitat Builder channel (for temporary use).

`-o ORIGIN`
: Specifies the origin.

  Default value: `core`.

## Examples

### Install the latest stable version

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

Unpacking this a bit, `curl -sSfL` is equivalent to `curl --silent --show-error --fail --location` meaning that `curl` minimizes output, fails fast, shows any error that occurs while following any redirects.

Alternatively, you could download the file and run it locally. For example:

```bash
curl -OL https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh
chmod u+x install.sh
./install.sh [options]
```

### Install a specific version

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -v 1.6.1245
```

### Install from the unstable channel

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -c unstable
```

### Install on Linux with aarch64 architecture

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -t aarch64-linux
```

## Environment variables

The script recognizes these environment variables:

`SSL_CERT_FILE`
: Allows you to verify against a custom certificate, such as one generated from a corporate firewall.

`DEBUG`
: If set, prints shell commands as they execute for troubleshooting.

`TMPDIR`
: Specifies the temporary directory for downloads.

  Default value: `/var/tmp` or `/tmp`.

## Platform-specific behavior

### Linux

On Linux systems, the script:

1. Downloads the hab binary as a `tar.gz` archive
1. Extracts and temporarily uses the binary to install the full Habitat package
1. Creates a binlink in `/bin/hab` for system-wide access
1. Uses SHA256 checksums for verification

### macOS

macOS installation varies by architecture:

#### x86_64 (Intel Macs)

- Downloads and installs the hab binary directly to `/usr/local/bin`
- Uses ZIP archives instead of tar.gz
- No special volume configuration required

#### aarch64 (Apple Silicon Macs)

- Creates a dedicated APFS volume called "Habitat Store" mounted at `/hab`
- Configures automatic mounting with the LaunchDaemon
- Handles FileVault encryption if enabled
- Updates system configuration files (`/etc/synthetic.conf`, `/etc/fstab`)
- Uses the full Habitat package installation process

## Security and verification

The script includes multiple verification steps:

- **Checksum verification** - Downloads and verifies SHA256 checksums for all packages
- **GPG signature verification** - If GnuPG is available, verifies package signatures using Chef's public key
- **Package integrity** - Ensures downloaded archives match expected checksums before installation

## Troubleshooting

### Common issues

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

### Debug mode

Enable debug output to troubleshoot installation issues:

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | DEBUG=1 sudo -E bash
```

This prints all executed commands and their output.

### Manual cleanup

If installation fails partway through, you can manually clean up:

On Linux:

```bash
## Remove temporary files
rm -rf /tmp/hab.*
## Remove incomplete installation
sudo rm -f /bin/hab
```

On macOS:

```bash
## Remove LaunchDaemon
sudo rm -f /Library/LaunchDaemons/sh.habitat.bldr.darwin-store.plist
## Remove volume (if created)
sudo diskutil apfs deleteVolume "Habitat Store"
## Remove synthetic.conf entry
sudo ex /etc/synthetic.conf # manually remove the 'hab' line
```

## Next steps

After successful installation:

1. Verify the installation: `hab --version`
2. Set up your origin: `hab origin key generate YOUR_ORIGIN`
3. Review the [CLI setup guide](../install/hab_setup.md) for initial configuration
4. Take the [Chef Habitat tutorial](https://www.chef.io/training/tutorials) available at [Chef Training](https://www.chef.io/training) to learn more about using Habitat.

## Support

If you have issues with the install script:

- See the [troubleshooting guide](/troubleshooting.md)
- Visit the [Habitat community forum](https://discourse.chef.io/c/habitat)
- Review known or file new issues in the [Habitat GitHub repository](https://github.com/habitat-sh/habitat/issues)
