+++
title = "Keys"
description = "Chef Habitat security"


[menu.reference]
    title = "Keys"
    identifier = "reference/keys"
    parent = "reference"

+++

Chef Habitat includes strong cryptography in Chef Habitat Builder, the Supervisor, and the `hab` CLI. This means there are several different kinds of keys.

## Origin key pairs

Every Chef Habitat artifact belongs to an [origin](pkg_ids) and is cryptographically signed with that origin's private key. Chef Habitat requires the private key to produce artifacts, and it requires the public key to verify artifacts before installation. If the key is present on Builder, Chef Habitat automatically downloads the public key for an origin when necessary.

Origin key cryptography is asymmetric: it includes a public key you can distribute freely, and a private key you should keep safe.

Chef Habitat uses the public origin key to verify the integrity of downloaded artifacts before installing them.
Chef Habitat only installs artifacts for which it has the public origin key.

You can provide a public origin key to Chef Habitat by pointing it to a Builder site that has the origin key with the `--url` argument to `hab pkg install`, or by using the `hab origin key import` command.
Use `hab origin key upload` to upload origin keys to Builder.
Use `hab origin key download` to download your origin keys from Builder to your environment.
Use `hab origin key import` to read the key from standard input or a local file:

```bash
hab origin key import <enter or paste key>
hab origin key import < <PATH_TO_KEY>
curl <URL_THAT_RETURNS_KEY> | hab origin key import
```

See the [hab origin key](habitat_cli/#hab-origin-key) command documentation for more information on working with origin keys from the command line.

## User and service group keys

User and service group keys are used to set up trust relationships between these two entities. Service groups can be set up to reject communication (for example, applying new configuration with `hab config apply`) from untrusted users.

By default, service groups trust *any* communication, so setting up these relationships is essential for a production deployment of Chef Habitat.

User and service group keys also use asymmetric cryptography. To apply configuration changes to service groups when running in this mode, a user uses their private key to encrypt configuration information for a service group with that service group's public key. The service group then uses its private key to decrypt the configuration information, and the user's public key to verify it.

## Ring encryption key

A Supervisor network can optionally be set up to encrypt *all* supervisor-to-supervisor communication.
This requires the use of a symmetric, pre-shared key.
