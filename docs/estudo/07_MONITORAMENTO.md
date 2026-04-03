# 📚 Módulo 7: Monitoramento - Actuator, Prometheus e Grafana

> **Tempo estimado:** 2-3 horas  
> **Importância:** ⭐⭐⭐⭐ (Essencial para produção)

---

## 🎯 O que você vai aprender:

1. ✅ Por que monitorar aplicações
2. ✅ Spring Boot Actuator
3. ✅ Prometheus - Coleta de métricas
4. ✅ Grafana - Visualização
5. ✅ Métricas importantes
6. ✅ Configuração no Bookanga

---

## 📌 1. POR QUE MONITORAR?

### 💡 Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Visibilidade** | Saber o que está acontecendo |
| **Proatividade** | Detectar problemas antes do usuário |
| **Performance** | Identificar gargalos |
| **Debugging** | Investigar incidentes |
| **Capacidade** | Planejar escalabilidade |

### 🔴 Sem monitoramento:

```
Usuário: "O site está lento!"
Dev: "Funciona na minha máquina... 🤷"
```

### 🟢 Com monitoramento:

```
Alerta: "CPU em 95%, latência aumentando"
Dev: "Vou escalar mais instâncias!"
```

---

## 📌 2. ARQUITETURA DE MONITORAMENTO

```
┌─────────────────────────────────────────────────────────────────┐
│                    STACK DE MONITORAMENTO                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐    │
│   │  Bookanga   │      │  Prometheus │      │   Grafana   │    │
│   │    API      │ ───► │   (coleta)  │ ───► │  (visualiza)│    │
│   │  /actuator  │      │             │      │             │    │
│   └─────────────┘      └─────────────┘      └─────────────┘    │
│                                                                 │
│   Expõe métricas       Armazena série      Dashboards e        │
│   em /prometheus       temporal            alertas             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📌 3. SPRING BOOT ACTUATOR

### 💡 O que é?

Módulo do Spring Boot que expõe endpoints de gerenciamento e monitoramento.

### 📦 Dependência:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### 📋 Endpoints disponíveis:

| Endpoint | Descrição |
|----------|-----------|
| `/actuator/health` | Status de saúde da aplicação |
| `/actuator/info` | Informações da aplicação |
| `/actuator/metrics` | Métricas da aplicação |
| `/actuator/prometheus` | Métricas em formato Prometheus |
| `/actuator/env` | Variáveis de ambiente |
| `/actuator/beans` | Todos os beans Spring |
| `/actuator/mappings` | Todos os endpoints HTTP |
| `/actuator/loggers` | Configuração de logs |

### 🔧 Configuração no Bookanga:

```properties
# application.properties

# Habilita endpoints específicos
management.endpoints.web.exposure.include=health,info,metrics,prometheus

# Habilita exportação para Prometheus
management.metrics.export.prometheus.enabled=true
management.endpoint.prometheus.enabled=true

# Mostra detalhes do health check
management.endpoint.health.show-details=always
```

### 🔍 Exemplos de resposta:

**GET /actuator/health**
```json
{
    "status": "UP",
    "components": {
        "db": {
            "status": "UP",
            "details": {
                "database": "PostgreSQL",
                "validationQuery": "isValid()"
            }
        },
        "diskSpace": {
            "status": "UP",
            "details": {
                "total": 250685575168,
                "free": 100123456789
            }
        }
    }
}
```

**GET /actuator/info**
```json
{
    "app": {
        "name": "Bookanga API",
        "version": "1.0.0"
    }
}
```

---

## 📌 4. PROMETHEUS

### 💡 O que é?

Sistema de monitoramento e alertas que coleta métricas via HTTP (scraping).

### 🔄 Como funciona:

```
┌─────────────────────────────────────────────────────────────────┐
│                         PROMETHEUS                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   1. Scraping: A cada 15s, Prometheus chama /actuator/prometheus│
│                                                                 │
│   2. Storage: Armazena dados como série temporal (time series)  │
│                                                                 │
│   3. Query: PromQL para consultar métricas                      │
│                                                                 │
│   4. Alerting: Regras de alerta quando métricas passam limite   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 🔧 Configuração do Prometheus (prometheus.yml):

