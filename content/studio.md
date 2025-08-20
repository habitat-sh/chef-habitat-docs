+++
title = "About Chef Habitat Studio"
description = "About Chef Habitat Studio"
draft = false

[menu.studio]
  title = "Habitat Studio"
  identifier = "Habitat Studio"
  weight = 10
+++

<!-- ## Scotts goals:
There are two goals I have with this document, the second being a component of the first, but is a major sticking point to selling Habitat right now.

I frequently see questions posed about the Studio that (feel like) there is an assumption that the Studio is providing certain capabilities, when it's often the underlying tools a particular implementation uses that provide those capabilities. In the case of troubleshooting, knowing which implementation you are using leads you to the correct set of tools to diagnose and fix the issue.

The desire to build Habitat packages in CI leads to the question of why we require elevated privileges in order to build.

In order to explain why that is, so that there is a common starting point, my goal is to break down the studio conceptually, and give a brief overview of the differing implementations before talking about the elevated privileges conundrum. -->

{{< readfile file="content/reusable/md/habitat_studio_overview.md" >}}

## Customizing Studio

When you enter Chef Habitat Studio, Chef Habitat will attempt to locate `/src/.studiorc` on Linux or `/src/studio_profile.ps1` on Windows and source it.
Think `~/.bashrc` or `$PROFILE`.
This file can be used to export any environment variables like the ones in `/reference/environment-variables`, as well as any other shell customizations to help you develop your plans from within the Studio.

To use this feature, place a `.studiorc` (Linux) or `studio_profile.ps1` (Windows) in the current working directory
where you will run `hab studio enter`.

{{< note >}}

Chef Habitat will only source `.studiorc` or `studio_profile.ps1` when you run `hab studio enter`---it won't be sourced when calling `hab studio run`, `hab studio build`, or `hab pkg build`.

{{< /note >}}

### Why do we need it (Linux)

The primary purpose of the Studio on Linux is to provide environmental and filesystem isolation from the build host during the build process. Many common environmental variables can influence the build process, such as `PATH` putting user installed tools ahead of the desired tool versions. Filesystem isolation is important as many tools use common system paths to autodiscover libraries, putting them ahead of the desired Habitat libraries. The result is a known, minimal environment that's portable and consistent across hosts (laptop to build farm) and forces the users to be explicit about how they build and package their software

### Why do we need it (Windows)

The purpose of the Studio on Windows is fundamentally the same as Linux. However, Windows can't achieve filesystem isolation with the "native" studio in the same way that Linux can, but this is also less important in Windows. It does provide similar environmental isolation, though there are unique constraints imposed by Windows that require certain system paths to be available. For instance, removing the system32 libraries and tools would be unnatural at best and completely break Windows at worst, but the Studio will strip all other PATH entries (your ProgramFiles applications for example) in order to provide a more isolated environment. Registry isolation is also a concern that's different from Linux, but the native studio doesn't provide this isolation. Note that the Docker Windows Studio mentioned below provides much more thorough isolation.

One other purpose of the Studio on Windows is to provide a known and common PowerShell environment that the Habitat build program is compatible with. The Windows Studio includes a packaged version of PowerShell which is different from the version of PowerShell that ships on the OS. Entering an interactive Windows Studio makes it easier to troubleshoot builds because one is placed in the same version of PowerShell that builds their packages and also the same version used by the Habitat Supervisor at runtime.

## What kinds of studios are there?

The Habitat Studio, as an abstract concept, is an environment to provide the required guarantees for builds. The `hab studio` command is our interface to do the requisite setup before handing control over to a studio implementation. `pkg build` uses the same setup but instead of creating an interactive process, it invokes `build` directly in a non-interactive environment.

The Habitat Studio implementations are built upon common utilities, such as chroot or Docker containers, thus constraints on the studio behaviors, where it can run, what kinds of packages it can build, and in many cases what kinds of errors you can expect, are imposed by those tools. In the case of errors, it's often a case of understanding and troubleshooting the underlying tool used to implement the studio rather than troubleshooting the studio itself.

### Linux "native" - aka `core/hab-studio`

Built using chroot and bind mounts to provide access to required paths from the host. This is the default studio on Linux, and only functions on Linux based systems. This requires root privileges to invoke, and the `hab studio` command will attempt to use `sudo` to elevate the users privileges, if they aren't already root. In addition, the installation of this package requires root privileges, as `/hab/pkgs` is owned by the root user. Specifically, chroot requires CAP_SYS_CHROOT and mounts require CAP_SYS_ADMIN. In addition to the bind mounts, `/proc` is required to be mounted for builds to function.

