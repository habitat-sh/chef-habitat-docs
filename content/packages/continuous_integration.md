+++
title = "Chef Habitat and continuous integration"
description = "Chef Habitat and continuous integration"
summary = "How Habitat integrates with CI tools like Jenkins and TravisCI, simplifying builds, testing, and package promotion."


[menu.packages]
    title = "Continuous integration"
    identifier = "packages/habitat-and-continuous-integration"
    parent = "packages"
    weight = 200

+++

**Examples: [Jenkins](https://jenkins.io/), [TravisCI](https://travis-ci.org/), and [Drone](https://drone.io/)**

Continuous integration allows you to build, test, and deploy your code by using CLI tools and plugins. Chef Habitat includes the [Chef Habitat Studio](pkg_build) which lets you do interactive builds on your developer workstation, or non-interactive builds with your continuous integration server. Your continuous integration server can also call the Chef Habitat CLI to promote your Chef Habitat packages to different channels, enabling your applications to update themselves. Chef Habitat isn't a continuous integration server and can make builds and promotion processes done by your continuous integration server easier.

[Chef Habitat Studio](pkg_build) provides a clean room build environment for your application build. Builds that occur on a developer's workstation, or on a continuous integration server, build in the same manner. Developers no longer need to worry about entire classes of "it works on my box" problems. Build engineers no longer need to create unique and difficult to maintain worker nodes for continuous integration servers. Instead, the Chef Habitat `plan.sh` file contains all the information needed to build the entire application, from dependency management, runtime environment binaries, packaging, and application lifecycle hooks. When using [Chef Habitat Studio](pkg_build), your continuous integration server can focus more on what it's good at doing, instead of worrying about managing custom plugins and their potential conflicts.

Your continuous integration server can promote a Chef Habitat package (a `.hart` file) to a channel by calling the [Chef Habitat CLI](/install/). This promotion method lets you deploy a new version of your application in a pull-based manner by using the Chef Habitat Supervisor. Because this promotion process can be invoked non-interactively through the [Chef Habitat CLI](/install/), you can manage your deployments using your existing tooling. If you choose, you can also do this promotion process manually. More complex application environments can also invoke the promotion process using a scheduling tool or provisioning tool to help manage infrastructure resources in addition to promoting Chef Habitat packages.
