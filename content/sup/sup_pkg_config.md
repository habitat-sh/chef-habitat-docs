+++
title = "Supervisor configuration"
description = "Configure the Supervisor for faster package development"


[menu.sup]
    title = "Supervisor package configuration"
    identifier = "supervisors/sup-pkg-config"
    parent = "supervisors"
    weight = 100
+++

To help you create new packages or modify existing ones, the Supervisor includes an option that lets you use configuration directly from a specific directory instead of from the compiled artifact. This can significantly shorten cycle time when you work on configuration and application lifecycle hooks.

Build the plan as you normally would. When you start the Supervisor, pass the path to the directory that contains your plan:

```bash
hab sup run core/redis --config-from /src
```

The Supervisor now takes its configuration and hooks from `/src` instead of from the package you previously built. When the configuration is ready, do a final package rebuild.