### Linux "Docker Studio"

The Linux Docker Studio is a completely separate implementation from the native studio, sharing no code aside from the common `hab studio` entrypoint. This difference in implementation includes available subcommands and help documentation, often leading to confusion. `hab studio -D` provides the necessary conversion to the required Docker CLI arguments, such as mounting volumes from the host into the container and setting the image to run. You can invoke this studio using only Docker commands,  but requires additional effort in setting all the correct options.

This studio was built to not require elevated permissions to run, to be able to provide studio builds inside CI systems or orchestration engines such as Kubernetes where elevated privileges are typically verboten. However, you still need to be able to communicate with the container engine in order to start the container.

### Windows "native" - aka `core/hab-studio`

The Windows studio uses Junction mounts in order to provide a consistent filesystem view in order to provide a similar experience to the Linux studios. Windows has no concept of "chroot" or jailed filesystems, so it provides no isolation from the host paths, registry and other machine scoped APIs (like Windows features, etc.).

### Windows "Docker Studio"

The Windows Docker studio doesn't exist as a component like `core/hab-studio` or `rootless_studio` in the Habitat code base. Instead it's created in our release pipeline, using a minimal Windows Container as the base and layering in the Windows implementation of `core/hab-studio` to build a Docker image. Like the rootless studio, this can be invoked using only the Docker CLI with the same additional setup required to set the correct options.

## Studio platform support

Habitat Studio is implemented in four environments and can be invoked from three different operating systems. This matrix shows which studios can be run on the various operating systems.

| Studio         | Linux | macOS | Windows |
| -------------- | ----- | ----- | ------- |
| Linux Native   | Yes   | No    | No      |
| Linux Docker   | Yes   | Yes   | Yes     |
| Windows Native | No    | No    | Yes     |
| Windows Docker | No    | No    | Yes     |

### Why do we need privileged containers to build (on Linux)?

Users wishing to build Habitat packages in containers will typically have their CI agent invoke `hab pkg build*`. This agent will be running in a non-privileged container, or possibly create a non-privileged container to invoke `hab pkg build`.

At this point, the hab command will try to create the studio to run the command in. In the case of the native studio, this will fail because the container it's running in doesn't have the `CAP_SYS_CHROOT` or `CAP_SYS_ADMIN` capabilities. The Docker studio will also fail, as the environment the build is executing in won't have permissions to run containers,  and also wouldn't have access to the Docker socket (or Docker in Docker).

It's possible that if the users are able to provide credentials to access a remote Docker host, we would be able to build, though in secured environments this is probably unlikely. I also don't know if volume mapping can work across the network. Even if it's possible, any IO operations, such as reading the source would be slow.

We also want to be careful about exposing build functionality directly to CI agents without requiring the studio boundary. We'd likely start (for example) fielding support questions around our package quality from user software segfaulting, when the underlying issue was the package was built on an Ubuntu host and it linked against the wrong libraries.

Today, users can configure their agents to run the Docker studio image directly, but that requires them to perform all the set up `hab pkg build` would normally do for them, creating a point of friction.

## Building packages cross platform

One question often posed is the desire to build Windows packages on non-Windows systems. This is often spurred by the ability to build Linux packages on Windows or macOS. However, this isn't a capability provided by the Studio, but by Docker. Docker runs a minimal Linux VM (using Hyper-V on Windows and Hyperkit on macOS) to provide the ability to run Linux containers.

### The "Mac Studio"

Habitat Studio on macOS relies on the Docker Desktop creating and running a Docker host inside a headless virtual machine. This gives us the capability to develop and build Linux packages on macOS. macOS itself provides no os-virtualization primitives beyond chroot. Because `hab studio` manages the set up and execution of the Docker CLI command, this gives the illusion that we're providing some magic to build Linux packages on Mac.

### How the Studio is used

Studios are used in interactive modes to develop packages, but are often used interactively to also build the resulting packages. While this is fine, any time you are invoking a build from an interactive process that has had additional commands run before the build start, such as creating binlinks or even invoking other builds, you run the risk of creating a "tainted" build. In other words you lose some of the guarantees provided by the studio, leading to scenarios where builds between developers or CI are different.

Studios are also used to develop software, though this is a less than ideal experience today as it requires additional setup from the user. This is because traditional developer tools have assumptions about the environment they're operating in and have no knowledge of the Habitat package structure. This is a point of friction to enable developers to develop against the same set of libraries that their software will ultimately be deployed against, allowing us to further shift left.
