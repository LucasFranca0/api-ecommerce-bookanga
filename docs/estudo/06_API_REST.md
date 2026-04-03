# 📚 Módulo 6: API REST e Boas Práticas

> **Tempo estimado:** 3-4 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Essencial para desenvolvimento web)

---

## 🎯 O que você vai aprender:

1. ✅ O que é REST e API
2. ✅ Métodos HTTP (GET, POST, PUT, DELETE, PATCH)
3. ✅ Status Codes HTTP
4. ✅ Design de URLs RESTful
5. ✅ Request e Response
6. ✅ DTOs e boas práticas

---

## 📌 1. O QUE É REST?

### 💡 Definição:

**REST** (Representational State Transfer) é um estilo arquitetural para comunicação entre sistemas via HTTP.

**API** (Application Programming Interface) é uma interface que permite sistemas se comunicarem.

**API REST** = Interface de comunicação que segue os princípios REST.

### 🔄 Como funciona:

```
┌─────────────┐                              ┌─────────────┐
│   Cliente   │                              │   Servidor  │
│  (Frontend) │                              │   (API)     │
├─────────────┤                              ├─────────────┤
│             │    HTTP Request              │             │
│             │  ──────────────────────────► │             │
│  Browser    │    GET /api/v1/products      │  Bookanga   │
│  Mobile     │                              │  Spring     │
│  Postman    │    HTTP Response             │  Boot       │
│             │  ◄────────────────────────── │             │
│             │    200 OK + JSON             │             │
└─────────────┘                              └─────────────┘
```

---

## 📌 2. MÉTODOS HTTP

### 📊 Os 5 principais métodos:

| Método | Ação | CRUD | Idempotente? | Corpo? |
|--------|------|------|--------------|--------|
| `GET` | Buscar | Read | ✅ Sim | ❌ Não |
| `POST` | Criar | Create | ❌ Não | ✅ Sim |
| `PUT` | Atualizar (completo) | Update | ✅ Sim | ✅ Sim |
| `PATCH` | Atualizar (parcial) | Update | ✅ Sim | ✅ Sim |
| `DELETE` | Remover | Delete | ✅ Sim | ❌ Não |

### 🧠 O que é Idempotente?

**Idempotente** = Executar múltiplas vezes produz o mesmo resultado.

```
GET /products/1     → Sempre retorna o mesmo produto ✅
DELETE /products/1  → Primeira vez deleta, depois "não existe" ✅
POST /products      → Cada chamada cria um NOVO produto ❌
```

### 🔍 Exemplos no Bookanga:

```java
@RestController
@RequestMapping("/api/v1/products")
public class ProductController {

    // GET - Buscar todos
    @GetMapping
    public List<Product> getAllProducts() { }

    // GET - Buscar por ID
    @GetMapping("/{id}")
    public Product getProductById(@PathVariable Long id) { }

    // POST - Criar novo
    @PostMapping
    public Product createProduct(@RequestBody ProductDTO dto) { }

    // PUT - Atualizar completo
    @PutMapping("/{id}")
    public Product updateProduct(@PathVariable Long id, @RequestBody ProductDTO dto) { }

    // PATCH - Atualizar parcial (exemplo)
    @PatchMapping("/{id}")
    public Product patchProduct(@PathVariable Long id, @RequestBody Map<String, Object> updates) { }

    // DELETE - Remover
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) { }
}
```

---

## 📌 3. STATUS CODES HTTP

### 📊 Categorias:

| Faixa | Categoria | Significado |
|-------|-----------|-------------|
| `1xx` | Informacional | Processando... |
| `2xx` | Sucesso | Deu certo! ✅ |
| `3xx` | Redirecionamento | Vá para outro lugar |
| `4xx` | Erro do Cliente | Você errou! ❌ |
| `5xx` | Erro do Servidor | Eu errei! 💥 |

### 🟢 Status de Sucesso (2xx):

