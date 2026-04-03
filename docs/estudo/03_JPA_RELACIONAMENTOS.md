# 📚 Módulo 3: JPA, Hibernate e Relacionamentos

> **Você não respondeu as questões 3.3 e 3.4 da prova**  
> **Tempo estimado:** 4-5 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Essencial para qualquer aplicação com banco de dados)

---

## 🎯 O que você vai aprender:

1. ✅ O que é JPA e Hibernate
2. ✅ Relacionamentos: @ManyToOne, @OneToMany, @ManyToMany
3. ✅ Cascade Types - Propagação de operações
4. ✅ FetchType - LAZY vs EAGER
5. ✅ Repository Pattern e Query Methods

---

## 📌 1. JPA vs HIBERNATE - Qual a diferença?

### 💡 Explicação Simples:

| Termo | O que é | Analogia |
|-------|---------|----------|
| **JPA** | Especificação (interface) | Manual de regras |
| **Hibernate** | Implementação | Quem segue as regras |

```java
// JPA define as anotações:
@Entity
@Table
@Id
@Column
@ManyToOne

// Hibernate implementa a lógica por trás delas
```

### 🔍 No projeto Bookanga:

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
    <!-- Já inclui Hibernate como implementação padrão -->
</dependency>
```

---

## 📌 2. ENTITY - Mapeando Classes para Tabelas

### 🔍 Anatomia de uma Entity:

```java
@Entity  // ← Marca como entidade JPA (será uma tabela)
@Table(name = "product")  // ← Nome da tabela (opcional se igual à classe)
public class Product {
    
    @Id  // ← Chave primária
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // ← Auto-increment
    private Long id;
    
    @Column(name = "title", nullable = false, length = 255)  // ← Configuração da coluna
    private String title;
    
    @Column(name = "publication_year")
    private Integer publicationYear;
}
```

### 📊 Mapeamento Classe → Tabela:

```
┌─────────────────────────┐         ┌─────────────────────────┐
│     Classe Java         │         │    Tabela PostgreSQL    │
├─────────────────────────┤         ├─────────────────────────┤
│ @Entity                 │  ──→    │ CREATE TABLE product    │
│ class Product           │         │                         │
├─────────────────────────┤         ├─────────────────────────┤
│ @Id Long id             │  ──→    │ id BIGSERIAL PRIMARY KEY│
│ String title            │  ──→    │ title VARCHAR(255)      │
│ Integer publicationYear │  ──→    │ publication_year INT    │
│ BigDecimal price        │  ──→    │ price DECIMAL(10,2)     │
└─────────────────────────┘         └─────────────────────────┘
```

---

## 📌 3. RELACIONAMENTOS JPA

O projeto Bookanga tem as entidades `Sale`, `SaleItem`, `User` e `Product` que se relacionam.

### 3.1 @ManyToOne (Muitos para Um)

```java
// Muitas vendas (Sale) pertencem a UM usuário (User)
// Muitos itens (SaleItem) pertencem a UMA venda (Sale)

@Entity
public class Sale {
    @Id
    private Long id;
    
    @ManyToOne  // ← MUITAS Sales para UM User
    @JoinColumn(name = "user_id", nullable = false)  // ← Coluna FK na tabela sale
    private User user;
}
```

**Visualização no Banco:**

```sql
CREATE TABLE sale (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,  -- ← FK criada pelo @JoinColumn
    total_price DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES user(id)
);
```

### 3.2 @OneToMany (Um para Muitos)

```java
// UMA venda (Sale) tem MUITOS itens (SaleItem)
// UM usuário (User) tem MUITAS vendas (Sale)

@Entity
public class Sale {
    @Id
    private Long id;
    
    @OneToMany(mappedBy = "sale", cascade = CascadeType.ALL)
    private List<SaleItem> items;  // ← UMA Sale para MUITOS Items
}

@Entity
public class SaleItem {
    @Id
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "sale_id")
    private Sale sale;  // ← O lado "dono" do relacionamento
}
```

### 🔑 O que é `mappedBy`?

```java
@OneToMany(mappedBy = "sale")  // ← "sale" é o nome do campo em SaleItem
private List<SaleItem> items;
```

| Lado | Característica | Quem tem a FK |
|------|---------------|---------------|
| **Dono** (SaleItem) | Tem `@JoinColumn` | ✅ Sim, tabela sale_item tem sale_id |
| **Inverso** (Sale) | Tem `mappedBy` | ❌ Não |

```
┌────────────────────┐         ┌────────────────────┐
│       SALE         │         │     SALE_ITEM      │
├────────────────────┤         ├────────────────────┤
│ id (PK)            │◄────────│ sale_id (FK)       │
│ user_id (FK)       │         │ id (PK)            │
│ total_price        │         │ product_id (FK)    │
│ date               │         │ quantity           │
└────────────────────┘         └────────────────────┘
         1                              N
      (Sale)                       (SaleItem)
