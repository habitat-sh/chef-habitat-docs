+++
title = "Upgrading from 1.6.x to 2.0.x"
description = "How to Upgrade Chef Habitat from 1.6.x to 2.0.x"
linkTitle = "Upgrade"

[menu.upgrade]
  title = "Upgrading from 1.6"
  identifier = "upgrade/upgrading-hab"
  parent = "upgrade"
  weight = 10
+++

While basic Chef Habitat behavior hasn't changed from version 1.6.x to 2.0.x, Chef Habitat Supervisor environments running 1.6.x can't seamlessly update themselves with the auto update feature nor can you install a Chef Habitat 2.0.x supervisor package and expect a supervisor restart to pick up the new 2.0.x package.

This is largely because the Chef Habitat binaries have moved from the `core` origin to the `chef` origin. You will need updated cli, launcher and supervisor binaries for everything to run correctly. On windows you will also need the updated `windows-service` package. Further, the supervisor will need a valid `HAB_AUTH_TOKEN` associated with a valid license key in its environment in order to download any license restricted `core` or `chef` packages.

Similar to the install scripts used to install Chef Habitat, we provide a migration script that installs a full set of the latest Chef Habitat 2.0.x packages, inject your auth token into the supervisor environment and restart all habitat services.

To upgrade a supervisor from 1.6.x to 2.0.x, run the following:

- **linux**: `curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/migrate.sh | sudo bash -s -- --auth <HAB_AUTH_TOKEN>`
- **windows**: `iex "& { $(irm https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/migrate.ps1) } --auth <HAB_AUTH_TOKEN>"`

Note that if your supervisor is running services while executing the migration script, these services will be restarted.

## Potentially breaking changes to handlebars templates

The [handlebars implementation](https://crates.io/crates/handlebars) was upgraded from an early version that habitat had pinned due to breaking changes after habitat was released for general use. The code base was upgraded to the most recent version available. Also it has been, and will continue to be, updated as new releases of the crate become available.

The impact of this is that you may have to update your templates as described in the following sections.

### Object Access Syntax Removed

In Habitat versions prior to 2.0 both `object.[index]` and `object[index]` were valid syntax for object access. After habitat 2.0 only the `object.[index]` remains valid syntax.

The action required is that you will need to proactively or reactively change any usages of the now removed `object[index]` syntax to the still viable `object.[index]` syntax. See [PR #6323](https://github.com/habitat-sh/habitat/issues/6323) [PR #9585](https://github.com/habitat-sh/habitat/pull/9585) for more information.

One way to identify files for review is `find . -type f | xargs grep --perl-regexp '(^|\s)[a-zA-Z0-9-_]+\[.*\]' --files-with-matches` but this should be adapted as appropriate for use against your codebase.

### Trimming Whitespace Now Works Correctly

The `{{~` and `~}}` syntax for whitespace trimming was effectively a noop for habitat versions prior to 2.0 After 2.0 usage of `{{~` and `~}}` will trim whitespace as expected which may result in errors.

The action required is that you need to review your usage of habitat templating where `{{~` and `~}}` has been and update as appropriate for the context in which the whitespace trimming operators are used as the effect. The reason the guidance here is to "update as appropriate for the context" is that effect of using `{{~` and `~}}` is very dependent on where and how the syntax is used.

For example, one issue that the habitat team encountered was with templated nginx.conf files. In the context of a templated nginx.conf where semicolons and braces terminate simple and block directives the effect was one of poor formatting as opposed to broken habitat package because the file that was produced was syntactically valid and parsable by nginx.

However, another example the habitat team encountered was in the context of generating a PostgreSQL pg_hba.conf file. There the use of `{{~` caused a line that should have been created on a line by itself to be concatenated with the previous line. In this instance the plan built as expected but contained an unparsable pg_hba.conf file that caused an error when attempting to run postgres.

One way to identify files for review is `find . -type f | xargs grep --perl-regexp '{{~|~}}' --files-with-matches` but this should be adapted as appropriate for use against your code base.

For more on how to use `{{~` and `~}}` you can read [Effective Use of Handlebars Whitespace Trimming](../reference/plan_helpers/#effective-use-of-handlebars-whitespace-trimming) or visit the [Handlebars website](https://handlebarsjs.com/).
