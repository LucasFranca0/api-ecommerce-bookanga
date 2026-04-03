# 📚 Módulo 4: Docker e Docker Compose

> **Você não respondeu NENHUMA questão de Docker na prova!**  
> **Tempo estimado:** 4-5 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Essencial para desenvolver e deployar)

---

## 🎯 O que você vai aprender:

1. ✅ O que é Docker e por que usar
2. ✅ Containers vs Máquinas Virtuais
3. ✅ Dockerfile - Criando imagens
4. ✅ Docker Compose - Orquestrando múltiplos containers
5. ✅ Volumes, Networks, Environment Variables
6. ✅ Entender o docker-compose.yml do Bookanga

---

## 📌 1. O QUE É DOCKER?

### 💡 Explicação Simples:

**Docker** é uma plataforma que permite **empacotar** sua aplicação com todas as suas dependências em um **container**.

### 🤔 O Problema que Docker Resolve:

```
Desenvolvedor: "Funciona na minha máquina!" 🤷‍♂️
Servidor: "Aqui não funciona!" 💥

Por quê?
- Versões diferentes de Java
- Bibliotecas faltando
- Configurações diferentes
- Sistema operacional diferente
```

### ✅ Com Docker:

```
Desenvolvedor: "Funciona no meu container!" 🐳
Servidor: "Funciona no meu container também!" ✅

Por quê?
- Mesmo container em qualquer lugar
- Todas as dependências incluídas
- Configuração padronizada
- Ambiente isolado
```

---

## 📌 2. CONTAINERS vs MÁQUINAS VIRTUAIS

### 📊 Comparação:

```
┌─────────────────────────────────────────────────────────────────┐
│                    MÁQUINA VIRTUAL (VM)                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                      │
│  │  App A   │  │  App B   │  │  App C   │                      │
│  ├──────────┤  ├──────────┤  ├──────────┤                      │
│  │  Libs A  │  │  Libs B  │  │  Libs C  │                      │
│  ├──────────┤  ├──────────┤  ├──────────┤                      │
│  │ Guest OS │  │ Guest OS │  │ Guest OS │  ← Cada VM tem SO!   │
│  └──────────┘  └──────────┘  └──────────┘    (pesado)          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      HYPERVISOR                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                   HOST OPERATING SYSTEM                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      HARDWARE                            │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                       DOCKER CONTAINERS                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                      │
│  │  App A   │  │  App B   │  │  App C   │                      │
│  ├──────────┤  ├──────────┤  ├──────────┤                      │
│  │  Libs A  │  │  Libs B  │  │  Libs C  │  ← Só libs, sem SO!  │
│  └──────────┘  └──────────┘  └──────────┘    (leve)            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     DOCKER ENGINE                        │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                   HOST OPERATING SYSTEM                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      HARDWARE                            │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

| Característica | VM | Container |
|----------------|-----|-----------|
| **Tamanho** | GB (inclui SO) | MB (só app + libs) |
| **Inicialização** | Minutos | Segundos |
| **Recursos** | Pesado | Leve |
| **Isolamento** | Total (hardware virtual) | Processo (compartilha kernel) |
| **Uso** | Sistemas completos | Microserviços, apps |

---

## 📌 3. CONCEITOS FUNDAMENTAIS

### 📦 Imagem vs Container:

| Conceito | Analogia | Descrição |
|----------|----------|-----------|
| **Imagem** | Receita de bolo | Template imutável com app + dependências |
| **Container** | Bolo pronto | Instância executando de uma imagem |

```bash
# Imagem = "receita" (não muda)
docker images
# REPOSITORY          TAG       SIZE
# eclipse-temurin     21-jre    200MB