```

### 3.3 @ManyToMany (Muitos para Muitos)

```java
// Exemplo: Um Product pode ter MUITAS Tags
//          Uma Tag pode ter MUITOS Products

@Entity
public class Product {
    @Id
    private Long id;
    
    @ManyToMany
    @JoinTable(
        name = "product_tag",  // ← Tabela intermediária
        joinColumns = @JoinColumn(name = "product_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<Tag> tags;
}

@Entity
public class Tag {
    @Id
    private Long id;
    private String name;
    
    @ManyToMany(mappedBy = "tags")
    private List<Product> products;
}
```

**Cria tabela intermediária:**

```sql
CREATE TABLE product_tag (
    product_id BIGINT,
    tag_id BIGINT,
    PRIMARY KEY (product_id, tag_id)
);
```

---

## 📌 4. CASCADE TYPES - Propagação de Operações

### 🤔 O que você não sabia:
> Questão 3.3b: "O que cascade = CascadeType.ALL faz?"

### 💡 Cascade propaga operações para entidades relacionadas:

```java
@OneToMany(mappedBy = "sale", cascade = CascadeType.ALL)
private List<SaleItem> items;
```

**Sem Cascade:**
```java
Sale sale = new Sale();
SaleItem item1 = new SaleItem();
SaleItem item2 = new SaleItem();
sale.setItems(List.of(item1, item2));

// Precisa salvar cada um separadamente:
saleRepository.save(sale);
saleItemRepository.save(item1);  // ← Necessário!
saleItemRepository.save(item2);  // ← Necessário!
```

**Com Cascade:**
```java
Sale sale = new Sale();
SaleItem item1 = new SaleItem();
SaleItem item2 = new SaleItem();
sale.setItems(List.of(item1, item2));

// Salvar sale automaticamente salva os items!
saleRepository.save(sale);  // ← Salva tudo!
```

### 📊 Tipos de Cascade:

| Tipo | Propaga | Quando usar |
|------|---------|-------------|
| `PERSIST` | save() | Salvar filhos junto com pai |
| `MERGE` | update() | Atualizar filhos junto com pai |
| `REMOVE` | delete() | Deletar filhos quando pai é deletado |
| `REFRESH` | refresh() | Recarregar filhos quando pai é recarregado |
| `DETACH` | detach() | Desvincular filhos quando pai é desvinculado |
| `ALL` | Todos acima | Propagar tudo (mais comum) |

### ⚠️ Cuidado com CASCADE REMOVE!

```java
// PERIGO: Deletar User deleta todas as Sales!
@Entity
public class User {
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Sale> sales;
}

// Deletar usuário:
userRepository.delete(user);  // 💥 Deleta todas as vendas também!
```

---

## 📌 5. FETCH TYPE - LAZY vs EAGER

### 💡 Como o JPA carrega relacionamentos:

| Tipo | Comportamento | Padrão para |
|------|---------------|-------------|
| `EAGER` | Carrega SEMPRE, junto com a entidade pai | @ManyToOne, @OneToOne |
| `LAZY` | Carrega SOMENTE quando acessar | @OneToMany, @ManyToMany |

### 🔍 Exemplo Prático:

```java
@Entity
public class Sale {
    @Id
    private Long id;
    
    @ManyToOne(fetch = FetchType.EAGER)  // ← Carrega User sempre
    private User user;
    
    @OneToMany(mappedBy = "sale", fetch = FetchType.LAZY)  // ← Carrega items só quando pedir
    private List<SaleItem> items;
}
```

```java
// Buscar uma venda:
Sale sale = saleRepository.findById(1L).get();

// Com EAGER: User já veio carregado
System.out.println(sale.getUser().getName());  // ✅ Funciona sempre

// Com LAZY: Items só carregam quando você acessa
System.out.println(sale.getItems().size());  // Faz nova query!
```

### ⚠️ Problema comum: LazyInitializationException

```java
@Service
public class SaleService {
    
    @Transactional  // ← IMPORTANTE para LAZY funcionar!
    public Sale getSale(Long id) {
        Sale sale = saleRepository.findById(id).get();
        
        // Dentro da transação, LAZY funciona:
        int itemCount = sale.getItems().size();  // ✅ OK
        
        return sale;
    }
}

// Fora da transação:
Sale sale = saleService.getSale(1L);
sale.getItems().size();  // 💥 LazyInitializationException!
// Porque a sessão do Hibernate já fechou!
```

### ✅ Soluções para LazyInitializationException:

1. **Usar @Transactional** no método que acessa dados lazy
2. **Usar EAGER** (cuidado com performance!)
3. **Usar JOIN FETCH** na query
4. **Usar DTO** com apenas os dados necessários

```java
// Solução com JOIN FETCH:
@Query("SELECT s FROM Sale s JOIN FETCH s.items WHERE s.id = :id")
Sale findByIdWithItems(@Param("id") Long id);
```

---

## 📌 6. REPOSITORY PATTERN

### 🤔 O que você não respondeu:
> Questão 3.4: "Por que ProductRepository é uma interface?"

### 💡 Spring Data JPA cria a implementação automaticamente!

```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Você define o contrato, Spring implementa!
}
```

### 📊 Métodos que vêm de graça:

| Método | O que faz |
|--------|-----------|
| `save(entity)` | Salva ou atualiza |
| `findById(id)` | Busca por ID |
| `findAll()` | Lista todos |
| `deleteById(id)` | Deleta por ID |
| `delete(entity)` | Deleta entidade |
| `count()` | Conta registros |
| `existsById(id)` | Verifica se existe |

### 🔮 Query Methods - Mágica do Spring Data!

O Spring cria queries automaticamente pelo NOME do método:

```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Spring gera: SELECT * FROM product WHERE title = ?
    List<Product> findByTitle(String title);
    
