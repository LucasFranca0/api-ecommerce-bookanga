#!/bin/bash
set -e

SCRIPT_NAME="clean.sh"
LOG_FILE="logs/clean-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    exit 1
}

trap 'error_handler $LINENO' ERR

echo "🧹 Cleaning project..."
echo "📋 Log file: $LOG_FILE"

echo "🧹 Running Maven clean..." | tee -a "$LOG_FILE"
mvn clean 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"

echo "🧹 Removing old log files..." | tee -a "$LOG_FILE"
find logs -name "*.log" -mtime +7 -delete 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE" || true

echo "💡 To clean IDE files, run: rm -rf .idea target"
echo "✅ Cleanup complete!"
echo "📋 Full log: $LOG_FILE"
