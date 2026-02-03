# 📚 Módulo 11: Padrões de Projeto

> **Tempo estimado:** 3-4 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Fundamental para código de qualidade)

---

## 🎯 O que você vai aprender:

1. ✅ O que são Design Patterns
2. ✅ Padrões usados no Bookanga
3. ✅ Repository Pattern
4. ✅ DTO Pattern
5. ✅ Service Layer Pattern
6. ✅ Factory e Builder Patterns
7. ✅ Singleton (e por que Spring cuida disso)

---

## 📌 1. O QUE SÃO DESIGN PATTERNS?

### 💡 Definição:

**Design Patterns** são soluções reutilizáveis para problemas comuns de design de software.

### 🤔 Por que usar?

| Benefício | Descrição |
|-----------|-----------|
| **Comunicação** | Vocabulário comum entre devs |
| **Experiência** | Soluções testadas por décadas |
| **Manutenibilidade** | Código mais organizado |
| **Flexibilidade** | Facilita mudanças |

### 📊 Categorias de Patterns:

| Categoria | Propósito | Exemplos |
|-----------|-----------|----------|
| **Criacionais** | Como criar objetos | Factory, Builder, Singleton |
| **Estruturais** | Como compor objetos | Adapter, Decorator, Facade |
| **Comportamentais** | Como objetos interagem | Strategy, Observer, Template |

---

## 📌 2. PADRÕES NO BOOKANGA

O projeto Bookanga já usa vários padrões:

```
┌─────────────────────────────────────────────────────────────────┐
│                    ARQUITETURA EM CAMADAS                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐    │
│   │ Controller  │ ───► │   Service   │ ───► │ Repository  │    │
│   │   (REST)    │      │  (Negócio)  │      │   (Dados)   │    │
│   └─────────────┘      └─────────────┘      └─────────────┘    │
│         │                    │                    │             │
│         │                    │                    │             │
│      DTO Pattern       Service Layer        Repository         │
│                          Pattern              Pattern           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📌 3. REPOSITORY PATTERN

### 💡 O que é?

Abstrai o acesso a dados, escondendo detalhes de persistência.

### 🔍 No Bookanga:

```java
// Interface - define o contrato
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    List<Product> findByGenre(String genre);
    
    List<Product> findByAuthor(String author);
}

// Uso no Service - não sabe nada sobre SQL ou JPA
@Service
public class ProductService {
    
    private final ProductRepository repository;
    
    public List<Product> findByGenre(String genre) {
        return repository.findByGenre(genre);  // Abstrato!
    }
}
```

### ✅ Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Abstração** | Service não conhece SQL |
| **Testabilidade** | Fácil criar mocks |
| **Flexibilidade** | Pode trocar banco sem mudar Service |
| **Organização** | Queries centralizadas |

### 📊 Antes vs Depois:

```java
// ❌ SEM Repository Pattern
@Service
public class ProductService {
    
    @PersistenceContext
    private EntityManager em;
    
    public List<Product> findByGenre(String genre) {
        // Service conhece detalhes de JPA/SQL
        return em.createQuery(
            "SELECT p FROM Product p WHERE p.genre = :genre", 
            Product.class)
            .setParameter("genre", genre)
            .getResultList();
    }
}

// ✅ COM Repository Pattern
@Service
public class ProductService {
    
    private final ProductRepository repository;
    
    public List<Product> findByGenre(String genre) {
        return repository.findByGenre(genre);  // Limpo!
    }
}
```

---

## 📌 4. DTO PATTERN (Data Transfer Object)

### 💡 O que é?

Objeto usado para transferir dados entre camadas, sem expor a entidade.

### 🔍 No Bookanga:

```java
// Entity - estrutura do banco
@Entity
public class Product {
    @Id
    private Long id;
    private String title;
    private String author;
    private BigDecimal price;
    private LocalDateTime createdAt;  // Interno
    private LocalDateTime updatedAt;  // Interno
    private boolean deleted;          // Interno
}

// DTO de Request - o que entra
@Data
public class ProductRequestDTO {
    @NotBlank
    private String title;
    
    @NotBlank
    private String author;
    
    @Positive
    private BigDecimal price;
}

// DTO de Response - o que sai
@Data
public class ProductResponseDTO {
    private Long id;
    private String title;
    private String author;
    private BigDecimal price;
    // Não expõe: createdAt, updatedAt, deleted
}
```

### ✅ Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Segurança** | Não expõe campos internos |
| **Validação** | Valida apenas no DTO de entrada |
| **Flexibilidade** | Formatos diferentes para entrada/saída |
| **Desacoplamento** | API independente do banco |

### 🔄 Conversão Entity ↔ DTO:

```java
// Manual
public ProductResponseDTO toDTO(Product product) {
    ProductResponseDTO dto = new ProductResponseDTO();
    dto.setId(product.getId());
    dto.setTitle(product.getTitle());
    dto.setAuthor(product.getAuthor());
    dto.setPrice(product.getPrice());
    return dto;
}

