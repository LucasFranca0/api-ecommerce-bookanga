# 📖 README EDUCATIVO - API E-commerce Bookangá

## 🎯 Sobre Este Projeto

**API E-commerce Bookangá** é uma API RESTful desenvolvida em **Spring Boot** para gerenciar um e-commerce de livros e mangás. Este projeto foi criado com fins educacionais para aprender e aplicar conceitos fundamentais de desenvolvimento Java/Spring.

---

## 🏗️ Arquitetura do Projeto

### Por Que Usar Arquitetura em Camadas?

```
┌─────────────────────────────────────────────────────┐
│                    CLIENTE (Frontend)                │
│                  (React, Angular, etc)               │
└────────────────────┬────────────────────────────────┘
                     │ HTTP Requests
                     ↓
┌─────────────────────────────────────────────────────┐
│              CAMADA CONTROLLER (API)                 │
│  • Recebe requisições HTTP                           │
│  • Valida dados de entrada (@Valid)                  │
│  • Retorna respostas HTTP                            │
│  • Converte JSON ↔ Java Objects                      │
└────────────────────┬────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────┐
│              CAMADA SERVICE (Lógica de Negócio)      │
│  • Regras de negócio                                 │
│  • Validações complexas                              │
│  • Orquestração de operações                         │
│  • Transações (@Transactional)                       │
└────────────────────┬────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────┐
│           CAMADA REPOSITORY (Acesso a Dados)         │
│  • Abstração do banco de dados                       │
│  • Queries automáticas (JPA)                         │
│  • CRUD operations                                   │
└────────────────────┬────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────┐
│                 BANCO DE DADOS (MySQL)               │
│  • Armazenamento persistente                         │
└─────────────────────────────────────────────────────┘
```

### **Por Que Esta Separação?**

#### ✅ **Vantagens:**

1. **Separação de Responsabilidades (SRP - Single Responsibility Principle)**
   - Cada camada tem UMA responsabilidade específica
   - Controller: gerenciar HTTP
   - Service: lógica de negócio
   - Repository: acesso a dados

2. **Manutenibilidade**
   - Mudanças em uma camada não afetam outras
   - Exemplo: trocar MySQL por PostgreSQL só afeta Repository

3. **Testabilidade**
   - Cada camada pode ser testada independentemente
   - Mocks facilitam testes unitários

4. **Reusabilidade**
   - Services podem ser usados por múltiplos Controllers
   - Repositories podem ser usados por múltiplos Services

---

## 🔧 Tecnologias Utilizadas

### **Spring Boot 3.1.0**

**O Que É?**
Framework Java que simplifica o desenvolvimento de aplicações enterprise.

**Por Que Usar ao Invés de Spring Framework Puro?**

| Aspecto | Spring Boot | Spring Framework |
|---------|-------------|------------------|
| **Configuração** | Auto-configuration (zero XML) | Configuração manual extensa |
| **Servidor Embutido** | Tomcat/Jetty embutido | Precisa configurar servidor externo |
| **Dependências** | Starters gerenciam tudo | Gerenciar cada dependência |
| **Tempo de Setup** | Minutos | Horas/Dias |
| **Produtividade** | ⭐⭐⭐⭐⭐ Alta | ⭐⭐ Baixa |

**Exemplo:**
```java
// Spring Boot - 2 linhas
@SpringBootApplication
public class EcommerceApplication {
    public static void main(String[] args) {
        SpringApplication.run(EcommerceApplication.class, args);
    }
}

// Spring Framework puro - ~100 linhas de XML + configurações
```

---

### **Spring Data JPA (Hibernate)**

**O Que É?**
Abstração sobre JPA (Java Persistence API) que simplifica acesso a banco de dados.

**Por Que Usar ao Invés de JDBC Puro?**

