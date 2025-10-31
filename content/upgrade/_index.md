+++
title = "Upgrade Chef Habitat from 1.6 to 2.x"
description = "Upgrade Chef Habitat from 1.6 to 2"
linkTitle = "Upgrade"

[menu.upgrade]
  title = "Upgrading to Habitat 2"
  identifier = "upgrade/upgrading-hab"
  parent = "upgrade"
  weight = 10
+++

Chef Habitat 2.x includes the following feature changes:

- We moved the Chef Habitat binaries from the `core` origin to the `chef` origin.
- Chef Habitat Supervisors now need a valid `HAB_AUTH_TOKEN` to download packages from the `core` and `chef` origins.
- We updated the Habitat handlebars templating.

To update to Chef Habitat 2.x:

- review your Habitat templates to verify that they're compatible with Habitat 2
- run migration script to update your Habitat Supervisors

## Update handlebars in Habitat templates

For Chef Habitat 2, we updated the [handlebars implementation](https://crates.io/crates/handlebars) used to input variables into templates.
You may need to update your templates as described in the following sections.

### Update object access syntax

In Chef Habitat 1.6 and earlier, both `object.[index]` and `object[index]` were valid syntax to access items in an object.
In Habitat 2.0 and later, only `object.[index]` is valid syntax.
Review your templates and replace instances of `object[index]` syntax with `object.[index]` syntax.

To identify files that need review, you can use the following command:

```sh
find . -type f | xargs grep --perl-regexp '(^|\s)[a-zA-Z0-9-_]+\[.*\]' --files-with-matches
```

Adapt this command as necessary for your codebase.

For more information, see:

- [issue #6323](https://github.com/habitat-sh/habitat/issues/6323)
- [PR #9585](https://github.com/habitat-sh/habitat/pull/9585)

### Update whitespace trimming in templates

Before Chef Habitat 2.x, the `~` character added to a set of braces in a mustache statement (for example `{{~#if items~}}`) didn't trim whitespace around the statement and was effectively a noop. In Habitat 2 and later, the `~` character [trims whitespace](https://handlebarsjs.com/guide/expressions.html#whitespace-control) as expected and may result in errors.

In one case, we found that a templated `nginx.conf` file output an `nginx.conf` file that was poorly formatted but syntactically valid and parsable by Nginx.

However, in another case, the `~` character in a template concatenated two lines that should be separate in a generated PostgreSQL `pg_hba.conf` file.
The Habitat plan built as expected, but PostgreSQL couldn't parse the `pg_hba.conf` file.

For more on how to use the `~` character in a mustache statement to control whitespace, see the [Habitat plan helpers documentation](../reference/plan_helpers/#trimming-whitespace) or the [Handlebars website](https://handlebarsjs.com/guide/expressions.html#whitespace-control).

#### Find whitespace trimming in your templates

Before you upgrade to Chef Habitat 2, identify and review instances of `{{~` or `~}}` in your Habitat templates.
To find `{{~` or `~}}` in your templates, you can use the following command:

```sh
find . -type f | xargs grep --perl-regexp '{{~|~}}' --files-with-matches
```

Adapt this command as necessary for your codebase.

## Update Habitat Supervisors

While basic Chef Habitat behavior hasn't changed from version 1.6 to 2.0, you can't use the [Habitat Supervisor auto update feature](/sup/sup_update/) to update Supervisor environments running 1.6.
Additionally, you can't install a Chef Habitat 2.x Supervisor package and expect a Supervisor restart to pick up the new Habitat 2.0 package.

To update your Supervisors, you can use the Habitat 2 Supervisor migration script.
The migration script handles the following tasks:

- Installs the Habitat 2 CLI, launcher, and Supervisor binaries
- On Windows, updates the `windows-service` package
- Injects your Habitat Builder authentication token into your Supervisor environment
- Restarts all Habitat services

### Run the Supervisor migration script

Use the following scripts to upgrade your Chef Habitat Supervisors.
If you run this migration script while a Habitat Supervisor is running services, the script restarts those services.

Before you run the migration script, you'll need a [Habitat Builder authentication token](/saas_builder/builder_profile/#create-a-personal-access-token).

To upgrade a Supervisor from Habitat 1.6 to 2:

- On Linux, run:

  ```sh
  curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/migrate.sh | sudo bash -s -- --auth <HAB_AUTH_TOKEN>
  ```

- On Windows, run:

  ```ps1
  iex "& { $(irm https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/migrate.ps1) } --auth <HAB_AUTH_TOKEN>"
  ```