    // Spring gera: SELECT * FROM product WHERE author = ?
    List<Product> findByAuthor(String author);
    
    // Spring gera: SELECT * FROM product WHERE genre = ? AND language = ?
    List<Product> findByGenreAndLanguage(String genre, String language);
    
    // Spring gera: SELECT * FROM product WHERE price < ?
    List<Product> findByPriceLessThan(BigDecimal price);
    
    // Spring gera: SELECT * FROM product WHERE price BETWEEN ? AND ?
    List<Product> findByPriceBetween(BigDecimal min, BigDecimal max);
    
    // Spring gera: SELECT * FROM product WHERE title LIKE '%?%'
    List<Product> findByTitleContaining(String keyword);
    
    // Spring gera: SELECT * FROM product ORDER BY price DESC
    List<Product> findAllByOrderByPriceDesc();
    
    // Com paginação:
    Page<Product> findByGenre(String genre, Pageable pageable);
}
```

### 📝 Palavras-chave para Query Methods:

| Palavra-chave | Exemplo | SQL gerado |
|---------------|---------|------------|
| `And` | `findByTitleAndAuthor` | `WHERE title = ? AND author = ?` |
| `Or` | `findByTitleOrAuthor` | `WHERE title = ? OR author = ?` |
| `Between` | `findByPriceBetween` | `WHERE price BETWEEN ? AND ?` |
| `LessThan` | `findByPriceLessThan` | `WHERE price < ?` |
| `GreaterThan` | `findByPriceGreaterThan` | `WHERE price > ?` |
| `Like` | `findByTitleLike` | `WHERE title LIKE ?` |
| `Containing` | `findByTitleContaining` | `WHERE title LIKE '%?%'` |
| `OrderBy` | `findByGenreOrderByPriceDesc` | `ORDER BY price DESC` |
| `Not` | `findByGenreNot` | `WHERE genre != ?` |
| `In` | `findByGenreIn(List)` | `WHERE genre IN (?, ?, ?)` |
| `IsNull` | `findByVolumeIsNull` | `WHERE volume IS NULL` |
| `IsNotNull` | `findByVolumeIsNotNull` | `WHERE volume IS NOT NULL` |

### 🔧 Queries Customizadas com @Query:

```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // JPQL (linguagem de query do JPA)
    @Query("SELECT p FROM Product p WHERE p.price > :minPrice AND p.genre = :genre")
    List<Product> findExpensiveByGenre(@Param("minPrice") BigDecimal minPrice, 
                                        @Param("genre") String genre);
    
    // SQL Nativo
    @Query(value = "SELECT * FROM product WHERE price > ?1", nativeQuery = true)
    List<Product> findExpensiveNative(BigDecimal minPrice);
    
    // Update/Delete com @Modifying
    @Modifying
    @Query("UPDATE Product p SET p.price = p.price * 1.1 WHERE p.genre = :genre")
    int increasePrice(@Param("genre") String genre);
}
```

---

## 📌 7. ESTRATÉGIAS DE HERANÇA JPA (Revisão)

### 🤔 O que você não soube:
> "Cite outras estratégias de herança do JPA" - Você: "Não sei"

### 📊 As 3 estratégias:

| Estratégia | Tabelas | Quando usar |
|------------|---------|-------------|
| `SINGLE_TABLE` | 1 tabela | Poucos campos diferentes entre subclasses |
| `JOINED` | 1 por classe | Muitos campos diferentes, normalizado |
| `TABLE_PER_CLASS` | 1 por classe concreta | Classes independentes |

### 1. SINGLE_TABLE (Usado no Bookanga):

```java
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "product_type")
public abstract class Product { }

