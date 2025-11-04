+++
title = "Configure the Chef Habitat CLI"
description = "Set up the Chef Habitat CLI and configure your workstation for development"

[menu.install]
    title = "Configure the CLI"
    identifier = "install/hab-setup"
    parent = "install"
    weight = 20
+++

After installing Chef Habitat, you need to configure the CLI to work with your development environment and Chef Habitat Builder.

## Initial Configuration

The `hab cli setup` command guides you through the essential configuration steps. Run this command and follow the prompts:

```bash
hab cli setup
```

![Habitat CLI setup output](/images/habitat/hab-setup.png)

## What Gets Configured

The setup process configures several important settings:

### 1. Origin Creation

You'll be prompted to create an **origin**, which is a unique namespace for your packages. Origins help organize and identify packages in Chef Habitat Builder.

- Choose a unique name (for example, your GitHub username or organization name)
- This will be the prefix for all packages you create

### 2. Origin Keys

Setup creates cryptographic key pairs for your origin:

- **Private key**: Used to sign packages you build
- **Public key**: Used by others to verify your packages

### 3. Personal Access Token (Optional)

Optionally provide a Chef Habitat personal access token to:

- Upload packages to the public depot
- Share them with the Chef Habitat community
- Access private origins

See the [access token documentation](/builder/saas/builder_profile.md#create-a-personal-access-token) for details on generating and using your access token.

### 4. Supervisor Control Gateway Secret (Optional)

You'll be asked if you want to register a Supervisor control gateway secret. This enables [remote command-and-control of Supervisors](/sup/sup_remote_control.md).

## Reconfiguring Settings

You can change your settings at any time by re-running:

```bash
hab cli setup
```

![Completed Hab CLI setup output](/images/habitat/hab-setup-complete.png)

## Next Steps

After configuration is complete, you're ready to:

- [Build your first package](/plans/)
- [Explore the Studio environment](/studio.md)
- [Learn about services](/services/)

{{< note >}}

For more information about using Chef Habitat Builder, see the [Builder documentation](/builder/saas/).

{{< /note >}}
