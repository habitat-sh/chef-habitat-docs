+++
title = "About Chef Habitat"
linkTitle = "Chef Habitat"

[cascade]
  breadcrumbs = true
  gh_repo = "chef-habitat-docs"

[menu.about]
  title = "About Chef Habitat"
  identifier = "habitat"
  weight = 1
+++

Chef Habitat is a workload-packaging, orchestration, and deployment system that lets you build, package, deploy, and manage applications and services without worrying about the infrastructure your application runs on, and without rewriting or refactoring the application if you switch infrastructure.

Habitat separates the platform-independent parts of your application---build dependencies, runtime dependencies, lifecycle events, and application codebase---from the operating system or deployment environment where the application runs, and bundles them into an immutable Habitat package.
Packages are stored in Chef Habitat Builder (SaaS or on-prem), which acts as a package store similar to Docker Hub where you can store and download your application's Habitat packages.
Habitat Supervisor pulls packages from Habitat Builder and starts, stops, runs, monitors, and updates your application based on the [plan](#plans) and lifecycle hooks you define in the package.
Habitat Supervisor runs on bare metal, virtual machines, containers, or Platform-as-a-Service environments.
A package managed by a Supervisor is called a service.
Services can be joined together in a service group, which is a collection of services with the same package and topology type that are connected together across a Supervisor network.

## Components

### Habitat Builder

{{< readfile file="content/reusable/md/habitat_builder_overview.md" >}}

For more information, see the [Chef Habitat Builder](builder) documentation.

### Habitat package

A Habitat package is an artifact that contains the application codebase, lifecycle hooks, and a manifest that defines the application's build and runtime dependencies.
The package is bundled into a Habitat Artifact (`.HART`) file, which is a binary distribution of a given package built with Chef Habitat.
The package is immutable and cryptographically signed with a key, so you can verify that the artifact came from the expected source.
Artifacts can be exported to run in a variety of runtimes, such as containers, with no refactoring or rewriting.

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

## When should I use Chef Habitat?

Chef Habitat lets you build and package your applications and deploy them anywhere without refactoring or rewriting your package for each platform.
Everything the application needs to run is defined without assumptions about the underlying infrastructure.

This lets you repackage and modernize legacy workloads in place to increase manageability, improve portability, and migrate to modern operating systems or cloud-native infrastructure such as containers.

You can also build new applications and use Chef Habitat to manage deployment if you're unsure which infrastructure your application will run on, or if business requirements change and you need to move to a different environment.

## Next steps

- [Download and install the Chef Habitat CLI](/install/).
- [Create an account](https://docs.chef.io/habitat/builder/saas/builder_account) on [Habitat SaaS Builder](https://bldr.habitat.sh).

## Additional resources

### Download

- [Download and install the Chef Habitat CLI](/install/).

### Learning

- [Chef Habitat webinars](https://www.chef.io/webinars?products=chef-habitat&page=1)
- [Resource Library](https://www.chef.io/resources?products=chef-habitat&page=1)

### Community

- [Chef Habitat on Discourse](https://discourse.chef.io/c/habitat/12)
- [Chef Habitat in the Chef Blog](https://www.chef.io/blog/category/chef-habitat)
- [Chef Habitat Community Resources](https://community.chef.io/tools/chef-habitat)

### Support

- [Chef Support](https://www.chef.io/support) (if you have a support contract)
- [Community forum](https://discourse.chef.io/c/habitat/12)
- [GitHub issues](https://github.com/habitat-sh/habitat/issues)

### GitHub repositories

- [Chef Habitat repository](https://github.com/habitat-sh/habitat)
- [Chef Habitat Foundational Packages repository](https://github.com/habitat-sh/foundational-packages)
- [Chef Habitat Builder repository](https://github.com/habitat-sh/builder)
- [Chef Habitat Builder on-prem repository](https://github.com/habitat-sh/on-prem-builder)
