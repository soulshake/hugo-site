FROM golang:1.8rc3-alpine
MAINTAINER AJ Bowen <aj@soulshake.net>

ENV HUGO_VERSION=0.18

RUN apk add --update \
    ca-certificates \
    git \
    wget \
    && wget --no-check-certificate https://github.com/spf13/hugo/releases/download/v0.18/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && mv hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/bin/hugo \
    && rm -r hugo_${HUGO_VERSION}_linux_amd64 \
    && apk del wget ca-certificates \
    && rm /var/cache/apk/*

RUN go get github.com/convox/rerun

# need a real pid 1 for signal handling, zombie reaping, etc
ADD http://convox-binaries.s3.amazonaws.com/tini-static /tini
RUN chmod +x /tini

# build the site
COPY . /src
WORKDIR /src

EXPOSE 1313
ENTRYPOINT ["/tini", "--"]

CMD ["bin/web"]
