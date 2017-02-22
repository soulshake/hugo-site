---
title: "Access Control"
---

Once you've created an organization, you'll find extra settings on the "Organization" pane in the Convox Console, allowing you to define access controls for your Convox resources. There, you'll find three sections: Settings, Users and Deploy Keys.

## Organization Settings

Here you can modify the organization name or delete the organization entirely.

## Users (Organization Members)

On this page you can manage which members have access to your team and Racks.

![Convox/Organization/Users](/assets/images/docs/rbac/users.png){: .screenshot }

On the <b>Pro</b> plan and above, you can configure individual access levels for each of the users you've added:

- **Administrator**: Full control of the Organization. Can add and remove other Members and manage their access levels.
* **Operator**: Can manage the organization and integrations, but not users and invites.
- **Developer**: Can create, update, and delete applications.

![Organization Members](/assets/images/docs/rbac/rbac.png){: .screenshot }


You can invite team members to your organization, which will give them each a unique API Key with access to all the org's Racks.

## Deploy Keys

Deploy keys are special, limited scope API keys that allow you to run the `build` and `deploy` commands from remote servers for the purposes of CI.

You should give a Deploy Key to a CI service like CircleCI or Travis CI so it can deploy code but not access or modify any other Rack resources.

![Deploy Keys](/assets/images/docs/rbac/deploy-keys.png){: .screenshot }
