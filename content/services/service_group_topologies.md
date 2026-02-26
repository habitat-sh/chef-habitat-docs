+++
title = "Service group topologies"
description = "Service group topologies"


[menu.services]
    title = "Service group topologies"
    identifier = "services/Service Group Topologies"
    parent = "services"
    weight = 30
+++

A topology describes the intended relationship between peers within a service group.
Two topologies ship with Chef Habitat by default: **standalone** and **leader-follower**.
The leader-follower topology employs [leader election](../sup/sup_crypto) to define a leader.

## Standalone

The standalone topology is what a Supervisor starts with by default if no topology is specified, or if the topology is explicitly specified with `--topology standalone` when starting the Supervisor. The standalone topology means that service group members don't have any defined relationship with one another, other than sharing the same configuration.

## Leader-follower topology

In a leader-follower topology, one member of the service group is elected leader, and the other members become followers of that leader. This topology is common for database systems like MySQL or PostgreSQL, where applications send writes to one member, and those writes are replicated to one or more read replicas.

As with any topology using leader election, you must start at least three peers using the `--topology leader` flag for the Supervisor.

```bash
hab sup run --topology leader --group production
hab svc load <ORIGIN>/<NAME>
```

The first Supervisor blocks until it has quorum. Start additional members by pointing them at the ring with the `--peer` argument:

```bash
hab sup run --topology leader --group production --peer 192.168.5.4
hab svc load <ORIGIN>/<NAME>
```

{{< note >}}

The `--peer` service doesn't need a peer in the same service group; it only needs to be in the same ring as the other members.

{{< /note >}}

Once you have quorum, one member is elected leader, the Supervisors in the service group update the service's configuration according to the policy defined at package build time, and the service group starts up.

### Defining leader and follower behavior in plans

Chef Habitat allows you to use the same immutable package in different deployment scenarios. In this example, a configuration template with conditional logic makes the running application behave differently based on whether it's a leader or a follower:

```handlebars
{{#if svc.me.follower}}
   {{#with svc.leader as |leader|}}
     replicaof {{leader.sys.ip}} {{leader.cfg.port}}
   {{/with}}
{{/if}}
```

This logic says that if this peer is a follower, it becomes a read replica of the IP and port of the service leader (`svc.leader`), which is found through service discovery in the ring. However, if this peer is the leader, the entire list of statements evaluates to empty text---meaning that the peer starts up as the leader.

## Robustness, network boundaries and recovering from partitions

Within a leader-follower topology, it's possible to get into a partitioned state where nodes are unable to achieve quorum. To solve this, use a permanent peer to heal the netsplit. Pass the `--permanent-peer` option, or its short form `-I`, to make a Supervisor act as a permanent peer.

```bash
hab sup run --topology leader --group production --permanent-peer
hab svc load <ORIGIN>/<NAME>
```

When a Supervisor is instructed to act as a permanent peer, the other Supervisors attempt to connect with the permanent peer and achieve quorum, even if the permanent peer is confirmed to be dead.

The notion of a permanent peer is an extension of the original
[SWIM](http://www.cs.cornell.edu/projects/Quicksilver/public_pdfs/SWIM.pdf)
gossip protocol. It can add robustness, provided everyone has a permanent member
on both sides of the split.
