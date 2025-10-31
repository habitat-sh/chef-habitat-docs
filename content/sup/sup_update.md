+++
title = "Updating the Supervisor"
description = "Updating the Supervisor"


[menu.sup]
    title = "Updating Supervisors"
    identifier = "supervisors/updating"
    parent = "supervisors"
    weight = 130

+++

Each new Chef Habitat release brings a new Supervisor that includes bug fixes and enhancements.
You should stay up to date with your running Supervisors.

## Update a Chef Habitat Supervisor from version 1.6 to 2.x

To update a Chef Habitat Supervisor from Habitat 1.6 to 2.x, see the [upgrade documentation](/upgrade/).

## Update a Chef Habitat Supervisor minor version

When you update Supervisors in production, you usually won't want to shut down your running services while you perform the update because it can cause an outage or require a maintenance window.
Chef Habitat provides a couple of ways to update a Supervisor without stopping your running services.

### Manual updates

While an older version of the Supervisor is running, install the newer Supervisor into your local Chef Habitat package repository:

```bash
hab pkg install core/hab-sup
```

This doesn't update the running Supervisor.
It downloads the new Supervisor and stores it in your `/hab/pkgs` store.
To update the running Supervisor, restart it:

```bash
hab sup restart
```

This command restarts the Supervisor service, but doesn't restart the running services.

### Automatic updates

You can configure the Supervisor to automatically update itself using the Habitat CLI or the Supervisor config file.

#### Habitat CLI

To configure automatic updates with the `hab` CLI, add the `--auto-update` flag to [`hab sup run`](/reference/habitat_cli/#hab-sup-run).

By default, the Supervisor checks for updates every 60 seconds.
You can adjust this interval by setting the `--auto-update-period` to a different number of seconds.

To look for updated Supervisor releases in an on-premises depot or in a channel other than `stable`, use the `--url` and `--channel` arguments with `hab sup run` to specify the Builder address and release channel.

#### Supervisor config file

To configure automatic updates with the [Supervisor config file](sup_config), set `auto_update` to `true`.
