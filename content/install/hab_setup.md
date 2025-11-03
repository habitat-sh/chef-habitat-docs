+++
title = "Configure the Chef Habitat CLI"
description = "Set up the Chef Habitat CLI and configure your workstation for development"

[menu.install]
    title = "Configure the Habitat CLI"
    identifier = "install/hab-setup"
    parent = "install"
    weight = 20
+++

After installing Chef Habitat, you need to configure the CLI to work with your development environment and Chef Habitat Builder.

## Initial configuration

The `hab cli setup` command guides you through the essential configuration steps. Run this command and follow the prompts:

```bash
hab cli setup
```

During the setup process, you will be prompted for the following:

- A Habitat [origin](/origins/), which is a unique namespace for your packages. Origins organize packages in [Chef Habitat Builder](/saas_builder/). You can use your GitHub username or organization name for your origin. The origin name will prefix all the packages you create.

- A cryptographic key pair for your origin:

  - private key: Used to sign packages you build
  - public key: Used by others to verify your packages

- Optional: A Chef Habitat personal access token to:

  - Upload packages to Chef Habitat Builder
  - Share them with the Chef Habitat community
  - Access private origins

  For details on generating and using your access token, see the [access token documentation](../saas_builder/builder_profile.md#create-a-personal-access-token).

- Optional: Register a Supervisor control gateway secret.
  This enables [remote command-and-control of Supervisors](/sup/sup_remote_control.md).

## Reconfigure the Habitat CLI settings

You can change your settings at any time by re-running:

```bash
hab cli setup
```

## Next steps

After configuration is complete, you're ready to:

- [Build your first package](/plans/)
- [Explore the Habitat Studio environment](/studio)
- [Learn about services](/services/)
