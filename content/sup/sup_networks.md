+++
title = "Supervisor networks"
description = "Robust Supervisor networks"


[menu.sup]
    title = "Supervisor networks"
    identifier = "supervisors/sup-networks Supervisor Networks Explained"
    parent = "supervisors"
    weight = 60
+++

Chef Habitat Supervisors communicate with each other using gossip algorithms, which underpin membership management, leadership election, and service discovery in Chef Habitat. By peering with a single existing Supervisor, a new Supervisor gradually learns about _all_ Supervisors in a Chef Habitat network. The gossip algorithm has built-in features to counteract brief network splits, but you still need to design a robust Supervisor network.

## The initial peer

While a Chef Habitat Supervisor doesn't need to connect with other Supervisors to be useful, a Supervisor network unlocks the full platform value of Chef Habitat. To do this, a Supervisor must be given the address of at least one other Supervisor in the network when it starts; this is known as the _initial peer problem_. You can think of a Supervisor network as an exclusive members-only club: you must first know a member to become a member yourself.

This Supervisor doesn't know about any other Supervisors, and will (at least initially) run in complete isolation.

```sh
hab sup run
```

This Supervisor, on the other hand, will start up knowing about three other Supervisors, and will quickly establish contact with each of them. Thanks to the gossip mechanism, it will also find out about every other Supervisor those initial Supervisors know about. Similarly, every other Supervisor will discover the presence of _this_ new Supervisor.

```sh
hab sup run --peer=192.168.0.1 --peer=192.168.0.2 --peer=192.168.0.3
```

Peering is symmetric. Even though the first Supervisor above didn't start out peered with any other Supervisors, it can still become part of a Supervisor network if another Supervisor declares it to be a peer.

## Managing membership with swim

In order for Chef Habitat's network functionality to work, the Supervisors must first know which other Supervisors they can communicate with. This is a problem of maintaining membership lists, and is achieved using the membership protocol known as _SWIM_. As detailed above, we must first "seed" a Supervisor's membership list with at least one "peer"; that is, another Supervisor that it can communicate with.

Given a non-empty membership list, the Supervisor can begin probing members of that list to see if they're still alive and running. Supervisor A sends a message to Supervisor B, effectively asking if it's still there. If Supervisor B is available, it replies to Supervisor A and sends contact information for up to five Supervisors that _it_ has in its membership list (Supervisor A also sends these introductions in its initial message). In this way, Supervisors can both maintain and _grow_ their membership lists. In short order, Supervisor A learns about all other Supervisors in the network, and they learn about Supervisor A.

If Supervisor A can't establish contact with Supervisor B, it doesn't immediately consider B dead. That would be too strict and could lead to unnecessary service flapping. Instead, Supervisor A marks Supervisor B as suspect. In this case, it asks Supervisor C (another Supervisor in its membership list) if it can contact Supervisor B. If Supervisor C can make contact, it relays that information back to Supervisor A, which then marks Supervisor B alive again. This scenario can arise, for example, if there is a network split between Supervisors A and B, but not between A and C, or B and C. Similarly, network congestion could delay messages so that Supervisor A's request times out before Supervisor B's reply can make it back.

If no Supervisor can make contact with Supervisor B, either directly or indirectly, the network marks Supervisor B as "confirmed" dead. In this case, Supervisor B is effectively removed from all membership lists across the network. As a result, no Supervisors try to contact it again. This is what happens when you shut down a Supervisor; the rest of the network realizes it's gone and can reconfigure services to stop communicating with services that were running on it.

If, on the other hand, Supervisor B is started back up again, it can rejoin the network. All the other Supervisors will (through the same SWIM mechanism described) recognize that it's back, and will mark it as alive once again. Services will be reconfigured to communicate with Supervisor B's services as appropriate.

This mechanism forms the foundation of the Chef Habitat network, but it can't provide a completely robust network by itself. For that, you need something additional.

## Permanent peers

