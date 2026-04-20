#!/bin/bash
set -e

CONFIG_FILE="/root/.openclaw/openclaw.json"
WORKSPACE="/root/.openclaw/workspace"

mkdir -p "$WORKSPACE"

# Write openclaw.json — v2026.4.x format
# ANTHROPIC_API_KEY is read directly from env, no "providers" block needed
cat > "$CONFIG_FILE" <<EOF
{
  "agents": {
    "defaults": {
      "workspace": "${WORKSPACE}",
      "compaction": {
        "mode": "safeguard"
      }
    }
  },
  "gateway": {
    "port": ${PORT:-18789},
    "bind": "lan",
    "auth": {
      "mode": "none"
    }
  }
EOF

# Add Telegram channel if token provided
if [ -n "$TELEGRAM_TOKEN" ]; then
cat >> "$CONFIG_FILE" <<EOF
  ,
  "telegram": {
    "token": "${TELEGRAM_TOKEN}",
    "enabled": true
  }
EOF
fi

# Add Discord channel if token provided
if [ -n "$DISCORD_BOT_TOKEN" ]; then
cat >> "$CONFIG_FILE" <<EOF
  ,
  "discord": {
    "token": "${DISCORD_BOT_TOKEN}",
    "enabled": true
  }
EOF
fi

# Add Slack channel if token provided
if [ -n "$SLACK_BOT_TOKEN" ]; then
cat >> "$CONFIG_FILE" <<EOF
  ,
  "slack": {
    "botToken": "${SLACK_BOT_TOKEN}",
    "enabled": true
  }
EOF
fi

cat >> "$CONFIG_FILE" <<EOF
}
EOF

# Write system prompt as AGENTS.md so the agent has business context from first message
if [ -n "$AGENT_SYSTEM_PROMPT" ]; then
  cat > "${WORKSPACE}/AGENTS.md" <<AGENTSEOF
${AGENT_SYSTEM_PROMPT}
AGENTSEOF
  echo "✓ System prompt written to AGENTS.md"
fi

echo "✓ OpenClaw config written (v2026.4.x format)"
echo "✓ Starting OpenClaw gateway on port ${PORT:-18789}..."

exec openclaw gateway --port "${PORT:-18789}" --allow-unconfigured
