#!/bin/bash
set -e

APP_NAME="devsecops-demo-app"
PORT=5000

echo "🔹 Rolling back to stable version..."
docker ps -q --filter "ancestor=$APP_NAME" | xargs -r docker stop
docker run -d -p $PORT:5000 $APP_NAME:stable
echo "✅ Rolled back to stable image!"

