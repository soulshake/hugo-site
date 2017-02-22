#!/bin/bash

../05-service/init.sh

cat <<EOF | patch docker-compose.yml 
8a9,10
>     environment:
>       - GITHUB_API_TOKEN
EOF

cat >.env <<EOF
GITHUB_API_TOKEN=e855b323a2c89d09dee5a2c719041851a71b6606
EOF

cat >>.dockerignore <<EOF
.env
EOF

cat >.gitignore <<EOF
.env
EOF