```yaml
global:
  scrape_interval: 15s      # Coleta a cada 15 segundos
  evaluation_interval: 15s  # Avalia regras a cada 15 segundos

scrape_configs:
  - job_name: 'bookanga-api'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['bookanga-api:8080']
        labels:
          application: 'Bookanga E-commerce'
          environment: 'docker'

  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

### 📊 Formato das métricas:

```
# /actuator/prometheus retorna:

# HELP http_server_requests_seconds Duration of HTTP server requests
# TYPE http_server_requests_seconds summary
http_server_requests_seconds_count{method="GET",uri="/api/v1/products",status="200"} 150
http_server_requests_seconds_sum{method="GET",uri="/api/v1/products",status="200"} 2.5

# HELP jvm_memory_used_bytes The amount of used memory
# TYPE jvm_memory_used_bytes gauge
jvm_memory_used_bytes{area="heap",id="G1 Eden Space"} 125829120

# HELP process_cpu_usage The CPU usage of the JVM process
# TYPE process_cpu_usage gauge
process_cpu_usage 0.15
```

### 🔍 PromQL - Linguagem de query:

```promql
# Requests por segundo
rate(http_server_requests_seconds_count[5m])

# Tempo médio de resposta
rate(http_server_requests_seconds_sum[5m]) / rate(http_server_requests_seconds_count[5m])

# Percentual de erros (5xx)
sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m])) / 
sum(rate(http_server_requests_seconds_count[5m])) * 100

# Uso de memória heap
jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} * 100
```

---

## 📌 5. GRAFANA

### 💡 O que é?

Plataforma de visualização de dados com dashboards interativos.

### 🔧 Configuração no docker-compose:

```yaml
grafana:
  image: grafana/grafana:latest
  container_name: bookanga-grafana
  environment:
    - GF_SECURITY_ADMIN_USER=admin
    - GF_SECURITY_ADMIN_PASSWORD=admin
  ports:
    - "3000:3000"
```

### 📊 Criando um Dashboard:

1. **Acesse**: http://localhost:3000 (admin/admin)
2. **Adicione Data Source**: Prometheus (http://prometheus:9090)
3. **Crie Dashboard**: New Dashboard → Add Panel
4. **Configure Query PromQL**

### 📈 Painéis úteis:

| Painel | Query PromQL |
|--------|-------------|
| Requests/s | `rate(http_server_requests_seconds_count[5m])` |
| Latência p95 | `histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))` |
| Taxa de Erro | `sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m]))` |
| CPU Usage | `process_cpu_usage * 100` |
| Memory Usage | `jvm_memory_used_bytes{area="heap"} / 1024 / 1024` |
| Active Threads | `jvm_threads_live_threads` |

---

## 📌 6. MÉTRICAS IMPORTANTES

### 📊 RED Method (para serviços):

| Métrica | Descrição | Query |
|---------|-----------|-------|
| **R**ate | Requests por segundo | `rate(http_server_requests_seconds_count[5m])` |
| **E**rrors | Taxa de erros | `rate(http_server_requests_seconds_count{status=~"5.."}[5m])` |
| **D**uration | Latência | `histogram_quantile(0.95, ...)` |

### 📊 USE Method (para recursos):

| Métrica | Descrição | Query |
|---------|-----------|-------|
| **U**tilization | % de uso | `process_cpu_usage` |
| **S**aturation | Fila/espera | `hikaricp_connections_pending` |
| **E**rrors | Erros | `hikaricp_connections_timeout_total` |

### 📊 Métricas JVM:

```promql
# Memória Heap
jvm_memory_used_bytes{area="heap"}

# Garbage Collection
jvm_gc_pause_seconds_sum

# Threads
jvm_threads_live_threads

# Classes carregadas
jvm_classes_loaded_classes
```

### 📊 Métricas de Banco:

```promql
# Conexões ativas
hikaricp_connections_active

# Conexões pendentes
hikaricp_connections_pending

