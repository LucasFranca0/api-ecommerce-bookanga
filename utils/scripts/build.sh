#!/bin/bash
set -e

SCRIPT_NAME="build.sh"
LOG_FILE="logs/build-$(date +%Y%m%d-%H%M%S).log"

mkdir -p logs

error_handler() {
    echo "❌ Error occurred in $SCRIPT_NAME at line $1"
    echo "❌ Last command: $BASH_COMMAND"
    echo "📋 Check log file: $LOG_FILE"
    exit 1
}

trap 'error_handler $LINENO' ERR

log_and_run() {
    echo "$1"
    eval "$2" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"
}

echo "🔨 Building API Ecommerce Bookanga..."
echo "📋 Log file: $LOG_FILE"

log_and_run "🧹 Cleaning previous build..." "mvn clean"

log_and_run "📦 Compiling project..." "mvn compile"

log_and_run "🧪 Running tests..." "mvn test"

log_and_run "📦 Creating package..." "mvn package -DskipTests"

echo "✅ Build completed successfully!"
echo "📦 JAR location: target/api-ecommerce-1.0-SNAPSHOT.jar"
echo "📋 Full log: $LOG_FILE"
