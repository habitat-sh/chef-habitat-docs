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

To use this feature, place a `.studiorc` (Linux) or `studio_profile.ps1` (Windows) in the current working directory where you run `hab studio enter`.

{{< note >}}

Chef Habitat will only source `.studiorc` or `studio_profile.ps1` when you run `hab studio enter`---it won't be sourced when calling `hab studio run`, `hab studio build`, or `hab pkg build`.

{{< /note >}}

### Why do we need it (Linux)

The primary purpose of the Studio on Linux is to provide environment and filesystem isolation from the build host during the build process. Many common environment variables can influence the build process, such as `PATH` putting user-installed tools ahead of the desired tool versions. Filesystem isolation is important because many tools use common system paths to autodiscover libraries, putting them ahead of the desired Habitat libraries. The result is a known, minimal environment that's portable and consistent across hosts (from laptop to build farm) and forces users to be explicit about how they build and package software.

### Why do we need it (Windows)

The purpose of the Studio on Windows is fundamentally the same as on Linux. However, Windows can't achieve filesystem isolation with the "native" studio in the same way Linux can, but this is also less important on Windows. It does provide similar environment isolation, though there are unique constraints imposed by Windows that require certain system paths to be available. For instance, removing system32 libraries and tools would be unnatural at best and would completely break Windows at worst, but the Studio strips all other `PATH` entries (your ProgramFiles applications, for example) to provide a more isolated environment. Registry isolation is also a concern that's different from Linux, but the native studio doesn't provide this isolation. Note that the Docker Windows Studio mentioned below provides much more thorough isolation.

One other purpose of the Studio on Windows is to provide a known and common PowerShell environment that the Habitat build program is compatible with. The Windows Studio includes a packaged version of PowerShell that is different from the version that ships with the OS. Entering an interactive Windows Studio makes troubleshooting builds easier because you're placed in the same version of PowerShell that builds packages and the same version used by the Habitat Supervisor at runtime.

## What kinds of studios are there?

The Habitat Studio, as an abstract concept, is an environment that provides the required guarantees for builds. The `hab studio` command is the interface that performs the required setup before handing control over to a studio implementation. `pkg build` uses the same setup, but instead of creating an interactive process, it invokes `build` directly in a non-interactive environment.

The Habitat Studio implementations are built upon common utilities, such as chroot or Docker containers, thus constraints on the studio behaviors, where it can run, what kinds of packages it can build, and in many cases what kinds of errors you can expect, are imposed by those tools. In the case of errors, it's often a case of understanding and troubleshooting the underlying tool used to implement the studio rather than troubleshooting the studio itself.

### Linux "native" - aka `core/hab-studio`

Built using chroot and bind mounts to provide access to required paths from the host. This is the default studio on Linux and only functions on Linux-based systems. This requires root privileges to invoke, and the `hab studio` command attempts to use `sudo` to elevate the user's privileges if they aren't already root. In addition, installing this package requires root privileges, as `/hab/pkgs` is owned by the root user. Specifically, chroot requires `CAP_SYS_CHROOT` and mounts require `CAP_SYS_ADMIN`. In addition to the bind mounts, `/proc` must be mounted for builds to function.

### Linux "Docker Studio"

The Linux Docker Studio is a completely separate implementation from the native studio, sharing no code aside from the common `hab studio` entrypoint. This difference in implementation includes available subcommands and help documentation, often leading to confusion. `hab studio -D` provides the necessary conversion to required Docker CLI arguments, such as mounting volumes from the host into the container and setting the image to run. You can invoke this studio using only Docker commands, but it requires additional effort to set all the correct options.

This studio was built to not require elevated permissions to run, to be able to provide studio builds inside CI systems or orchestration engines such as Kubernetes where elevated privileges are typically verboten. However, you still need to be able to communicate with the container engine in order to start the container.

### Windows "native" - aka `core/hab-studio`

The Windows studio uses Junction mounts to provide a consistent filesystem view and a similar experience to Linux studios. Windows has no concept of "chroot" or jailed filesystems, so it provides no isolation from host paths, the registry, and other machine-scoped APIs (such as Windows features).

### Windows "Docker Studio"

The Windows Docker studio doesn't exist as a component like `core/hab-studio` or `rootless_studio` in the Habitat codebase. Instead, it's created in the release pipeline, using a minimal Windows container as the base and layering in the Windows implementation of `core/hab-studio` to build a Docker image. Like the rootless studio, it can be invoked using only the Docker CLI, with the same additional setup required to set the correct options.

## Studio platform support

Habitat Studio is implemented in four environments and can be invoked from three different operating systems. This matrix shows which studios can be run on the various operating systems.

| Studio         | Linux | macOS | Windows |
| -------------- | ----- | ----- | ------- |
| Linux Native   | Yes   | No    | No      |
| Linux Docker   | Yes   | Yes   | Yes     |
| Windows Native | No    | No    | Yes     |
| Windows Docker | No    | No    | Yes     |

### Why do we need privileged containers to build (on Linux)?

Users who want to build Habitat packages in containers typically have their CI agent invoke `hab pkg build*`. This agent runs in a non-privileged container, or it might create a non-privileged container to invoke `hab pkg build`.

At this point, the `hab` command tries to create the studio to run the command in. In the case of the native studio, this fails because the container it's running in doesn't have the `CAP_SYS_CHROOT` or `CAP_SYS_ADMIN` capabilities. The Docker studio also fails, as the environment the build is executing in won't have permissions to run containers and also won't have access to the Docker socket (or Docker in Docker).

It's possible that if users can provide credentials to access a remote Docker host, builds could run, though in secured environments this is probably unlikely. Also, volume mapping across the network may not work. Even if it does, any I/O operations, such as reading source files, would be slow.

You also need to be careful about exposing build functionality directly to CI agents without requiring the studio boundary. For example, this can lead to support questions about package quality when user software segfaults, even though the underlying issue is that the package was built on an Ubuntu host and linked against the wrong libraries.

Today, users can configure agents to run the Docker studio image directly, but that requires them to perform all the setup `hab pkg build` would normally do, creating a point of friction.

## Building packages cross-platform

One question often asked is how to build Windows packages on non-Windows systems. This is often spurred by the ability to build Linux packages on Windows or macOS. However, this isn't a capability provided by the Studio, but by Docker. Docker runs a minimal Linux VM (using Hyper-V on Windows and Hyperkit on macOS) to provide the ability to run Linux containers.

### The "Mac Studio"

Habitat Studio on macOS relies on Docker Desktop creating and running a Docker host inside a headless virtual machine. This gives you the capability to develop and build Linux packages on macOS. macOS itself provides no OS virtualization primitives beyond chroot. Because `hab studio` manages setup and execution of the Docker CLI command, this can create the impression that Studio itself provides Linux package builds on Mac.

### How the Studio is used

Studios are used in interactive modes to develop packages, and they're often used interactively to build the resulting packages. While this is fine, any time you invoke a build from an interactive process that has had additional commands run before the build starts, such as creating binlinks or invoking other builds, you run the risk of creating a "tainted" build. In other words, you lose some of the guarantees provided by the studio, leading to scenarios where builds between developers or CI are different.

Studios are also used to develop software, though this is a less-than-ideal experience today because it requires additional setup from the user. This is because traditional developer tools make assumptions about their environment and have no knowledge of the Habitat package structure. This creates friction for developers who want to develop against the same set of libraries that their software will ultimately be deployed with, allowing teams to shift left.
