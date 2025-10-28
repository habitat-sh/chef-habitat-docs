+++
title = "Habitat install.sh Reference"
draft = false
linkTitle = "Habitat install.sh reference"
summary = "Habitat install.sh reference"

[menu.reference]
    title = "Habitat install.sh Reference"
    identifier = "reference/install-sh"
    parent = "reference"
    weight = 10
+++

## Habitat Install Script Reference

The Habitat install script (`install.sh`) provides an automated way to download and install the Habitat CLI (`hab`) on Linux and macOS systems. This script handles platform detection, package verification, and system-specific configuration.

### Overview

The install script performs these main tasks:

- Downloads the appropriate Habitat CLI package for your platform
- Verifies package integrity using checksums and GPG signatures
- Installs the CLI with proper system integration
- Configures platform-specific requirements (especially on macOS)

### Quick Start

To install Habitat using the default settings:

```bash
curl -sSfL https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

### Usage

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash [FLAGS]
```

#### Available Flags

- `-c CHANNEL` - Specifies the release channel [values: stable, unstable] [default: stable]
- `-h` - Prints help information
- `-v VERSION` - Specifies a version (for example: 1.6.1245, 1.6.1245/20250905140900)
- `-t TARGET` - Specifies the target architecture of the 'hab' program to download
  - [values: x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin] [default: x86_64-linux]
- `-u URL` - Specifies a custom Builder URL
- `-b CHANNEL` - Specifies Builder channel (for temporary use)
- `-o ORIGIN` - Specifies the origin [default: core]

{{< note >}}
These options when combined may result in a request to to install something that doesn't exist. For example, if you specify `-o FOO -c BAR` then an origin named FOO must exist and a channel named BAR must exist and must also be used within the FOO origin.
{{< /note >}}

#### Examples

##### Install Latest Stable Version

Installing the latest stable version is the same command as seen in the Quick Start section above:

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

Unpacking this a bit, `curl -sSfL` is equivalent to `curl --silent --show-error --fail --location` meaning that `curl` minimizes output, fails fast, shows any error that occurs while following any redirects.

Alternatively, while we will use the curl bash version in our documentation you could chose to download the file and run it locally. One way to do this would be the following:

```bash
curl -OL https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh
chmod u+x install.sh
./install.sh [FLAGS]
```

##### Install A Specific Version

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -v 1.6.1245
```

##### Install from the Unstable Channel

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -c unstable
```

##### Install specify for aarch64 Architecture on linux

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -t aarch64-linux
```

### Environment Variables

The script recognizes these environment variables:

- `SSL_CERT_FILE` - Allows you to verify against a custom certificate, such as one generated from a corporate firewall
- `DEBUG` - If set, prints shell commands as they execute for troubleshooting
- `TMPDIR` - Specifies the temporary directory for downloads [default: /var/tmp or /tmp]

### Platform-Specific Behavior

#### Linux

On Linux systems, the script:

1. Downloads the hab binary as a tar.gz archive
2. Extracts and temporarily uses the binary to install the full Habitat package
3. Creates a binlink in `/bin/hab` for system-wide access
4. Uses SHA256 checksums for verification

#### macOS

macOS installation varies by architecture:

##### x86_64 (Intel Macs)

- Downloads and installs the hab binary directly to `/usr/local/bin`
- Uses ZIP archives instead of tar.gz
- No special volume configuration required

##### aarch64 (Apple Silicon Macs)

- Creates a dedicated APFS volume called "Habitat Store" mounted at `/hab`
- Configures automatic mounting with the LaunchDaemon
- Handles FileVault encryption if enabled
- Updates system configuration files (`/etc/synthetic.conf`, `/etc/fstab`)
- Uses the full Habitat package installation process

### macOS Volume Setup Details

For Apple Silicon Macs, the script performs these additional setup steps:

#### Volume Creation

- Creates a new APFS volume on the root disk
- Labels the volume "Habitat Store"
- Mounts the volume at `/hab`

#### Encryption Handling

- Detects if FileVault is enabled on the system
- Encrypts the Habitat volume if FileVault is active
- Stores encryption passwords in the System Keychain
- Configures automatic unlock during boot

#### System Integration

- Updates `/etc/synthetic.conf` to create the mount point
- Configures `/etc/fstab` with proper mount options
- Installs a LaunchDaemon for automatic mounting
- Enables file ownership on the volume

### Security and Verification

The script includes multiple verification steps:

1. **Checksum Verification** - Downloads and verifies SHA256 checksums for all packages
2. **GPG Signature Verification** - If GnuPG is available, verifies package signatures using Chef's public key
3. **Package Integrity** - Ensures downloaded archives match expected checksums before installation

### Requirements

#### All Platforms

- `curl` or `wget` with SSL support
- Internet connectivity to packages.chef.io
- Sufficient disk space for Habitat installation

#### Linux-Specific

- `tar` and `gzip` for archive extraction
- `sha256sum` for checksum verification
- Root or sudo access for system installation

#### macOS-Specific

- `diskutil` for volume management
- `security` command for keychain operations
- `launchctl` for daemon management
- Administrative privileges for system configuration

### Troubleshooting

#### Common Issues

**Download failures:**

- Verify internet connectivity
- Check if corporate firewalls block packages.chef.io
- Set `SSL_CERT_FILE` if using custom certificates

**Permission errors:**

- Ensure you have appropriate privileges (sudo on Linux, admin on macOS)
- Check that target directories are writable

**macOS volume creation failures:**

- Verify sufficient disk space for the new volume
- Ensure the root disk has available space
- Check that FileVault setup is complete if encryption is enabled

#### Debug Mode

Enable debug output to troubleshoot installation issues:

```bash
curl -ssfl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | DEBUG=1 sudo -E bash
```

This prints all executed commands and their output.

#### Manual Cleanup

If installation fails partway through, you can manually clean up:

**Linux:**

```bash
## Remove temporary files
rm -rf /tmp/hab.*
## Remove incomplete installation
sudo rm -f /bin/hab
```

**macOS:**

```bash
## Remove LaunchDaemon
sudo rm -f /Library/LaunchDaemons/sh.habitat.bldr.darwin-store.plist
## Remove volume (if created)
sudo diskutil apfs deleteVolume "Habitat Store"
## Remove synthetic.conf entry
sudo ex /etc/synthetic.conf # manually remove the 'hab' line
```

### Next Steps

After successful installation:

1. Verify the installation: `hab --version`
2. Set up your origin: `hab origin key generate YOUR_ORIGIN`
3. Review the [CLI setup guide](../install/hab_setup.md) for initial configuration
4. Take the [Chef Habitat tutorial](https://www.chef.io/training/tutorials) available at [Chef Training](https://www.chef.io/training) to learn more about using Habitat.

### Support

If you encounter issues with the install script:

- Check the [troubleshooting guide](../install/troubleshooting.md)
- Visit the [Habitat community forum](https://discourse.chef.io/c/habitat)
- Review known or file new issues in the [Habitat GitHub repository](https://github.com/habitat-sh/habitat/issues)
