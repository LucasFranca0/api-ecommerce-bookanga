#!/bin/bash

# Script para limpeza LEVE do Docker
# Remove apenas containers parados, imagens não usadas e volumes órfãos

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     🧹 Docker Light Cleanup (Limpeza Leve) 🧹           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}ℹ️  Este script irá remover:${NC}"
echo -e "   ✓ Containers parados"
echo -e "   ✓ Imagens não utilizadas (dangling)"
echo -e "   ✓ Volumes órfãos"
echo -e "   ✓ Networks não utilizadas"
echo -e "   ✓ Cache de build não utilizado"
echo ""
echo -e "${GREEN}✅ Containers em execução serão mantidos${NC}"
echo -e "${GREEN}✅ Imagens em uso serão mantidas${NC}"
echo ""

# Mostra espaço antes
echo -e "${YELLOW}📊 Antes da limpeza:${NC}"
docker system df
echo ""

# Remove containers parados
echo -e "${YELLOW}🗑️  Removendo containers parados...${NC}"
docker container prune -f

# Remove imagens dangling (sem tag)
echo -e "${YELLOW}🖼️  Removendo imagens não utilizadas...${NC}"
docker image prune -f

# Remove volumes órfãos
echo -e "${YELLOW}📦 Removendo volumes órfãos...${NC}"
docker volume prune -f

# Remove networks não utilizadas
echo -e "${YELLOW}🌐 Removendo networks não utilizadas...${NC}"
docker network prune -f

# Remove cache de build não utilizado
echo -e "${YELLOW}🗄️  Limpando cache de build não utilizado...${NC}"
docker builder prune -f

echo ""
echo -e "${YELLOW}📊 Depois da limpeza:${NC}"
docker system df
echo ""

echo -e "${GREEN}✅ Limpeza leve concluída!${NC}"
echo ""