An important thing to keep in mind about the basic SWIM mechanism is that if two Supervisors are separated long enough, each will eventually view the other as dead and stop trying to reestablish contact. While this is the behavior you want when you intentionally shut down a Supervisor, it's definitely _not_ the behavior you want if your Chef Habitat network experiences an extended network incident. In such a case, you could end up with two (or more) smaller Supervisor networks that are still _internally_ connected, but completely disconnected _from each other_. Supervisors in "Network A" would view those in "Network B" as dead, and vice versa. After network connectivity is restored, you could still have a fractured network because each network collectively considers the other dead.

By starting a few Supervisors in the network using the `--permanent-peer` option, additional information is gossiped about those Supervisors. In effect, it tells other Supervisors to _always_ try to reestablish contact with a permanent peer, even if that Supervisor currently considers the permanent peer dead. This provides a mechanism for split networks to stitch themselves back together after a split is resolved.

## The "bastion ring"

Defining a few Supervisors as permanent peers _will_ provide a robust network, but without care, it can be less than ideal. We recommend running a small number of Supervisors as permanent peers, and running _no services_ on those Supervisors. In modern dynamic architectures, it's common for nodes to come and go; VMs may be shut down, and containers can be rescheduled. If _all_ Supervisors are permanent peers, you can create unnecessary network traffic as Supervisors come and go over time. Each Supervisor would try to maintain contact with every Supervisor that has ever been a member of the network.

If your permanent peer Supervisors aren't running any services, they will be less subject to the pressures that would cause service-running Supervisors to come and go. They can exist solely to anchor the entire Supervisor network.

## Pulling it all together: a robust Supervisor network

Using these patterns, you can create a robust Chef Habitat network architecture. In fact, this is the same architecture the Chef Habitat team uses to run the public [Builder service](https://bldr.habitat.sh).

### Create the bastion ring

First, set up three Supervisors (A, B, and C) as permanent peers, all mutually peered to each other:

``` sh
# Supervisor "A"
hab sup run --permanent-peer --peer=<IP_ADDRESS_B> --peer=<IP_ADDRESS_C>

# Supervisor "B"
hab sup run --permanent-peer --peer=<IP_ADDRESS_A> --peer=<IP_ADDRESS_C>

# Supervisor "C"
hab sup run --permanent-peer --peer=<IP_ADDRESS_A> --peer=<IP_ADDRESS_B>
```

Replace:

- `<IP_ADDRESS_X>` with the IP address that a peer Supervisor is reachable at.

These Supervisors should never run services. They _can_, however, serve as convenient, well-known, and stable entry points to the network for tasks like injecting configuration with `hab config apply`, adding files with `hab file upload`, and departing Supervisors with `hab sup depart`.

### Peer additional Supervisors to the bastion Supervisors

Each additional Supervisor you add to the network should be peered to _at least one_ bastion ring Supervisor. Technically, only one peer is necessary, because it provides access to the rest of the network. However, a Supervisor might not fully connect to all peers if it joins _during_ a network split event. For convention and redundancy, peer to _all_ bastion ring Supervisors, like this:

``` sh
# Supervisor "D" (a "normal" Supervisor)
hab sup run --peer=<IP_ADDRESS_A> --peer=<IP_ADDRESS_B> --peer=<IP_ADDRESS_C>
```

This Supervisor _should_ be used to run services, but _shouldn't_ be started as a permanent peer.

## Conclusion

This overview should give you a clearer understanding of how Chef Habitat networking works, and how to use it to provide a robust network foundation for your services.

If you prefer a concise summary, the advice above can be reduced to:

1. Run three mutually-peered, permanent Supervisors
2. Never run services on those Supervisors
3. Peer all other Supervisors to those first three

## Related reading

If you want additional details, the following technical journal articles describe the algorithms that form the basis of Chef Habitat's gossip system:

- [SWIM: Scalable Weakly-consistent Infection-style Process Group Membership Protocol](https://www.cs.cornell.edu/projects/Quicksilver/public_pdfs/SWIM.pdf) by Abhinandan Das, Indranil Gupta, Ashish Motivala.
- [A Robust and Scalable Peer-to-Peer Gossiping Protocol](https://doi.org/10.1007/978-3-540-25840-7_6) by Spyros Voulgaris, Mark Jelasity, and Maarten van Steen.
