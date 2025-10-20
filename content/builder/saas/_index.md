+++
title = "SaaS Builder"
description = "Chef Habitat Builder is Chef's Application Delivery Enterprise hub"
linkTitle = "SaaS Builder"

[menu.builder]
    title = "SaaS Builder"
    parent = "builder"
    identifier = "builder/saas/SaaS Builder"
    weight = 10
+++

Chef Habitat Builder is the core of Chef's Application Delivery Enterprise hub. Chef Habitat Builder can be used as either a cloud-based or an on-premises solution.
Cloud-based SaaS Chef Habitat Builder is used to host core packages belonging to [Chef owned origins](path-to-chef-owned-origins). [Chef Habitat On-Prem Builder](https://docs.chef.io/habitat/on_prem_builder/) can be used to host the packages belonging to user owned origins.

{{< note >}}
When this document is merged with the new menu structure, this should be part of "About Chef Habitat Builder" and not necessarily SaaS Builder documentation.
{{< /note >}}

## Chef Habitat Builder components

- **Application Manifest**: The application manifest provides a single application directory, which includes, at a minimum, the compiled app artifact, dynamic links to all direct and transitive runtime dependencies, and instructions to install and run the app.
- **Deployment Channel Management**: Pre-canned deployment channels that you can use as-is or customize. Apps deployed through Chef Habitat can subscribe to a channel and be upgraded automatically whenever the app is promoted.
- **Content Library**: Hundreds of pre-built [application delivery packages](https://bldr.habitat.sh/#/pkgs/core) and core dependencies make it easy to get started with Chef Habitat.
- **Custom Data and Reporting APIs**: Rich APIs enable exporting data to CSV or JSON.
- **DevOps Integration APIs**: APIs allow clients to find and download the necessary packages to run their applications. Additional APIs enable integration with popular DevOps tools, including Jenkins, Terraform, Artifactory, Hashi Vault, and others.
- **Role-Based User Access**: Improves your organization's operational safety by letting you assign specific levels of access to each origin member.

For more information about how the SaaS and on-premises versions of Chef Habitat Builder work together, read the blog: [Chef Habitat Builder On-Prem Enhancements that Extend Support to Airgap Environments and Simplify Set-Up](https://www.chef.io/blog/chef-habitat-product-announcement-builder-on-prem-enhancements-that-extend-support-to-airgap-environments-and-simplify-set-up).
