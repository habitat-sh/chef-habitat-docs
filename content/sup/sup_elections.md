+++
title = "Leader elections"
date = 2020-10-26T19:05:42-07:00
draft = false


[menu.sup]
    title = "Leader elections"
    identifier = "supervisors/Leader Elections"
    parent = "supervisors"
    weight = 40
+++

The Chef Habitat Supervisor performs leader election natively for service group [topologies](../services/service_group_topologies) that require it, such as _leader-follower_.

Because Chef Habitat is an eventually-consistent distributed system, the role of the leader is different than in strongly-consistent systems. It only serves as the leader for _application level semantics_, for example a database write leader. The fact that a Supervisor is a leader has no bearing upon other operations in the Chef Habitat system, including rumor dissemination for configuration updates. It's _not_ akin to a [Raft](https://raft.github.io/) leader, through which writes must all be funneled. This allows for very high scalability of the Chef Habitat Supervisor ring.

Service groups that use a leader need a minimum of three Supervisors to break ties.
Don't run a service group with an even number of members.
Otherwise, during a network partition with equal members on each side, both sides can elect a leader and create a split-brain condition that the algorithm can't recover from.
Supervisors in a service group warn you when leader election is enabled and the group has an even number of Supervisors.

## Protocol for electing a leader

When a service group starts in a leader topology, it waits until enough members are available to form a quorum (at least three). At that point, an election cycle can begin. Each Supervisor injects the same election rumor into the ring, targeted at the service group, declaring an election and nominating itself as leader.
This algorithm is known as [Bully](https://en.wikipedia.org/wiki/Bully_algorithm).

Each peer that receives this rumor performs a lexicographic comparison of its GUID with the GUID in the rumor. The peer with the higher GUID wins. The peer then adds a vote for the winning GUID and shares the rumor with others, including the total votes from peers that already voted for that winner.

An election ends when candidate peer X receives a rumor from the ring stating that X is the winner with votes from all members. At that point, X sends a rumor declaring itself the winner, and the election cycle ends.

## Related reading

- For more information about the bully algorithm, see [Elections in a Distributed Computing System](https://dl.acm.org/doi/10.1109/TC.1982.1675885) by Héctor García-Molina.
