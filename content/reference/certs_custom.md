+++
title = "Custom certificates"
description = "Handling custom (CA) certificates"


[menu.reference]
    title = "Custom certificates"
    identifier = "reference/certs-custom Custom Certs"
    parent = "reference"
+++

Many enterprise environments use custom certificates, such as self-signed certificates. For example, an on-premises Chef Habitat Builder Depot might use a self-signed SSL certificate.

Attempting to perform an operation using the Habitat client to communicate with a service that has a custom certificate can produce an error, such as:

```output
✗✗✗
✗✗✗ the handshake failed: The OpenSSL library reported an error: error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed:s3_clnt.c:1269:: unable to get local issuer certificate
✗✗✗
```

One way to fix this error is to define an `SSL_CERT_FILE` environment variable that points to the custom certificate path before you run the client operation.

Chef Habitat also looks for custom certificates in the `~/.hab/cache/ssl` directory, which is `/hab/cache/ssl` when you run as root.
Copying multiple certificates---for example, a self-signed certificate and a custom certificate authority certificate---to the Chef Habitat cache directory makes them automatically available to the Habitat client.

The `/hab/cache/ssl` directory is also available inside a Habitat Studio. As long as the certificates are in the cache directory before you enter the Studio, you'll also find them inside the Studio. In addition, if you've set the `SSL_CERT_FILE` environment variable, you'll also find both the variable and the file it points to in the Studio `/hab/cache/ssl` directory.

**Note:** The `cert.pem` file name is reserved for Habitat. Don't use `cert.pem` as a file name when copying certificates into the cache directory.
