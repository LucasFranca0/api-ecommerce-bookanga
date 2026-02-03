#!/bin/bash

# Script para gerenciar o ambiente de monitoramento Bookanga

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Bookanga - Ambiente de Monitoramento${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Verifica se os containers estão rodando
if ! docker compose ps | grep -q "Up"; then
    echo -e "${YELLOW}⚠️  Containers não estão rodando!${NC}"
    echo -e "${YELLOW}Execute: docker compose up -d${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Todos os serviços estão rodando!${NC}"
echo ""
echo -e "${BLUE}📊 Serviços Disponíveis:${NC}"
echo ""
echo -e "${GREEN}🔹 Grafana (Dashboards)${NC}"
echo -e "   URL: ${YELLOW}http://localhost:3000${NC}"
echo -e "   Usuário: ${YELLOW}admin${NC} | Senha: ${YELLOW}admin${NC}"
echo ""
echo -e "${GREEN}🔹 Prometheus (Métricas)${NC}"
echo -e "   URL: ${YELLOW}http://localhost:9090${NC}"
echo -e "   Targets: ${YELLOW}http://localhost:9090/targets${NC}"
echo ""
echo -e "${GREEN}🔹 API Bookanga${NC}"
echo -e "   URL: ${YELLOW}http://localhost:8080${NC}"
echo -e "   Métricas: ${YELLOW}http://localhost:8080/actuator/prometheus${NC}"
echo -e "   Health: ${YELLOW}http://localhost:8080/actuator/health${NC}"
echo ""
echo -e "${GREEN}🔹 PostgreSQL${NC}"
echo -e "   Host: ${YELLOW}localhost:5432${NC}"
echo -e "   Database: ${YELLOW}bookanga_db${NC}"
echo ""
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}💡 Dicas Rápidas:${NC}"
echo -e "  • Ver logs: ${GREEN}docker compose logs -f [app|prometheus|grafana]${NC}"
echo -e "  • Reiniciar: ${GREEN}docker compose restart${NC}"
echo -e "  • Parar tudo: ${GREEN}docker compose down${NC}"
echo ""

# Verifica se as métricas estão sendo coletadas
echo -e "${BLUE}🔍 Verificando métricas...${NC}"
if curl -s http://localhost:8080/actuator/prometheus | grep -q "jvm_"; then
    echo -e "${GREEN}✅ API está expondo métricas corretamente!${NC}"
else
    echo -e "${YELLOW}⚠️  Aguarde alguns segundos para as métricas ficarem disponíveis...${NC}"
fi
echo ""
