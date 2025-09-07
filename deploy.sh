#!/bin/bash
set -e

APP_NAME="devsecops-demo-app"
PORT=5000

echo "🔹 Step 1: Building Docker image..."
docker build -t $APP_NAME .

echo "🔹 Step 2: Stopping any running containers..."
docker ps -q --filter "ancestor=$APP_NAME" | xargs -r docker stop

echo "🔹 Step 3: Running container..."
docker run -d -p $PORT:5000 $APP_NAME

echo "✅ Deployment complete! Visit: http://localhost:$PORT"

# Optional: Rollback helper
echo ""
echo "ℹ️ To rollback to last stable build:"
echo "   docker run -d -p $PORT:5000 $APP_NAME:stable"

