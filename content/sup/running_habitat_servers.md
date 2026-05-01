+++
title = "Running Chef Habitat on servers (Linux and Windows)"
description = "Running Chef Habitat on servers (Linux and Windows)"


[menu.sup]
    title = "Running Chef Habitat on servers (Linux and Windows)"
    identifier = "supervisors/running-habitat-servers"
    parent = "supervisors"
    weight = 25
+++

Chef Habitat can run on bare metal servers, as well as virtual machines. Currently, Chef Habitat runs on Linux and Windows platforms, and in all cases, running a Supervisor comes down to running `hab sup run`. How that happens depends on the platform you use.

## Running Chef Habitat on Linux

First, you must [install Chef Habitat](/install/) itself on the machine.

Second, many packages default to running as the `hab` user, so you should ensure that both a `hab` user and group exist:

```bash
sudo groupadd hab
sudo useradd -g hab hab
```

Finally, you need to wire Chef Habitat to your system's init system. This may be SysVinit, systemd, runit, and so on. The details differ for each system, but in the end, you must call `hab sup run`.

### Running under systemd

A basic systemd unit file for Chef Habitat might look like this. This assumes that you have already created the `hab` user and group, as instructed above, and that your `hab` binary is linked to `/bin/hab`.

```toml
    [Unit]
    Description=The Chef Habitat Supervisor

    [Service]
    ExecStart=/bin/hab sup run

    [Install]
    WantedBy=default.target
```

Depending on your needs and deployment, you may want to modify the options passed to `hab sup run`. In particular, if you want to participate in larger Supervisor networks, you need to pass at least one `--peer` option.

## Running Chef Habitat on Windows

As with Linux, you must first [install Chef Habitat](/install/) on the machine. Unlike Linux, however, the Windows Supervisor has no requirements for any `hab` user.

On Windows, you can run the Supervisor as a Windows Service. You can use the `windows-service` Chef Habitat package to host the Supervisor inside the Windows Service Control Manager:

```powershell
hab pkg install chef/windows-service
```
