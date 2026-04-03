#!/bin/bash

# Script para limpeza APENAS do projeto Bookanga
# Remove apenas containers, imagens e volumes relacionados ao Bookanga

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     🧹 Limpeza do Projeto Bookanga 🧹                   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verifica se está no diretório correto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

echo -e "${YELLOW}ℹ️  Este script irá remover:${NC}"
echo -e "   ❌ Containers do Bookanga"
echo -e "   ❌ Imagens do Bookanga"
echo -e "   ❌ Volumes do Bookanga"
echo -e "   ❌ Network do Bookanga"
echo ""
echo -e "${GREEN}✅ Outras imagens e containers Docker serão mantidos${NC}"
echo ""

read -p "$(echo -e ${YELLOW}Deseja continuar? [s/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]
then
    echo -e "${GREEN}✅ Operação cancelada!${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Limpando projeto Bookanga...${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Para e remove containers via docker-compose
echo -e "${YELLOW}🛑 Parando containers do Bookanga...${NC}"
if [ -f "docker-compose.yml" ]; then
    docker compose down -v 2>/dev/null || docker-compose down -v 2>/dev/null
    echo -e "${GREEN}✅ Containers parados e removidos${NC}"
else
    echo -e "${RED}❌ docker-compose.yml não encontrado${NC}"
fi
echo ""

# Remove imagens do projeto
echo -e "${YELLOW}🖼️  Removendo imagens do Bookanga...${NC}"
docker images | grep -E "bookanga|api-ecommerce" | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null
echo -e "${GREEN}✅ Imagens removidas${NC}"
echo ""

# Remove volumes órfãos
echo -e "${YELLOW}📦 Removendo volumes órfãos...${NC}"
docker volume prune -f 2>/dev/null
echo -e "${GREEN}✅ Volumes órfãos removidos${NC}"
echo ""

# Limpa cache de build do projeto
echo -e "${YELLOW}🗄️  Limpando cache de build...${NC}"
docker builder prune -f 2>/dev/null
echo -e "${GREEN}✅ Cache limpo${NC}"
echo ""

# Mostra status
echo -e "${YELLOW}📊 Status atual do Docker:${NC}"
docker system df
echo ""

echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     ✅ Projeto Bookanga limpo! ✅                        ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Para reconstruir o ambiente:${NC}"
echo -e "   ${GREEN}docker compose up --build -d${NC}"
echo ""
