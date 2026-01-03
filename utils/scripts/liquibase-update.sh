#!/bin/bash
set -e

SCRIPT_NAME="liquibase-update.sh"
LOG_FILE="logs/liquibase-update-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    echo "💡 Verify database connection and changelog files"
    exit 1
}

trap 'error_handler $LINENO' ERR

echo "🔄 Running Liquibase migrations..."
echo "📋 Log file: $LOG_FILE"

mvn liquibase:update 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee "$LOG_FILE"

echo "✅ Migrations completed successfully!"
echo "📋 Full log: $LOG_FILE"