| Status | Nome | Quando usar |
|--------|------|-------------|
| `200` | OK | GET, PUT, PATCH com sucesso |
| `201` | Created | POST criou recurso |
| `204` | No Content | DELETE com sucesso (sem corpo) |

### 🔴 Status de Erro do Cliente (4xx):

| Status | Nome | Quando usar |
|--------|------|-------------|
| `400` | Bad Request | Dados inválidos |
| `401` | Unauthorized | Não autenticado |
| `403` | Forbidden | Autenticado mas sem permissão |
| `404` | Not Found | Recurso não existe |
| `409` | Conflict | Conflito (ex: duplicado) |
| `422` | Unprocessable Entity | Validação falhou |

### 🔴 Status de Erro do Servidor (5xx):

| Status | Nome | Quando usar |
|--------|------|-------------|
| `500` | Internal Server Error | Erro genérico do servidor |
| `502` | Bad Gateway | Erro de proxy/gateway |
| `503` | Service Unavailable | Servidor indisponível |

### 🔍 No Bookanga:

```java
@RestController
public class ProductController {

    // 200 OK
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id) {
        Product product = service.findById(id);
        return ResponseEntity.ok(product);  // 200
    }

    // 201 Created
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody ProductDTO dto) {
        Product created = service.create(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);  // 201
    }

    // 204 No Content
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();  // 204
    }
}

// Exception Handler
@ControllerAdvice
public class GlobalExceptionHandler {

    // 404 Not Found
    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ProductNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)  // 404
            .body(new ErrorResponse(404, ex.getMessage()));
    }

    // 400 Bad Request
    @ExceptionHandler(InvalidProductDataException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(InvalidProductDataException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)  // 400
            .body(new ErrorResponse(400, ex.getMessage()));
    }
}
```

---

## 📌 4. DESIGN DE URLs RESTful

### ✅ Boas práticas:

| Regra | Bom ✅ | Ruim ❌ |
|-------|--------|---------|
| Use substantivos, não verbos | `/products` | `/getProducts` |
| Use plural | `/products` | `/product` |
| Use kebab-case | `/sale-items` | `/saleItems` |
| Hierarquia com aninhamento | `/users/1/orders` | `/getUserOrders?userId=1` |
| Versionamento | `/api/v1/products` | `/products` |

### 📊 Padrão de URLs:

```
# Coleção
GET    /api/v1/products          → Lista todos
POST   /api/v1/products          → Cria novo

# Recurso específico
GET    /api/v1/products/1        → Busca por ID
PUT    /api/v1/products/1        → Atualiza por ID
PATCH  /api/v1/products/1        → Atualiza parcial
DELETE /api/v1/products/1        → Remove por ID

# Relacionamentos
GET    /api/v1/users/1/orders    → Pedidos do usuário 1
GET    /api/v1/orders/5/items    → Itens do pedido 5

# Filtros (query params)
GET    /api/v1/products?genre=fiction
GET    /api/v1/products?minPrice=10&maxPrice=50
GET    /api/v1/products?page=0&size=10&sort=price,desc

# Ações especiais (quando necessário)
POST   /api/v1/orders/1/cancel   → Cancelar pedido
POST   /api/v1/products/1/archive → Arquivar produto
```

---

## 📌 5. REQUEST E RESPONSE

### 📥 Request (Requisição):

```http
POST /api/v1/products HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...

{
    "title": "1984",
    "author": "George Orwell",
    "price": 29.90,
    "isbn": "9780451524935"
}
```

| Parte | Descrição |
|-------|-----------|
| **Método** | POST |
| **URL** | /api/v1/products |
| **Headers** | Content-Type, Authorization |
| **Body** | JSON com dados |

### 📤 Response (Resposta):

```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v1/products/1

{
    "id": 1,
    "title": "1984",
    "author": "George Orwell",
    "price": 29.90,
    "isbn": "9780451524935",
    "createdAt": "2026-01-01T10:00:00Z"
}
```

| Parte | Descrição |
|-------|-----------|
| **Status** | 201 Created |
| **Headers** | Content-Type, Location |
| **Body** | JSON com recurso criado |

