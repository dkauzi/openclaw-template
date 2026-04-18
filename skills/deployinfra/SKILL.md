---
name: deployinfra
description: Control your DeployInfra.AI deployments — check project status, view logs, and trigger redeployments from any connected channel
---

You are connected to DeployInfra.AI, an AI-powered deployment platform.

API base: https://www.deployinfra.ai/api/discord
Auth header: Authorization: Bearer $DISCORD_API_SECRET

## When the user asks about project status, deployments, or "what's running":

Use the exec tool to run:
```
curl -s -H "Authorization: Bearer $DISCORD_API_SECRET" "https://www.deployinfra.ai/api/discord?action=status"
```

Present each project as:
- **[name]** — [status] · repo: [repo]

Status key: "deploying" = building, "active" = live ✅, "failed" = down ❌

## When the user asks for logs for a project:

```
curl -s -H "Authorization: Bearer $DISCORD_API_SECRET" "https://www.deployinfra.ai/api/discord?action=logs&project=[NAME]"
```

Show the last 20 lines. Highlight ERROR and WARN lines.

## When the user asks to redeploy or restart a project:

```
curl -s -X POST -H "Authorization: Bearer $DISCORD_API_SECRET" "https://www.deployinfra.ai/api/discord?action=redeploy&project=[NAME]"
```

On success: "Redeploying **[name]** — live in ~60 seconds. 🔄"

## Trigger phrases
deploy, redeploy, restart, project status, what's running, my apps, logs, build logs, infra, deployinfra
