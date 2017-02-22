#!/bin/bash

../09-resource/init.sh

cat <<EOF | patch docker-compose.yml 
5a6,9
>     environment:
>      - REDIS_URL
>     links:
>      - redis
12a17,19
>       - REDIS_URL
>     links:
>       - redis
14a22,23
>     ports:
>       - 6379
EOF
