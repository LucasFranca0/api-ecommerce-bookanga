# 📚 Módulo 12: SQL e PostgreSQL

> **Tempo estimado:** 3-4 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Base de qualquer aplicação)

---

## 🎯 O que você vai aprender:

1. ✅ Fundamentos de SQL
2. ✅ CRUD (SELECT, INSERT, UPDATE, DELETE)
3. ✅ JOINs e relacionamentos
4. ✅ PostgreSQL específico
5. ✅ Índices e performance
6. ✅ Queries do Bookanga

---

## 📌 1. FUNDAMENTOS DE SQL

### 💡 O que é SQL?

**SQL** (Structured Query Language) é a linguagem padrão para manipular bancos de dados relacionais.

### 📊 Estrutura do PostgreSQL:

```
┌─────────────────────────────────────────────────────────────────┐
│                       PostgreSQL                                │
├─────────────────────────────────────────────────────────────────┤
│   Cluster (Instalação)                                         │
│   └── Database (bookanga_db)                                   │
│       └── Schema (public)                                      │
│           ├── Table (product)                                  │
│           ├── Table (sale)                                     │
│           ├── Table (user)                                     │
│           ├── Index (idx_product_genre)                        │
│           └── Sequence (product_id_seq)                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📌 2. CRUD - Operações Básicas

### 📖 SELECT (Read)

```sql
-- Selecionar tudo
SELECT * FROM product;

-- Selecionar colunas específicas
SELECT id, title, author, price FROM product;

-- Com alias (apelido)
SELECT 
    p.title AS titulo,
    p.author AS autor,
    p.price AS preco
FROM product p;

-- Com filtro (WHERE)
SELECT * FROM product WHERE genre = 'Fiction';

-- Múltiplos filtros
SELECT * FROM product 
WHERE genre = 'Fiction' 
  AND price < 50.00
  AND language = 'pt-BR';

-- OU (OR)
SELECT * FROM product 
WHERE genre = 'Fiction' OR genre = 'Romance';

-- IN (lista de valores)
SELECT * FROM product 
WHERE genre IN ('Fiction', 'Romance', 'Horror');

-- LIKE (padrão de texto)
SELECT * FROM product WHERE title LIKE '%1984%';
SELECT * FROM product WHERE title LIKE 'O%';  -- Começa com O
SELECT * FROM product WHERE title LIKE '%a';  -- Termina com a

-- ILIKE (case insensitive - PostgreSQL)
SELECT * FROM product WHERE title ILIKE '%guerra%';

-- BETWEEN (intervalo)
SELECT * FROM product WHERE price BETWEEN 20.00 AND 50.00;

-- NULL
SELECT * FROM product WHERE volume IS NULL;
SELECT * FROM product WHERE volume IS NOT NULL;

-- Ordenação
SELECT * FROM product ORDER BY price ASC;
SELECT * FROM product ORDER BY price DESC;
SELECT * FROM product ORDER BY genre, price DESC;

-- Limite
SELECT * FROM product LIMIT 10;
SELECT * FROM product LIMIT 10 OFFSET 20;  -- Paginação

-- Distinct (únicos)
SELECT DISTINCT genre FROM product;
```

### ➕ INSERT (Create)

```sql
-- Inserir um registro
INSERT INTO product (title, author, price, isbn, genre, language, product_type)
VALUES ('1984', 'George Orwell', 29.90, '9780451524935', 'Fiction', 'en', 'book');

-- Inserir múltiplos
INSERT INTO product (title, author, price, isbn, genre, language, product_type)
VALUES 
    ('Brave New World', 'Aldous Huxley', 34.90, '9780060850524', 'Fiction', 'en', 'book'),
    ('Fahrenheit 451', 'Ray Bradbury', 27.90, '9781451673319', 'Fiction', 'en', 'book');

-- Inserir e retornar o ID
INSERT INTO product (title, author, price, isbn, genre, language, product_type)
VALUES ('New Book', 'Author', 25.00, '1234567890', 'Fiction', 'en', 'book')
RETURNING id;
```

### ✏️ UPDATE (Update)

```sql
-- Atualizar registro
UPDATE product 
SET price = 35.90 
WHERE id = 1;

-- Atualizar múltiplos campos
UPDATE product 
SET 
    price = 35.90,
    genre = 'Classic Fiction'
