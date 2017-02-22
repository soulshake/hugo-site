---
title: Introduction
permalink: /guide/heroku/
---

Heroku and Convox are both Platforms-as-a-Service designed around [The Twelve-Factor App methodologies](https://12factor.net/).

Convox is open-source and built entirely on AWS cloud services. It enables you to deploy your apps to your own AWS account for maximum control. Depending on your application and engineering team, migrating an app to Convox could unlock security, reliability, performance, cost and/or operational improvements.

Many parts of the Heroku platform map directly to Convox:

<table>
  <thead>
    <tr>
      <th></th>
      <th>Heroku</th>
      <th>Convox</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Codebase</td>
      <td>Git Repo</td>
      <td>Git Repo</td>
    </tr>
    <tr>
      <td>Config</td>
      <td>
        <pre>$ heroku config</pre>
      </td>
      <td>
        <pre>$ convox env</pre>
      </td>
    </tr>
    <tr>
      <td>Build / Release / Run</td>
      <td>
        <pre>$ git push heroku master</pre>
        <pre>$ heroku releases</pre>
      </td>
      <td>
        <pre>$ convox deploy</pre>
        <pre>$ convox releases</pre>
      </td>
    </tr>
    <tr>
      <td>Processes</td>
      <td>
        <pre>$ heroku ps</pre>
      </td>
      <td>
        <pre>$ convox ps</pre>
      </td>
    </tr>
    <tr>
      <td>Concurrency</td>
      <td>
        <pre>$ heroku scale</pre>
      </td>
      <td>
        <pre>$ convox scale</pre>
      </td>
    </tr>
    <tr>
      <td>Databases</td>
      <td>
        <pre>$ heroku addons</pre>
      </td>
      <td>
        <pre>$ convox resources</pre>
      </td>
    </tr>
    <tr>
      <td>Logs</td>
      <td>
        <pre>$ heroku logs</pre>
      </td>
      <td>
        <pre>$ convox logs</pre>
      </td>
    </tr>
    <tr>
      <td>Admin Processes</td>
      <td>
        <pre>$ heroku run</pre>
      </td>
      <td>
        <pre>$ convox run</pre>
        <pre>$ convox exec</pre>
      </td>
    </tr>
  </tbody>
</table>

Other parts are similar, but represent more significant changes to your apps:

<table>
  <thead>
    <tr>
      <th></th>
      <th>Heroku</th>
      <th>Convox</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Dependencies</td>
      <td>
        <div>Cedar Stack Image</div>
        <div>Buildpacks</div>
      </td>
      <td>
        <div>Docker Base Image</div>
        <div>Dockerfile</div>
      </td>
    </tr>
    <tr>
      <td>Manifest</td>
      <td>
        <div>Procfile</div>
      </td>
      <td>
        <div>docker-compose.yml</div>
      </td>
    </tr>
    <tr>
      <td>Ports</td>
      <td>
        <div>Port Assignment</div>
        <div>$PORT environment variable</div>
      </td>
      <td>
        <div>Port Mapping</div>
        <pre>ports:
  - 80:8000
</pre>
      </td>
    </tr>
    <tr>
      <td>Development</td>
      <td>
        <pre>$ heroku local</pre>
        <div>Homebrew</div>
      </td>
      <td>
        <pre>$ convox start</pre>
        <div>Docker</div>
      </td>
    </tr>
    <tr>
      <td>Production</td>
      <td>
        <div>Cedar Stack Image</div>
        <div>PaaS</div>
      </td>
      <td>
        <div>Docker Base Image</div>
        <div>IaaS / AWS</div>
      </td>
    </tr>
  </tbody>
</table>

This guide explains the differences of the platforms, and walks you through the steps required to migrate an app.

## Prerequisites

Let's start with a simple Python and Postgres Heroku app. The codebase is in a GitHub repo.

<pre class="terminal">
# clone source code and deploy to Heroku

<span class="command">git clone https://github.com/heroku/python-getting-started.git</span>
<span class="command">cd python-getting-started-getting-started</span>

<span class="command">heroku create</span>
Creating app... done, ⬢ pure-basin-53177
https://pure-basin-53177.herokuapp.com/ | https://git.heroku.com/pure-basin-53177.git

<span class="command">git push heroku master</span>
remote: Building source:
remote: 
remote: -----> Python app detected
remote: -----> Installing python-2.7.12
remote:      $ pip install -r requirements.txt
remote:      $ python manage.py collectstatic --noinput
remote: -----> Discovering process types
remote:        Procfile declares types -> web
remote: -----> Launching...
remote:        Released v4
remote:        https://pure-basin-53177.herokuapp.com/ deployed to Heroku
remote: 
remote: Verifying deploy... done.
To https://git.heroku.com/pure-basin-53177.git
 * [new branch]      master -> master

# run database migrations

<span class="command">heroku run python manage.py migrate</span>
Running python manage.py migrate on ⬢ pure-basin-53177... up, run.3384 (Free)
Operations to perform:
  Apply all migrations: sessions, hello, contenttypes, auth, admin
Running migrations:
  Rendering model states... DONE
  Applying contenttypes.0001_initial... OK
  ...
</pre>

Next, let's start with an empty Convox app:

<pre class="terminal">
<span class="command">convox apps create</span>
Creating app python-getting-started... CREATING
</pre>

If you don't have Convox set up in your AWS account, refer to the [Getting Started](http://localhost/docs/getting-started/) doc.

## Dependencies

<table class="vs">
  <thead>
    <tr>
      <th>Heroku</th>
      <th>Convox</th>
    </tr>
  </thead>
  <tr>
    <td>
      Heroku uses <b>buildpacks</b> to package application code and dependencies into a <b>slug</b>.
    </td>
    <td>
      Convox uses <b>Dockerfiles</b> to package an app into <b>images</b>.
    </td>
  </tr>
</table>

First we have to add a `Dockerfile` to our Heroku app.

We prefer to write a Dockerfile from scratch that builds the application. This will result in a build recipe that is simple to understand and modify over the life of our application.

For some apps this is straightforward. On the example app we can change to a modern Linux operating system, install the build dependencies with standard tooling, and run standard build steps in a few lines of code and no changes to the app.

<pre class="file dockerfile" title="Dockerfile">
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y libpq-dev python python-pip

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt --disable-pip-version-check

COPY . ./app
</pre>

<pre class="terminal">
<span class="command">docker build .</span>
Sending build context to Docker daemon 184.8 kB
Step 1 : FROM ubuntu:16.04
Step 2 : RUN apt-get update && apt-get install -y libpq-dev python python-pip
Step 3 : WORKDIR /app
Step 4 : COPY requirements.txt /app/requirements.txt
Step 5 : RUN pip install -r requirements.txt --disable-pip-version-check
Step 6 : COPY . /app
Successfully built 21389aff49d2
</pre>

For other apps this could be hard due to the specifics of the Heroku runtime, assumptions in the buildpacks and nuances of Docker tooling. See the [Building a Heroku App with Docker](/guide/heroku/docker/) guide for ways to better emulate Heroku.

## Manifest (service definitions)

<table class="vs">
  <thead>
    <tr>
      <th>Heroku</th>
      <th>Convox</th>
    </tr>
  </thead>
  <tr>
    <td>
      Heroku uses a <b>Procfile</b> to define process types and commands.
    </td>
    <td>
      Convox uses a <b>docker-compose.yml file</b> to define service types and commands.
    </td>
  </tr>
</table>

Next we have to add a `docker-compose.yml` file to our Convox app. Every process type and command in `Procfile` is added as a service and command to `docker-compose.yml`.

<pre class="file yaml" title="docker-compose.yml">
version: 2
services:
  web:
    build: .
    command: gunicorn gettingstarted.wsgi --log-file -
</pre>

## Ports

<table class="vs">
  <thead>
    <tr>
      <th>Heroku</th>
      <th>Convox</th>
    </tr>
  </thead>
  <tr>
    <td>
      Heroku uses a single <b>port assignment</b> and sets a <p>$PORT environment variable</p> that your app must bind to.
    </td>
    <td>
      Convox uses multiple <b>port mappings</b> that your app must bind to.
    </td>
  </tr>
</table>

Next we have to add port mapping to our Convox app.

<pre class="file yaml" title="docker-compose.yml">
<span class="diff-u">version: 2</span>
<span class="diff-u">services:</span>
<span class="diff-u">  web:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: gunicorn gettingstarted.wsgi --log-file -</span>
<span class="diff-a">    ports:</span>
<span class="diff-a">      - 80:8000</span>
</pre>

Convox uses virtual networking which allows every process to bind to whatever port(s) it wants. So we add a port mapping that says we want public-facing port `80` to map to the `gunicorn` server's port `8000`.

See the [Port Mapping](/docs/port-mapping/) doc for more information.

## Deploying

Now our app can be deployed to Convox:

<pre class="terminal">
<span class="command">convox deploy</span>
Deploying python-getting-started
Creating tarball... OK
Uploading: 70.30 KB / 70.12 KB [=========================] 100.25 % 0s

Starting build... OK
running: docker build
Sending build context to Docker daemon 184.8 kB
Step 1 : FROM ubuntu:16.04
...
Successfully built b0acccdaa320

running: docker tag 
running: docker push 
web.BLEWKYOZMOV: digest: sha256:514ad420 size: 7865

Promoting RQZVCPKHSIT... OK

<span class="command">convox apps info</span>
Name       python-getting-started
Status     running
Release    RQZVCPKHSIT
Processes  web
Endpoints  python-w-OMR6OMC-1706078211.us-east-1.elb.amazonaws.com:80 (web)
</pre>

Sure enough, our app is available at the endpoint.

## Databases

<table class="vs">
  <thead>
    <tr>
      <th>Heroku</th>
      <th>Convox</th>
    </tr>
  </thead>
  <tr>
    <td>
      Heroku uses <b>addons</b> to provision database services, and sets app <b>config</b> with service connection information.
    </td>
    <td>
      Convox uses <b><a href="/docs/about-resources/">resources</a></b> to provision database services, and sets app <b><a href="/docs/environment/">environment</a></b> with service connection information.
    </td>
  </tr>
</table>

The final step is to add a database to our Convox app. There are two strategies.

#### Reuse Heroku Addons

Both Heroku and Convox run in the AWS cloud. As long as the Heroku addons and Convox app are in the same region, access between them is fast. So the simplest strategy is to connect the Convox app to the Heroku addons by copying over the config.

<pre class="terminal">
# copy Heroku config to Convox app environment

<span class="command">heroku config -s | convox env set</span>
Updating environment... OK
To deploy these changes run `convox releases promote RWGFPGSELVA`

<span class="command">convox releases promote RWGFPGSELVA</span>
Promoting RWGFPGSELVA... OK

# verify the Convox environment, database connection and data

<span class="command">convox run web python manage.py migrate</span>
Running migrations:
  No migrations to apply.
</pre>

#### Migrate Data

The other strategy is to create new databases and migrate data. This has the security advantage of moving your database and data into a VPC that is not acessable to anything but your Convox app.

To do this, we will backup the Heroku database, and restore it into a new, private Postgres database.

<pre class="terminal">
# create the Convox resource and open a local proxy

<span class="command">convox resources create postgres</span>
Creating postgres-2098 (postgres)... CREATING

<span class="command">convox resources proxy postgres-2098</span>
proxying 127.0.0.1:5432 to dev-east-postgres-2098.cyzckls48pd3.us-east-1.rds.amazonaws.com:5432

# stop writing data and capture a backup

<span class="command">heroku maintenance:on</span>

<span class="command">heroku pg:backups:capture</span>
Backing up DATABASE to b001... done

<span class="command">heroku pg:backups:download</span>
Getting backup from ⬢ pure-basin-53177... done, #1
Downloading latest.dump...

# restore the Convox database from the backup

<span class="command">pg_restore -Ov -d app -h localhost -n public -U postgres latest.dump</span>
pg_restore: connecting to database for restore
Password: 
pg_restore: creating TABLE "public.auth_group"
pg_restore: creating SEQUENCE "public.auth_group_id_seq"
...
</pre>

### Next Steps

Our first deploy to Convox is just the beginning. From here you can explore:

* [Developing the app with `convox start`](https://convox.com/docs/running-locally/)
* [Configuring HTTPS, TCP and private load balancing](https://convox.com/docs/load-balancers/)
* [Attaching to a running container](https://convox.com/docs/one-off-commands/)
* [SSHing to an instance](https://convox.com/docs/debugging/)
* [Automating builds, tests and releases](https://convox.com/docs/workflows/)
