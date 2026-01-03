# 💡 EXEMPLOS PRÁTICOS DE CÓDIGO - Melhorias para Implementar

Este documento contém exemplos de código prontos para você implementar melhorias no projeto.

---

## 🎯 IMPLEMENTAÇÃO 1: Paginação

### **Por Que?**
Retornar 10.000 produtos de uma vez sobrecarrega memória e rede.

### **Código Completo**

#### **1. Atualizar ProductController.java**

```java
package com.products.controller;

import com.products.dto.ProductDTO;
import com.products.model.Product;
import com.products.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@CrossOrigin
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    // ✅ NOVO: Endpoint com paginação
    @GetMapping
    public ResponseEntity<Page<Product>> getAllProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "title") String sortBy,
            @RequestParam(defaultValue = "ASC") String direction
    ) {
        Sort.Direction sortDirection = Sort.Direction.fromString(direction);
        Pageable pageable = PageRequest.of(page, size, Sort.by(sortDirection, sortBy));
        
        Page<Product> products = productService.getAllProducts(pageable);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id);
        return ResponseEntity.ok(product);
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@Valid @RequestBody ProductDTO productDTO) {
        Product createdProduct = productService.createProduct(productDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduct);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(
            @PathVariable Long id, 
            @Valid @RequestBody ProductDTO productDto
    ) {
        Product updatedProduct = productService.updateProduct(id, productDto);
        return ResponseEntity.ok(updatedProduct);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }

    // ⚠️ PROTEGER: Só admin deveria poder deletar tudo
    @DeleteMapping
    public ResponseEntity<Void> deleteAllProducts() {
        productService.deleteAllProducts();
        return ResponseEntity.noContent().build();
    }
}
```

#### **2. Atualizar ProductService.java**

```java
package com.products.service;

import com.products.dto.ProductDTO;
import com.products.exception.ProductNotFoundException;
import com.products.model.Book;
import com.products.model.Manga;
import com.products.model.Product;
import com.products.repository.ProductRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ProductService {
    
    private final ProductRepository productRepository;

    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    // ✅ NOVO: Retorna Page ao invés de List
    @Transactional(readOnly = true)
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(
                        "Livro/Mangá não encontrado com o ID: " + id
                ));
    }

    public Product createProduct(ProductDTO productDTO) {
        Product product;
        
        if (productDTO.getVolume() == null) {
            product = new Book();
        } else {
            product = new Manga();
        }
        
        BeanUtils.copyProperties(productDTO, product);
        return productRepository.save(product);
    }

    public Product updateProduct(Long id, ProductDTO productDTO) {
        Product product = getProductById(id);
        BeanUtils.copyProperties(productDTO, product, "id");
        return productRepository.save(product);
    }

    public void deleteProduct(Long id) {
        getProductById(id);
        productRepository.deleteById(id);
    }

    public void deleteAllProducts() {
        productRepository.deleteAll();
    }
}
```

### **Como Testar:**

```bash
# Página 0 (primeira), 10 itens por página, ordenado por título ASC
curl "http://localhost:8080/api/products?page=0&size=10&sortBy=title&direction=ASC"

# Página 1 (segunda), 20 itens, ordenado por preço DESC
curl "http://localhost:8080/api/products?page=1&size=20&sortBy=price&direction=DESC"
```

### **Resposta Esperada:**

```json
{
    "content": [
        {
            "id": 1,
            "title": "1984",
            "author": "Orwell",
            ...
        }
    ],
    "pageable": {
        "sort": {
            "sorted": true,
            "unsorted": false,
            "empty": false
        },
        "offset": 0,
        "pageNumber": 0,
        "pageSize": 10
    },
    "totalPages": 5,
    "totalElements": 50,
    "last": false,
    "first": true,
    "size": 10,
    "number": 0,
    "numberOfElements": 10,
    "empty": false
}
```

---

## 🎯 IMPLEMENTAÇÃO 2: Busca com Filtros

### **Por Que?**
Permitir buscar produtos por título, autor, gênero, etc.

### **Código Completo**

#### **1. Criar ProductSpecifications.java**

