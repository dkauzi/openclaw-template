#!/bin/bash
set -e

mkdir -p /root/.openclaw
CONFIG_FILE="/root/.openclaw/openclaw.json"
WORKSPACE="/root/.openclaw/workspace"
mkdir -p "$WORKSPACE"

# v2026.4.x config format — agent/providers keys removed, ANTHROPIC_API_KEY read from env
node -e "
const cfg = {
  agents: {
    defaults: {
      workspace: '/root/.openclaw/workspace',
      compaction: { mode: 'safeguard' }
    }
  },
  gateway: {
    port: parseInt(process.env.PORT || '18789'),
    bind: 'auto',
    auth: {
      mode: 'token',
      token: process.env.OPENCLAW_GATEWAY_TOKEN || 'demo'
    }
  }
};

if (process.env.TELEGRAM_TOKEN) {
  cfg.telegram = { token: process.env.TELEGRAM_TOKEN, enabled: true };
}
if (process.env.DISCORD_BOT_TOKEN) {
  cfg.discord = { token: process.env.DISCORD_BOT_TOKEN, enabled: true };
}
if (process.env.SLACK_BOT_TOKEN) {
  cfg.slack = { botToken: process.env.SLACK_BOT_TOKEN, enabled: true };
}

require('fs').writeFileSync('${CONFIG_FILE}', JSON.stringify(cfg, null, 2));
console.log('Config written');
"

# System prompt becomes AGENTS.md — read on every conversation start
if [ -n "$AGENT_SYSTEM_PROMPT" ]; then
  printf '%s\n' "$AGENT_SYSTEM_PROMPT" > "${WORKSPACE}/AGENTS.md"
  echo "System prompt written"
fi

echo "Starting OpenClaw gateway on port ${PORT:-18789}..."
exec openclaw gateway --port "${PORT:-18789}" --allow-unconfigured
