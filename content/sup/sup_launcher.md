+++
title = "Launcher"
description = "Launcher"


[menu.sup]
    title = "Launcher"
    identifier = "supervisors/sup-launcher Supervisor Launcher Sidecar Process"
    parent = "supervisors"
    weight = 110

+++

Chef Habitat's Launcher is a sidecar process for the Supervisor that launches processes on the Supervisor's behalf. It's the entry point for running the Supervisor and acts as a supervisor for the Supervisor itself. The Supervisor can update itself automatically, but the Launcher is released differently by design, so it should rarely need to change.

To update your Launcher, run:

```bash
hab pkg install chef/hab-launcher
```

Then restart the Supervisor. This action requires a restart of supervised services, so factor that into your planning.

The Launcher is designed to run as process 1 and is minimal by design. Its responsibility is to be the parent process for the Supervisor.

The Launcher enables the Supervisor to update itself without shutting down or re-parenting supervised services. The Launcher is versioned separately from the Supervisor and should be updated very infrequently because a Launcher update can require a system restart when it runs as process 1.
