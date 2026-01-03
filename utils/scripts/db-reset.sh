#!/bin/bash
set -e

SCRIPT_NAME="db-reset.sh"
LOG_FILE="logs/db-reset-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    exit 1
}

trap 'error_handler $LINENO' ERR

echo "🗄️  Resetting database..."
echo "📋 Log file: $LOG_FILE"

echo "🔻 Stopping containers..." | tee -a "$LOG_FILE"
docker-compose down -v 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"

echo "🔺 Starting PostgreSQL..." | tee -a "$LOG_FILE"
docker-compose up -d postgres 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"

echo "⏳ Waiting for PostgreSQL to be ready..." | tee -a "$LOG_FILE"
sleep 5

timeout=60
counter=0
until docker-compose exec -T postgres pg_isready -U bookanga > /dev/null 2>&1; do
    if [ $counter -ge $timeout ]; then
        echo "❌ PostgreSQL failed to be ready within ${timeout}s" | tee -a "$LOG_FILE"
        docker-compose logs postgres | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "⏳ Waiting for database... ($counter/$timeout)" | tee -a "$LOG_FILE"
    sleep 2
    counter=$((counter + 2))
done

echo "✅ Database reset complete!" | tee -a "$LOG_FILE"
echo "💡 Run Liquibase migrations with: ./utils/scripts/liquibase-update.sh"
echo "📋 Full log: $LOG_FILE"
