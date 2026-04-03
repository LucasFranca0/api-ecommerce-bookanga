# 📚 Módulo 5: Liquibase - Migrations de Banco de Dados

> **Tempo estimado:** 2-3 horas  
> **Importância:** ⭐⭐⭐⭐ (Essencial para gerenciar schema do banco)

---

## 🎯 O que você vai aprender:

1. ✅ O que é Liquibase e por que usar
2. ✅ Conceito de Database Migrations
3. ✅ Estrutura dos arquivos de changelog
4. ✅ ChangeSets e como funcionam
5. ✅ Rollback - Desfazendo mudanças
6. ✅ Como resolver o erro do Bookanga

---

## 📌 1. O QUE É LIQUIBASE?

### 💡 Explicação Simples:

**Liquibase** é uma ferramenta de **versionamento de banco de dados**. Assim como o Git versiona código, Liquibase versiona o schema do banco.

### 🤔 O Problema que Liquibase Resolve:

```
Sem Liquibase:
- "Rodou o script de criação de tabela?" 🤷
- "Qual versão do schema está em produção?" 😰
- "Quem alterou a tabela users?" 😤
- Scripts SQL espalhados em pastas
- Banco de dev diferente de prod

Com Liquibase:
- Histórico completo de todas as alterações ✅
- Sabe exatamente o estado de cada ambiente ✅
- Rastreabilidade de quem fez o quê ✅
- Migrations organizadas e versionadas ✅
- Todos os ambientes iguais ✅
```

---

## 📌 2. CONCEITO DE MIGRATIONS

### 💡 O que é uma Migration?

Uma **migration** é um script versionado que altera o schema do banco de dados.

```
┌─────────────────────────────────────────────────────────────────┐
│                    LINHA DO TEMPO                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  001                    002                    003              │
│  create_product         insert_data           add_column        │
│       │                     │                     │             │
│       ▼                     ▼                     ▼             │
│  ┌─────────┐           ┌─────────┐           ┌─────────┐       │
│  │ CREATE  │ ────────► │ INSERT  │ ────────► │ ALTER   │       │
│  │ TABLE   │           │ INTO    │           │ TABLE   │       │
│  └─────────┘           └─────────┘           └─────────┘       │
│                                                                 │
│  Estado 1              Estado 2              Estado 3           │
│  (tabela vazia)        (com dados)           (coluna nova)      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### ✅ Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Versionamento** | Cada mudança tem um ID único |
| **Rastreabilidade** | Sabe quem, quando e o quê mudou |
| **Reprodutibilidade** | Qualquer ambiente fica igual |
| **Rollback** | Pode desfazer mudanças |
| **Automação** | Aplica mudanças automaticamente |

---

## 📌 3. ESTRUTURA NO PROJETO BOOKANGA

### 📁 Estrutura de arquivos:

```
src/main/resources/
└── db/
    └── changelog/
        ├── db.changelog-master.yaml    ← Arquivo principal
        └── changes/
            ├── 001-create-product-table.yaml
            ├── 002-insert-test-data.yaml
            ├── 003-create-history-tables.yaml
            └── 004-create-triggers.yaml
```

### 🔍 O arquivo master (db.changelog-master.yaml):

```yaml
databaseChangeLog:
  - include:
      file: db/changelog/changes/001-create-product-table.yaml
  - include:
      file: db/changelog/changes/002-insert-test-data.yaml
  - include:
      file: db/changelog/changes/003-create-history-tables.yaml
  - include:
      file: db/changelog/changes/004-create-triggers.yaml
```

**🧠 Por que um arquivo master?**
- Centraliza todos os changelogs
- Define a ordem de execução
- Facilita organização

---

## 📌 4. CHANGESET - Unidade de Mudança

### 🔍 Anatomia de um ChangeSet:

```yaml
databaseChangeLog:
  - changeSet:
      id: 001-create-product-table      # ID único
      author: bookanga                   # Quem criou
      changes:
        - createTable:
            tableName: product
            columns:
              - column:
                  name: id
                  type: BIGSERIAL
                  constraints:
                    primaryKey: true
                    nullable: false
              - column:
                  name: title
                  type: VARCHAR(255)
                  constraints:
                    nullable: false
