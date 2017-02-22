---
title: "Port Mapping"
order: 700
---

You can define the ports on which your processes will listen in the manifest for your application.

## External Ports

External ports are open to the Internet. You define an external port using a port pair in the `ports:` section of your `docker-compose.yml`:

    ports:
      - 80:5000
      
This example configuration would listen to port `80` on an Internet-accessible load balancer and forward connections to port `5000` on the Process.

## Internal Ports

Internal ports are only accessible to other apps and services on the same Rack. You define an internal port using a single port in the `ports:` section of your `docker-compose.yml`:

    ports:
      - 5000
      
This example configuration would listen to port `5000` on an internal-only load balancer and forward connections to port `5000` on the Process.

If you want to make all of an application's ports internal, regardless of port definition, you can set the Internal app parameter.

    $ convox apps params set Internal=Yes

## See also

- [Load balancers](/docs/load-balancers)
