---
title: "Integrations"
---

Convox Console can integrate with GitLab and GitHub to capture source code management events and with Slack for notifications.

To enable these integrations, click the Enable button on the Integrations page in Console.

## GitLab

The GitLab integration can be used to create triggers for [Workflows](/docs/workflows).

## GitHub

The GitHub integration can be used to create triggers for [Workflows](/docs/workflows).

When enabling the integration, please note that there are OAuth settings for each GitHub organization. If you want to use a repository to trigger Workflows, its organization must be authorized.

Also note that forks from private repos in unauthorized GitHub organizations will not be available for triggers, even if the fork's current organization is authorized. To work around this limitation, instead of forking you can clone the original repo and push it to a new repo in an authorized organization.

## Slack

The Slack integration can be used to recieve notifications of Rack events in your team's chat. See the [Notifications](/docs/notifications) doc for details about the types of notifications that are sent.
