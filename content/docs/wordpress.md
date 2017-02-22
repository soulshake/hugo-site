---
title: "WordPress"
---

[WordPress](https://wordpress.org/) is a popular blogging platform based on PHP and MySQL. It's simple to set up a WordPress blog on Convox with the following steps.

## Create the App and Database

```
$ convox apps create wordpress-site
$ convox resources create mysql --name wordpress-db
```

## Create the Local Files

```
$ mkdir wordpress-site && cd wordpress-site
```

Inside the `wordpress-site` directory, create a `docker-compose.yml` file with the following contents:

```
web:
  image: wordpress:4.5.3-apache
  labels:
    - convox.port.443.protocol=https
  ports:
    - 80:80
    - 443:80
  volumes:
    - /var/www/html
```

The [official WordPress image from Docker Hub](https://hub.docker.com/_/wordpress/) will be used in your app.

The `volumes` directive will persist all of your WordPress files to a [network filesystem associated with your Rack](/docs/volumes). This means your themes, plugins, and uploaded media will not be lost on restarts, and can be shared between containers, supporting scaling.

## Attach the Database to the App

The database creation that you kicked off above will take 10-15 minutes to complete. You can check status with:

```
$ convox resources
```

Once the status is `RUNNING` fetch the DB info:

```
$ convox resources info wordpress-db
Name    wordpress-db
Status  running
Exports
  URL: mysql://app:EXWKHJKDZTBQIPGUMEKGSNTRYGAYAC@convox-dev-wordpress-db.cbm4183bzjrr.us-east-1.rds.amazonaws.com:3306/app
```

Reference the URL output to set the necessary database environment variables on the app:

```
$ convox env set WORDPRESS_DB_USER=app WORDPRESS_DB_NAME=app \
WORDPRESS_DB_HOST=convox-dev-wordpress-db.cbm4183bzjrr.us-east-1.rds.amazonaws.com:3306 \
WORDPRESS_DB_PASSWORD=EXWKHJKDZTBQIPGUMEKGSNTRYGAYAC
```

## Deploy the App

```
$ convox deploy
```

## Run the WordPress Web Installer

Fetch the app URL:

```
$ convox apps info -a wordpress-site
Name       wordpress-site
Status     running
Release    RKOHYAOPRST
Processes  web wordpress-db
Endpoints  wordpress-site-web-OXGXLU7-1245013691.us-east-1.elb.amazonaws.com:80 (web)
           :3306 (wordpress-db)
```

Visit the port 80 URL in your browser, and go through WordPress web installer.

## Custom Domain

See the [Custom Domains](/docs/custom-domains) doc for instructions on setting up a domain for your WordPress site.

## SSL

The `docker-compose.yml` file above configures port 443 for secure traffic. To enable SSL on your site follow the instructions in the [SSL](/docs/ssl) doc to upload or generate an SSL certificate.

Then log into the Wordpress admin interface and click **Settings -> General**.

Set **WordPress Address (URL)** and **Site Address (URL)** to https://www.yourdomain.com.