---

## 📌 6. ANOTAÇÕES SPRING PARA REST

### 📋 Anotações de Mapeamento:

```java
@RestController  // Marca como controller REST
@RequestMapping("/api/v1/products")  // URL base
public class ProductController {

    @GetMapping           // GET /api/v1/products
    @GetMapping("/{id}")  // GET /api/v1/products/1
    
    @PostMapping          // POST /api/v1/products
    
    @PutMapping("/{id}")  // PUT /api/v1/products/1
    
    @PatchMapping("/{id}")// PATCH /api/v1/products/1
    
    @DeleteMapping("/{id}") // DELETE /api/v1/products/1
}
```

### 📋 Anotações de Parâmetros:

```java
// @PathVariable - Valor da URL
@GetMapping("/{id}")
public Product getById(@PathVariable Long id) { }
// GET /products/1 → id = 1

// @RequestParam - Query parameter
@GetMapping
public List<Product> search(@RequestParam String genre) { }
// GET /products?genre=fiction → genre = "fiction"

// @RequestParam com valor padrão
@GetMapping
public Page<Product> list(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size) { }

// @RequestBody - Corpo JSON
@PostMapping
public Product create(@RequestBody ProductDTO dto) { }
// POST com JSON no corpo

// @RequestHeader - Header HTTP
@GetMapping
public Product get(@RequestHeader("Authorization") String token) { }

// @Valid - Ativa validação
@PostMapping
public Product create(@Valid @RequestBody ProductDTO dto) { }
```

---

## 📌 7. DTOs (Data Transfer Objects)

### 💡 Por que usar DTOs?

```
❌ Sem DTO (usando Entity diretamente):
- Expõe estrutura interna do banco
- Campos desnecessários na resposta
- Difícil validar entrada
- Risco de segurança

✅ Com DTO:
- Controla exatamente o que entra e sai
- Validação na entrada
- Diferentes formatos para diferentes endpoints
- Desacopla API da estrutura do banco
```

### 🔍 Exemplo no Bookanga:

```java
// Entity (estrutura do banco)
@Entity
public class Product {
    @Id
    private Long id;
    private String title;
    private String author;
    private BigDecimal price;
    private String isbn;
    private LocalDateTime createdAt;  // Não queremos expor
    private LocalDateTime updatedAt;  // Não queremos expor
    private boolean deleted;          // Não queremos expor
}

// DTO de entrada (Request)
@Data
public class ProductRequestDTO {
    @NotBlank
    private String title;
    
    @NotBlank
    private String author;
    
    @Positive
    private BigDecimal price;
    
    @Pattern(regexp = "\\d{10}|\\d{13}")
    private String isbn;
}

// DTO de saída (Response)
@Data
public class ProductResponseDTO {
    private Long id;
    private String title;
    private String author;
    private BigDecimal price;
    private String isbn;
    // Sem createdAt, updatedAt, deleted
}

// Controller usando DTOs
@RestController
public class ProductController {
    
    @PostMapping
    public ProductResponseDTO create(@Valid @RequestBody ProductRequestDTO request) {
        Product product = mapper.toEntity(request);
        Product saved = service.save(product);
        return mapper.toResponse(saved);
    }
}
```

### 🔄 Padrões de DTO:

| Padrão | Uso |
|--------|-----|
| `CreateProductDTO` | Criar novo produto |
| `UpdateProductDTO` | Atualizar produto |
| `ProductResponseDTO` | Resposta da API |
| `ProductListDTO` | Lista resumida |
| `ProductDetailDTO` | Detalhes completos |

---

## 📌 8. PAGINAÇÃO

### 💡 Por que paginar?

```
❌ Sem paginação:
GET /products → Retorna 10.000 produtos
Problema: Lento, consome memória, ruim pro cliente

✅ Com paginação:
GET /products?page=0&size=10 → Retorna 10 produtos
Página por página, eficiente
```

### 🔍 Implementação com Spring Data:

