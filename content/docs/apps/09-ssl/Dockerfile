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