// Com ModelMapper ou MapStruct (mais elegante)
@Mapper(componentModel = "spring")
public interface ProductMapper {
    ProductResponseDTO toDTO(Product product);
    Product toEntity(ProductRequestDTO dto);
}
```

---

## 📌 5. SERVICE LAYER PATTERN

### 💡 O que é?

Camada que contém a lógica de negócio, entre Controller e Repository.

### 🔍 No Bookanga:

```java
@Service
public class ProductService {
    
    private final ProductRepository repository;
    
    // Lógica de negócio centralizada
    public Product createProduct(ProductDTO dto) {
        // Validação de negócio
        if (dto.getTitle().trim().isEmpty()) {
            throw new InvalidProductDataException("Título obrigatório");
        }
        
        // Regra de negócio: diferencia Book de Manga
        Product product;
        if (dto.getVolume() == null) {
            product = new Book();
        } else {
            product = new Manga();
        }
        
        // Copia dados
        BeanUtils.copyProperties(dto, product);
        
        // Persiste
        return repository.save(product);
    }
}
```

### ✅ Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Separação** | Controller só recebe requests |
| **Reutilização** | Mesmo service para diferentes controllers |
| **Testabilidade** | Testa lógica sem HTTP |
| **Transações** | @Transactional no service |

### 📊 Responsabilidades:

| Camada | Responsabilidade |
|--------|-----------------|
| **Controller** | Receber HTTP, validar entrada, retornar resposta |
| **Service** | Lógica de negócio, transações, orquestração |
| **Repository** | Acesso a dados, queries |

---

## 📌 6. FACTORY PATTERN

### 💡 O que é?

Delega a criação de objetos para uma classe especializada.

### 🔍 Exemplo para Bookanga:

```java
// Factory para criar produtos
public class ProductFactory {
    
    public static Product create(ProductDTO dto) {
        if (dto.getVolume() != null && dto.getVolume() > 0) {
            return createManga(dto);
        } else {
            return createBook(dto);
        }
    }
    
    private static Book createBook(ProductDTO dto) {
        Book book = new Book();
        book.setTitle(dto.getTitle());
        book.setAuthor(dto.getAuthor());
        book.setPrice(dto.getPrice());
        return book;
    }
    
    private static Manga createManga(ProductDTO dto) {
        Manga manga = new Manga();
        manga.setTitle(dto.getTitle());
        manga.setAuthor(dto.getAuthor());
        manga.setVolume(dto.getVolume());
        manga.setPrice(dto.getPrice());
        return manga;
    }
}

// Uso
Product product = ProductFactory.create(dto);
```

### ✅ Benefícios:

- Centraliza lógica de criação
- Encapsula complexidade
- Facilita mudanças

---

## 📌 7. BUILDER PATTERN

### 💡 O que é?

Constrói objetos complexos passo a passo.

### 🔍 Com Lombok (@Builder):

```java
@Data
@Builder
public class ProductDTO {
    private String title;
    private String author;
    private BigDecimal price;
    private String isbn;
    private Integer volume;
}

// Uso - construção fluente
ProductDTO dto = ProductDTO.builder()
    .title("1984")
    .author("George Orwell")
    .price(new BigDecimal("29.90"))
    .isbn("9780451524935")
    .build();
```

### 🔍 Implementação manual:

```java
public class Product {
    private final String title;
    private final String author;
    private final BigDecimal price;
    
    private Product(Builder builder) {
        this.title = builder.title;
        this.author = builder.author;
        this.price = builder.price;
    }
    
    public static class Builder {
        private String title;
        private String author;
        private BigDecimal price;
        
        public Builder title(String title) {
            this.title = title;
            return this;
        }
        
        public Builder author(String author) {
            this.author = author;
            return this;
        }
        
        public Builder price(BigDecimal price) {
            this.price = price;
            return this;
        }
        
        public Product build() {
            return new Product(this);
        }
    }
}

// Uso
Product product = new Product.Builder()
    .title("1984")
    .author("George Orwell")
    .price(new BigDecimal("29.90"))
    .build();
```

### ✅ Quando usar:

- Objetos com muitos parâmetros
- Parâmetros opcionais
- Objetos imutáveis

---

## 📌 8. SINGLETON PATTERN (e Spring)

### 💡 O que é?

Garante que existe apenas UMA instância de uma classe.

### 🔍 Implementação clássica:

```java
public class ConfigManager {
    private static ConfigManager instance;
    
