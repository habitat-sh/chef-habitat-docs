+++
title = "Setting up a ring"
description = "Setting up a ring"


[menu.sup]
    title = "Setting up a ring"
    identifier = "supervisors/sup-rings"
    parent = "supervisors"
    weight = 50
+++

## Bastion ring / permanent peers

A bastion ring is a pattern for preventing rumor loss and split-brain conditions in a network of Chef Habitat Supervisors, and it's highly recommended for production environments. Create a minimum of three Supervisors and join them together. These Supervisors shouldn't run services, and they should be marked as permanent peers---their only job is to spread rumors to each other. Then, when you provision additional Supervisors, pass the network address of each Supervisor in the bastion ring to the `--peer` argument of `hab sup run`. It's recommended to create a bastion ring in any network zone that may become partitioned due to hardware failure. For example, if you have a Chef Habitat ring spanning multiple data centers and clouds, each should have a bastion ring with a minimum of three Supervisors in addition to the Supervisors running your services.

## Initial peers

Initial peers are a requirement in distributed systems. In Chef Habitat, a new Supervisor looks for an initial peer to join so it can begin sharing information about the health and status of peers and services, which improves the health of the overall ring.
