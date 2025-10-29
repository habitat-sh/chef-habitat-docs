+++
title = "Upgrading from 1.6 to 2.x"
description = "Upgrade Chef Habitat from 1.6 to 2"
linkTitle = "Upgrade"

[menu.upgrade]
  title = "Upgrading to Habitat 2"
  identifier = "upgrade/upgrading-hab"
  parent = "upgrade"
  weight = 10
+++

## Update Habitat Supervisors

While basic Chef Habitat behavior hasn't changed from version 1.6 to 2.0, Chef Habitat Supervisor environments running 1.6 can't seamlessly update themselves with the auto update feature nor can you install a Chef Habitat 2.x Supervisor package and expect a Supervisor restart to pick up the new Habitat 2.0 package.

This is largely because the Chef Habitat binaries have moved from the `core` origin to the `chef` origin. You will need updated cli, launcher and supervisor binaries for everything to run correctly. On Windows, you will also need the updated `windows-service` package. Further, the supervisor will need a valid `HAB_AUTH_TOKEN` associated with a valid license key in its environment in order to download any license restricted `core` or `chef` packages.

Similar to the install scripts used to install Chef Habitat, we provide a migration script that installs a full set of the latest Chef Habitat 2 packages, inject your auth token into the supervisor environment and restart all Habitat services.

### Supervisor migration script

You can run the following scripts to upgrade Chef Habitat.

If you execute this migration script while a Habitat Supervisor is running services, the migration script will restart those services.

To upgrade a Supervisor from Habitat 1.6 to 2, run the following:

- On Linux:

  ```sh
  curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/migrate.sh | sudo bash -s -- --auth <HAB_AUTH_TOKEN>
  ```

- On Windows:

  ```ps1
  iex "& { $(irm https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/migrate.ps1) } --auth <HAB_AUTH_TOKEN>"
  ```

## Update Habitat handlebars in templates

For Chef Habitat 2, we've updated the [handlebars implementation](https://crates.io/crates/handlebars) used to input variables into templates.
You may have to update your templates as described in the following sections.

### Object access syntax

In Chef Habitat 1.6 and earlier, both `object.[index]` and `object[index]` were valid syntax to access items in an object. After Habitat 2.0, only the `object.[index]` remains valid syntax.

Review your templates and identify instances of `object[index]` syntax and replace them with `object.[index]` syntax.

You can use the following command to identify files that need review:

```sh
find . -type f | xargs grep --perl-regexp '(^|\s)[a-zA-Z0-9-_]+\[.*\]' --files-with-matches
```

Adapt this command as necessary for your codebase.

See the following GitHub issue and PR for more information:

- [issue #6323](https://github.com/habitat-sh/habitat/issues/6323)
- [PR #9585](https://github.com/habitat-sh/habitat/pull/9585)

### Whitespace trimming in templates

Before Chef Habitat 2.x, [whitespace trimming](https://handlebarsjs.com/guide/expressions.html#whitespace-control) using tildes (`~`) around a mustache statement was effectively a noop. With Habitat 2.0, `{{~` and `~}}` trims whitespace as expected and may result in errors.

In one case, the Habitat team found that a templated `nginx.conf` file output an `nginx.conf` that was poorly formatted, but syntactically valid and parsable by Nginx.

However, in another example, whitespace trimming with `{{~` concatenated two lines together that should be separate in a generated PostgreSQL `pg_hba.conf` file.
The Habitat plan built as expected, but PostgreSQL couldn't parse the `pg_hba.conf` file.

#### Find whitespace trimming in your templates

Before you upgrade to Habitat 2, identify and review instances of whitespace trimming in your Habitat plans.
You can use the following command to identify instances of `{{~` and `~}}`:

```sh
find . -type f | xargs grep --perl-regexp '{{~|~}}' --files-with-matches
```

Adapt this command as necessary for your codebase.

#### Whitespace trimming example

If you have a template expression with `~`, for example:

```handlebars
Hello, {{~planet~}} !
```

And an input JSON file:

```json
{
  "planet": "World"
}
```

The whitespace around the expression is removed from the compiled output:

```plain
Hello,World!
```

If the template expression doesn't have the tildes (`~`), the whitespaces are preserved and the output would be:

```plain
Hello, World !
```

For more on how to use tildes (`~`) to collapse whitespace, read [Effective Use of Handlebars Whitespace Trimming](../reference/plan_helpers/#effective-use-of-handlebars-whitespace-trimming) or see the [Handlebars website](https://handlebarsjs.com/guide/expressions.html#whitespace-control
).
