+++
title = "Service group updates"
description = "Update service groups with Supervisor configuration"


[menu.services]
    title = "Service group updates"
    identifier = "services/Service Group Updates"
    parent = "services"
    weight = 50
+++

The Chef Habitat Supervisor can be configured to use an optional _update strategy_, which describes how the Supervisor and its peers within a service group should respond when a new package version is available.

To use an update strategy, configure the Supervisor to subscribe to Chef Habitat Builder, and more specifically, a channel for new versions.

## Configuring an update strategy

Chef Habitat supports three update strategies: `none`, `rolling`, and `at-once`.

To start a Supervisor with the automatic update strategy, pass the `--strategy` argument to a Supervisor run command, and optionally specify the depot URL:

```bash
hab sup run --strategy rolling --url https://bldr.habitat.sh
hab svc load <ORIGIN>/<NAME>
```

### None strategy

This strategy means your package won't automatically be updated when a newer version is available. By default, Supervisors start with their update strategy set to `none` unless explicitly set to one of the other two update strategies.

### Rolling strategy

This strategy requires Supervisors in a service group to update to a newer package version one at a time. An update leader is elected, and all Supervisors in the service group update around that leader. All update followers first ensure they're running the same version of the service as their leader, and then the leader polls Builder for a newer version of the service package.

Once the update leader finds a new version, it updates and waits until all other alive members in the service group have also been updated before attempting to find a newer software version. Updates happen more or less one at a time until completion, with the exception of a new node being introduced into the service group during an update.

If your service group is also running with the `--topology leader` flag, the leader of that election never becomes the update leader, so all followers within a leader topology update first.

It's important to note that because a leader election is required to determine an update leader, _you must have at least three Supervisors running a service group to use the rolling update strategy_.

### At-once strategy

This strategy does no peer coordination with other Supervisors in the service group. It simply updates the underlying Chef Habitat package whenever it detects that a new version has either been published to a depot or installed in the local Chef Habitat `pkg` cache. No coordination between Supervisors is done, and each Supervisor polls Builder on its own.