```

| Elemento | Obrigatório | Descrição |
|----------|-------------|-----------|
| `id` | ✅ Sim | Identificador único do changeset |
| `author` | ✅ Sim | Quem criou a mudança |
| `changes` | ✅ Sim | Lista de mudanças a aplicar |
| `context` | ❌ Não | Contexto (dev, prod, test) |
| `labels` | ❌ Não | Rótulos para filtragem |
| `preConditions` | ❌ Não | Condições antes de executar |
| `rollback` | ❌ Não | Como desfazer a mudança |

### 🆔 Por que ID único é importante?

```
┌───────────────────────────────────────────────────────────────┐
│                 TABELA DATABASECHANGELOG                      │
├───────────────────────────────────────────────────────────────┤
│ ID                          │ AUTHOR    │ DATEEXECUTED        │
├─────────────────────────────┼───────────┼─────────────────────┤
│ 001-create-product-table    │ bookanga  │ 2026-01-01 10:00:00 │
│ 002-insert-test-data        │ bookanga  │ 2026-01-01 10:00:01 │
│ 003-create-history-tables   │ bookanga  │ 2026-01-01 10:00:02 │
└───────────────────────────────────────────────────────────────┘

O Liquibase sabe quais changesets já foram executados!
```

---

## 📌 5. TIPOS DE MUDANÇAS (Changes)

### 📊 Mudanças de estrutura:

```yaml
# Criar tabela
- createTable:
    tableName: product
    columns:
      - column:
          name: id
          type: BIGSERIAL
          constraints:
            primaryKey: true

# Adicionar coluna
- addColumn:
    tableName: product
    columns:
      - column:
          name: description
          type: TEXT

# Remover coluna
- dropColumn:
    tableName: product
    columnName: old_column

# Renomear coluna
- renameColumn:
    tableName: product
    oldColumnName: titulo
    newColumnName: title

# Criar índice
- createIndex:
    tableName: product
    indexName: idx_product_genre
    columns:
      - column:
          name: genre

# Adicionar foreign key
- addForeignKeyConstraint:
    baseTableName: sale_item
    baseColumnNames: product_id
    referencedTableName: product
    referencedColumnNames: id
    constraintName: fk_sale_item_product
```

### 📊 Mudanças de dados:

```yaml
# Inserir dados
- insert:
    tableName: product
    columns:
      - column:
          name: title
          value: "1984"
      - column:
          name: author
          value: "George Orwell"

# Atualizar dados
- update:
    tableName: product
    columns:
      - column:
          name: price
          valueNumeric: 29.90
    where: id = 1

# Deletar dados
- delete:
    tableName: product
    where: id = 999

# SQL customizado
- sql:
    sql: UPDATE product SET updated_at = NOW()
```

---

## 📌 6. ROLLBACK - Desfazendo Mudanças

### 💡 Rollback Automático:

Para algumas mudanças, Liquibase sabe desfazer automaticamente:

| Mudança | Rollback Automático |
|---------|---------------------|
| `createTable` | `dropTable` |
| `addColumn` | `dropColumn` |
| `createIndex` | `dropIndex` |
| `insert` | ❌ Não tem |
| `update` | ❌ Não tem |

### 🔧 Rollback Manual:

```yaml
- changeSet:
    id: 003-add-column
    author: lucas
    changes:
      - addColumn:
          tableName: product
          columns:
            - column:
                name: rating
                type: DECIMAL(3,2)
    rollback:
      - dropColumn:
          tableName: product
          columnName: rating
```

### 🛠️ Comandos de Rollback:

```bash
# Rollback do último changeset
mvn liquibase:rollback -Dliquibase.rollbackCount=1

# Rollback até uma tag
mvn liquibase:rollback -Dliquibase.rollbackTag=v1.0

# Rollback até uma data
mvn liquibase:rollback -Dliquibase.rollbackDate="2026-01-01"
```

---

## 📌 7. CONFIGURAÇÃO NO SPRING BOOT

### 📋 application.properties:

```properties
# Habilita Liquibase
spring.liquibase.enabled=true

# Arquivo principal de changelog
spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.yaml

# IMPORTANTE: Desabilita Hibernate DDL (Liquibase gerencia o schema)
spring.jpa.hibernate.ddl-auto=none
```

### ⚠️ Por que `ddl-auto=none`?

```
Se ddl-auto=update e liquibase.enabled=true:
  → Hibernate tenta criar tabelas
  → Liquibase tenta criar tabelas
  → CONFLITO! Dependência circular!
  
Solução:
  → ddl-auto=none (Hibernate não mexe no schema)
  → Liquibase gerencia tudo
