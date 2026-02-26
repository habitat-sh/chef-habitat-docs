+++
title = "Chef Habitat Supervisors"
linkTitle = "Supervisors"


[menu.sup]
    title = "About Supervisors"
    identifier = "supervisors/sup Supervisors"
    parent = "supervisors"
    weight = 10
+++

The Supervisor is a process manager that has two primary responsibilities. First, it starts and monitors child services defined in the plan it's running. Second, it receives and acts on information from the other Supervisors to which it's connected. A service is reconfigured through application lifecycle hooks if its configuration has changed.

## The Supervisor ring

Supervisors typically run in a network, which we refer to as a *ring* (although it's more like a peer-to-peer network than a circular ring). The ring can be very large; it can contain hundreds or thousands of Supervisors. The membership list of this ring is maintained independently by each Supervisor and is known as the *census*.

## Census

The census is the core of the service discovery mechanism in Chef Habitat. It keeps track of every Supervisor in the ring, and handles reading, writing, and serializing through the discovery backend.

Each Supervisor in the system is a *census entry* that together form a *census*. Operations to discover or mutate the state of the census happen through algorithms that arrive at the same conclusion given the same inputs.

An example is leader election: it's handled here by having a consistent (and simple) algorithm for selecting a leader deterministically for the group. We rely on the eventual consistency of every Supervisor's census entry to elect a new leader in a reasonable amount of time.

## Supervisor REST API

The Chef Habitat Supervisor provides an HTTP API to expose cluster metadata, statistics, and general diagnostic information useful for monitoring and support in JSON format. It also provides detailed information about the Chef Habitat package it's supervising, including metadata such as build and runtime dependencies and their versions.

## Control gateway

The Supervisor control gateway is used to issue commands to a remote Supervisor. When a new Supervisor is created, a key for the `HAB_CTL_SECRET` environment variable is generated for it by default, if one isn't already present; this key is used to authenticate requests that are made with the control gateway.
See the [control gateway](sup_remote_control) documentation for more details.
