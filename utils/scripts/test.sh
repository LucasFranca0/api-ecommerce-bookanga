#!/bin/bash
set -e

SCRIPT_NAME="test.sh"
LOG_FILE="logs/test-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    echo "💡 Test failures details in: target/surefire-reports/"
    exit 1
}

trap 'error_handler $LINENO' ERR

echo "🧪 Running tests for API Ecommerce Bookanga..."
echo "📋 Log file: $LOG_FILE"

mvn test 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee "$LOG_FILE"

echo "✅ All tests passed!"
echo "📋 Full log: $LOG_FILE"
