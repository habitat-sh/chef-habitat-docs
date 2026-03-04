+++
title = "Origin settings"
date = 2020-10-12T14:02:01-07:00
draft = false


[menu.origins]
    title = "Origin settings"
    identifier = "origins/origin-settings Origin Settings"
    parent = "origins"
    weight = 40
+++

The _Origin Settings_ tab contains the default package settings for all packages in the origin.

Everyone with origin membership can see the _Settings_ tab, but only origin administrators and owners can add, update, or delete settings.

| Settings Actions           | Read-Only | Member | Maintainer | Administrator | Owner |
| -------------------------- | --------- | ------ | ---------- | ------------- | ----- |
| View settings              | Y         | Y      | Y          | Y             | Y     |
| Add/Update/Delete settings | N         | N      | N          | Y             | Y     |
| **Origin Secrets Actions** |           |        |            |               |       |
| View secrets               | N         | N      | Y          | Y             | Y     |
| Add/Update/Delete secrets  | N         | N      | N          | Y             | Y     |

![The administrator or owner's view of the origin settings tab with a public default package setting and a saved origin secret](/images/habitat/origin-secrets.png)

## Default package settings

The _Default Package Settings_ define the visibility of build artifacts (.hart files). Everyone with origin membership can view the origin settings, but only origin administrators and owners can add, update, or delete settings.

* Public packages are visible in search results and can be used by every Chef Habitat Builder user
* Private artifacts don't appear in search results and are available only to users with origin membership

Change the default setting for an origin by switching from **Public Packages** to **Private Packages**. The default setting is required for each origin. Packages can have different default visibility settings than the origin to which they belong. You can change the default visibility setting for an individual package in the package setting tab (Builder > Origin > Package > Settings).
