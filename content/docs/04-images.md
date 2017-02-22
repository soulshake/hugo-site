---
title: Images
permalink: /guide/images/
phase: build
---

An _image_ is an immutable package containing your app and all of its dependencies, down to the operating system.

Using an image enables you to run your app predictably on any computer, from your laptop to the cloud.

An image is built from instructions in the `Dockerfile` and `.dockerignore` files.

A Dockerfile starts from a base image and includes the steps necessary to build your app.

The following Dockerfile defines an image for a simple Node.js app:

<pre class="file dockerfile" title="Dockerfile">
# start from a base image
FROM ubuntu:16.04

# install system dependencies
RUN apt-get update && \
  apt-get install -y nodejs npm && \
  update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# specify the app location
WORKDIR /app

# install app dependencies
COPY package.json /app/package.json
RUN npm install

# add app source code
COPY . /app
</pre>

There is a companion `.dockerignore` file for things you never want to copy into the image. For now, you want to ignore the `.git` directory to reduce the image size and to avoid including sensitive source code history.

<pre class="file dockerignore" title=".dockerignore">
.git
</pre>

Your image needs to include app dependencies. You want to use a language-specific package configuration file to specify these. For a simple Node.js app this is an [npm](https://www.npmjs.com/) `package.json` file with a list of packages like `redis`:

<pre class="file package.json" title="package.json">
{
  "name": "myapp",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "redis": "^2.6.2"
  },
  "devDependencies": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "description": ""
}
</pre>

Write a `Dockerfile` that follows these steps:

* specifies an operating system and installs needed system packages,
* copies the app package config file and runs the app package installation tool, and
* copies the entire codebase directory into the image app directory.

Finally, create a `.dockerignore` file that omits files and directories that don't need to be in the image.

Now run `convox doctor` to build and validate your first image:

<pre class="terminal">
<span class="command">convox doctor</span>

### Build: Image

[<span class="pass">✓</span>] Dockerfiles found
[<span class="pass">✓</span>] .git in .dockerignore
[<span class="pass">✓</span>] Large files in .dockerignore
[<span class="pass">✓</span>] Image builds successfully
</pre>

In our example, the last check may take a few minutes to pull the Ubuntu base image from Docker Hub, install system packages from Ubuntu and app dependencies from npm. Subsequent image builds will be much faster.

Now that you have a portable image, you can [configure services to use it](/guide/services/).

{% include_relative _includes/next.html
  next="Configure services"
  next_url="/guide/services"
%}

