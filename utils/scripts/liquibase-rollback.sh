#!/bin/bash
set -e

SCRIPT_NAME="liquibase-rollback.sh"
LOG_FILE="logs/liquibase-rollback-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    echo "💡 Verify rollback configuration in changesets"
    exit 1
}

trap 'error_handler $LINENO' ERR

if [ -z "$1" ]; then
    echo "❌ Usage: $0 <number_of_changesets>"
    echo "Example: $0 1"
    exit 1
fi

echo "⏪ Rolling back $1 changeset(s)..."
echo "📋 Log file: $LOG_FILE"

mvn liquibase:rollback -Dliquibase.rollbackCount=$1 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee "$LOG_FILE"

echo "✅ Rollback completed!"
echo "📋 Full log: $LOG_FILE"