WHERE id = 1;

-- Atualizar com cálculo
UPDATE product 
SET price = price * 1.10  -- Aumenta 10%
WHERE genre = 'Fiction';

-- Atualizar baseado em outra tabela
UPDATE product p
SET price = p.price * 0.9  -- 10% desconto
FROM sale_item si
WHERE p.id = si.product_id
  AND si.sale_id = 1;

-- Atualizar e retornar
UPDATE product 
SET price = 39.90 
WHERE id = 1
RETURNING *;
```

### 🗑️ DELETE (Delete)

```sql
-- Deletar registro
DELETE FROM product WHERE id = 1;

-- Deletar com condição
DELETE FROM product WHERE genre = 'Test';

-- Deletar todos (CUIDADO!)
DELETE FROM product;

-- Deletar com subquery
DELETE FROM product 
WHERE id IN (SELECT product_id FROM old_products);

-- Soft Delete (melhor prática)
UPDATE product SET deleted = true WHERE id = 1;
```

---

## 📌 3. FUNÇÕES DE AGREGAÇÃO

```sql
-- COUNT (contar)
SELECT COUNT(*) FROM product;
SELECT COUNT(*) FROM product WHERE genre = 'Fiction';

-- SUM (somar)
SELECT SUM(price) FROM product;

-- AVG (média)
SELECT AVG(price) FROM product;

-- MIN e MAX
SELECT MIN(price), MAX(price) FROM product;

-- GROUP BY (agrupar)
SELECT 
    genre,
    COUNT(*) as quantidade,
    AVG(price) as preco_medio,
    MIN(price) as menor_preco,
    MAX(price) as maior_preco
FROM product
GROUP BY genre;

-- HAVING (filtro pós-agrupamento)
SELECT 
    genre,
    COUNT(*) as quantidade
FROM product
GROUP BY genre
HAVING COUNT(*) > 5;

-- Combinando
SELECT 
    genre,
    language,
    COUNT(*) as total,
    ROUND(AVG(price), 2) as media
FROM product
WHERE product_type = 'book'
GROUP BY genre, language
HAVING COUNT(*) >= 2
ORDER BY total DESC;
```

---

## 📌 4. JOINs - Unindo Tabelas

### 📊 Tipos de JOIN:

```
┌───────────────────────────────────────────────────────────────┐
│                        TIPOS DE JOIN                          │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│   INNER JOIN          LEFT JOIN           RIGHT JOIN          │
│   ┌───┬───┐           ┌───┬───┐           ┌───┬───┐          │
│   │ A │ B │           │ A │ B │           │ A │ B │          │
│   │ ┌─┼─┐ │           │███│   │           │   │███│          │
│   │ │█│█│ │           │███│   │           │   │███│          │
│   │ └─┼─┘ │           │███│   │           │   │███│          │
│   └───┴───┘           └───┴───┘           └───┴───┘          │
│   Só interseção       Todos de A          Todos de B          │
│                                                               │
│   FULL OUTER JOIN                                             │
│   ┌───┬───┐                                                   │
│   │███│███│                                                   │
│   │███│███│                                                   │
│   │███│███│                                                   │
│   └───┴───┘                                                   │
│   Todos de ambos                                              │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

### 🔍 Exemplos com Bookanga:

```sql
-- INNER JOIN: Vendas com usuários
SELECT 
    s.id as venda_id,
    s.date,
    s.total_price,
    u.name as cliente
FROM sale s
INNER JOIN "user" u ON s.user_id = u.id;

-- LEFT JOIN: Todos os produtos e suas vendas (mesmo sem venda)
SELECT 
    p.title,
    COUNT(si.id) as vezes_vendido
FROM product p
LEFT JOIN sale_item si ON p.id = si.product_id
GROUP BY p.id, p.title;

-- Múltiplos JOINs: Detalhes completos da venda
SELECT 
    s.id as venda_id,
    u.name as cliente,
    p.title as produto,
    si.quantity as quantidade,
    si.unit_price as preco_unitario,
    (si.quantity * si.unit_price) as subtotal
FROM sale s
JOIN "user" u ON s.user_id = u.id
JOIN sale_item si ON s.id = si.sale_id
JOIN product p ON si.product_id = p.id
ORDER BY s.id, p.title;

-- Self JOIN: Produtos do mesmo autor
SELECT 
    p1.title as produto1,
    p2.title as produto2,
    p1.author
FROM product p1
JOIN product p2 ON p1.author = p2.author AND p1.id < p2.id;
```

