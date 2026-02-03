# 🐳 Docker Setup - API E-commerce Bookanga

## Pré-requisitos

- Docker instalado
- Docker Compose instalado

## Como usar

### 1. Iniciar o PostgreSQL

```bash
docker-compose up -d
```

Este comando irá:
- Baixar a imagem do PostgreSQL 15 (Alpine)
- Criar um container chamado `bookanga-postgres`
- Criar o banco de dados `bookanga_db`
- Expor a porta 5432

### 2. Verificar se o container está rodando

```bash
docker-compose ps
```

### 3. Ver os logs do PostgreSQL

```bash
docker-compose logs -f postgres
```

### 4. Parar o container

```bash
docker-compose down
```

### 5. Parar e remover volumes (apaga os dados)

```bash
docker-compose down -v
```

## Configurações do Banco de Dados

- **Host**: localhost
- **Porta**: 5432
- **Database**: bookanga_db
- **Usuário**: bookanga
- **Senha**: bookanga123

## Conectar ao PostgreSQL via CLI

```bash
docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db
```

## Comandos úteis do PostgreSQL

Dentro do psql:

```sql
-- Listar tabelas
\dt

-- Descrever estrutura de uma tabela
\d nome_da_tabela

-- Listar todos os bancos de dados
\l

-- Sair
\q
```

## Backup e Restore

### Fazer backup

```bash
docker exec bookanga-postgres pg_dump -U bookanga bookanga_db > backup.sql
```

### Restaurar backup

```bash
docker exec -i bookanga-postgres psql -U bookanga bookanga_db < backup.sql
```

## Troubleshooting

### Porta 5432 já em uso

Se você já tem PostgreSQL instalado localmente, pode mudar a porta no `docker-compose.yml`:

```yaml
ports:
  - "5433:5432"  # Muda para porta 5433 no host
```

E atualizar o `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/bookanga_db
```

### Resetar o banco de dados

```bash
docker-compose down -v
docker-compose up -d
```
