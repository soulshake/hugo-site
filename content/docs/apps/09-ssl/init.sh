#!/bin/bash

../06-environment/init.sh

cat <<EOF | patch docker-compose.yml
5a6,7
>     ports:
>      - 80:8000
EOF
