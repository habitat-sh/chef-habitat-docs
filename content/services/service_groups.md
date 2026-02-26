+++
title = "Service groups"
description = "Service groups"


[menu.services]
    title = "Service groups"
    identifier = "services/Service Groups"
    parent = "services"
    weight = 20
+++

A service group is a logical grouping of services with the same package and topology type connected together across a Supervisor network.
They're created to share configuration and file updates among the services within those groups and can be segmented based on workflow or deployment needs (for example, QA or production).
Updates can also be [encrypted](../sup/sup_secure) so that only members of a specific service group can decrypt the contents.

By default, every service joins the `service-name.default` service group unless
otherwise specified at runtime.

In addition, multiple service groups can reside in the same Supervisor network. This allows data exposed by Supervisors to be shared with other members of the ring, regardless of which group they're in.

## Joining a service group

To join services together in a group, they must run on Supervisors that are participating in the same Supervisor gossip network (they're ultimately peered together), and they must use the same group name. To illustrate, we'll show two `core/redis` services joining the same group.

First, we'll start two Supervisors on different hosts, peering the second one back to the first.

```bash
$ hab sup run # on 172.18.0.2 (Supervisor A)
hab-sup(MR): Supervisor Member-ID e89b6616d2c040c8a82f475b00ba8c69
hab-sup(MR): Starting gossip-listener on 0.0.0.0:9638
hab-sup(MR): Starting ctl-gateway on 0.0.0.0:9632
hab-sup(MR): Starting http-gateway on 0.0.0.0:9631
```

```bash
$ hab sup run --peer=172.18.0.2:9638 # on 172.18.0.3 (Supervisor B)
hab-sup(MR): Supervisor Member-ID bc8dc23243e44fee8ea7b9023073c28a
hab-sup(MR): Starting gossip-listener on 0.0.0.0:9638
hab-sup(MR): Starting ctl-gateway on 0.0.0.0:9632
hab-sup(MR): Starting http-gateway on 0.0.0.0:9631
```

Now, run the following on each Supervisor to load `core/redis` in the "prod" group:

```sh
hab svc load core/redis --group=prod
```

Each will start up, and will be joined into the same group; here is Supervisor A's output:
![Supervisor A running Redis](/images/habitat/supervisor_a_before.png)

And here is Supervisor B's output:
![Supervisor B running Redis](/images/habitat/supervisor_b_before.png)

Note that they're both listening on the same port.

To prove they're in the same group, we can apply a configuration change; if they are in the same group, they should both receive the change.

Let's change the port they're running on using the `hab config apply` command, run from Supervisor A.

```bash
echo 'port = 2112' | hab config apply redis.prod 1
```

Both service instances restart with the new configuration. Supervisor A's output is:

![Supervisor A running Redis on a new port](/images/habitat/supervisor_a_after.png)

and Supervisor B's output is:

![Supervisor B running Redis on a new port](/images/habitat/supervisor_b_after.png)

Note that both have restarted (as evidenced by the new PID values), and both are now running on port 2112, as expected.

Had the services been in different groups, the configuration change would not have applied to both of them (it was targeted at `redis.prod`). If the Supervisors had not been in gossip communication (achieved here through the use of the `--peer` option when Supervisor B was started), the configuration rumor (injected into Supervisor A's gossip network) would not have made it to the `core/redis` service running on Supervisor B.
