t+++
title = "Chef Habitat Supported Platforms"
description = "Chef Habitat Supported Platforms"
draft=false

[menu.platforms]
    title = "Supported Platforms"
    identifier = "Supported Platforms"
    weight = 10
+++

Chef Habitat runs on and supports the following platforms:

- Modern Linux kernels on 64 bit Intel x86 bit platforms (x86_64, amd64)
- Modern Linux kernels on 64 bit ARM platforms (aarch64)
- Microsoft Windows operating systems on Intel x86 64 bit platforms (x86_64, amd64)
- Apple macOS operating systems on Apple Silicon / ARM platforms (aarch64)

Modern kernel version means those Linux kernel versions that are still supported the Linux kernel team or supported within a distribution that is actively supported by a community, e.g. Debian, or a commercial vendor, e.g Ubuntu or Red Hat. If the Linux kernel or distribution in question is supported on x84_64 or ARM then habitat will likely run on it. Once the Linux Kernel Team or the distribution vendor drop supports for a version then habitat also drops support for that kernel or distribution version.

Regarding Windows and macOS operating systems if Microsoft and Apple list the operating system version in question as supported and it had not reached end of life then we aim to support it.  Once an operating system enters end of life support for that operating system version ends.