```java
@RestController
public class ProductController {

    @GetMapping
    public Page<Product> list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String direction) {
        
        Sort sort = direction.equals("desc") 
            ? Sort.by(sortBy).descending() 
            : Sort.by(sortBy).ascending();
            
        Pageable pageable = PageRequest.of(page, size, sort);
        return productRepository.findAll(pageable);
    }
}
```

### 📤 Response paginado:

```json
{
    "content": [
        { "id": 1, "title": "1984" },
        { "id": 2, "title": "Brave New World" }
    ],
    "pageable": {
        "pageNumber": 0,
        "pageSize": 10,
        "sort": { "sorted": true, "unsorted": false }
    },
    "totalElements": 100,
    "totalPages": 10,
    "first": true,
    "last": false,
    "numberOfElements": 10
}
```

---

## 📌 9. VERSIONAMENTO DE API

### 📊 Estratégias:

| Estratégia | Exemplo | Prós/Contras |
|------------|---------|--------------|
| **URL Path** | `/api/v1/products` | ✅ Simples, ❌ Muda URL |
| **Query Param** | `/products?version=1` | ✅ Mesma URL, ❌ Poluído |
| **Header** | `Accept: application/vnd.api.v1+json` | ✅ URL limpa, ❌ Complexo |

### 🔍 O Bookanga usa URL Path (mais comum):

```java
@RestController
@RequestMapping("/api/v1/products")  // Versão 1
public class ProductControllerV1 { }

@RestController
@RequestMapping("/api/v2/products")  // Versão 2 (futura)
public class ProductControllerV2 { }
```

---

## 📌 10. BOAS PRÁTICAS

### ✅ Faça:

1. **Use substantivos, não verbos**
   ```
   ✅ POST /products
   ❌ POST /createProduct
   ```

2. **Retorne o recurso criado/atualizado**
   ```java
   @PostMapping
   public Product create(@RequestBody ProductDTO dto) {
       return service.save(dto);  // Retorna o produto criado
   }
   ```

3. **Use status codes corretos**
   ```java
   return ResponseEntity.status(HttpStatus.CREATED).body(product);
   ```

4. **Valide a entrada**
   ```java
   public Product create(@Valid @RequestBody ProductDTO dto)
   ```

5. **Documente a API (Swagger/OpenAPI)**

### ❌ Não faça:

1. **Retornar 200 para tudo**
   ```java
   // RUIM
   return ResponseEntity.ok(null);  // Deveria ser 404
   ```

2. **Expor entities diretamente**
   ```java
   // RUIM - expõe estrutura do banco
   public Product create(@RequestBody Product product)
   ```

3. **URLs com verbos**
   ```
   ❌ /getProducts
   ❌ /deleteProduct
   ```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Analise os endpoints

Olhe o `ProductController` do Bookanga e identifique:
1. Quais métodos HTTP são usados?
2. Quais status codes são retornados?
3. Onde está sendo usada validação?

### Exercício 2: Melhore o DELETE

```java
// Atual:
@DeleteMapping("/{id}")
public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
    productService.deleteProduct(id);
    return ResponseEntity.noContent().build();
}

// Melhore para tratar caso de produto não encontrado
```

### Exercício 3: Adicione paginação

Modifique o `getAllProducts()` para suportar paginação:
```java
@GetMapping
public Page<Product> getAllProducts(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size) {
    // implementar
}
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **REST** | Estilo arquitetural para APIs |
| **GET** | Buscar recursos |
| **POST** | Criar recurso |
| **PUT** | Atualizar recurso (completo) |
| **PATCH** | Atualizar recurso (parcial) |
| **DELETE** | Remover recurso |
| **2xx** | Sucesso |
| **4xx** | Erro do cliente |
| **5xx** | Erro do servidor |
| **DTO** | Objeto de transferência de dados |
| **Paginação** | Dividir resultados em páginas |

---

## ⏭️ Próximo Módulo

**Módulo 7: Monitoramento com Actuator, Prometheus e Grafana**

---

**🎉 Parabéns por completar o Módulo 6!**

