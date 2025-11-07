+++
title = "Container orchestration"
description = "Container orchestration with Chef Habitat"


[menu.containers]
    title = "Container orchestration"
    identifier = "containers/container-orchestration"
    parent = "containers"
    weight = 20

+++

Chef Habitat packages may be exported with the Supervisor directly into a [variety of container formats](/packages/pkg_exports), but frequently the container is running in a container orchestrator such as Kubernetes or Mesos. Container orchestrators provide scheduling and resource allocation, ensuring workloads are running and available. Containerized Chef Habitat packages can run within these runtimes, managing the applications while the runtimes handle the environment (compute, networking, security) surrounding the application.
