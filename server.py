import asyncio
import logging
import os

from fastmcp import FastMCP 
from fastapi import status,Request,Response # Import status codes for clearer responses
from fastapi.responses import JSONResponse
from starlette.requests import Request


# Setup logging directory and file
LOG_DIR = "logging"
os.makedirs(LOG_DIR, exist_ok=True)

log_filename = os.path.join(LOG_DIR, "mcp_server.log")

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.FileHandler(log_filename, mode='a'),  # Append mode
        logging.StreamHandler()  # Also show logs in terminal
    ]
)

logger = logging.getLogger(__name__)


# Create MCP and pass your FastAPI app
mcp = FastMCP("MCP Server on Cloud Run")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Use this to add two numbers together."""
    logger.info(f">>> Tool: 'add' called with numbers '{a}' and '{b}'")
    return a + b

@mcp.tool()
def subtract(a: int, b: int) -> int:
    """Use this to subtract two numbers."""
    logger.info(f">>> Tool: 'subtract' called with numbers '{a}' and '{b}'")
    return a - b


# Health check endpoint
@mcp.custom_route("/health", methods=["GET"])
async def health_check(request: Request):
    """Health check endpoint."""
    logger.info(">>> Health check endpoint called.")
    return JSONResponse(content={"status": "ok"}, status_code=status.HTTP_200_OK)




# Start the server
if __name__ == "__main__":
    port = int(os.getenv("PORT", 8080))
    logger.info(f"🚀 MCP server starting on port {port}")
    asyncio.run(
        mcp.run_async(
            transport="streamable-http", 
            host="0.0.0.0", 
            port=port,
        )
    )