@Entity
@DiscriminatorValue("book")
public class Book extends Product { }

@Entity
@DiscriminatorValue("manga")
public class Manga extends Product { }
```

```sql
-- Uma única tabela:
CREATE TABLE product (
    id BIGINT,
    product_type VARCHAR(20),  -- discriminator
    title VARCHAR(255),
    author VARCHAR(255),
    volume INT  -- null para books
);
```

### 2. JOINED:

```java
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Product { }

@Entity
public class Book extends Product { }

@Entity
public class Manga extends Product { }
```

```sql
-- Tabela base:
CREATE TABLE product (
    id BIGINT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255)
);

-- Tabela específica:
CREATE TABLE book (
    id BIGINT PRIMARY KEY,  -- FK para product
    publisher VARCHAR(255)
);

CREATE TABLE manga (
    id BIGINT PRIMARY KEY,  -- FK para product
    volume INT
);
```

### 3. TABLE_PER_CLASS:

```java
@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class Product { }
```

```sql
-- Tabelas separadas (sem tabela product):
CREATE TABLE book (
    id BIGINT,
    title VARCHAR(255),
    author VARCHAR(255),
    publisher VARCHAR(255)
);

CREATE TABLE manga (
    id BIGINT,
    title VARCHAR(255),
    author VARCHAR(255),
    volume INT
);
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Crie Query Methods

Adicione ao `ProductRepository`:

```java
// 1. Buscar por gênero
List<Product> findByGenre(String genre);

// 2. Buscar por autor contendo texto
List<Product> findByAuthorContaining(String keyword);

// 3. Buscar por preço menor que X, ordenado por preço
List<Product> findByPriceLessThanOrderByPriceAsc(BigDecimal maxPrice);

// 4. Buscar mangás (por product_type)
@Query("SELECT p FROM Product p WHERE TYPE(p) = Manga")
List<Product> findAllMangas();
```

### Exercício 2: Entenda o Cascade

Analise o código abaixo e responda:

```java
@Entity
public class Sale {
    @OneToMany(mappedBy = "sale", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SaleItem> items;
}
```

1. Se eu deletar uma Sale, o que acontece com os SaleItems?
2. O que `orphanRemoval = true` faz?

### Exercício 3: Corrija o Erro

```java
// Este código dá LazyInitializationException. Por quê? Como corrigir?
public Sale getSaleWithItems(Long id) {
    Sale sale = saleRepository.findById(id).get();
    return sale;
}

// No Controller:
Sale sale = saleService.getSaleWithItems(1L);
System.out.println(sale.getItems().size());  // 💥 ERRO!
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **JPA** | Especificação de persistência Java |
| **Hibernate** | Implementação do JPA |
| **@Entity** | Marca classe como tabela |
| **@ManyToOne** | N:1 - Muitos para Um |
| **@OneToMany** | 1:N - Um para Muitos |
| **mappedBy** | Indica o lado inverso do relacionamento |
| **Cascade** | Propaga operações para filhos |
| **LAZY** | Carrega só quando acessar |
| **EAGER** | Carrega sempre |
| **Query Methods** | Queries automáticas pelo nome do método |

---

## ⏭️ Próximo Módulo

**Módulo 4: Docker e Docker Compose**
- Você não respondeu NENHUMA questão de Docker!

---

**🎉 Parabéns por completar o Módulo 3!**