---

## 📌 5. SUBQUERIES

```sql
-- Subquery no WHERE
SELECT * FROM product 
WHERE price > (SELECT AVG(price) FROM product);

-- Subquery com IN
SELECT * FROM product 
WHERE id IN (
    SELECT product_id FROM sale_item 
    WHERE sale_id = 1
);

-- Subquery correlacionada
SELECT 
    p.*,
    (SELECT COUNT(*) FROM sale_item si WHERE si.product_id = p.id) as vendas
FROM product p;

-- EXISTS
SELECT * FROM product p
WHERE EXISTS (
    SELECT 1 FROM sale_item si WHERE si.product_id = p.id
);

-- WITH (CTE - Common Table Expression)
WITH top_products AS (
    SELECT 
        product_id,
        SUM(quantity) as total_vendido
    FROM sale_item
    GROUP BY product_id
    ORDER BY total_vendido DESC
    LIMIT 10
)
SELECT 
    p.title,
    tp.total_vendido
FROM top_products tp
JOIN product p ON tp.product_id = p.id;
```

---

## 📌 6. POSTGRESQL ESPECÍFICO

### 📊 Tipos de dados especiais:

```sql
-- JSON
CREATE TABLE config (
    id SERIAL PRIMARY KEY,
    settings JSONB
);

INSERT INTO config (settings) 
VALUES ('{"theme": "dark", "language": "pt-BR"}');

SELECT settings->>'theme' FROM config;

-- Arrays
SELECT * FROM product WHERE genre = ANY(ARRAY['Fiction', 'Romance']);

-- UUID
CREATE TABLE order (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    ...
);

-- TIMESTAMP
SELECT NOW(), CURRENT_DATE, CURRENT_TIME;
SELECT * FROM sale WHERE date > NOW() - INTERVAL '7 days';
```

### 🔧 Funções úteis:

```sql
-- Texto
SELECT UPPER(title), LOWER(author), LENGTH(title) FROM product;
SELECT CONCAT(title, ' - ', author) as full_name FROM product;
SELECT SUBSTRING(title, 1, 10) FROM product;
SELECT TRIM('  text  '), REPLACE(title, ' ', '-') FROM product;

-- Números
SELECT ROUND(price, 2), CEIL(price), FLOOR(price) FROM product;
SELECT ABS(-10), MOD(10, 3), POWER(2, 3);

-- Datas
SELECT 
    EXTRACT(YEAR FROM date) as ano,
    EXTRACT(MONTH FROM date) as mes,
    TO_CHAR(date, 'DD/MM/YYYY HH24:MI') as formatado
FROM sale;

-- Condicionais
SELECT 
    title,
    CASE 
        WHEN price < 20 THEN 'Barato'
        WHEN price < 50 THEN 'Médio'
        ELSE 'Caro'
    END as categoria_preco
FROM product;

-- COALESCE (valor padrão para NULL)
SELECT COALESCE(volume, 0) as volume FROM product;

-- NULLIF
SELECT NULLIF(volume, 0) FROM product;  -- Retorna NULL se for 0
```

---

## 📌 7. ÍNDICES E PERFORMANCE

### 💡 O que são índices?

Estruturas que aceleram buscas, como índice de um livro.

### 🔧 Criando índices:

```sql
-- Índice simples
CREATE INDEX idx_product_genre ON product(genre);

-- Índice composto
CREATE INDEX idx_product_genre_language ON product(genre, language);

-- Índice único
CREATE UNIQUE INDEX idx_product_isbn ON product(isbn);

-- Índice parcial
CREATE INDEX idx_product_active ON product(id) WHERE deleted = false;

-- Índice para LIKE
CREATE INDEX idx_product_title_trgm ON product 
USING gin (title gin_trgm_ops);
```

### 📊 Verificando performance:

