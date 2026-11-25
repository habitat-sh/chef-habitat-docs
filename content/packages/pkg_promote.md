+++
title = "Promote packages"
description = "Best practices for promoting packages in channels for building and testing code changes as part of continuous deployment with channel tags"


[menu.packages]
    title = "Promoting packages"
    identifier = "packages/promote Promoting Packages"
    parent = "packages"
    weight = 20

+++

Continuous deployment is a well-known software development practice of building and testing code changes in preparation for a release to a production environment.

## Continuous deployment using channels

Chef Habitat supports continuous deployment workflows through the use of channels. A channel is a tag for a package that the Supervisors in a service group can subscribe to. Channels are useful in CI/CD scenarios where you want to gate a package before making it the default version of the package that users should consume. You can think of this split as the difference between test and production, or nightly releases versus stable releases of products.

By default, every new package is placed in the `unstable` channel by Builder. Packages in the `unstable` channel can't be started or installed unless you specify the `--channel` flag in the `hab` CLI, or set the `HAB_BLDR_CHANNEL` environment variable to a non-stable channel. This is because the default channel used by the `hab` CLI when starting, installing, or loading packages is the `base` channel for `core` origin packages and `stable` for all other origins. These channels indicate a level of stability and functionality suitable for use in multi-service applications or as a dependency for your service.

To promote your package to a channel, you must either use Builder to build your package or upload it to Builder yourself, and then use the `hab pkg promote` subcommand to promote the package to the intended channel. To combine operations, the `hab` CLI allows you to do both in one command by using the `--channel` option when uploading your package. The following shows how to upload and promote a package to a custom channel named `test`.

```bash
hab pkg upload -z <TOKEN> results/<hart file> --channel test
```

In the example above, if you look up your package in the Builder UI, or using the `hab pkg channels` subcommand, you can see that your package is tagged for both the `test` and `unstable` channels.

{{< note >}}

Custom channels like `test` are scoped to each package. Builder doesn't create channels scoped to an origin, so if you want to use custom channels for future releases of a package, you must promote to those channels for each release.

{{< /note >}}

If you have already uploaded your package to a channel and wish to promote it to a different channel, use the `hab pkg promote` subcommand as shown below.

```bash
hab pkg promote -z <TOKEN> <ORIGIN>/<PACKAGE>/<VERSION>/<RELEASE> stable
```

### Promoting an entire channel

Use `hab bldr channel promote` to promote all packages in one origin channel to another:

```bash
hab bldr channel promote -o <ORIGIN> -z <TOKEN> <SOURCE_CHANNEL> <TARGET_CHANNEL>
```

Add `--check` to ask Builder to check the combined target and source package dependencies for incompatible versions before promotion. A conflict stops the promotion and exits non-zero. The output names each conflicting package and target platform, its full package identifiers, and the source or target packages that introduced each version. Add `--json` to print Builder's full conflict response as JSON.

```bash
hab bldr channel promote --check -o <ORIGIN> -z <TOKEN> dev stable
```

Add `--snapshot` to create a channel containing the target channel's packages after promotion. On success, the command prints the snapshot channel name and a package list that includes transitive dependencies. `--check --snapshot` checks first; if the check finds a conflict, Builder creates no snapshot. With `--json`, the snapshot response is printed as JSON.

```bash
hab bldr channel promote --check --snapshot -o <ORIGIN> -z <TOKEN> dev stable
```

These flags require a recent Builder. Older Builders may ignore them and still promote packages. An empty success response is normal for a successful `--check`, so it cannot confirm whether an older Builder ran the check. With `--snapshot`, an empty success response means no snapshot was confirmed, and the CLI reports that.

### Combining an update strategy with channels

By using both channels and either the `at-once` or `rolling` [update strategies](#combining-an-update-strategy-with-channels), you can automatically update packages in a given channel as shown below:

![Promoting packages through channels](/images/habitat/habitat-promote-packages-through-channels.png)

Using the infographic as a guide, a typical continuous deployment scenario would be as follows:

1. You build a new version of your package either through Builder or through a local Studio environment and then upload it to Builder.
2. When you're ready to roll out a new version of the package, you promote that package to the channel corresponding to the intended environment, for example, `dev`. You can have multiple service groups in the same environment pointing to different channels, or the same channel.
3. An existing set of running Supervisors in that service group see that the channel they're subscribed to has an update, so they update their underlying Chef Habitat package, coordinating with one another according to their update strategy, and restart their service.
4. When you're ready, you then promote that version of your package to a new channel, for example, `acceptance`. The running Supervisors in that group see the update and perform the same service update as in step 3. You repeat steps 3 and 4 until your package makes its way through your continuous deployment pipeline.

Configuring a Supervisor's update strategy to point to a channel ensures that new versions of the application don't get deployed until the channel is updated, thereby preventing unstable versions from reaching environments for which they aren't intended.

To start a service with an update strategy and pointing to a channel, specify them as options when loading the service.

```sh
hab svc load <ORIGIN>/<PACKAGE> --strategy rolling --channel test
```

While that service is running, update your package, rebuild it, and then promote it to the same channel that the previous release of that service is currently running in, for example, `test`. Those running instances should now update according to their update strategy.

### Listing and filtering channels

Use `hab bldr channel list` to list the channels of an origin, one name per line. Add `--sandbox` to include sandbox channels. Use `--filter <STRING>` to list only channels whose names contain the string. The match is case-sensitive, and an empty or whitespace-only value is rejected.

```bash
hab bldr channel list <ORIGIN> --filter test
```

If no channels match, the command prints `No channels found matching '<STRING>'` and exits with status 0.

### Listing packages in a channel

Use `hab bldr channel list-packages` to see every package promoted to a channel:

```bash
hab bldr channel list-packages core stable
```

The command prints one fully qualified `<ORIGIN>/<PACKAGE>/<VERSION>/<RELEASE>` identifier per line and retrieves all pages from Builder. Use `--limit N` to show at most N packages, or `--json` to print a JSON array of identifiers. An empty channel prints a message; with `--json`, it prints `[]`.

For a private origin, pass `--auth <AUTH_TOKEN>` (or `-z`), set `HAB_AUTH_TOKEN`, or configure an auth token in `cli.toml`. Use `--url <BLDR_URL>` to select a different Builder endpoint. `HAB_BLDR_URL` and `cli.toml` are also supported.

### Demoting a package from a channel

If you need to un-associate a channel from a specific package release, you can do so using the `hab pkg demote` subcommand. Packages can be demoted from all channels except `unstable`.

```bash
hab pkg demote -z <TOKEN> <ORIGIN>/<PACKAGE>/<VERSION>/<RELEASE> test
```

The Builder UI for that package release and `hab pkg channels` both reflect the removal of that channel.

{{< note >}}

If you demote a package from the `stable` channel, then any other packages that depend on the stable version of that package will either fail to load or build depending on how that demoted packaged was used.

Also, downgrading to another release for a specific channel isn't available at this time. This means if you run the latest release of a package from a specific channel, and demote the channel for that release, the package won't downgrade to the next most recent release from that channel.

{{< /note >}}