```java
package com.products.specification;

import com.products.model.Product;
import org.springframework.data.jpa.domain.Specification;

import java.math.BigDecimal;

public class ProductSpecifications {

    public static Specification<Product> titleContains(String title) {
        return (root, query, criteriaBuilder) -> {
            if (title == null || title.trim().isEmpty()) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.like(
                criteriaBuilder.lower(root.get("title")),
                "%" + title.toLowerCase() + "%"
            );
        };
    }

    public static Specification<Product> authorContains(String author) {
        return (root, query, criteriaBuilder) -> {
            if (author == null || author.trim().isEmpty()) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.like(
                criteriaBuilder.lower(root.get("author")),
                "%" + author.toLowerCase() + "%"
            );
        };
    }

    public static Specification<Product> genreEquals(String genre) {
        return (root, query, criteriaBuilder) -> {
            if (genre == null || genre.trim().isEmpty()) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.equal(root.get("genre"), genre);
        };
    }

    public static Specification<Product> priceBetween(BigDecimal minPrice, BigDecimal maxPrice) {
        return (root, query, criteriaBuilder) -> {
            if (minPrice == null && maxPrice == null) {
                return criteriaBuilder.conjunction();
            }
            if (minPrice != null && maxPrice != null) {
                return criteriaBuilder.between(root.get("price"), minPrice, maxPrice);
            }
            if (minPrice != null) {
                return criteriaBuilder.greaterThanOrEqualTo(root.get("price"), minPrice);
            }
            return criteriaBuilder.lessThanOrEqualTo(root.get("price"), maxPrice);
        };
    }

    public static Specification<Product> yearEquals(Integer year) {
        return (root, query, criteriaBuilder) -> {
            if (year == null) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.equal(root.get("publication_year"), year);
        };
    }
}
```

#### **2. Atualizar ProductRepository.java**

```java
package com.products.repository;

import com.products.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends 
    JpaRepository<Product, Long>,
    JpaSpecificationExecutor<Product> { // ✅ ADICIONAR ISTO
}
```

#### **3. Adicionar Método no ProductService.java**

```java
@Transactional(readOnly = true)
public Page<Product> searchProducts(
        String title,
        String author,
        String genre,
        BigDecimal minPrice,
        BigDecimal maxPrice,
        Integer year,
        Pageable pageable
) {
    Specification<Product> spec = Specification.where(null);
    
    if (title != null && !title.trim().isEmpty()) {
        spec = spec.and(ProductSpecifications.titleContains(title));
    }
    if (author != null && !author.trim().isEmpty()) {
        spec = spec.and(ProductSpecifications.authorContains(author));
    }
    if (genre != null && !genre.trim().isEmpty()) {
        spec = spec.and(ProductSpecifications.genreEquals(genre));
    }
    if (minPrice != null || maxPrice != null) {
        spec = spec.and(ProductSpecifications.priceBetween(minPrice, maxPrice));
    }
    if (year != null) {
        spec = spec.and(ProductSpecifications.yearEquals(year));
    }
    
    return productRepository.findAll(spec, pageable);
}
```

#### **4. Adicionar Endpoint no ProductController.java**

```java
@GetMapping("/search")
public ResponseEntity<Page<Product>> searchProducts(
        @RequestParam(required = false) String title,
        @RequestParam(required = false) String author,
        @RequestParam(required = false) String genre,
        @RequestParam(required = false) BigDecimal minPrice,
        @RequestParam(required = false) BigDecimal maxPrice,
        @RequestParam(required = false) Integer year,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "20") int size,
        @RequestParam(defaultValue = "title") String sortBy,
        @RequestParam(defaultValue = "ASC") String direction
) {
    Sort.Direction sortDirection = Sort.Direction.fromString(direction);
    Pageable pageable = PageRequest.of(page, size, Sort.by(sortDirection, sortBy));
    
    Page<Product> products = productService.searchProducts(
        title, author, genre, minPrice, maxPrice, year, pageable
    );
    
    return ResponseEntity.ok(products);
}
```

### **Como Testar:**

```bash
# Buscar por título
curl "http://localhost:8080/api/products/search?title=naruto"

# Buscar por autor
curl "http://localhost:8080/api/products/search?author=orwell"

# Buscar por gênero e faixa de preço
curl "http://localhost:8080/api/products/search?genre=Dystopia&minPrice=10&maxPrice=50"

# Busca combinada
curl "http://localhost:8080/api/products/search?title=1984&author=orwell&year=1949"
```