```

---

## 📌 8. O ERRO DO BOOKANGA

### 🔴 O erro que você viu:

```
Circular depends-on relationship between 'liquibase' and 'entityManagerFactory'
```

### 🤔 Por que acontece?

```
1. Spring tenta criar EntityManagerFactory (JPA/Hibernate)
2. Hibernate precisa validar entities contra o banco
3. Mas banco ainda não tem as tabelas!
4. Liquibase deveria criar as tabelas
5. Mas Liquibase depende do DataSource
6. DataSource já está criado, mas EntityManagerFactory ainda não terminou
7. LOOP! Dependência circular!
```

### ✅ Solução:

```properties
# 1. Garantir que Hibernate não valide antes do Liquibase
spring.jpa.hibernate.ddl-auto=none

# 2. Desabilitar inicialização de SQL (se houver data.sql)
spring.sql.init.mode=never

# 3. Desabilitar open-in-view
spring.jpa.open-in-view=false
```

Se ainda não resolver, você pode forçar a ordem no código:

```java
@Configuration
public class LiquibaseConfig {
    
    @Bean
    @DependsOn("liquibase")  // EntityManager só cria depois do Liquibase
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(
            EntityManagerFactoryBuilder builder, DataSource dataSource) {
        // configuração
    }
}
```

---

## 📌 9. BOAS PRÁTICAS

### ✅ Faça:

1. **Um changeset = uma mudança lógica**
   ```yaml
   # BOM: changeset focado
   - changeSet:
       id: 005-add-email-column
       changes:
         - addColumn: ...
   ```

2. **IDs descritivos e ordenados**
   ```yaml
   id: 001-create-product-table
   id: 002-insert-initial-data
   id: 003-add-category-column
   ```

3. **Sempre defina author**
   ```yaml
   author: lucas
   ```

4. **Teste rollback em desenvolvimento**

5. **Nunca altere changeset já executado em produção**

### ❌ Não faça:

1. **Alterar changeset já executado**
   ```
   Liquibase calcula hash do changeset.
   Se mudar, erro! Checksum mismatch!
   ```

2. **Changesets muito grandes**
   ```yaml
   # RUIM: muitas mudanças em um changeset
   - changeSet:
       id: 001-everything
       changes:
         - createTable: product
         - createTable: user
         - createTable: sale
         - insert: ...
         - insert: ...
   ```

3. **IDs genéricos**
   ```yaml
   # RUIM
   id: 1
   id: change1
   ```

---

## 📌 10. FORMATOS DE CHANGELOG

Liquibase suporta vários formatos:

### YAML (usado no Bookanga):
```yaml
databaseChangeLog:
  - changeSet:
      id: 001
      author: lucas
      changes:
        - createTable:
            tableName: product
```

### XML:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog>
    <changeSet id="001" author="lucas">
        <createTable tableName="product">
            <column name="id" type="BIGSERIAL"/>
        </createTable>
    </changeSet>
</databaseChangeLog>
```

### SQL:
```sql
--liquibase formatted sql
--changeset lucas:001
CREATE TABLE product (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255)
);
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Crie uma nova migration

Crie o arquivo `005-add-description-column.yaml`:

```yaml
databaseChangeLog:
  - changeSet:
      id: 005-add-description-column
      author: lucas
      changes:
        - addColumn:
            tableName: product
            columns:
              - column:
                  name: description
                  type: TEXT
      rollback:
        - dropColumn:
            tableName: product
            columnName: description
```

### Exercício 2: Adicione ao master

Edite `db.changelog-master.yaml`:

```yaml
databaseChangeLog:
  # ... outros includes ...
  - include:
      file: db/changelog/changes/005-add-description-column.yaml
```

### Exercício 3: Verifique o status

```bash
# Ver changesets pendentes
mvn liquibase:status

# Aplicar changesets
mvn liquibase:update
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Migration** | Script versionado de alteração de banco |
| **ChangeLog** | Arquivo com lista de changesets |
| **ChangeSet** | Unidade atômica de mudança |
| **ID** | Identificador único do changeset |
| **Author** | Quem criou a mudança |
| **Rollback** | Desfazer uma mudança |
| **DATABASECHANGELOG** | Tabela de controle do Liquibase |
| **Checksum** | Hash para detectar alterações |

---

## ⏭️ Próximo Módulo

**Módulo 6: API REST e Boas Práticas**
- Métodos HTTP
- Status Codes
- Design de endpoints

---

**🎉 Parabéns por completar o Módulo 5!**

