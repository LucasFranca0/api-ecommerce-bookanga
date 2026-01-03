# 🐳 Ambiente Docker Completo - Bookanga API

## 🚀 Início Rápido (Apenas 1 comando!)

```bash
./docker.sh start
```

Isso irá:
- ✅ Criar e iniciar PostgreSQL 15
- ✅ Compilar a aplicação Spring Boot
- ✅ Rodar Liquibase migrations
- ✅ Inserir massa de dados de teste
- ✅ Subir a API na porta 8080

**Pronto! Tudo rodando em containers!** 🎉

## 📋 O que está incluído?

### 🐘 PostgreSQL 15
- Porta: `5432`
- Database: `bookanga_db`
- User: `bookanga`
- Password: `bookanga123`

### 🍃 Spring Boot API
- Porta: `8080`
- Endpoints REST disponíveis
- JPA + Hibernate
- Lombok configurado

### 💧 Liquibase
- Migrations automáticas
- Versionamento de schema
- Massa de dados de teste

## 📦 Massa de Dados Incluída

### Livros (5 itens)
1. Dom Quixote - Miguel de Cervantes
2. A Metamorfose - Franz Kafka
3. O Senhor dos Anéis - J.R.R. Tolkien
4. 1984 - George Orwell
5. Cem Anos de Solidão - Gabriel García Márquez

### Mangás (7 itens)
1. One Piece Vol. 1 - Eiichiro Oda
2. Naruto Vol. 1 - Masashi Kishimoto
3. Berserk Vol. 1 - Kentaro Miura
4. Attack on Titan Vol. 1 - Hajime Isayama
5. Death Note Vol. 1 - Tsugumi Ohba
6. Fullmetal Alchemist Vol. 1 - Hiromu Arakawa
7. My Hero Academia Vol. 1 - Kohei Horikoshi

## 🎮 Comandos Disponíveis

```bash
./docker.sh start      # Inicia tudo (PostgreSQL + API)
./docker.sh stop       # Para todos os containers
./docker.sh restart    # Reinicia tudo
./docker.sh rebuild    # Reconstrói a aplicação
./docker.sh logs       # Ver logs de tudo
./docker.sh logs app   # Ver logs só da API
./docker.sh logs postgres  # Ver logs só do PostgreSQL
./docker.sh status     # Status dos containers
./docker.sh psql       # Conectar no banco via CLI
./docker.sh reset      # Apaga tudo e recria do zero
./docker.sh clean      # Remove containers e imagens
./docker.sh shell app  # Shell dentro do container da API
./docker.sh shell postgres  # Shell do PostgreSQL
```

## 🧪 Testando a API

### Verificar se está rodando
```bash
curl http://localhost:8080/actuator/health
```

### Listar produtos (exemplo)
```bash
curl http://localhost:8080/api/products
```

### Ver dados no banco
```bash
./docker.sh psql
```

Dentro do psql:
```sql
-- Listar todas as tabelas
\dt

-- Ver produtos
SELECT * FROM product;

-- Contar livros
SELECT COUNT(*) FROM product WHERE product_type = 'book';

-- Contar mangás
SELECT COUNT(*) FROM product WHERE product_type = 'manga';

-- Sair
\q
```

## 📂 Estrutura Liquibase

```
src/main/resources/db/changelog/
├── db.changelog-master.yaml          # Master changelog
└── changes/
    ├── 001-create-product-table.yaml # Cria tabela product
    └── 002-insert-test-data.yaml     # Insere dados de teste
```

### Como adicionar novas migrations

1. Crie um novo arquivo em `src/main/resources/db/changelog/changes/`
   ```yaml
   # 003-add-new-column.yaml
   databaseChangeLog:
     - changeSet:
         id: 003-add-new-column
         author: seu-nome
         changes:
           - addColumn:
               tableName: product
               columns:
                 - column:
                     name: description
                     type: TEXT
   ```

2. Adicione ao master changelog:
   ```yaml
   # db.changelog-master.yaml
   databaseChangeLog:
     - include:
         file: db/changelog/changes/001-create-product-table.yaml
     - include:
         file: db/changelog/changes/002-insert-test-data.yaml
     - include:
         file: db/changelog/changes/003-add-new-column.yaml
   ```

3. Rebuilde o container:
   ```bash
   ./docker.sh rebuild
   ```

## 🔧 Configurações

### Variáveis de Ambiente

O `docker-compose.yml` já está configurado com todas as variáveis necessárias:

```yaml
environment:
  SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/bookanga_db
  SPRING_DATASOURCE_USERNAME: bookanga
  SPRING_DATASOURCE_PASSWORD: bookanga123
```

### Application Properties

O arquivo `application.properties` está configurado para:
- ✅ Conectar no PostgreSQL
- ✅ Usar Liquibase
- ✅ Hibernate DDL modo `none` (Liquibase gerencia o schema)
- ✅ Show SQL ativado para debug

## 🐛 Troubleshooting

### Container não sobe

```bash
# Ver logs detalhados
./docker.sh logs

# Verificar erros específicos
./docker.sh logs app
./docker.sh logs postgres
```

### Erro de conexão com banco

```bash
# Verificar se PostgreSQL está pronto
docker exec bookanga-postgres pg_isready -U bookanga

# Ver logs do PostgreSQL
./docker.sh logs postgres
```

### Rebuildar tudo do zero

```bash
# Apaga containers, volumes e imagens
./docker.sh clean

# Sobe tudo novamente
./docker.sh start
```

### Migrations não rodaram

```bash
# Conectar no banco e verificar
./docker.sh psql

-- Ver migrations executadas
SELECT * FROM databasechangelog ORDER BY dateexecuted DESC;
```

### Aplicação não compila

```bash
# Rebuildar com cache limpo
./docker.sh rebuild

# Ou manualmente
docker compose down
docker compose build --no-cache
docker compose up -d
```

## 📊 Healthcheck

O PostgreSQL tem healthcheck configurado:
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U bookanga -d bookanga_db"]
  interval: 10s
  timeout: 5s
  retries: 5
```

A API só sobe depois que o PostgreSQL estiver healthy:
```yaml
depends_on:
  postgres:
    condition: service_healthy
```

## 🎯 Próximos Passos

1. ✅ Ambiente totalmente dockerizado
2. ⬜ Adicionar Swagger/OpenAPI
3. ⬜ Configurar profiles (dev/prod)
4. ⬜ Adicionar Redis cache
5. ⬜ CI/CD com GitHub Actions
6. ⬜ Kubernetes manifests

## 📝 Notas Importantes

- 🔒 **Produção**: Troque as senhas padrão!
- 💾 **Dados**: Os dados persistem no volume `postgres_data`
- 🔄 **Migrations**: Liquibase gerencia o schema automaticamente
- 🚀 **Build**: Multi-stage Dockerfile otimizado
- 🐳 **Imagens**: Alpine Linux para menor tamanho

## 🎉 Benefícios

✅ **Zero configuração local** - Tudo roda em Docker  
✅ **Reprodutível** - Mesmo ambiente para todos  
✅ **Isolado** - Não interfere com outras aplicações  
✅ **Versionado** - Migrations controladas pelo Liquibase  
✅ **Testável** - Massa de dados já incluída  
✅ **Rápido** - Multi-stage build otimizado  

---

**Ambiente pronto para desenvolvimento! 🚀**
