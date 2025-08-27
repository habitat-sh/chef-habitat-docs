+++
title = "About Chef Habitat"
linkTitle = "Chef Habitat"

[cascade]
  breadcrumbs = true

[menu.about]
  title = "About Chef Habitat"
  identifier = "habitat"
  weight = 1
+++

Chef Habitat is a workload-packaging, orchestration, and deployment system that allows you to build, package, deploy, and manage applications and services without worrying about which infrastructure your application will deploy on, and without any rewriting or refactoring if you switch to a different infrastructure.

Habitat separates the platform-independent parts of your application—the build dependencies, runtime dependencies, lifecycle events, and application codebase—from the operating system or deployment environment that the application will run on, and bundles it into an immutable Habitat Package.
The package is sent to the Chef Habitat Builder (SaaS or on-prem), which acts as a package store like Docker Hub where you can store, build, and deploy your Habitat package.
Habitat Supervisor pulls packages from Habitat Builder, and will start, stop, run, monitor, and update your application based on the plan and lifecycle hooks you define in the package.
Habitat Supervisor runs on bare metal, virtual machines, containers, or Platform-as-a-Service environments.
A package under management by a Supervisor is called a service.
Services can be joined together in a service group, which is a collection of services with the same package and topology type that are connected together across a Supervisor network.

## Components

### Habitat Builder

{{< readfile file="content/reusable/md/habitat_builder_overview.md" >}}

For more information, see the [Chef Habitat Builder](saas_builder) documentation.

### Habitat Package

A Habitat Package is an artifact that contains the application codebase, lifecycle hooks, and a manifest that defines build and runtime dependencies of the application.
The package is bundled into a Habitat Artifact (.HART) file, which is a binary distribution of a given package built with Chef Habitat.
The package is immutable and cryptographically signed with a key so you can verify that the artifact came from the place you expected it to come from.
Artifacts can be exported to run in a variety of runtimes with zero refactoring or rewriting.

### Plans

{{< readfile file="content/reusable/md/habitat_plans_overview.md" >}}

For more information, see the [Habitat plan](/plans/plan_writing) documentation.

### Services

{{< readfile file="content/reusable/md/habitat_services_overview.md" >}}

See the [services documentation](/services/) for more information.

### Habitat Studio

{{< readfile file="content/reusable/md/habitat_studio_overview.md" >}}

See the [Habitat Studio documentation](/studio/) for more information.

### Habitat Supervisor

{{< readfile file="content/reusable/md/habitat_supervisor_overview.md" >}}

See the [Habitat Supervisor documentation](sup) for more information.

## When Should I Use Chef Habitat?

Chef Habitat allows you to build and package your applications and deploy them anywhere without having to refactor or rewrite your package for each platform.
Everything that the application needs to run is defined, without assuming anything about the underlying infrastructure that the application is running on.

This will allow you to repackage and modernize legacy workloads in-place to increase their manageability, make them portable, and migrate them to modern operating systems or even cloud-native infrastructure like containers.

You can also develop your application if you are unsure of the infrastructure your application will run on, or in the event that business requirements change and you have to switch your application to a different environment.

## Next Steps

- [Download and install the Chef Habitat CLI](/install/).
- [Create an account](/saas_builder/builder_account) on the [Habitat Builder SaaS](https://bldr.habitat.sh).

## Additional Resources

### Download

- [Download Chef Habitat](https://www.chef.io/downloads)
- [Install documentation](/install/)

### Learning

- [Learn Chef: Deliver Applications with Chef Habitat](https://learn.chef.io/courses/course-v1:chef+Habitat101+Perpetual/about)
- [Chef Habitat webinars](https://www.chef.io/webinars?products=chef-habitat&page=1)
- [Resource Library](https://www.chef.io/resources?products=chef-habitat&page=1)

### Community

- [Chef Habitat on Discourse](https://discourse.chef.io/c/habitat/12)
- [Chef Habitat in the Chef Blog](https://www.chef.io/blog/category/chef-habitat)
- [Chef Habitat Community Resources](https://community.chef.io/tools/chef-habitat)

### Support

- [Chef Support](https://www.chef.io/support)

### GitHub Repositories

- [Chef Habitat repository](https://github.com/habitat-sh/habitat)
- [Chef Habitat Core Plans repository](https://github.com/habitat-sh/core-plans)
- [Chef Habitat Builder repository](https://github.com/habitat-sh/builder)
- [Chef Habitat Builder on-prem repository](https://github.com/habitat-sh/on-prem-builder)
