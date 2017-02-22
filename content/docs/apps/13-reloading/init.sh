#!/bin/bash

../10-link/init.sh

mkdir -p bin

cat >bin/web <<'EOF'
#!/bin/bash

if [ "$NODE_ENV" == "development" ]; then
  $(npm bin)/nodemon web.js "$@"
else
  node web.js "$@"
fi
EOF

cat >bin/worker <<'EOF'
#!/bin/bash

if [ "$NODE_ENV" == "development" ]; then
  $(npm bin)/nodemon worker.js "$@"
else
  node worker.js "$@"
fi
EOF

chmod +x bin/web bin/worker


cat <<EOF | patch package.json
5a6
>     "nodemon": "^1.11.0",
EOF

cat <<EOF | patch docker-compose.yml
5c5
<     command: ["node", "web.js"]
---
>     command: ["bin/web"]
6a7
>      - NODE_ENV=development
14c15
<     command: ["node", "worker.js"]
---
>     command: ["bin/worker"]
16a18
>       - NODE_ENV=development
EOF
