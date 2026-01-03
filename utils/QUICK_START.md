# 🚀 Quick Start - API E-commerce Bookanga

## Configuração PostgreSQL + Docker

### 1️⃣ Iniciar o Banco de Dados

```bash
# Opção 1: Usando o script helper
./docker.sh start

# Opção 2: Comando direto
docker compose up -d
```

### 2️⃣ Verificar Status

```bash
./docker.sh status
```

Você deve ver:
```
bookanga-postgres   postgres:15-alpine   Up   0.0.0.0:5432->5432/tcp
```

### 3️⃣ Compilar o Projeto

```bash
mvn clean package
```

### 4️⃣ Rodar a Aplicação

```bash
# Ir para o diretório target
cd target

# Rodar o JAR
java -jar api-ecommerce-1.0-SNAPSHOT.jar
```

Ou se tiver uma classe Main específica:

```bash
mvn spring-boot:run
```

---

## 📋 Comandos Úteis

### Docker

```bash
./docker.sh start     # Inicia PostgreSQL
./docker.sh stop      # Para PostgreSQL
./docker.sh restart   # Reinicia PostgreSQL
./docker.sh logs      # Ver logs em tempo real
./docker.sh psql      # Conectar ao banco via CLI
./docker.sh reset     # Resetar banco (apaga tudo!)
```

### Maven

```bash
mvn clean             # Limpa o projeto
mvn compile           # Compila
mvn package           # Gera o JAR
mvn clean install     # Compila e instala
```

### Verificar Conexão PostgreSQL

```bash
docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db -c "\dt"
```

---

## 🔧 Configuração do Banco

| Propriedade | Valor |
|------------|-------|
| **Host** | localhost |
| **Porta** | 5432 |
| **Database** | bookanga_db |
| **Usuário** | bookanga |
| **Senha** | bookanga123 |

---

## ⚠️ Troubleshooting

### Erro: "Porta 5432 já em uso"

Se você já tem PostgreSQL instalado localmente:

1. Edite o `docker-compose.yml`:
```yaml
ports:
  - "5433:5432"  # Muda para 5433
```

2. Edite o `application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/bookanga_db
```

### Erro de compilação Java

Certifique-se de estar usando Java 17 ou 21:
```bash
java -version
```

Se necessário, configure o JAVA_HOME correto.

### Container não inicia

```bash
# Ver logs detalhados
docker compose logs -f

# Resetar tudo
docker compose down -v
docker compose up -d
```

---

## 📦 O que foi configurado?

✅ PostgreSQL 15 no Docker  
✅ Driver PostgreSQL no pom.xml  
✅ application.properties configurado  
✅ Maven Compiler Plugin 3.11.0  
✅ Lombok 1.18.30 (compatível com Java 21)  
✅ Script helper para gerenciar Docker  
✅ .gitignore configurado  

---

## 🎯 Próximos Passos

1. Verifique se a aplicação está rodando:
```bash
curl http://localhost:8080
```

2. Teste os endpoints da API

3. Veja os dados inseridos automaticamente pelo `data.sql`

---

**Dúvidas?** Consulte o `README_DOCKER.md` para mais detalhes.