---

## 🎯 IMPLEMENTAÇÃO 3: Auditoria (CreatedAt, UpdatedAt)

### **Por Que?**
Rastrear quando produtos foram criados/atualizados.

### **Código Completo**

#### **1. Criar Auditable.java (Base Class)**

```java
package com.products.model;

import jakarta.persistence.Column;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
public abstract class Auditable {

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(nullable = false)
    private LocalDateTime updatedAt;
}
```

#### **2. Atualizar Product.java**

```java
package com.products.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "product_type", discriminatorType = DiscriminatorType.STRING)
@JsonInclude(JsonInclude.Include.NON_NULL)
public abstract class Product extends Auditable { // ✅ HERDAR DE Auditable

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 70)
    @NotBlank(message = "O título do livro é obrigatório")
    private String title;

    // ... resto dos campos
    
    @JsonProperty("product_type")
    public abstract String getProductType();
}
```

#### **3. Habilitar JPA Auditing**

```java
package com.products;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing // ✅ ADICIONAR ISTO
public class EcommerceApplication {
    public static void main(String[] args) {
        SpringApplication.run(EcommerceApplication.class, args);
    }
}
```

### **Resultado:**

Agora todos os produtos terão automaticamente:
```json
{
    "id": 1,
    "title": "1984",
    "author": "Orwell",
    "createdAt": "2024-01-15T10:30:00",
    "updatedAt": "2024-01-20T14:45:00",
    ...
}
```

---

## 🎯 IMPLEMENTAÇÃO 4: Soft Delete

### **Por Que?**
Ao invés de deletar permanentemente, marcar como deletado (permite recuperação).

### **Código Completo**

#### **1. Atualizar Product.java**

```java
package com.products.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "product_type", discriminatorType = DiscriminatorType.STRING)
@JsonInclude(JsonInclude.Include.NON_NULL)
@SQLDelete(sql = "UPDATE product SET deleted = true WHERE id = ?") // ✅ SOFT DELETE
@Where(clause = "deleted = false") // ✅ NÃO RETORNAR DELETADOS
public abstract class Product extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ✅ ADICIONAR CAMPO DELETED
    @Column(nullable = false)
    private boolean deleted = false;

    @Column(nullable = false, unique = true, length = 70)
    @NotBlank(message = "O título do livro é obrigatório")
    private String title;

    // ... resto dos campos
    
    @JsonProperty("product_type")
    public abstract String getProductType();
}
```

### **Resultado:**

Agora ao chamar `productService.deleteProduct(1L)`:
- Produto NÃO é deletado do banco
- Campo `deleted` vira `true`
- Produto não aparece mais em buscas
- Pode ser recuperado manualmente no banco

---

## 🎯 IMPLEMENTAÇÃO 5: Tratamento de Validation Errors

### **Por Que?**
Retornar mensagens claras quando validação falha.

### **Código Completo**

#### **Atualizar GlobalExceptionHandler.java**

```java
package com.products.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleProductNotFoundException(ProductNotFoundException ex) {
        ErrorResponse errorResponse = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(), 
            ex.getMessage()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
    }

    @ExceptionHandler(InvalidProductDataException.class)
    public ResponseEntity<ErrorResponse> handleInvalidProductDataException(InvalidProductDataException e) {
        ErrorResponse errorResponse = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(), 
            e.getMessage()
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }

    // ✅ NOVO: Tratamento de erros de validação
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(
            MethodArgumentNotValidException ex
    ) {
        Map<String, Object> response = new HashMap<>();
        Map<String, String> errors = new HashMap<>();
        
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        
        response.put("status", HttpStatus.BAD_REQUEST.value());
        response.put("message", "Validation failed");
        response.put("errors", errors);
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception e) {
        ErrorResponse errorResponse = new ErrorResponse(
            HttpStatus.INTERNAL_SERVER_ERROR.value(), 
            "Ocorreu um erro interno no servidor."
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }
}
```

### **Resultado:**

Ao enviar dados inválidos:
```json
{
    "status": 400,
    "message": "Validation failed",
    "errors": {
        "title": "O título é obrigatório",
        "price": "O preço deve ser um valor positivo",
        "isbn": "ISBN inválido"
    }
}
```