**SEM JPA (JDBC):**
```java
public Product findById(Long id) {
    String sql = "SELECT * FROM product WHERE id = ?";
    try (Connection conn = dataSource.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setLong(1, id);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            Product product = new Product();
            product.setId(rs.getLong("id"));
            product.setTitle(rs.getString("title"));
            product.setAuthor(rs.getString("author"));
            // ... 10 linhas mais
            return product;
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    return null;
}
```

**COM JPA:**
```java
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Pronto! Métodos automáticos:
    // - findById()
    // - findAll()
    // - save()
    // - delete()
}
```

**Comparação:**

| Aspecto | JPA/Hibernate | JDBC Puro |
|---------|---------------|-----------|
| **Produtividade** | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **Código Boilerplate** | Mínimo | Muito |
| **Manutenibilidade** | Fácil | Difícil |
| **Performance** | Boa (cache L1/L2) | Excelente (controle total) |
| **Curva Aprendizado** | Média | Baixa |
| **Quando Usar** | 90% dos casos | Otimizações extremas |

---

### **Bean Validation (JSR 380)**

**O Que É?**
Validação declarativa usando annotations.

**Por Que Usar ao Invés de Validação Manual?**

**MANUAL (❌ Evitar):**
```java
@PostMapping
public Product createProduct(@RequestBody ProductDTO dto) {
    if (dto.getTitle() == null || dto.getTitle().trim().isEmpty()) {
        throw new InvalidProductDataException("Título obrigatório");
    }
    if (dto.getPrice() == null || dto.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
        throw new InvalidProductDataException("Preço inválido");
    }
    if (dto.getIsbn() == null || !dto.getIsbn().matches("\\d{10}|\\d{13}")) {
        throw new InvalidProductDataException("ISBN inválido");
    }
    // ... 20 validações mais
    
    return productService.createProduct(dto);
}
```

**BEAN VALIDATION (✅ Preferir):**
```java
// DTO
public class ProductDTO {
    @NotBlank(message = "Título obrigatório")
    private String title;
    
    @Positive(message = "Preço inválido")
    private BigDecimal price;
    
    @Pattern(regexp = "\\d{10}|\\d{13}", message = "ISBN inválido")
    private String isbn;
}

// Controller
@PostMapping
public Product createProduct(@Valid @RequestBody ProductDTO dto) {
    // Se validação falhar, Spring automaticamente retorna 400 Bad Request
    return productService.createProduct(dto);
}
```

