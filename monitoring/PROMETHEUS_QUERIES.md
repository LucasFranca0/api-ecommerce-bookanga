# Exemplos de Queries Prometheus para Bookanga

## 🔥 Queries Essenciais

### **Requisições HTTP**
```promql
# Taxa de requisições por segundo (últimos 5 minutos)
rate(http_server_requests_seconds_count[5m])

# Requisições por endpoint
sum by (uri) (rate(http_server_requests_seconds_count[5m]))

# Taxa de erro (status 4xx e 5xx)
sum(rate(http_server_requests_seconds_count{status=~"[45].."}[5m])) / sum(rate(http_server_requests_seconds_count[5m])) * 100

# Latência média (tempo de resposta)
rate(http_server_requests_seconds_sum[5m]) / rate(http_server_requests_seconds_count[5m])

# Percentil 95 de latência
histogram_quantile(0.95, sum by (le) (rate(http_server_requests_seconds_bucket[5m])))

# Percentil 99 de latência
histogram_quantile(0.99, sum by (le) (rate(http_server_requests_seconds_bucket[5m])))
```

### **JVM - Memória**
```promql
# Uso de memória Heap (em MB)
jvm_memory_used_bytes{area="heap"} / 1024 / 1024

# Memória Heap máxima
jvm_memory_max_bytes{area="heap"} / 1024 / 1024

# Percentual de uso do Heap
(jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"}) * 100

# Memória total usada (Heap + Non-Heap)
sum(jvm_memory_used_bytes) / 1024 / 1024
```

### **JVM - Garbage Collection**
```promql
# Taxa de GC por segundo
rate(jvm_gc_pause_seconds_count[5m])

# Tempo total gasto em GC (por minuto)
rate(jvm_gc_pause_seconds_sum[1m]) * 60

# Tempo médio de pausa do GC
rate(jvm_gc_pause_seconds_sum[5m]) / rate(jvm_gc_pause_seconds_count[5m])
```

### **JVM - Threads**
```promql
# Threads ativas
jvm_threads_live_threads

# Threads daemon
jvm_threads_daemon_threads

# Threads em estado BLOCKED
jvm_threads_states_threads{state="blocked"}

# Threads em estado WAITING
jvm_threads_states_threads{state="waiting"}
```

### **CPU**
```promql
# Uso de CPU do processo Java
process_cpu_usage * 100

# Uso de CPU do sistema
system_cpu_usage * 100
```

### **Banco de Dados - HikariCP**
```promql
# Conexões ativas no pool
hikaricp_connections_active{pool="HikariPool-1"}

# Conexões ociosas
hikaricp_connections_idle{pool="HikariPool-1"}

# Conexões aguardando
hikaricp_connections_pending{pool="HikariPool-1"}

# Total de conexões
hikaricp_connections{pool="HikariPool-1"}

# Tempo de aquisição de conexão (média)
rate(hikaricp_connections_acquire_seconds_sum[5m]) / rate(hikaricp_connections_acquire_seconds_count[5m])

# Timeout de conexões
rate(hikaricp_connections_timeout_total[5m])
```

### **Liquibase**
```promql
# Tempo gasto em migrações Liquibase
liquibase_update_seconds_sum
```

### **Logback - Logs**
```promql
# Taxa de logs de erro por segundo
rate(logback_events_total{level="error"}[5m])

# Taxa de logs de warning
rate(logback_events_total{level="warn"}[5m])

# Total de logs por nível
sum by (level) (logback_events_total)
```

## 🎯 Alertas Sugeridos

### Configurar no Prometheus (prometheus.yml)

```yaml
groups:
  - name: bookanga_alerts
    rules:
      - alert: HighErrorRate
        expr: sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Alta taxa de erros HTTP 5xx"

      - alert: HighMemoryUsage
        expr: (jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"}) * 100 > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Uso de memória Heap acima de 90%"

      - alert: DatabaseConnectionPoolExhausted
        expr: hikaricp_connections_active >= hikaricp_connections_max
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Pool de conexões do banco esgotado"

      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Tempo de resposta P95 acima de 1 segundo"
```

## 📊 Dashboards Úteis para Importar no Grafana

1. **JVM Micrometer (ID: 11378)** ⭐ Recomendado
   - Visão completa de JVM, HTTP, DB

2. **Spring Boot APM (ID: 6756)**
   - Métricas específicas do Spring Boot

3. **Spring Boot Statistics (ID: 12900)**
   - Estatísticas detalhadas

4. **JVM Dashboard (ID: 4701)**
   - Foco em métricas da JVM

## 🔍 Como Usar no Grafana

1. Acesse http://localhost:3000
2. Vá em **Explore** (ícone de bússola no menu lateral)
3. Cole qualquer query acima
4. Clique em **Run Query**
5. Ajuste o intervalo de tempo no canto superior direito