```sql
-- EXPLAIN mostra o plano de execução
EXPLAIN SELECT * FROM product WHERE genre = 'Fiction';

-- EXPLAIN ANALYZE executa e mostra tempo real
EXPLAIN ANALYZE SELECT * FROM product WHERE genre = 'Fiction';

-- Exemplo de saída
/*
Index Scan using idx_product_genre on product  (cost=0.15..8.17 rows=1 width=...)
  Index Cond: ((genre)::text = 'Fiction'::text)
  Actual time: 0.015..0.016 rows=5 loops=1
Planning Time: 0.080 ms
Execution Time: 0.030 ms
*/
```

### ✅ Quando criar índices:

| Criar índice | Não criar |
|--------------|-----------|
| Colunas em WHERE frequente | Tabelas pequenas |
| Colunas em JOIN | Colunas com poucos valores distintos |
| Colunas em ORDER BY | Tabelas com muitos INSERTs |
| Foreign Keys | |

---

## 📌 8. TRANSAÇÕES

```sql
-- Transação explícita
BEGIN;

UPDATE product SET price = price * 0.9 WHERE id = 1;
UPDATE product SET price = price * 0.9 WHERE id = 2;

-- Se tudo ok
COMMIT;

-- Se algo errado
ROLLBACK;

-- Savepoint (ponto de retorno)
BEGIN;
UPDATE product SET price = 10 WHERE id = 1;
SAVEPOINT before_second;
UPDATE product SET price = 20 WHERE id = 2;
-- Ops, erro!
ROLLBACK TO before_second;
COMMIT;  -- Só a primeira alteração é salva
```

---

## 📌 9. QUERIES DO BOOKANGA

### 🔍 Queries úteis para o projeto:

```sql
-- Produtos mais vendidos
SELECT 
    p.title,
    p.author,
    SUM(si.quantity) as total_vendido,
    SUM(si.quantity * si.unit_price) as receita
FROM product p
JOIN sale_item si ON p.id = si.product_id
GROUP BY p.id
ORDER BY total_vendido DESC
LIMIT 10;

-- Vendas por mês
SELECT 
    DATE_TRUNC('month', date) as mes,
    COUNT(*) as num_vendas,
    SUM(total_price) as receita_total
FROM sale
GROUP BY DATE_TRUNC('month', date)
ORDER BY mes DESC;

-- Produtos sem vendas
SELECT p.* FROM product p
LEFT JOIN sale_item si ON p.id = si.product_id
WHERE si.id IS NULL;

-- Ticket médio por cliente
SELECT 
    u.name,
    COUNT(s.id) as num_compras,
    AVG(s.total_price) as ticket_medio
FROM "user" u
JOIN sale s ON u.id = s.user_id
GROUP BY u.id
ORDER BY ticket_medio DESC;

-- Livros vs Mangás (estatísticas)
SELECT 
    product_type,
    COUNT(*) as quantidade,
    AVG(price) as preco_medio,
    MIN(price) as menor,
    MAX(price) as maior
FROM product
GROUP BY product_type;
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Conectar ao banco

```bash
# Entre no container
docker exec -it bookanga-postgres psql -U bookanga -d bookanga_db

# Liste tabelas
\dt

# Descreva uma tabela
\d product

# Execute query
SELECT * FROM product LIMIT 5;

# Saia
\q
```

### Exercício 2: Queries

Escreva queries para:
1. Listar produtos com preço acima da média
2. Contar produtos por gênero
3. Encontrar o autor com mais livros

### Exercício 3: Performance

```sql
-- Compare com e sem índice
EXPLAIN ANALYZE SELECT * FROM product WHERE genre = 'Fiction';

-- Crie índice
CREATE INDEX idx_product_genre ON product(genre);

-- Compare novamente
EXPLAIN ANALYZE SELECT * FROM product WHERE genre = 'Fiction';
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **SELECT** | Buscar dados |
| **INSERT** | Inserir dados |
| **UPDATE** | Atualizar dados |
| **DELETE** | Remover dados |
| **JOIN** | Unir tabelas |
| **GROUP BY** | Agrupar resultados |
| **INDEX** | Acelerar buscas |
| **TRANSACTION** | Operações atômicas |
| **EXPLAIN** | Analisar performance |

---

## ⏭️ Próximo Módulo

**Módulo 13: Segurança - Spring Security**

---

**🎉 Parabéns por completar o Módulo 12!**

