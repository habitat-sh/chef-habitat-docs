+++
title = "Chef Habitat and containers"
description = "Chef Habitat and containers"
linkTitle = "Containers"
list_pages = true

[menu.containers]
    title = "Chef Habitat and containers"
    identifier = "containers/containers"
    parent = "containers"
    weight = 10

+++

Containers, for example, [Docker](https://www.docker.com/), let you build an immutable snapshot of your runtime environment, including your operating system, system libraries, application libraries, and application. The container is built with a CLI tool and then pushed to a container-specific artifact repository, known as a container registry. Chef Habitat isn't a container format and exports your application to the container format of your choice.

Chef Habitat builds more secure containers by exporting your application and any of its runtime dependencies directly into the container.
When you build your application with Chef Habitat, your application takes ownership of the entire toolchain of its runtime dependencies.
As a result, you no longer have to rely on a large operating system and unnecessary system libraries.
This lets you include only the binaries your application uses inside your container, which can decrease your container size.
By eliminating the need for a large operating system, you also avoid including binaries that an attacker could use, which further increases container security.
Visit the [Running Chef Habitat Containers](running_habitat_linux_containers) section for more details about how containers are built with Chef Habitat.
Finally, [Chef Habitat's HTTP API](../services/monitor_services) allows all of your application's runtime dependencies to be audited at any time.

If a brand-new vulnerability is revealed, Chef Habitat's HTTP API makes it easy to programmatically inspect and audit the entire toolchain of your runtime environment without needing to worry about how your containers were built.

If your situation requires it, Chef Habitat makes it simple to switch from containerized to non-containerized workloads. This is because Chef Habitat packages only have a requirement on the kernel version of your operating system. You can take the same `.hart` file you use to export to a Docker container and run it on a virtual machine or bare metal. By only requiring the kernel, Chef Habitat lets you switch container formats or switch to non-containerized workloads without significant rework.