# Container = "instância em execução" (pode ter vários da mesma imagem)
docker ps
# CONTAINER ID   IMAGE              STATUS    NAMES
# abc123         eclipse-temurin    Running   bookanga-api
# def456         eclipse-temurin    Running   bookanga-api-2
```

### 🏗️ Dockerfile → Imagem → Container:

```
┌────────────────┐     docker build     ┌────────────────┐     docker run     ┌────────────────┐
│   Dockerfile   │  ────────────────►   │     Imagem     │  ────────────────► │   Container    │
│   (receita)    │                      │    (pacote)    │                    │  (executando)  │
└────────────────┘                      └────────────────┘                    └────────────────┘
```

---

## 📌 4. DOCKERFILE - Entendendo o do Bookanga

### 🔍 Vamos analisar linha por linha:

```dockerfile
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build
```

| Elemento | Significado |
|----------|-------------|
| `FROM` | Imagem base (ponto de partida) |
| `maven:3.9-eclipse-temurin-21` | Imagem com Maven 3.9 + JDK 21 |
| `AS build` | Nome deste estágio (para referência) |

```dockerfile
WORKDIR /app
```

| Elemento | Significado |
|----------|-------------|
| `WORKDIR` | Define diretório de trabalho (como `cd /app`) |

```dockerfile
# Copia pom.xml e baixa dependências (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B
```

| Elemento | Significado |
|----------|-------------|
| `COPY pom.xml .` | Copia pom.xml do host para o container |
| `RUN mvn dependency:go-offline` | Baixa todas as dependências |
| `-B` | Modo batch (sem interação) |

**🧠 Por que copiar pom.xml ANTES do código?**

Docker usa **cache de layers**. Se pom.xml não mudar, as dependências ficam em cache!

```
Build 1: pom.xml não mudou → CACHE HIT → Pula download (rápido!)
Build 2: pom.xml mudou → CACHE MISS → Baixa tudo de novo (lento)
```

```dockerfile
# Copia código fonte e compila
COPY src ./src
RUN mvn clean package -DskipTests
```

| Elemento | Significado |
|----------|-------------|
| `COPY src ./src` | Copia pasta src para o container |
| `mvn clean package` | Compila e gera o JAR |
| `-DskipTests` | Pula testes (mais rápido para build) |

```dockerfile
# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
```

| Elemento | Significado |
|----------|-------------|
| `FROM` | NOVA imagem base (segundo estágio) |
| `eclipse-temurin:21-jre-alpine` | JRE 21 (só runtime, não JDK) + Alpine Linux (menor) |

**🧠 Por que usar Multi-Stage Build?**

| Stage 1 (build) | Stage 2 (runtime) |
|-----------------|-------------------|
| Maven + JDK (500MB+) | Só JRE (200MB) |
| Código fonte | Só JAR final |
| Ferramentas de build | Nada extra |

Resultado: **Imagem final MUITO menor!**

```dockerfile
WORKDIR /app

