---
title: "SSL"
order: 900
---

You can easily secure traffic to your application using TLS (SSL).

## Add a Secure Port to Your Manifest

Edit your app's `docker-compose.yml` file to create a port mapping for your secure traffic. For most web applications this will be port 443, the standard for HTTPS.

You'll also need to set the protocol for the port using the `convox.port.<port>.protocol` label. Use `https` as the value if you want to get HTTP headers and don't need to support websockets. Otherwise use `tls`. For example:

    web:
      labels:
        - convox.port.443.protocol=https
      ports:
        - 80:3000
        - 443:3000

When you're done editing, redeploy your application.

    $ convox deploy

Your app is now configured to serve encrypted traffic with a self-signed certificate on port 443. To use a real certificate, you will need to acquire an SSL Certificate and apply it to your SSL endpoint. See the following sections for more information.

## Acquire an SSL Certificate

### Generate a Certificate

You can request an SSL certificate for any domain you control using `convox certs generate`:

    $ convox certs generate foo.example.org
    Requesting certificate... OK, acm-01234567890

A confirmation email will be sent to addresses associated with the domain's WHOIS record. Click the link in the confirmation email to activate your certificate. These certificates, generated by Amazon Certificate Manager, are free and auto-renewing.

<div class="block-callout block-show-callout type-info" markdown="1">
Certificate generation is currently [only available in certain regions](http://docs.aws.amazon.com/acm/latest/userguide/acm-regions.html).
</div>

### Purchase a Certificate

You can also purchase an SSL certificate from most registrars and DNS providers. Convox is a fan of [Gandi](https://www.gandi.net/ssl).

Upload your certificate and private key using `convox certs create`:

    $ convox certs create example.org.pub example.org.key
    Uploading certificate... OK, cert-1234567890

### Apply the Certificate

You can then apply a certificate to your load balancer with `convox ssl update`:

    $ convox ssl update web:443 cert-1234567890
    Updating certificate... OK

### Inspect SSL Configuration

You can use the Convox CLI to view SSL configuration for an app.

    $ convox ssl
    TARGET   CERTIFICATE       DOMAIN       EXPIRES
    web:443  cert-1234567890   example.org  2 months from now

## Managing Certificates

The Convox CLI includes commands that let you list, update, and remove SSL certificates.

### Listing Certificates

You can see the certificates associated with your account with `convox certs`:

    $ convox certs
    ID               DOMAIN       EXPIRES
    cert-1234567890  example.org  2 months ago
    cert-0987654321  example.org  2 months from now

### Updating Your SSL Certificate

When it's time to update your SSL certificate, upload your new certificate and use `convox ssl update` again:

    $ convox certs create example.org.pub example.org.key
    Uploading certificate... OK, cert-0987654321

    $ convox ssl update web:443 certs-0987654321
    Updating certificate... OK

### Removing Old Certificates

You can remove old certificates that you are no longer using.

    $ convox certs delete cert-1234567890
    Removing certificate... OK
