#!/bin/bash

../08-balancer/init.sh

cat <<EOF | patch docker-compose.yml 
12a13,14
>   redis:
>     image: convox/redis
EOF

cat >redis-client.js <<'EOF'
var redis = require("redis");

module.exports = redis.createClient({
  retry_strategy: function(options) {
    console.log("redis client retry with backoff");

    if (options.total_retry_time > 1000 * 60 * 60) {
      return new Error("Retry time exhausted");
    }

    return Math.max(options.attempt * 100, 3000);  
  },
  url: process.env.REDIS_URL
});
EOF

cat <<EOF | patch web.js
2d1
< var redis = require("redis");
4c3
< var client = redis.createClient(process.env.REDIS_URL);
---
> var client = require("./redis-client.js");
EOF

cat <<EOF | patch worker.js
1,3c1
< var redis = require("redis");
< 
< var client = redis.createClient(process.env.REDIS_URL);
---
> var client = require("./redis-client.js")
EOF