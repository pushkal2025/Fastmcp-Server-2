#!/bin/bash
set -e

# ─────────────────────────────────────────────
# Create logging directory if not exists
# ─────────────────────────────────────────────
mkdir -p logging

# ─────────────────────────────────────────────
# 1. Start FastMCP server (port 8080)
# ─────────────────────────────────────────────
echo "🔧 Starting FastMCP server on port 8080..."
uv run server.py --port 8080 &

# ─────────────────────────────────────────────
# 2. Set up JIRA credentials
# ─────────────────────────────────────────────
: "${JIRA_USERNAME:?JIRA_USERNAME not set}"
: "${JIRA_API_KEY:?JIRA_API_KEY not set}"
: "${JIRA_URL:=https://mobikwik.atlassian.net}"  # Default if not set

# ─────────────────────────────────────────────
# 3. Start Jira MCP (port 8000)
# ─────────────────────────────────────────────
echo "🚀 Starting Jira MCP server on port 8000..."
uvx mcp-atlassian \
  --jira-url "$JIRA_URL" \
  --jira-username "$JIRA_USERNAME" \
  --jira-token "$JIRA_API_KEY" \
  --transport streamable-http \
  --host 0.0.0.0 \
  --port 8000 &

# ─────────────────────────────────────────────
# 4. Start nginx reverse proxy
# ─────────────────────────────────────────────
echo "🌐 Starting Nginx reverse proxy..."
nginx -c /app/nginx.conf -g "daemon off;"
