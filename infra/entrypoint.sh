#!/bin/sh
set -e

# Start mcporter daemon for keep-alive MCP servers
if [ -f /home/node/.openclaw/workspace/config/mcporter.json ]; then
  echo "Starting mcporter daemon..."
  mcporter daemon start --config /home/node/.openclaw/workspace/config/mcporter.json || true
fi

# Start the OpenClaw gateway
exec node dist/index.js gateway --bind lan --port 18789