---

## 🎯 IMPLEMENTAÇÃO 6: Endpoint de Health Check

### **Por Que?**
Verificar se a aplicação está rodando.

### **Código Completo**

#### **Criar HealthController.java**

```java
package com.products.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    @Autowired
    private DataSource dataSource;

    @GetMapping
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", LocalDateTime.now());
        
        // Verificar conexão com banco
        try (Connection conn = dataSource.getConnection()) {
            health.put("database", "UP");
        } catch (Exception e) {
            health.put("database", "DOWN");
            health.put("database_error", e.getMessage());
        }
        
        return ResponseEntity.ok(health);
    }
}
```

### **Teste:**

```bash
curl http://localhost:8080/api/health
```

**Resposta:**
```json
{
    "status": "UP",
    "timestamp": "2024-01-15T10:30:00",
    "database": "UP"
}
```

---

## 🎯 IMPLEMENTAÇÃO 7: CORS Configuração Adequada

### **Por Que?**
`@CrossOrigin` sem parâmetros permite TUDO (inseguro).

### **Código Completo**

#### **Criar WebConfig.java**

```java
package com.products.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(
                    "http://localhost:3000",      // React dev
                    "http://localhost:4200",      // Angular dev
                    "https://meusite.com"         // Produção
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600); // Cache de preflight (1 hora)
    }
}
```

#### **Remover @CrossOrigin dos Controllers**

```java
// ❌ ANTES
@RestController
@CrossOrigin // Remover isto
@RequestMapping("/api/products")
public class ProductController {
    // ...
}

// ✅ DEPOIS
@RestController
@RequestMapping("/api/products")
public class ProductController {
    // CORS configurado em WebConfig
}
```

---

## 📋 RESUMO DE IMPLEMENTAÇÕES

| # | Feature | Benefício | Dificuldade |
|---|---------|-----------|-------------|
| 1 | Paginação | Performance | ⭐⭐ Fácil |
| 2 | Busca com Filtros | UX melhor | ⭐⭐⭐ Médio |
| 3 | Auditoria | Rastreamento | ⭐ Muito Fácil |
| 4 | Soft Delete | Recuperação de dados | ⭐⭐ Fácil |
| 5 | Validation Errors | Mensagens claras | ⭐ Muito Fácil |
| 6 | Health Check | Monitoramento | ⭐ Muito Fácil |
| 7 | CORS Config | Segurança | ⭐ Muito Fácil |

---

## 🚀 ORDEM RECOMENDADA DE IMPLEMENTAÇÃO

1. ✅ **Health Check** (5 minutos) - Validar que tudo está funcionando
2. ✅ **Validation Errors** (10 minutos) - Melhorar mensagens de erro
3. ✅ **Auditoria** (15 minutos) - CreatedAt/UpdatedAt
4. ✅ **Paginação** (20 minutos) - Essencial para performance
5. ✅ **CORS Config** (10 minutos) - Segurança
6. ✅ **Soft Delete** (15 minutos) - Proteção de dados
7. ✅ **Busca com Filtros** (30 minutos) - Feature avançada

**Tempo Total:** ~2 horas

---

## 🧪 TESTANDO TUDO

Após implementar tudo, teste cada feature:

```bash
# 1. Health Check
curl http://localhost:8080/api/health

# 2. Criar produto (testar validation)
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"title": "Test"}' # Deve retornar erros de validação

# 3. Criar produto válido (testar auditoria)
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "title": "1984",
    "author": "Orwell",
    "publication_year": 1949,
    "price": 29.90,
    "isbn": "0451524934",
    "genre": "Dystopia",
    "language": "English",
    "product_type": "book"
  }'
# Verificar createdAt e updatedAt no JSON

# 4. Listar com paginação
curl "http://localhost:8080/api/products?page=0&size=5"

# 5. Buscar com filtros
curl "http://localhost:8080/api/products/search?title=1984&author=orwell"

# 6. Deletar (soft delete)
curl -X DELETE http://localhost:8080/api/products/1

# 7. Verificar que não aparece mais
curl http://localhost:8080/api/products
```

---

**Pronto! Com essas implementações seu projeto estará em nível profissional! 🚀**
