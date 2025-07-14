# Use the official Python slim image
FROM python:3.13-slim

# Install system packages
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Install the project into /app

# Copy entire project
COPY . .


# Allow statements and log messages to immediately appear in the logs
ENV PYTHONUNBUFFERED=1


# Ensure logging directory exists
RUN mkdir -p logging


# Install Python dependencies
RUN uv sync

# RUN pip install fastmcp

# Install current project in editable mode
# RUN uv pip install -e .

# Entrypoint script permissions
RUN chmod +x entrypoint.sh

# Expose ports
EXPOSE 8080  8000 

CMD ["./entrypoint.sh"]
