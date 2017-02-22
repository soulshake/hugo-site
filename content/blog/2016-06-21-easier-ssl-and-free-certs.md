---
author: Matt Manning
date: 2016-06-21T00:00:00Z
title: Easy SSL and Free Certificates
twitter: mattmanning
url: /2016/06/21/easier-ssl-and-free-certs/
---

We’ve streamlined our SSL configuration and integrated with [Amazon Certificate Manager](https://aws.amazon.com/certificate-manager/) to bring easy, free SSL to everyone. You can generate a free SSL certificate with a single Convox command:

    $ convox certs generate *.mydomain.com
    Requesting certificate... OK, acm-bea0ac39a538

<!--more-->

Once the certificate is generated you’ll need to approve it. Amazon sends approval emails to the domain owner, technical contact, and administrative contact based on WHOIS records. They also send to the following addresses:

* administrator@mydomain.com
* hostmaster@mydomain.com
* postmaster@mydomain.com
* webmaster@mydomain.com
* admin@mydomain.com

As long as at least one of these addresses is deliverable, you’re good to go. Follow the link from the email to your AWS account and click the **I Approve** button.

Once the certificate is approved it’s ready to use. You can add it to a secure endpoint on your app with one more command:

    $ convox ssl update web:443 acm-bea0ac39a538

Easy, right?

Check out our [technical docs on SSL](https://convox.com/docs/ssl) for more info and a full description of how to set up secure endpoints.
