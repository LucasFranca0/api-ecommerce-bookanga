#!/bin/bash
set -e

SCRIPT_NAME="run-local.sh"
LOG_FILE="logs/run-local-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    exit 1
}

trap 'error_handler $LINENO' ERR

echo "🚀 Starting API Ecommerce Bookanga locally..."
echo "📋 Log file: $LOG_FILE"

if ! pg_isready -h localhost -p 5432 > /dev/null 2>&1; then
    echo "⚠️  PostgreSQL não está rodando. Iniciando com Docker..." | tee -a "$LOG_FILE"
    docker-compose up -d postgres 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"
    echo "⏳ Aguardando PostgreSQL iniciar..." | tee -a "$LOG_FILE"
    sleep 5
    
    timeout=30
    counter=0
    until pg_isready -h localhost -p 5432 > /dev/null 2>&1; do
        if [ $counter -ge $timeout ]; then
            echo "❌ PostgreSQL failed to start within ${timeout}s" | tee -a "$LOG_FILE"
            exit 1
        fi
        echo "⏳ Waiting for PostgreSQL... ($counter/$timeout)" | tee -a "$LOG_FILE"
        sleep 2
        counter=$((counter + 2))
    done
fi

echo "▶️  Running application..." | tee -a "$LOG_FILE"
mvn spring-boot:run 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"
