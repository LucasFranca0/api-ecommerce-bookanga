# 🐳 Docker Management Scripts - Bookanga

Este diretório contém scripts para gerenciar o ambiente Docker do projeto Bookanga.

## 📜 Scripts Disponíveis

### 🚀 `restart-docker.sh`
**Reinicia o ambiente completo do Bookanga**
- Verifica dependências (Docker, Docker Compose, Maven)
- Compila o projeto
- Para containers existentes
- Inicia todos os serviços
- Mostra status final

```bash
bash utils/docker/restart-docker.sh
```

---

### 🧹 `clean-docker.sh` ⚠️ **CUIDADO - REMOVE TUDO**
**Limpeza COMPLETA do Docker (não apenas Bookanga)**

Remove:
- ❌ **TODOS** os containers (de qualquer projeto)
- ❌ **TODAS** as imagens Docker
- ❌ **TODOS** os volumes
- ❌ **TODAS** as networks customizadas
- ❌ **TODO** o cache de build

**⚠️ Use com cautela! Isso afetará TODOS os seus projetos Docker!**

```bash
bash utils/docker/clean-docker.sh
```

**Exemplo de uso:**
```bash
$ bash utils/docker/clean-docker.sh
Deseja continuar? [s/N]: s
🧹 Executando limpeza final do sistema...
✅ Docker completamente limpo!
```

---

### 🧼 `clean-docker-light.sh` ✅ **SEGURO**
**Limpeza LEVE do Docker**

Remove apenas:
- ✓ Containers parados
- ✓ Imagens não utilizadas (dangling)
- ✓ Volumes órfãos
- ✓ Networks não utilizadas
- ✓ Cache de build não utilizado

**✅ Mantém:**
- ✅ Containers em execução
- ✅ Imagens em uso
- ✅ Volumes ativos

```bash
bash utils/docker/clean-docker-light.sh
```

---

### 🎯 `clean-bookanga.sh` ✅ **RECOMENDADO**
**Limpeza APENAS do projeto Bookanga**

Remove:
- ❌ Containers do Bookanga
- ❌ Imagens do Bookanga
- ❌ Volumes do Bookanga
- ❌ Network do Bookanga

**✅ Mantém:**
- ✅ Outros projetos Docker intactos
- ✅ Outras imagens e containers

```bash
bash utils/docker/clean-bookanga.sh
```

---

## 🎯 Qual Script Usar?

| Situação | Script Recomendado |
|----------|-------------------|
| Reiniciar o projeto | `restart-docker.sh` |
| Limpar apenas o Bookanga | `clean-bookanga.sh` ⭐ |
| Liberar espaço em disco (leve) | `clean-docker-light.sh` |
| Resetar Docker completamente | `clean-docker.sh` ⚠️ |

---

## 💡 Comandos Docker Úteis

### Ver uso de espaço
```bash
docker system df
docker system df -v  # Detalhado
```

### Listar recursos
```bash
docker ps -a              # Containers
docker images             # Imagens
docker volume ls          # Volumes
docker network ls         # Networks
```

### Ver logs
```bash
docker compose logs -f              # Todos os serviços
docker compose logs -f app          # Apenas API
docker compose logs -f prometheus   # Apenas Prometheus
docker compose logs --tail=50       # Últimas 50 linhas
```

### Executar comandos em containers
```bash
# Acessar bash na API
docker exec -it bookanga-api sh

# Acessar PostgreSQL
docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db
```

### Reiniciar serviços específicos
```bash
docker compose restart app           # Apenas API
docker compose restart prometheus    # Apenas Prometheus
docker compose restart               # Todos
```

---

## 🔧 Troubleshooting

### Porta já em uso
```bash
# Ver o que está usando a porta
lsof -i :8080   # API
lsof -i :3000   # Grafana
lsof -i :9090   # Prometheus
lsof -i :5432   # PostgreSQL

# Matar processo
kill -9 <PID>
```

### Permissão negada
```bash
chmod +x utils/docker/*.sh
```

### Limpar tudo e recomeçar
```bash
# Opção 1: Apenas Bookanga
bash utils/docker/clean-bookanga.sh
docker compose up --build -d

# Opção 2: Todo Docker
bash utils/docker/clean-docker.sh
docker compose up --build -d
```

### Ver recursos consumidos
```bash
# Espaço em disco
docker system df

# Processos
docker stats

# Inspecionar container
docker inspect bookanga-api
```

### Build falha
```bash
# Limpar cache e rebuildar
docker builder prune -af
docker compose build --no-cache
docker compose up -d
```

---

## 📊 Monitoramento

Após iniciar o ambiente, acesse:

- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **API**: http://localhost:8080
- **API Health**: http://localhost:8080/actuator/health
- **Métricas**: http://localhost:8080/actuator/prometheus

---

## 🗄️ Banco de Dados

### Conectar via CLI
```bash
docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db
```

### Comandos PostgreSQL úteis
```sql
-- Listar tabelas
\dt

-- Descrever tabela
\d product

-- Ver dados
SELECT * FROM product LIMIT 5;

-- Ver histórico
SELECT * FROM product_hist ORDER BY changed_at DESC LIMIT 10;

-- Sair
\q
```

### Backup e Restore
```bash
# Backup
docker exec bookanga-postgres pg_dump -U bookanga bookanga_db > backup.sql

# Restore
docker exec -i bookanga-postgres psql -U bookanga bookanga_db < backup.sql
```

---

## 🚀 Comandos Rápidos

```bash
# Iniciar tudo
docker compose up -d

# Parar tudo
docker compose down

# Ver status
docker compose ps

# Ver logs em tempo real
docker compose logs -f

# Reiniciar tudo
docker compose restart

# Rebuild e iniciar
docker compose up --build -d

# Limpar volumes (reseta banco)
docker compose down -v
```
