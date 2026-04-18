#!/bin/bash
set -e

CONFIG_FILE="/root/.openclaw/openclaw.json"

# Build openclaw.json from environment variables
cat > "$CONFIG_FILE" <<EOF
{
  "agent": {
    "model": "${OPENCLAW_MODEL:-anthropic/claude-haiku-4-5-20251001}"
  },
  "providers": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}"
    }
  }
EOF

# Add Discord if token provided
if [ -n "$DISCORD_BOT_TOKEN" ]; then
cat >> "$CONFIG_FILE" <<EOF
  ,
  "discord": {
    "token": "${DISCORD_BOT_TOKEN}",
    "enabled": true
  }
EOF
fi

# Add Telegram if token provided
if [ -n "$TELEGRAM_TOKEN" ]; then
cat >> "$CONFIG_FILE" <<EOF
  ,
  "telegram": {
    "token": "${TELEGRAM_TOKEN}",
    "enabled": true
  }
EOF
fi

# Add Slack if token provided
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

echo "✓ OpenClaw config written"
echo "✓ Starting OpenClaw gateway on port ${PORT:-18789}..."

# Start the gateway
exec openclaw gateway --port "${PORT:-18789}"
