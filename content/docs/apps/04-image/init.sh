#!/bin/bash

cat >Dockerfile <<'EOF'
# start from a base Image
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
EOF

cat >.dockerignore <<EOF
.git
EOF

cat >package.json <<'EOF'
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
EOF