
# Use the official Python slim image
FROM python:3.13-slim

# ──────────────────────────────────────────────
# 1. Install system dependencies
# ──────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    nginx curl gnupg bash \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ──────────────────────────────────────────────
# 2. Install uv (for Python deps and mcp)
# ──────────────────────────────────────────────
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# ──────────────────────────────────────────────
# 3. Set work directory
# ──────────────────────────────────────────────
WORKDIR /app

# ──────────────────────────────────────────────
# 4. Copy project files
# ──────────────────────────────────────────────
COPY . .

# ──────────────────────────────────────────────
# 5. Install Python dependencies via uv
# ──────────────────────────────────────────────
RUN uv sync

# ──────────────────────────────────────────────
# 6. Ensure logging and executable scripts
# ──────────────────────────────────────────────
RUN mkdir -p logging
RUN chmod +x entrypoint.sh

# ──────────────────────────────────────────────
# 7. Expose only nginx reverse proxy port
# ──────────────────────────────────────────────
EXPOSE 80

# ──────────────────────────────────────────────
# 8. Start everything via entrypoint.sh
# ──────────────────────────────────────────────
CMD ["./entrypoint.sh"]
