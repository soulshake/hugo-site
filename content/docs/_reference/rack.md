---
title: "Add an existing Rack"
---

## "Import" a Rack from another account

Sharing a Rack is possible whether it's associated with a personal or organization account.

### Personal account

If a Rack is installed into your `personal` organization, you can share the Rack's API key.


how do i "import" my existing rack `personal/legit` to my newly-upgraded `squirrel` org? i added the rack via console, but now when i run `convox apps i get:

$ convox apps
ERROR: response status: 401

aj@patamushka ~/git/blog.soulshake.net on master [?] [personal/legit] 
$ cat .convox/rack 
personal/legit


$ echo "squirrels/legit" > .convox/rack 

aj@patamushka ~/git/blog.soulshake.net on master [?] [squirrels/legit] 
$ convox apps
APP                 STATUS
blog-soulshake-net  running
cv-soulshake-net    running
flask               running



Set the Rack API key
Find the Rack hostname

Add existing rack in console

wait a while (because in the meantime you'll get 401s)