    private ConfigManager() { }  // Construtor privado
    
    public static synchronized ConfigManager getInstance() {
        if (instance == null) {
            instance = new ConfigManager();
        }
        return instance;
    }
}
```

### 🧠 No Spring, você NÃO precisa implementar!

```java
@Service  // Por padrão, Spring cria UM bean (singleton)
public class ProductService {
    // Só existe UMA instância desta classe no container
}
```

**Scopes do Spring:**

| Scope | Comportamento |
|-------|--------------|
| `singleton` (padrão) | Uma instância por container |
| `prototype` | Nova instância a cada injeção |
| `request` | Uma por requisição HTTP |
| `session` | Uma por sessão HTTP |

```java
@Service
@Scope("prototype")  // Nova instância cada vez
public class EmailService { }
```

---

## 📌 9. STRATEGY PATTERN

### 💡 O que é?

Define família de algoritmos intercambiáveis.

### 🔍 Exemplo para Bookanga - Cálculo de desconto:

```java
// Interface da estratégia
public interface DiscountStrategy {
    BigDecimal calculate(BigDecimal originalPrice);
}

// Implementações
@Component
public class NoDiscount implements DiscountStrategy {
    public BigDecimal calculate(BigDecimal price) {
        return price;
    }
}

@Component
public class PercentageDiscount implements DiscountStrategy {
    public BigDecimal calculate(BigDecimal price) {
        return price.multiply(new BigDecimal("0.9"));  // 10% off
    }
}

@Component
public class FixedDiscount implements DiscountStrategy {
    public BigDecimal calculate(BigDecimal price) {
        return price.subtract(new BigDecimal("5.00"));  // R$5 off
    }
}

// Uso
@Service
public class PriceService {
    
    private final Map<String, DiscountStrategy> strategies;
    
    public PriceService(List<DiscountStrategy> strategies) {
        this.strategies = strategies.stream()
            .collect(Collectors.toMap(
                s -> s.getClass().getSimpleName(),
                s -> s
            ));
    }
    
    public BigDecimal calculateFinalPrice(BigDecimal price, String discountType) {
        DiscountStrategy strategy = strategies.getOrDefault(
            discountType, 
            new NoDiscount()
        );
        return strategy.calculate(price);
    }
}
```

---

## 📌 10. TEMPLATE METHOD PATTERN

### 💡 O que é?

Define o esqueleto de um algoritmo, delegando alguns passos para subclasses.

### 🔍 Exemplo:

```java
// Template abstrato
public abstract class OrderProcessor {
    
    // Template method - define o algoritmo
    public final void processOrder(Order order) {
        validateOrder(order);
        calculateTotal(order);
        applyDiscounts(order);  // Customizável
        processPayment(order);
        sendNotification(order);  // Customizável
    }
    
    // Passos fixos
    private void validateOrder(Order order) { /* ... */ }
    private void calculateTotal(Order order) { /* ... */ }
    private void processPayment(Order order) { /* ... */ }
    
    // Passos customizáveis (hooks)
    protected abstract void applyDiscounts(Order order);
    protected abstract void sendNotification(Order order);
}

// Implementação específica
public class VIPOrderProcessor extends OrderProcessor {
    
    @Override
    protected void applyDiscounts(Order order) {
        order.setDiscount(20);  // VIP tem 20% de desconto
    }
    
    @Override
    protected void sendNotification(Order order) {
        // Envia SMS para VIP
    }
}
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Identifique os padrões

Olhe o código do Bookanga e identifique:
1. Onde está o Repository Pattern?
2. Onde está o DTO Pattern?
3. Onde está o Service Layer Pattern?

### Exercício 2: Crie um Factory

Crie uma factory para gerar diferentes tipos de notificação:

```java
public interface Notification {
    void send(String message);
}

public class NotificationFactory {
    public static Notification create(String type) {
        // EMAIL, SMS, PUSH
    }
}
```

### Exercício 3: Use Builder

Refatore a criação de Product para usar @Builder do Lombok.

---

## 📋 RESUMO DO MÓDULO

| Padrão | Propósito | Uso no Bookanga |
|--------|-----------|-----------------|
| **Repository** | Abstrai acesso a dados | ProductRepository |
| **DTO** | Transferência de dados | ProductDTO |
| **Service Layer** | Lógica de negócio | ProductService |
| **Factory** | Criação de objetos | Criar Book/Manga |
| **Builder** | Construção fluente | @Builder do Lombok |
| **Singleton** | Uma instância | @Service (Spring) |
| **Strategy** | Algoritmos intercambiáveis | Cálculo de desconto |

---

## ⏭️ Próximo Módulo

**Módulo 12: SQL e PostgreSQL**

---

**🎉 Parabéns por completar o Módulo 11!**

