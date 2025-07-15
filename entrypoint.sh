#!/bin/bash
set -e

# Ensure the logging directory exists
mkdir -p logging

# Start the Python MCP server and log its stdout/stderr
echo "🔧 Starting Python server (FastAPI)..."
uv run server.py --port 8080  &

# Load JIRA credentials from config.py using inline Python
# eval $(python3 <<EOF
# import config
# print(f'export JIRA_USERNAME="{config.JIRA_USERNAME}"')
# print(f'export JIRA_TOKEN="{config.JIRA_API_KEY}"')
# EOF
# )

# echo "🚀 Starting MCP Atlassian agent for $JIRA_USERNAME..."

# # Start MCP Atlassian agent and log its output
# uvx mcp-atlassian \
#   --jira-url https://mobikwik.atlassian.net \
#   --jira-username "$JIRA_USERNAME" \
#   --jira-token "$JIRA_TOKEN" \
#   --transport streamable-http \
#   --host 0.0.0.0 \
#   --port 8000 

# Wait for any process to exit
wait -n