**Vantagens:**
- ✅ **DRY** (Don't Repeat Yourself): validação em um lugar
- ✅ **Declarativo**: fica claro as regras
- ✅ **Reusável**: mesma validação em múltiplos endpoints
- ✅ **Padrão**: JSR 380 (Java Standard)

---

### **Lombok**

**O Que É?**
Biblioteca que gera código boilerplate automaticamente.

**Por Que Usar?**

**SEM LOMBOK:**
```java
public class Product {
    private Long id;
    private String title;
    private String author;
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Product product = (Product) o;
        return Objects.equals(id, product.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return "Product{id=" + id + ", title='" + title + "', author='" + author + "'}";
    }
}
// 50+ linhas
```

**COM LOMBOK:**
```java
@Data
public class Product {
    private Long id;
    private String title;
    private String author;
}
// 6 linhas - mesmo resultado!
```

**Annotations Principais:**
- `@Data`: Gera getters, setters, equals, hashCode, toString
- `@Getter` / `@Setter`: Só getters/setters
- `@NoArgsConstructor` / `@AllArgsConstructor`: Construtores
- `@Builder`: Padrão Builder
- `@Slf4j`: Logger

**⚠️ Cuidado:**
```java
// ❌ EVITAR @Data em entidades JPA com relacionamentos
@Data
@Entity
public class Sale {
    @OneToMany
    private List<SaleItem> items; // Pode causar recursão infinita no toString!
}

// ✅ PREFERIR
@Getter
@Setter
@Entity
public class Sale {
    @OneToMany
    private List<SaleItem> items;
}
```

---

### **MySQL**

**O Que É?**
Banco de dados relacional open-source.

**Por Que Usar MySQL ao Invés de Outros Bancos?**

| Banco | Uso Típico | Vantagens | Desvantagens |
|-------|-----------|-----------|--------------|
| **MySQL** | E-commerce, CMS, Apps Web | Fácil, rápido reads, popular | Menos features que Postgres |
| **PostgreSQL** | Apps enterprise, dados complexos | JSON nativo, full-text search, extensível | Setup mais complexo |
| **MongoDB** | Big Data, logs, analytics | Flexibilidade (schemaless) | Sem ACID (transações) completo |
| **H2** | Testes | In-memory, zero config | Não persistente |

**Quando Usar Cada Um:**

**MySQL (Sua Escolha):**
- ✅ E-commerce (caso de uso perfeito!)
- ✅ Blogs, CMS
- ✅ Aplicações com muitas leituras
- ✅ Quando equipe já conhece MySQL

**PostgreSQL:**
- ✅ Dados complexos (JSON)
- ✅ Full-text search avançado
- ✅ Geolocalização (PostGIS)
- ✅ Quando precisa de features avançadas

**MongoDB:**
- ✅ Logs, eventos
- ✅ Big Data
- ✅ Estrutura de dados variável
- ❌ **NÃO** para e-commerce (precisa de transações!)

---

## 🎨 Padrões de Projeto Utilizados

### **1. Repository Pattern**

**O Que É?**
Abstração que separa lógica de negócio do acesso a dados.

**Como Funciona no Projeto:**
```java
// Interface define o contrato
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Spring Data JPA implementa automaticamente!
}

// Service usa Repository (não acessa banco direto)
@Service
public class ProductService {
    private final ProductRepository repository;
    
    public Product getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new ProductNotFoundException("Not found"));
    }
}
```

**Por Que Usar?**
- ✅ **Desacoplamento**: Service não sabe se é MySQL, PostgreSQL ou MongoDB
- ✅ **Testabilidade**: Fácil mockar em testes
- ✅ **DRY**: Queries reutilizáveis

---

### **2. DTO Pattern (Data Transfer Object)**

**O Que É?**
Objeto usado para transferir dados entre camadas.

**Por Que Usar ao Invés de Retornar Entidades Direto?**

**❌ SEM DTO (Retornando Entidade):**
```java
@Entity
public class User {
    private Long id;
    private String name;
    private String email;
    private String password; // 😱 EXPOSTO NA API!
    private String creditCard; // 😱 VAZAMENTO DE DADOS!
}

// Controller
@GetMapping
public User getUser() {
    return userRepository.findById(1L).get();
}

// Resposta JSON
{
    "id": 1,
    "name": "João",
    "email": "joao@email.com",
    "password": "$2a$10$...", // 💀 SENHA NO JSON!
    "creditCard": "1234-5678-9012-3456" // 💀 DADOS SENSÍVEIS!
}
```

**✅ COM DTO:**
```java
// DTO expõe SOMENTE o necessário
public class UserDTO {
    private Long id;
    private String name;
    // SEM password, SEM creditCard
}

// Controller
@GetMapping
public UserDTO getUser() {
    User user = userRepository.findById(1L).get();
    return new UserDTO(user.getId(), user.getName());
}

// Resposta JSON (SEGURA)
{
    "id": 1,
    "name": "João"
}
```

**Vantagens:**
1. **Segurança**: Controla o que é exposto
2. **Flexibilidade**: JSON diferente da estrutura do banco
3. **Versionamento**: Múltiplos DTOs para mesma entidade
4. **Performance**: Pode retornar menos dados

**Exemplo de Flexibilidade:**
```java
// Entidade
@Entity
public class Product {
    private Long id;
    private String title;
    private String author;
    private String internalNotes; // Só para uso interno
    private BigDecimal cost; // Custo de compra (confidencial)
    private BigDecimal price; // Preço de venda
}

// DTO para API pública
public class ProductDTO {
    private Long id;
    private String title;
    private String author;
    private BigDecimal price; // Só preço de venda
    // SEM internalNotes, SEM cost
}

// DTO para API admin
public class ProductAdminDTO {
    private Long id;
    private String title;
    private String author;
    private String internalNotes; // Admin pode ver
    private BigDecimal cost; // Admin pode ver
    private BigDecimal price;
    private BigDecimal profit; // Calculado (price - cost)
}
```

---

### **3. Strategy Pattern (Herança)**

**O Que É?**
Define uma família de algoritmos e os torna intercambiáveis.

**Como Está no Projeto:**
```java
// Estratégia base
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public abstract class Product {
    private String title;
    private String author;
    
    public abstract String getProductType(); // Método abstrato
}

// Estratégia concreta 1
@Entity
public class Book extends Product {
    @Override
    public String getProductType() {
        return "book";
    }
}

// Estratégia concreta 2
@Entity
public class Manga extends Product {
    private Integer volume; // Campo específico de Manga
    
    @Override
    public String getProductType() {
        return "manga";
    }
}
```

**Por Que Usar?**
- ✅ **Extensibilidade**: Fácil adicionar novos tipos (Magazine, Comic)
- ✅ **Polimorfismo**: Tratar todos como Product
- ✅ **DRY**: Campos comuns em Product

**Estratégias de Herança JPA:**

| Estratégia | Estrutura | Performance | Quando Usar |
|-----------|-----------|-------------|-------------|
| **SINGLE_TABLE** | 1 tabela com discriminator | ⭐⭐⭐⭐⭐ | Poucas diferenças (Book vs Manga) ✅ |
| **JOINED** | 1 tabela por classe | ⭐⭐⭐ | Muitas diferenças, normalização importante |
| **TABLE_PER_CLASS** | Tabelas separadas | ⭐⭐ | Sem relação entre classes |

**Sua Escolha (SINGLE_TABLE):**
```sql
-- Uma tabela com discriminator
CREATE TABLE product (
    id BIGINT PRIMARY KEY,
    title VARCHAR(70),
    author VARCHAR(50),
    product_type VARCHAR(10), -- 'book' ou 'manga'
    volume INT,               -- NULL para books
    ...
);
```

**Vantagens:**
- ✅ Performance excelente (sem JOINs)
- ✅ Queries simples
- ✅ Perfeito quando as diferenças são pequenas

**Desvantagens:**
- ❌ Campos específicos são NULL para outros tipos
- ❌ Menos normalizado

---

### **4. Exception Handler Pattern**

**O Que É?**
Centraliza tratamento de exceções em um só lugar.

**Por Que Usar ao Invés de Try/Catch em Cada Controller?**

**❌ SEM @ControllerAdvice:**
```java
@RestController
public class ProductController {
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getProduct(@PathVariable Long id) {
        try {
            Product product = productService.getById(id);
            return ResponseEntity.ok(product);
        } catch (ProductNotFoundException e) {
            return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponse("Erro interno"));
        }
    }
    
    @PostMapping
    public ResponseEntity<?> createProduct(@RequestBody ProductDTO dto) {
        try {
            Product product = productService.create(dto);
            return ResponseEntity.status(HttpStatus.CREATED).body(product);
        } catch (InvalidProductDataException e) {
            return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponse("Erro interno"));
        }
    }
    
    // 🔴 Repetição em TODOS os endpoints!
}
```

**✅ COM @ControllerAdvice (Seu Projeto):**
```java
// Centralizado em um lugar
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ProductNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }
    
    @ExceptionHandler(InvalidProductDataException.class)
    public ResponseEntity<ErrorResponse> handleInvalidData(InvalidProductDataException ex) {
        ErrorResponse error = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        ErrorResponse error = new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), "Erro interno");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}

// Controllers ficam limpos
@RestController
public class ProductController {
    
    @GetMapping("/{id}")
    public Product getProduct(@PathVariable Long id) {
        // Se lançar exceção, @ControllerAdvice trata automaticamente!
        return productService.getById(id);
    }
    
    @PostMapping
    public ResponseEntity<Product> createProduct(@Valid @RequestBody ProductDTO dto) {
        Product product = productService.create(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(product);
    }
}
```

**Vantagens:**
- ✅ **DRY**: Tratamento em um lugar
- ✅ **Consistência**: Mesma estrutura de erro em toda API
- ✅ **Manutenibilidade**: Fácil alterar formato de erro
- ✅ **Limpeza**: Controllers sem try/catch

---

## 📦 Estrutura de Diretórios Explicada

```
src/main/java/com/products/
│
├── EcommerceApplication.java      # Ponto de entrada (main)
│
├── controller/                     # 🌐 Camada de apresentação
│   ├── ProductController.java     # Endpoints REST de produtos
│   └── SaleController.java        # Endpoints REST de vendas
│
├── service/                        # 💼 Lógica de negócio
│   ├── ProductService.java        # Regras de negócio de produtos
│   ├── SaleService.java           # Interface de vendas
│   └── SaleServiceImpl.java       # Implementação de vendas
│
├── repository/                     # 💾 Acesso a dados
│   └── ProductRepository.java     # CRUD automático de produtos
│
├── model/                          # 🗂️ Entidades JPA (tabelas)
│   ├── Product.java               # Classe base (herança)
│   ├── Book.java                  # Subclasse de Product
│   ├── Manga.java                 # Subclasse de Product
│   ├── Sale.java                  # Venda
│   ├── SaleItem.java              # Item de venda
│   └── User.java                  # Usuário
│
├── dto/                            # 📄 Objetos de transferência
│   ├── ProductDTO.java            # Request/Response de produto
│   └── SaleDTO.java               # Request de venda
│
└── exception/                      # ❌ Tratamento de erros
    ├── GlobalExceptionHandler.java
    ├── ProductNotFoundException.java
    ├── InvalidProductDataException.java
    └── ErrorResponse.java
```

**Por Que Separar Assim?**

1. **Controller**: "O que a API expõe"
2. **Service**: "Como faz"
3. **Repository**: "Onde busca"
4. **Model**: "O que armazena"
5. **DTO**: "O que transfere"
6. **Exception**: "Como trata erros"

---

## 🚀 Como Executar o Projeto

### **Pré-requisitos**
- Java 17+
- Maven 3.8+
- MySQL 8.0+

### **Passo a Passo**

1. **Clone o repositório**
```bash
git clone <url-do-repositorio>
cd api-ecommerce-bookanga
```

2. **Configure o banco de dados**
```sql
CREATE DATABASE ecommerce;
```

3. **Configure application.properties**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha
```

4. **Execute o projeto**
```bash
mvn spring-boot:run
```

5. **Teste a API**
```bash
curl http://localhost:8080/api/products
```

---

## 📡 Endpoints da API

### **Produtos**

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/products` | Lista todos os produtos |
| GET | `/api/products/{id}` | Busca produto por ID |
| POST | `/api/products` | Cria novo produto |
| PUT | `/api/products/{id}` | Atualiza produto |
| DELETE | `/api/products/{id}` | Deleta produto |
| DELETE | `/api/products` | Deleta todos (⚠️ usar com cuidado!) |

### **Exemplo de Requisição POST**
```json
POST /api/products
Content-Type: application/json

{
    "title": "1984",
    "author": "George Orwell",
    "publication_year": 1949,
    "price": 29.90,
    "isbn": "0451524934",
    "genre": "Dystopia",
    "language": "English",
    "product_type": "book"
}
```

### **Exemplo de Resposta**
```json
{
    "id": 1,
    "title": "1984",
    "author": "George Orwell",
    "publication_year": 1949,
    "price": 29.90,
    "isbn": "0451524934",
    "genre": "Dystopia",
    "language": "English",
    "product_type": "book"
}
```

---

## 🧪 Testando a API

### **Usando cURL**
```bash
# GET - Listar produtos
curl http://localhost:8080/api/products

# POST - Criar produto
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Naruto",
    "author": "Masashi Kishimoto",
    "publication_year": 1999,
    "price": 19.90,
    "isbn": "1234567890123",
    "genre": "Shonen",
    "language": "Japanese",
    "product_type": "manga",
    "volume": 1
  }'
```

### **Usando Postman**
1. Importar collection (criar arquivo JSON)
2. Configurar base URL: `http://localhost:8080`
3. Executar requests

---

## 🎓 Conceitos-Chave Para Aprender

### **1. Injeção de Dependência**

**O Problema:**
```java
// ❌ Acoplamento forte
public class ProductController {
    private ProductService service = new ProductService(); // Dependência hard-coded
}
```

**A Solução:**
```java
// ✅ Injeção de dependência
@RestController
public class ProductController {
    
    private final ProductService service;
    
    @Autowired // Spring injeta automaticamente
    public ProductController(ProductService service) {
        this.service = service;
    }
}
```

**Por Que Usar?**
- ✅ Facilita testes (pode injetar mock)
- ✅ Desacoplamento
- ✅ Configuração centralizada no Spring

---

### **2. REST (Representational State Transfer)**

**Princípios REST:**

| Princípio | Significado | Exemplo |
|-----------|-------------|---------|
| **Stateless** | Servidor não guarda estado | Cada request tem todas informações |
| **Resource-Based** | URLs representam recursos | `/products/1` (não `/getProduct?id=1`) |
| **HTTP Verbs** | Métodos HTTP têm significado | GET=ler, POST=criar, PUT=atualizar, DELETE=deletar |
| **Representations** | Dados em formatos padrão | JSON, XML |

**Boas Práticas REST:**
```
✅ GET    /api/products        - Lista
✅ GET    /api/products/1      - Busca por ID
✅ POST   /api/products        - Cria
✅ PUT    /api/products/1      - Atualiza
✅ DELETE /api/products/1      - Deleta

❌ GET    /api/getProducts     - Verbo na URL
❌ POST   /api/products/create - Ação na URL
❌ GET    /api/products/delete/1 - Usar DELETE!
```

---

### **3. HTTP Status Codes**

| Código | Significado | Quando Usar |
|--------|-------------|-------------|
| **200 OK** | Sucesso | GET, PUT bem-sucedidos |
| **201 Created** | Criado | POST bem-sucedido |
| **204 No Content** | Sem conteúdo | DELETE bem-sucedido |
| **400 Bad Request** | Dados inválidos | Validação falhou |
| **404 Not Found** | Não encontrado | Recurso não existe |
| **500 Internal Server Error** | Erro do servidor | Exceção não tratada |

---

## 📚 Recursos Para Continuar Aprendendo

### **Documentação Oficial**
- [Spring Boot Reference](https://docs.spring.io/spring-boot/docs/current/reference/)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/docs/current/reference/)
- [Bean Validation](https://beanvalidation.org/)

### **Tutoriais**
- [Baeldung Spring Tutorials](https://www.baeldung.com/spring-tutorial)
- [Spring Guides](https://spring.io/guides)

### **Livros**
- "Spring in Action" - Craig Walls
- "High-Performance Java Persistence" - Vlad Mihalcea

---

## 🤝 Contribuindo

Este é um projeto educacional. Sugestões e melhorias são bem-vindas!

---

## 📄 Licença

Este projeto é livre para uso educacional.

---

## 👨‍💻 Autor

Desenvolvido como projeto de aprendizado em Java e Spring Boot.

---

## 📞 Suporte

Para dúvidas e sugestões:
- Consulte o arquivo `AVALIACAO_COMPLETA.md` para análise detalhada
- Consulte o arquivo `GUIA_DE_APRENDIZADO.md` para plano de estudos

---

**🎯 Próximos Passos Sugeridos:**
1. Implementar testes unitários
2. Adicionar Spring Security
3. Implementar paginação
4. Documentar com Swagger/OpenAPI
5. Adicionar cache (Redis)

**Bons estudos! 🚀**
