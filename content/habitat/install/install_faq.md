+++
title = "Installation FAQ"
description = "Frequently asked questions about downloading and installing Chef Habitat"
draft = false

[menu.install]
    title = "Installation FAQ"
    identifier = "install/install-faq"
    parent = "install"
    weight = 30
+++

This section covers frequently asked questions about downloading and installing the `hab` CLI.

## General Questions

**Q: Can I just download a GitHub release of Chef Habitat?**

A: While we do publish releases on GitHub as part of our release process, those archives contain source code that requires compilation. Since the `hab` CLI is written in Rust, you would need to compile the source for your platform. We recommend using our pre-compiled packages instead.

**Q: Are there native packages for my operating system?**

A: Yes! We publish compiled packages for Linux, macOS, and Windows.

## Installation Methods

**Q: What installation methods are available?**

A: We provide several installation options:

- **Linux**: curl/bash script, manual download, package managers (coming soon)
- **macOS**: Homebrew, curl/bash script, manual download
- **Windows**: Chocolatey, PowerShell script, manual download

**Q: How do I install a specific version of `hab`?**

A: You can specify a version with the installation scripts:

```shell
# Linux/macOS
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh \
    | sudo bash -s -- -v 1.6.1245

# Windows PowerShell
iex "& { $(irm https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.ps1) } -Version 1.6.1245"
```

**Q: Are curl/bash installation scripts safe?**

A: We understand curl/bash scripts can be controversial. For transparency, you can review our installation scripts before running them:

- [Linux/macOS script](https://github.com/habitat-sh/habitat/blob/main/components/hab/install.sh)
- [Windows script](https://github.com/habitat-sh/habitat/blob/main/components/hab/install.ps1)

If you prefer not to use these scripts, you can download packages directly from our [downloads page](/habitat/install/).

## Enterprise and Fleet Installation

**Q: How do I install `hab` across my server fleet?**

\A: For enterprise deployments, consider these approaches:

1. **Configuration management**: Use your existing tools (Ansible, Chef 360, Chef Infra, Puppet, etc.) with our installation scripts
2. **Container images**: If your applications are containerized with Chef Habitat, the `hab` CLI is included in the container
3. **Custom packaging**: Create custom packages for your organization's package management system

**Q: Do you support air-gapped environments?**

A: Yes, you can download packages for offline installation:

1. Download the appropriate package from [our downloads page](https://www.chef.io/downloads)
2. Transfer to your air-gapped environment
3. Install manually following the platform-specific instructions

## Platform Integrations

**Q: Does Chef Habitat work with container orchestrators?**

A: Chef Habitat can be used with Kubernetes. See our [Kubernetes documentation](/habitat/containers/kubernetes/) for more information.

## Troubleshooting

**Q: What if installation fails?**

A: Common solutions:

1. Check system requirements
2. Verify internet connectivity
3. Run with elevated privileges if needed
4. Check our [troubleshooting guide](/habitat/install/troubleshooting/)

**Q: How do I verify my installation?**

A: After installation, verify with:

```bash
hab --version
hab cli setup --help
```

## Getting Help

Still have questions? Here are your options:

- [Chef Habitat documentation](/)
- [Community forum](https://discourse.chef.io/c/habitat/12)
- [GitHub issues](https://github.com/habitat-sh/habitat/issues)
- [Chef Support](https://www.chef.io/support) (for support customers)
