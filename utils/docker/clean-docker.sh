#!/bin/bash

# Script para limpar completamente o Docker
# Remove containers, imagens, volumes, networks e cache

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${RED}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║                                                          ║${NC}"
echo -e "${RED}║        🧹 Docker Complete Cleanup Script 🧹             ║${NC}"
echo -e "${RED}║                                                          ║${NC}"
echo -e "${RED}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}⚠️  ATENÇÃO: Este script irá remover:${NC}"
echo -e "   ${RED}❌ Todos os containers (parados e em execução)${NC}"
echo -e "   ${RED}❌ Todas as imagens Docker${NC}"
echo -e "   ${RED}❌ Todos os volumes${NC}"
echo -e "   ${RED}❌ Todas as networks customizadas${NC}"
echo -e "   ${RED}❌ Todo o cache de build${NC}"
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
echo -e "${BLUE}Iniciando limpeza completa do Docker...${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Função para mostrar espaço em disco
show_disk_usage() {
    echo -e "${BLUE}💾 Espaço usado pelo Docker:${NC}"
    docker system df
    echo ""
}

# Mostra uso atual
echo -e "${YELLOW}📊 Antes da limpeza:${NC}"
show_disk_usage

# 1. Para e remove todos os containers
echo -e "${YELLOW}🛑 Parando todos os containers...${NC}"
if [ "$(docker ps -aq)" ]; then
    docker stop $(docker ps -aq) 2>/dev/null
    echo -e "${GREEN}✅ Containers parados${NC}"
else
    echo -e "${GREEN}✅ Nenhum container em execução${NC}"
fi

echo -e "${YELLOW}🗑️  Removendo todos os containers...${NC}"
if [ "$(docker ps -aq)" ]; then
    docker rm -f $(docker ps -aq) 2>/dev/null
    echo -e "${GREEN}✅ Containers removidos${NC}"
else
    echo -e "${GREEN}✅ Nenhum container para remover${NC}"
fi
echo ""

# 2. Remove todas as imagens
echo -e "${YELLOW}🖼️  Removendo todas as imagens...${NC}"
if [ "$(docker images -aq)" ]; then
    docker rmi -f $(docker images -aq) 2>/dev/null
    echo -e "${GREEN}✅ Imagens removidas${NC}"
else
    echo -e "${GREEN}✅ Nenhuma imagem para remover${NC}"
fi
echo ""

# 3. Remove todos os volumes
echo -e "${YELLOW}📦 Removendo todos os volumes...${NC}"
if [ "$(docker volume ls -q)" ]; then
    docker volume rm -f $(docker volume ls -q) 2>/dev/null
    echo -e "${GREEN}✅ Volumes removidos${NC}"
else
    echo -e "${GREEN}✅ Nenhum volume para remover${NC}"
fi
echo ""

# 4. Remove todas as networks customizadas
echo -e "${YELLOW}🌐 Removendo networks customizadas...${NC}"
if [ "$(docker network ls -q -f type=custom)" ]; then
    docker network prune -f 2>/dev/null
    echo -e "${GREEN}✅ Networks removidas${NC}"
else
    echo -e "${GREEN}✅ Nenhuma network customizada para remover${NC}"
fi
echo ""

# 5. Remove cache de build
echo -e "${YELLOW}🗄️  Limpando cache de build...${NC}"
docker builder prune -af 2>/dev/null
echo -e "${GREEN}✅ Cache de build limpo${NC}"
echo ""

# 6. Limpeza final agressiva
echo -e "${YELLOW}🧹 Executando limpeza final do sistema...${NC}"
docker system prune -af --volumes 2>/dev/null
echo -e "${GREEN}✅ Limpeza final concluída${NC}"
echo ""

# Mostra uso após limpeza
echo -e "${YELLOW}📊 Depois da limpeza:${NC}"
show_disk_usage

echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                          ║${NC}"
echo -e "${GREEN}║        ✅ Docker completamente limpo! ✅                 ║${NC}"
echo -e "${GREEN}║                                                          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}💡 Dicas:${NC}"
echo -e "   • Para verificar o espaço: ${YELLOW}docker system df${NC}"
echo -e "   • Para listar imagens: ${YELLOW}docker images${NC}"
echo -e "   • Para listar containers: ${YELLOW}docker ps -a${NC}"
echo -e "   • Para listar volumes: ${YELLOW}docker volume ls${NC}"
echo ""
echo -e "${BLUE}Para reconstruir o ambiente Bookanga:${NC}"
echo -e "   ${GREEN}cd $(git rev-parse --show-toplevel 2>/dev/null || pwd)${NC}"
echo -e "   ${GREEN}docker compose up --build -d${NC}"
echo ""