# Tempo de aquisição
hikaricp_connections_acquire_seconds_sum
```

---

## 📌 7. ALERTAS

### 🔔 Configurando alertas no Prometheus:

```yaml
# alert.rules.yml
groups:
  - name: bookanga-alerts
    rules:
      - alert: HighErrorRate
        expr: sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m])) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Taxa de erro alta na API"
          
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Latência p95 acima de 2 segundos"
          
      - alert: HighMemoryUsage
        expr: jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Uso de memória heap acima de 90%"
```

---

## 📌 8. HEALTH CHECKS CUSTOMIZADOS

### 🔧 Criando seu próprio Health Indicator:

```java
@Component
public class DatabaseHealthIndicator implements HealthIndicator {

    private final DataSource dataSource;

    public DatabaseHealthIndicator(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public Health health() {
        try (Connection connection = dataSource.getConnection()) {
            if (connection.isValid(1)) {
                return Health.up()
                    .withDetail("database", "PostgreSQL")
                    .withDetail("status", "Connected")
                    .build();
            }
        } catch (SQLException e) {
            return Health.down()
                .withDetail("error", e.getMessage())
                .build();
        }
        return Health.down().build();
    }
}
```

### 🔧 Health check para serviço externo:

```java
@Component
public class ExternalServiceHealthIndicator implements HealthIndicator {

    private final RestTemplate restTemplate;

    @Override
    public Health health() {
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(
                "https://external-service.com/health", 
                String.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                return Health.up()
                    .withDetail("service", "external-service")
                    .build();
            }
        } catch (Exception e) {
            return Health.down()
                .withException(e)
                .build();
        }
        return Health.down().build();
    }
}
```

---

## 📌 9. MÉTRICAS CUSTOMIZADAS

### 🔧 Criando métricas próprias:

```java
@Service
public class ProductService {

    private final Counter productCreatedCounter;
    private final Timer productSearchTimer;
    
    public ProductService(MeterRegistry registry, ProductRepository repo) {
        this.productRepository = repo;
        
        // Counter - conta eventos
        this.productCreatedCounter = Counter.builder("products_created_total")
            .description("Total de produtos criados")
            .register(registry);
        
        // Timer - mede duração
        this.productSearchTimer = Timer.builder("product_search_duration")
            .description("Tempo de busca de produtos")
            .register(registry);
    }
    
    public Product createProduct(ProductDTO dto) {
        Product product = // ... criação
        productCreatedCounter.increment();  // Incrementa contador
        return product;
    }
    
    public List<Product> searchProducts(String query) {
        return productSearchTimer.record(() -> {  // Mede tempo
            return productRepository.search(query);
        });
    }
}
```

### 📊 Tipos de métricas:

| Tipo | Uso | Exemplo |
|------|-----|---------|
| **Counter** | Contagem incremental | Requests, erros |
| **Gauge** | Valor atual | Conexões ativas, memória |
| **Timer** | Duração | Latência de requests |
| **Histogram** | Distribuição | Percentis de latência |

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Acessar endpoints

```bash
# Suba o projeto
docker-compose up -d

# Acesse os endpoints
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/metrics
curl http://localhost:8080/actuator/prometheus

# Acesse Prometheus
# http://localhost:9090

# Acesse Grafana
# http://localhost:3000 (admin/admin)
```

### Exercício 2: Query PromQL

No Prometheus, execute:
1. Quantos requests por segundo?
2. Qual o uso de memória?
3. Quantas threads ativas?

### Exercício 3: Dashboard Grafana

Crie um dashboard com:
1. Painel de requests por segundo
2. Painel de latência
3. Painel de uso de memória

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Actuator** | Endpoints de gerenciamento do Spring |
| **Prometheus** | Sistema de coleta e armazenamento de métricas |
| **Grafana** | Plataforma de visualização de dashboards |
| **Scraping** | Coleta periódica de métricas |
| **PromQL** | Linguagem de query do Prometheus |
| **RED** | Rate, Errors, Duration |
| **Health Check** | Verificação de saúde da aplicação |
| **Counter** | Métrica incremental |
| **Gauge** | Métrica de valor atual |
| **Timer** | Métrica de duração |

---

## ⏭️ Próximo Módulo

**Módulo 12: SQL e PostgreSQL**

---

**🎉 Parabéns por completar o Módulo 7!**

