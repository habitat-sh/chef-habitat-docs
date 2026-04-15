+++
title = "Control Supervisors remotely"
description = "Controlling Supervisors remotely"


[menu.sup]
    title = "Remote Supervisor control"
    identifier = "supervisors/sup-remote-control"
    parent = "supervisors"
    weight = 120
+++

It's possible to command and control one or more Supervisors from a remote location. The default way to interact with a Supervisor is to take action directly on the machine where the Supervisor is running. Remote command and control opens more possibilities for using and managing Chef Habitat.

Here, we'll discuss how this is implemented, how it can be enabled in your Chef Habitat deployments, and how it can be used.

## Remote command and control overview

The Chef Habitat Supervisor uses a defined TCP protocol for all interactions; the `hab` CLI tool is the client for this protocol, and the Supervisor is the server. Interactions are authenticated using a shared secret.

Previously, to run `core/redis` on a Supervisor running on, for example, `hab1.mycompany.com`, you needed direct access to the machine (as well as root privileges) to load the service, which might look like this:

```sh
ssh hab1.mycompany.com
sudo hab svc load core/redis
```

Now, using Supervisor remote control capabilities, you can do this from a workstation or bastion host with a command as simple as this:

```sh
hab svc load core/redis --remote-sup=hab1.mycompany.com:9632
```

No direct host access is required, and you can control multiple Supervisors from one central location.

### Remote control is optional

Operating Chef Habitat Supervisors remotely is optional; you must take explicit action to enable this behavior. If you prefer, you can continue to manage Supervisors through on-host direct action, likely without changes to your current procedures. Read on for more details about enabling this capability, and how local interaction continues to operate through a new implementation.

## Managing shared Supervisor secrets

Authentication between client (`hab` CLI) and server (Supervisor) is achieved using a shared secret. The `hab` CLI receives its secret from a configuration file (`~/.hab/config/cli.toml`) or from an environment variable (`HAB_CTL_SECRET`). The Supervisor reads its secret from its `CTL_SECRET` file, located at `/hab/sup/default/CTL_SECRET`. When the value used by `hab` matches the one used by the Supervisor, the requested command is carried out.

### Create a secret

Shared secrets are created in one of two ways.

First, when a Supervisor starts, it creates a new secret in `/hab/sup/default/CTL_SECRET` automatically if one doesn't already exist. This helps transparently upgrade older Supervisors and continue to allow local interactions.

Second, and this is the recommended approach, you can generate a new secret with `hab sup secret generate`:

```sh
hab sup secret generate
VKca6ezRD0lfuwvhgeQLPSD0RMwE/ZYX5nYfGi2x0R1mXNh4QZSpa50H2deB85HoV/Ik48orF4p0/7MuVNPwNA==
```

This generates a new secret and prints it to standard output. Using the provisioner or configuration management tool of your choice, you can then use this value to create your own `/hab/sup/default/CTL_SECRET` file, ensuring that your Supervisors use a predetermined key instead of each creating their own.

If you have a pre-existing Supervisor fleet that already started with individually generated secrets, you likely want to overwrite existing `CTL_SECRET` files with one key of your own creation.

If you are using a raw container-based deployment (not a managed platform like Kubernetes), you will want to mount an appropriate `CTL_SECRET` file into the container.

### Configure the Hab CLI with your secret

Once you have a secret, you can add it to your local `hab` configuration file, preferably by running `hab cli setup` and following the interactive prompts. Alternatively, you can export it into your environment:

```sh
export HAB_CTL_SECRET="VKca6ezRD0lfuwvhgeQLPSD0RMwE/ZYX5nYfGi2x0R1mXNh4QZSpa50H2deB85HoV/Ik48orF4p0/7MuVNPwNA=="
```

Note that your `hab` configuration file only keeps a single "secret" entry, and exporting a single secret into your environment does effectively the same thing. An assumption of this arrangement is that all Supervisors you wish to interact with have the same shared secret; if you wish to control a set of Supervisors that don't all use the same shared secret, you will need to manage the mapping of secret-to-supervisor yourself, which might look something like this:

```sh
HAB_CTL_SECRET=${secret_for_supervisor_1} hab svc load ... --remote-sup=${address_of_supervisor_1}
HAB_CTL_SECRET=${secret_for_supervisor_2} hab svc load ... --remote-sup=${address_of_supervisor_2}
# etc.
```

## Configuring Supervisors for remote command and control

As stated earlier, the Supervisor reads its secret from `/hab/sup/default/CTL_SECRET`, whose contents you can control with `hab sup secret generate` and your chosen provisioner or deployment tooling. This ensures the shared secret is in place, but you must take one more step to fully enable the feature.

By default, the Supervisor's "control gateway" listens on the `127.0.0.1` interface for incoming commands. This means it can only receive commands from the same machine, not from remote clients. If you want to control a Supervisor remotely, start the Supervisor with `--listen-ctl` set to an appropriate interface and port (9632 is the default control gateway port):

```sh
hab sup run --listen-ctl=0.0.0.0:9632
```

This Supervisor can now be controlled through any network interface, provided the request uses the appropriate shared secret. As always, use interface values that fit your specific situation (for example, pass an internal network-facing interface rather than a publicly exposed interface).

## Targeting a remote Supervisor

This documentation includes many examples of interacting with a Supervisor; commands like `hab svc load`, `hab svc start`, and `hab svc stop` all generate requests using the Supervisor's defined interaction protocol. They all operate over TCP, even in the default case of interacting with a Supervisor on the same host.

To target a remote Supervisor, you must have the appropriate shared secret available, as described above (either in the environment or in the `hab` CLI configuration file), and you must specify the target Supervisor with the `--remote-sup` option. The value for this option should match the `--listen-ctl` value the Supervisor was started with; it is the address and port where the Supervisor's control gateway can be reached. All Supervisor interaction commands accept `--remote-sup` for this targeting.

## Local Supervisor interactions

Without specifying `--remote-sup`, the `hab` CLI always tries to connect to a Supervisor running on the current host. It must still use the correct shared secret. As a last resort, if no secret is found in either a configuration file or an environment variable, the `hab` CLI attempts to read one from `/hab/sup/default/CTL_SECRET`. In this way, it uses the same secret as the local Supervisor, enabling the request to proceed.
