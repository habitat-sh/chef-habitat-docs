A plan is the set of instructions, templates, and configuration files that define how you download, configure, make, install, and manage the lifecycle of the application artifact. The plan is defined in the `habitat` directory at the root of your project repository.

The `habitat` directory includes:

- a plan file (`plan.sh` for Linux systems or `plan.ps1` for Windows)
- a `default.toml` file defining configuration settings used to render configuration templates
- an optional `config` directory for configuration templates
- an optional `hooks` directory for lifecycle hooks

You can create this directory at the root of your application with the `hab plan init` command.
