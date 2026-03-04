+++
title = "Downloading packages"
description = "Downloading packages individually and in bulk"


[menu.packages]
    title = "Downloading packages"
    identifier = "packages/pkg-download Downloading Packages"
    parent = "packages"

+++

The `hab pkg download` command can be used to download individual
packages (along with their dependencies and keys) from Builder,
without installing them. This allows you to more easily transfer
packages from one Builder instance to another, or to take a selective
snapshot of particular packages.

While you can download packages one-at-a-time, it can be more
convenient to use a file to specify your packages. Two formats are
recognized: plain text and TOML.

## Plain text download descriptors

The simplest thing you can do is create a plain text file with a
package identifier on each line, like so:

```text
# These are the packages needed to run a Supervisor
chef/hab-launcher
chef/hab
chef/hab-sup
```

Each line is a valid package identifier. You can also add comments using `#`.

To download these packages (and their dependencies), save that to a file named `supervisor.txt` and run:

```bash
hab pkg download --file=supervisor.txt
```

This downloads the packages into your existing Habitat cache directory.
Alternatively, you can specify a directory using the `--download-directory` option.

(You can also specify `--channel` and `--target` to further control which specific packages you download; run `hab pkg download --help` for more).

## TOML download descriptors

Plain text is fine for simple cases, but has drawbacks.
For instance, all packages will come from the same channel and will be for the same platform target.
For maximum flexibility, you'll want to use TOML to
write your download descriptor. Here is an example of one that the Habitat core team uses to take periodic snapshots of everything needed to run Builder itself:

```toml
format_version = 1
file_descriptor = "Packages needed to run an instance of Builder"

[[x86_64-linux]]
channel = "stable"
packages = [
  # Supervisor and prerequisites
  "chef/hab-launcher",
  "chef/hab",
  "chef/hab-sup",

  # Utilities
  "core/sumologic",
  "core/nmap"
]

# Targets can be repeated to specify additional subsets of packages,
# possibly from different channels
[[x86_64-linux]]
channel = "stable"
packages = [
  # Builder services
  "habitat/builder-api",
  "habitat/builder-api-proxy",
  "habitat/builder-memcached",
]

[[aarch64-linux]]
channel = "stable"
packages = [
  # Supervisor and prerequisites
  "chef/hab-launcher",
  "chef/hab",
  "chef/hab-sup",
]

[[x86_64-windows]]
channel = "stable"
packages = [
  # Supervisor and prerequisites
  "chef/windows-service",
  "chef/hab",
  "chef/hab-sup",
]
```

This format allows us to specify multiple subsets of packages from different channels and for different architectures.
Here, we're pulling down all the core service packages, which run on Linux, but are also pulling down the platform-specific versions of the cli and supervisor packages.
Without this format, we would need to invoke `hab pkg download` multiple times with different parameters.
The file allows us to capture our full intention in one place.