# Cria usuário não-root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
```

| Elemento | Significado |
|----------|-------------|
| `addgroup`/`adduser` | Cria usuário não-root (segurança!) |
| `USER spring:spring` | Roda a app como usuário spring |

**🔒 Por que usuário não-root?**
- Se a app for hackeada, invasor não tem acesso root
- Princípio do menor privilégio

```dockerfile
# Copia JAR da stage de build
COPY --from=build /app/target/*.jar app.jar
```

| Elemento | Significado |
|----------|-------------|
| `--from=build` | Copia do stage anterior chamado "build" |
| `/app/target/*.jar` | O JAR gerado |
| `app.jar` | Nome no container |

```dockerfile
# Expõe porta
EXPOSE 8080
```

| Elemento | Significado |
|----------|-------------|
| `EXPOSE` | Documenta que a app usa porta 8080 |
| **NÃO** abre a porta | Só documentação! |

```dockerfile
# Configuração JVM
ENV JAVA_OPTS="-Xms256m -Xmx512m"
```

| Elemento | Significado |
|----------|-------------|
| `ENV` | Define variável de ambiente |
| `-Xms256m` | Memória inicial da JVM |
| `-Xmx512m` | Memória máxima da JVM |

```dockerfile
# Comando de inicialização
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

| Elemento | Significado |
|----------|-------------|
| `ENTRYPOINT` | Comando que roda quando container inicia |
| `java -jar app.jar` | Executa o JAR |
| `$JAVA_OPTS` | Usa a variável de ambiente |

---

## 📌 5. DOCKER COMPOSE - Orquestrando Containers

### 💡 O que é Docker Compose?

Gerencia **múltiplos containers** que trabalham juntos.

No Bookanga temos:
- 🐘 PostgreSQL (banco de dados)
- ☕ API Spring Boot
- 📊 Prometheus (métricas)
- 📈 Grafana (dashboards)

### 🔍 Analisando o docker-compose.yml:

```yaml
services:
  postgres:
    image: postgres:15-alpine
    container_name: bookanga-postgres
    environment:
      POSTGRES_DB: bookanga_db
      POSTGRES_USER: bookanga
      POSTGRES_PASSWORD: bookanga123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - bookanga-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U bookanga -d bookanga_db"]
      interval: 10s
      timeout: 5s
      retries: 5
```

| Elemento | Significado |
|----------|-------------|
| `services` | Lista de containers |
| `postgres` | Nome do serviço |
| `image: postgres:15-alpine` | Usa imagem oficial do PostgreSQL |
| `container_name` | Nome do container |
| `environment` | Variáveis de ambiente para o container |
| `ports: "5432:5432"` | Mapeia porta do host para container |
| `volumes` | Persistência de dados |
| `networks` | Rede para comunicação |
| `healthcheck` | Verifica se o serviço está saudável |

### 🔄 O que é `depends_on` com `service_healthy`?

```yaml
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: bookanga-api
    depends_on:
      postgres:
        condition: service_healthy  # ← Espera postgres estar SAUDÁVEL
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://bookanga-postgres:5432/bookanga_db
```

| Condição | Comportamento |
|----------|---------------|
| Sem condição | Espera container INICIAR (não garante que está pronto!) |
| `service_healthy` | Espera healthcheck PASSAR (garantido que está pronto!) |

**Por que isso importa?**

```
❌ Sem service_healthy:
1. Docker inicia postgres (container sobe)
2. Docker inicia app IMEDIATAMENTE
3. App tenta conectar ao postgres
4. 💥 ERRO! Postgres ainda não aceitando conexões!

✅ Com service_healthy:
1. Docker inicia postgres
2. Docker ESPERA pg_isready retornar OK
3. Docker inicia app
4. ✅ App conecta com sucesso!
```

### 🌐 Por que usamos o nome do container no JDBC URL?

```yaml
SPRING_DATASOURCE_URL: jdbc:postgresql://bookanga-postgres:5432/bookanga_db
#                                        ↑
#                                Nome do container, não localhost!
```

**Porque containers estão em uma rede Docker interna:**

```
┌─────────────────────────────────────────────────────────────┐
│                  bookanga-network (Docker)                  │
│                                                             │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │  bookanga-api   │ ──────► │ bookanga-postgres│           │
│  │  (app)          │         │ (banco)          │           │
│  │                 │         │                  │           │
│  │ "localhost" =   │         │ Escuta em        │           │
│  │  eu mesmo!      │         │ postgres:5432    │           │
│  └─────────────────┘         └─────────────────┘           │
│                                                             │
│  DNS interno: "bookanga-postgres" → IP do container        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📌 6. VOLUMES - Persistindo Dados

### 💡 O Problema:

```bash
# Container é efêmero (temporário)
docker rm bookanga-postgres  # 💥 TODOS OS DADOS PERDIDOS!
```

### ✅ A Solução: Volumes

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
#   ↑              ↑
#   nome volume    caminho dentro do container
```

**Tipos de volumes:**

| Tipo | Sintaxe | Uso |
|------|---------|-----|
| **Named Volume** | `postgres_data:/path` | Produção, dados persistentes |
| **Bind Mount** | `./local:/path` | Desenvolvimento, código fonte |
| **Anonymous** | `/path` | Temporário |

```yaml
# Named Volume (gerenciado pelo Docker)
volumes:
  postgres_data:  # Docker cria e gerencia
  
# Bind Mount (pasta do seu computador)
volumes:
  - ./monitoring/prometheus:/etc/prometheus  # Pasta local mapeada
```

---

## 📌 7. NETWORKS - Comunicação entre Containers

```yaml
networks:
  bookanga-network:
    driver: bridge
```

| Tipo | Uso |
|------|-----|
| `bridge` | Rede isolada para containers se comunicarem |
| `host` | Usa rede do host diretamente |
| `none` | Sem rede |

**Por que criar rede customizada?**

1. **Isolamento**: Containers só veem outros na mesma rede
2. **DNS automático**: Containers se encontram pelo nome
3. **Segurança**: Outros containers não acessam

---

## 📌 8. VARIÁVEIS DE AMBIENTE

### 💡 Por que usar?

```yaml
environment:
  SPRING_DATASOURCE_URL: jdbc:postgresql://bookanga-postgres:5432/bookanga_db
  SPRING_DATASOURCE_USERNAME: bookanga
  SPRING_DATASOURCE_PASSWORD: bookanga123
```

| Benefício | Descrição |
|-----------|-----------|
| **Configuração externa** | Não precisa mudar código |
| **Diferentes ambientes** | Dev, staging, prod |
| **Segurança** | Senhas fora do código |
| **Flexibilidade** | Muda config sem rebuild |

### 🔄 Prioridade no Spring Boot:

```
1. Variáveis de ambiente (maior prioridade)
2. application.properties/yaml
3. Valores padrão no código
```

```java
// No application.properties:
spring.datasource.url=jdbc:postgresql://localhost:5432/local_db

// No docker-compose.yml:
SPRING_DATASOURCE_URL: jdbc:postgresql://bookanga-postgres:5432/bookanga_db

// Resultado: Docker usa bookanga-postgres (variável ambiente vence!)
```

---

## 📌 9. COMANDOS DOCKER ESSENCIAIS

### 🛠️ Comandos do dia a dia:

```bash
# === DOCKER COMPOSE ===

# Subir todos os serviços (em background)
docker-compose up -d

# Ver logs de todos os serviços
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f app

# Parar todos os serviços
docker-compose down

# Parar e remover volumes (APAGA DADOS!)
docker-compose down -v

# Rebuild da imagem
docker-compose up -d --build

# === DOCKER ===

# Listar containers rodando
docker ps

# Listar todos os containers (incluindo parados)
docker ps -a

# Listar imagens
docker images

# Entrar em um container
docker exec -it bookanga-api bash

# Ver logs de um container
docker logs bookanga-api

# Parar um container
docker stop bookanga-api

# Remover um container
docker rm bookanga-api

# Remover uma imagem
docker rmi bookanga-api

# Limpar tudo não usado
docker system prune -a
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Subir o Projeto

```bash
# Entre na pasta do projeto
cd ~/IdeaProjects/api-ecommerce-bookanga

# Suba os containers
docker-compose up -d

# Veja os logs
docker-compose logs -f app

# Acesse a API
curl http://localhost:8080/api/v1/products
```

### Exercício 2: Entre no Container

```bash
# Entre no container do banco
docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db

# Execute SQL
SELECT * FROM product;
\q
```

### Exercício 3: Identifique no docker-compose.yml

1. Quantos serviços existem?
2. Qual porta o Grafana usa?
3. Qual a senha do PostgreSQL?
4. Qual container depende de qual?

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Docker** | Plataforma de containers |
| **Container** | Instância executando de uma imagem |
| **Imagem** | Template imutável para criar containers |
| **Dockerfile** | "Receita" para criar imagens |
| **Docker Compose** | Orquestrador de múltiplos containers |
| **Volume** | Persistência de dados |
| **Network** | Comunicação entre containers |
| **Environment** | Variáveis de configuração |
| **Multi-stage build** | Dockerfile com múltiplos FROMs |
| **Healthcheck** | Verifica se serviço está saudável |

---

## ⏭️ Próximo Módulo

**Módulo 5: Liquibase - Migrations de Banco de Dados**
- Como o Bookanga gerencia o schema do banco

---

**🎉 Parabéns por completar o Módulo 4!**

Agora você entende Docker!

