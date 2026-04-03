# Monitoramento com Prometheus + Grafana

## 🚀 Serviços Disponíveis

Após executar `docker compose up -d`, os seguintes serviços estarão disponíveis:

### 📊 **Grafana** - Dashboards e Visualizações
- **URL:** http://localhost:3000
- **Usuário:** admin
- **Senha:** admin
- **Função:** Interface visual para criar dashboards e visualizar métricas

### 📈 **Prometheus** - Coletor de Métricas
- **URL:** http://localhost:9090
- **Função:** Coleta e armazena métricas da aplicação Spring Boot
- **Targets:** http://localhost:9090/targets (veja os alvos sendo monitorados)

### 🔧 **API Bookanga** - Aplicação
- **URL:** http://localhost:8080
- **Métricas:** http://localhost:8080/actuator/prometheus
- **Health:** http://localhost:8080/actuator/health
- **Todas métricas:** http://localhost:8080/actuator/metrics

### 🗄️ **PostgreSQL** - Banco de Dados
- **Host:** localhost:5432
- **Database:** bookanga_db
- **Usuário:** bookanga
- **Senha:** bookanga123

---

## 📊 Configurando Grafana

### 1. Primeiro Acesso
1. Acesse http://localhost:3000
2. Login com **admin / admin**
3. Você será solicitado a trocar a senha (pode pular)

### 2. Adicionar Prometheus como Data Source
1. No menu lateral, clique em **Connections** → **Data Sources**
2. Clique em **Add data source**
3. Selecione **Prometheus**
4. Configure:
   - **Name:** Prometheus
   - **URL:** `http://bookanga-prometheus:9090`
5. Clique em **Save & Test** (deve mostrar "Successfully queried")

### 3. Importar Dashboard Pronto (Recomendado)
1. No menu lateral, clique em **Dashboards** → **Import**
2. Digite o ID: **11378** (JVM Micrometer Dashboard)
3. Clique em **Load**
4. Selecione **Prometheus** como data source
5. Clique em **Import**

**Pronto!** Você terá um dashboard completo com:
- ✅ CPU Usage
- ✅ Memória JVM (Heap, Non-Heap)
- ✅ Threads ativos
- ✅ Garbage Collection
- ✅ HTTP Requests (latência, taxa de erro)
- ✅ Logs do Liquibase
- ✅ Pool de conexões do banco

### 4. Outros Dashboards Recomendados
- **4701** - JVM Dashboard
- **12900** - Spring Boot 2.1 Statistics
- **6756** - Spring Boot APM Dashboard

---

## 📈 Métricas Importantes

### Verificar no Prometheus (http://localhost:9090)

Execute estas queries:

```promql
# Taxa de requisições HTTP por segundo
rate(http_server_requests_seconds_count[1m])

# Uso de memória JVM
jvm_memory_used_bytes{area="heap"}

# Threads ativas
jvm_threads_live_threads

# Tempo de resposta HTTP (p95)
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))

# Conexões do pool de dados
hikaricp_connections_active{pool="HikariPool-1"}
```

---

## 🛠️ Troubleshooting

### Prometheus não está coletando métricas?
1. Verifique se a API está expondo métricas: http://localhost:8080/actuator/prometheus
2. Verifique os targets no Prometheus: http://localhost:9090/targets
   - Deve mostrar `bookanga-api:8080` com status **UP**

### Grafana não conecta ao Prometheus?
- Use `http://bookanga-prometheus:9090` (nome do container Docker)
- NÃO use `http://localhost:9090`

### Como reiniciar tudo limpo?
```bash
docker compose down -v
docker compose up --build -d
```

---

## 📚 Recursos Adicionais

- [Prometheus Query Examples](https://prometheus.io/docs/prometheus/latest/querying/examples/)
- [Grafana Dashboard Gallery](https://grafana.com/grafana/dashboards/)
- [Spring Boot Actuator Docs](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Micrometer Prometheus](https://micrometer.io/docs/registry/prometheus)
