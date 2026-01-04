#!/bin/bash

# Script para reiniciar e gerenciar o ambiente Docker completo do projeto Bookanga
# Este script verifica dependências, para containers existentes e sobe todo o ambiente

set -e

# Determinar diretório raiz do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Bookanga - Restart Docker Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Função para verificar se Docker está instalado
check_docker() {
    echo -e "${YELLOW}🔍 Verificando Docker...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker não está instalado!${NC}"
        echo -e "${YELLOW}Por favor, instale o Docker antes de continuar.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker instalado${NC}"
}

# Função para verificar se Docker Compose está instalado
check_docker_compose() {
    echo -e "${YELLOW}🔍 Verificando Docker Compose...${NC}"
    if ! command -v docker compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose não está instalado!${NC}"
        echo -e "${YELLOW}Por favor, instale o Docker Compose antes de continuar.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker Compose instalado${NC}"
}

# Função para verificar se Maven está instalado
check_maven() {
    echo -e "${YELLOW}🔍 Verificando Maven...${NC}"
    if ! command -v mvn &> /dev/null; then
        echo -e "${RED}❌ Maven não está instalado!${NC}"
        echo -e "${YELLOW}Por favor, instale o Maven antes de continuar.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Maven instalado${NC}"
}

# Função para baixar dependências Maven
download_dependencies() {
    echo ""
    echo -e "${YELLOW}📦 Verificando dependências Maven...${NC}"
    
    cd "$PROJECT_ROOT"
    
    if [ ! -d "target" ] || [ ! -f "target/api-ecommerce-1.0-SNAPSHOT.jar" ]; then
        echo -e "${YELLOW}📥 Baixando dependências e compilando projeto...${NC}"
        mvn clean install -DskipTests
        echo -e "${GREEN}✅ Dependências baixadas e projeto compilado${NC}"
    else
        echo -e "${GREEN}✅ Dependências já estão disponíveis${NC}"
    fi
}

# Função para parar containers existentes
stop_existing_containers() {
    echo ""
    echo -e "${YELLOW}🛑 Verificando containers em execução...${NC}"
    
    cd "$PROJECT_ROOT"
    
    if docker compose ps | grep -q "bookanga"; then
        echo -e "${YELLOW}⏸️  Parando containers existentes...${NC}"
        echo -e "${YELLOW}🗑️  Removendo volumes para limpar banco de dados e Liquibase...${NC}"
        docker compose down -v
        echo -e "${GREEN}✅ Containers parados e volumes removidos${NC}"
    else
        echo -e "${GREEN}✅ Nenhum container em execução${NC}"
    fi
}

# Função para iniciar todo o ambiente
start_environment() {
    echo ""
    echo -e "${YELLOW}🚀 Iniciando ambiente completo...${NC}"
    
    cd "$PROJECT_ROOT"
    
    echo -e "${BLUE}📦 Building Docker images...${NC}"
    docker compose build
    
    echo -e "${BLUE}🔺 Starting services...${NC}"
    docker compose up -d
    
    echo ""
    echo -e "${YELLOW}⏳ Aguardando serviços iniciarem...${NC}"
    sleep 5
}

# Função para verificar status dos containers
check_status() {
    echo ""
    echo -e "${GREEN}📊 Status dos containers:${NC}"
    
    cd "$PROJECT_ROOT"
    docker compose ps
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✅ Ambiente iniciado com sucesso!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${BLUE}📊 Serviços disponíveis:${NC}"
    echo -e "${BLUE}   • API: http://localhost:8080${NC}"
    echo -e "${BLUE}   • Status Page: http://localhost:8080/status.html${NC}"
    echo -e "${BLUE}   • PostgreSQL: localhost:5432${NC}"
    echo ""
    echo -e "${YELLOW}💡 Dicas:${NC}"
    echo -e "${YELLOW}   • Ver logs: docker compose logs -f${NC}"
    echo -e "${YELLOW}   • Parar ambiente: docker compose down${NC}"
    echo -e "${YELLOW}   • Acessar PostgreSQL: docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db${NC}"
    echo ""
}

# Executar verificações e inicialização
main() {
    check_docker
    check_docker_compose
    check_maven
    download_dependencies
    stop_existing_containers
    start_environment
    check_status
}

# Executar script principal
main
