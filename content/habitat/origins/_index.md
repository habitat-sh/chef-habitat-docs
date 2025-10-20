+++
title = "Chef Habitat Origins"
linkTitle = "Origins"

[menu.origins]
    parent = "habitat"
    title = "Chef Habitat Origins"
    identifier = "habitat/origins/Chef Habitat Origins"
    weight = 10
+++

{{< readfile file="/reusable/md/builder_origins.md" >}}

## Chef-owned origins

Progress Chef maintains the following origins:

- **core**: Hosts packages for common dependencies and compilers maintained by Progress Chef.
- **chef**: Hosts packages for Chef products like Chef Infra Client, Chef InSpec, and Chef Automate.
- **chef-platform**: Hosts packages for Chef 360 Platform skills.
- **habitat**: Hosts packages required for an on-prem Habitat Builder deployment.

## Where can I create an origin

You can create origins in an on-prem Habitat Builder deployment.
[Chef's public Habitat Builder](https://bldr.habitat.sh) doesn't support creating new origins.

## Create an origin

hooey


### Create an origin with the Chef Habitat CLI

{{< readfile file="/reusable/md/create_origins_cli.md" >}}

To create key pair for your origin, see the [origin keys](/habitat/origins/origin_keys/#generate-origin-keys) documentation.
