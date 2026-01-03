#!/bin/bash
set -e

SCRIPT_NAME="logs.sh"
SERVICE=${1:-app}

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME"
    echo "❌ Failed to get logs for service: $SERVICE"
    echo "💡 Check if service is running: docker-compose ps"
    exit 1
}

trap 'error_handler' ERR

if ! docker-compose ps | grep -q "$SERVICE"; then
    echo "⚠️  Warning: Service '$SERVICE' may not be running"
    echo "📋 Available services:"
    docker-compose ps
    echo ""
fi

echo "📋 Showing logs for $SERVICE..."
docker-compose logs -f $SERVICE
