FROM node:22-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw

# Create openclaw home directory
RUN mkdir -p /root/.openclaw/workspace/skills

# Copy startup script and skill
COPY start.sh /start.sh
COPY skills/deployinfra/SKILL.md /root/.openclaw/workspace/skills/deployinfra/SKILL.md

RUN chmod +x /start.sh

EXPOSE ${PORT:-18789}

CMD ["/start.sh"]
