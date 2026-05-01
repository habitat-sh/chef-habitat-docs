+++
title = "Chef Habitat scaffolding"
description = "Scaffolding"
summary = "A scaffolding is a standardized plan that automates building and running your application."
linkTitle = "Scaffolding"

[menu.plans]
    title = "Scaffolding"
    identifier = "plans/scaffolding"
    parent = "plans"
    weight = 95
+++

Chef Habitat scaffoldings are standardized plans for building and running your application automatically. Each scaffolding is tuned to how your application is built, which lets it create the appropriate [Application Lifecycle hooks](../reference/application_lifecycle_hooks.md) and add the correct runtime dependencies when building your package. Scaffoldings also provide default health check hooks, where appropriate, to help ensure your application functions reliably. You can create custom scaffoldings to support reuse of common patterns in your organization for developing, building, and running applications.

## Automated scaffolding

While we're targeting many platforms for automated scaffolding, we currently support Ruby, Node.js, and Gradle.

- [core/scaffolding-ruby](https://github.com/habitat-sh/core-plans/blob/main/scaffolding-ruby/doc/reference.md)
- [core/scaffolding-node](https://github.com/habitat-sh/core-plans/tree/main/scaffolding-node)
- [core/scaffolding-gradle](https://github.com/habitat-sh/core-plans/blob/main/scaffolding-gradle)

## Variables

Scaffolding provides customizable variables for language-specific behavior. See the appropriate scaffolding documentation for details.

### Overriding scaffolding callbacks

If you want to override scaffold build phases in your plans, override the main `do_xxx` phase, not the callback directly. For example, override `do_install()` instead of `do_default_install` or `do_node_install`.

### Scaffolding internals

A language or framework scaffolding is shipped as a Chef Habitat package, which means that each scaffolding runtime dependency becomes a build dependency for the application being built.

## `lib/scaffolding.sh` file

To create scaffolding, a package must contain a `lib/scaffolding.sh` file, which gets sourced by the Bash build program.

## `scaffolding_load()` function

An optional function named `scaffolding_load()` can be created in `lib/scaffolding.sh`. The build program calls this function early, which allows a scaffolding author to control and augment the `pkg_deps` and `pkg_build_deps` arrays. At this point, no other build or runtime dependencies have been resolved, so the code in this function can only rely on what the build program provides or software pulled in with the scaffolding's plan.

## Default build phases implementations

The remainder of `lib/scaffolding.sh` contains one or more default implementations for the build phases. These include, but aren't limited to:

- `do_default_prepare()`
- `do_default_build()`
- `do_default_install()`
