# Tabelas de Histórico e Auditoria

## Tabelas Criadas

### 1. product_hist
Tabela de histórico para rastrear todas as alterações em produtos.

**Campos:**
- `hist_id` (PK): ID único do histórico
- `product_id`: ID do produto
- `title`, `author`, `publication_year`, `price`, `isbn`, `genre`, `language`, `product_type`, `volume`: Cópias dos dados do produto
- `operation_type`: Tipo de operação (INSERT, UPDATE, DELETE)
- `changed_by`: Usuário que fez a alteração
- `changed_at`: Data/hora da alteração
- `changes_json`: JSON com valores antigos e novos

### 2. user_hist
Tabela de histórico para rastrear alterações em usuários.

**Campos:**
- `hist_id` (PK): ID único do histórico
- `user_id`: ID do usuário
- `name`, `email`: Dados do usuário (senha não é armazenada por segurança)
- `operation_type`: Tipo de operação (INSERT, UPDATE, DELETE)
- `changed_by`: Usuário que fez a alteração
- `changed_at`: Data/hora da alteração
- `changes_json`: JSON com valores antigos e novos

### 3. sale_hist
Tabela de histórico para rastrear alterações em vendas.

**Campos:**
- `hist_id` (PK): ID único do histórico
- `sale_id`: ID da venda
- `user_id`, `date`, `total_price`: Dados da venda
- `operation_type`: Tipo de operação (INSERT, UPDATE, DELETE)
- `changed_by`: Usuário que fez a alteração
- `changed_at`: Data/hora da alteração
- `changes_json`: JSON com valores antigos e novos

### 4. audit_log
Tabela de auditoria geral do sistema.

**Campos:**
- `id` (PK): ID único do log
- `table_name`: Nome da tabela afetada
- `record_id`: ID do registro afetado
- `operation_type`: Tipo de operação (INSERT, UPDATE, DELETE)
- `user_email`: Email do usuário que fez a alteração
- `ip_address`: Endereço IP da requisição
- `user_agent`: User agent do browser/cliente
- `old_values`: JSON com valores antigos
- `new_values`: JSON com valores novos
- `timestamp`: Data/hora da operação
- `description`: Descrição adicional da operação

### 5. price_history
Tabela específica para rastrear alterações de preço.

**Campos:**
- `id` (PK): ID único
- `product_id`: ID do produto
- `old_price`: Preço antigo
- `new_price`: Preço novo
- `changed_by`: Usuário que fez a alteração
- `changed_at`: Data/hora da alteração
- `reason`: Motivo da alteração de preço

## Triggers Automáticos

Foram criados triggers PostgreSQL para automaticamente popular as tabelas de histórico:

1. **product_history_trigger**: Dispara após INSERT, UPDATE ou DELETE na tabela `product`
2. **user_history_trigger**: Dispara após INSERT, UPDATE ou DELETE na tabela `users`
3. **sale_history_trigger**: Dispara após INSERT, UPDATE ou DELETE na tabela `sale`

## Índices Criados

Para melhor performance nas consultas de histórico:

- Índices em todos os campos `*_id` das tabelas de histórico
- Índices em todos os campos `changed_at` para busca por data
- Índices em `table_name`, `record_id`, `timestamp` e `user_email` na tabela `audit_log`

## Consultas de Exemplo

### Verificar histórico de um produto
```sql
SELECT * FROM product_hist 
WHERE product_id = 1 
ORDER BY changed_at DESC;
```

### Ver alterações de preço de um produto
```sql
SELECT * FROM price_history 
WHERE product_id = 1 
ORDER BY changed_at DESC;
```

### Auditoria geral por usuário
```sql
SELECT * FROM audit_log 
WHERE user_email = 'user@example.com' 
ORDER BY timestamp DESC;
```

### Ver todas as operações de DELETE
```sql
SELECT * FROM audit_log 
WHERE operation_type = 'DELETE' 
ORDER BY timestamp DESC;
```

## Como Aplicar

Execute o Liquibase para aplicar as migrações:

```bash
cd /home/lucas/IdeaProjects/api-ecommerce-bookanga
mvn liquibase:update
```

Ou inicie a aplicação Spring Boot que aplicará automaticamente as mudanças:

```bash
mvn spring-boot:run
```
