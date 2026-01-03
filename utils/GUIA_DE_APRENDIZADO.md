# 📚 GUIA DE APRENDIZADO - Spring Boot & Java

## 🎯 PLANO DE ESTUDOS ESTRUTURADO

Este guia foi criado especificamente para você evoluir do seu nível atual para um desenvolvedor Spring Boot sênior.

---

## 📊 SEU NÍVEL ATUAL (Avaliado pelo projeto)

**Nível Estimado:** Júnior/Pleno (Transição)

**O que você JÁ DOMINA:**
- ✅ Conceitos básicos de POO (herança, encapsulamento)
- ✅ Arquitetura em camadas (MVC)
- ✅ REST APIs básicas
- ✅ JPA/Hibernate fundamentos
- ✅ Bean Validation
- ✅ Exception Handling

**O que você PRECISA APRENDER:**
- 📚 Gerenciamento de dependências (Maven avançado)
- 📚 Spring Boot profundo (auto-configuration, profiles)
- 📚 Testes automatizados (TDD)
- 📚 Spring Security
- 📚 Performance e otimização
- 📚 Design Patterns aplicados
- 📚 Microservices

---

## 🗺️ ROADMAP DE APRENDIZADO (12 SEMANAS)

### 📅 SEMANA 1-2: FUNDAMENTOS SÓLIDOS

#### **Tópico 1: Maven Profundo**

**POR QUE APRENDER:**
Você está com dependências conflitantes. Maven é essencial para gerenciar projetos profissionais.

**O QUE ESTUDAR:**
1. Ciclo de vida do Maven (compile, test, package, install, deploy)
2. Dependency Management vs Dependencies
3. Scopes (compile, runtime, test, provided)
4. Maven Parent POM e herança
5. Profiles (dev, test, prod)
6. Plugins essenciais

**RECURSOS:**
- 📖 [Maven Official Guide](https://maven.apache.org/guides/getting-started/)
- 📺 YouTube: "Maven Full Course" - Amigoscode
- 🛠️ **PRÁTICA:** Corrigir o pom.xml do seu projeto

**EXERCÍCIO PRÁTICO:**
```xml
<!-- Desafio: Configure seu projeto com profiles -->
<profiles>
    <profile>
        <id>dev</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <spring.profiles.active>dev</spring.profiles.active>
        </properties>
    </profile>
    <profile>
        <id>prod</id>
        <properties>
            <spring.profiles.active>prod</spring.profiles.active>
        </properties>
    </profile>
</profiles>
```

---

#### **Tópico 2: Spring Boot Internals**

**POR QUE APRENDER:**
Entender como Spring Boot funciona por trás dos panos te torna um desenvolvedor muito melhor.

**O QUE ESTUDAR:**
1. **Auto-Configuration:** Como `@SpringBootApplication` funciona
2. **Component Scanning:** Como Spring encontra seus beans
3. **Dependency Injection:** Field vs Constructor vs Setter
4. **Bean Lifecycle:** @PostConstruct, @PreDestroy
5. **Profiles:** Configurações por ambiente
6. **Properties:** application.properties vs application.yml

**CONCEITO IMPORTANTE - Dependency Injection:**

```java
// 🔍 ENTENDA AS DIFERENÇAS

// ❌ FIELD INJECTION (não recomendado)
@RestController
public class ProductController {
    @Autowired
    private ProductService productService; // Difícil testar, acoplado
}

// ✅ CONSTRUCTOR INJECTION (RECOMENDADO)
@RestController
@RequiredArgsConstructor // Lombok gera o construtor
public class ProductController {
    private final ProductService productService; // Imutável, fácil testar
}

// 📝 POR QUE CONSTRUCTOR É MELHOR:
// 1. Campos podem ser 'final' (imutabilidade)
// 2. Fácil criar testes (new ProductController(mockService))
// 3. Deixa claro as dependências obrigatórias
// 4. Evita NullPointerException
```

**RESOURCES:**
- 📖 Spring Boot Reference Documentation (Seção: Core Features)
- 📺 YouTube: "Spring Boot Tutorial" - Spring Academy
- 📚 Livro: "Spring in Action" - Craig Walls (Capítulos 1-3)

**EXERCÍCIO PRÁTICO:**
Criar aplicação com 3 profiles (dev, test, prod) com configurações diferentes.

---

### 📅 SEMANA 3-4: TESTES AUTOMATIZADOS

**POR QUE APRENDER:**
Seu projeto tem JUnit 3.8.1 (2003!) e zero testes. Testes são **OBRIGATÓRIOS** em empresas.

#### **Tópico 1: JUnit 5 (Jupiter)**

**Principais Conceitos:**

```java
// 📝 ANATOMIA DE UM TESTE

@SpringBootTest // Sobe contexto Spring completo
class ProductServiceTest {
    
    @Autowired
    private ProductService productService;
    
    @MockBean // Mock gerenciado pelo Spring
    private ProductRepository productRepository;
    
    @BeforeEach // Executa antes de cada teste
    void setUp() {
        // Preparação
    }
    
    @Test
    @DisplayName("Deve criar produto com sucesso")
    void shouldCreateProduct() {
        // ARRANGE (preparar)
        ProductDTO dto = new ProductDTO();
        dto.setTitle("Test Book");
        dto.setAuthor("Test Author");
        // ... configurar DTO
        
        Product product = new Book();
        BeanUtils.copyProperties(dto, product);
        
        when(productRepository.save(any(Product.class)))
            .thenReturn(product);
        
        // ACT (executar)
        Product result = productService.createProduct(dto);
        
        // ASSERT (verificar)
        assertNotNull(result);
        assertEquals("Test Book", result.getTitle());
        verify(productRepository, times(1)).save(any(Product.class));
    }
    
    @Test
    @DisplayName("Deve lançar exceção quando produto não encontrado")
    void shouldThrowExceptionWhenProductNotFound() {
        // ARRANGE
        when(productRepository.findById(99L))
            .thenReturn(Optional.empty());
        
        // ACT & ASSERT
        assertThrows(ProductNotFoundException.class, () -> {
            productService.getProductById(99L);
        });
    }
}
```

**O QUE ESTUDAR:**
1. **Annotations:** @Test, @BeforeEach, @AfterEach, @DisplayName
2. **Assertions:** assertEquals, assertTrue, assertThrows, assertAll
3. **Mockito:** mock(), when(), verify(), ArgumentCaptor
4. **@SpringBootTest** vs **@WebMvcTest** vs **@DataJpaTest**

**DIFERENÇAS IMPORTANTES:**

| Annotation | Uso | Performance | Quando Usar |
|-----------|-----|-------------|-------------|
| `@SpringBootTest` | Teste completo | ⭐⭐ Lento | Testes de integração |
| `@WebMvcTest` | Só camada web | ⭐⭐⭐⭐ Rápido | Testes de controller |
| `@DataJpaTest` | Só camada dados | ⭐⭐⭐⭐ Rápido | Testes de repository |

```java
// 📝 EXEMPLO @WebMvcTest (Controller)
@WebMvcTest(ProductController.class)
class ProductControllerTest {
    
    @Autowired
    private MockMvc mockMvc; // Simula requisições HTTP
    
    @MockBean
    private ProductService productService;
    
    @Test
    void shouldReturnAllProducts() throws Exception {
        // ARRANGE
        List<Product> products = Arrays.asList(new Book(), new Manga());
        when(productService.getAllProducts()).thenReturn(products);
        
        // ACT & ASSERT
        mockMvc.perform(get("/api/products"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(2));
    }
    
    @Test
    void shouldCreateProduct() throws Exception {
        mockMvc.perform(post("/api/products")
            .contentType(MediaType.APPLICATION_JSON)
            .content("""
                {
                    "title": "1984",
                    "author": "Orwell",
                    "publication_year": 1949,
                    "price": 29.90,
                    "isbn": "1234567890",
                    "genre": "Dystopia",
                    "language": "English",
                    "product_type": "book"
                }
                """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("1984"));
    }
}
```

**RESOURCES:**
- 📖 [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)
- 📖 [Mockito Documentation](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)
- 📺 YouTube: "Spring Boot Testing" - Amigoscode
- 📚 Livro: "Effective Unit Testing" - Lasse Koskela

**EXERCÍCIO PRÁTICO:**
Escrever testes para TODAS as operações CRUD do ProductService.

**META:** Cobertura de 80%+ de código

---

#### **Tópico 2: TDD (Test-Driven Development)**

**CONCEITO:**
Escrever o teste ANTES do código.

**CICLO RED-GREEN-REFACTOR:**
```
1. 🔴 RED: Escrever teste que falha
2. 🟢 GREEN: Escrever código mínimo para passar
3. 🔵 REFACTOR: Melhorar código mantendo testes passando
```

**EXEMPLO PRÁTICO:**

```java
// 1️⃣ RED - Escrever teste primeiro
@Test
void shouldCalculateTotalSalePrice() {
    // ARRANGE
    SaleDTO saleDTO = new SaleDTO();
    saleDTO.setBookId(1L);
    saleDTO.setQuantity(3);
    
    Product product = new Book();
    product.setPrice(new BigDecimal("29.90"));
    
    when(productRepository.findById(1L))
        .thenReturn(Optional.of(product));
    
    // ACT
    Sale sale = saleService.createSale(saleDTO);
    
    // ASSERT
    assertEquals(new BigDecimal("89.70"), sale.getTotalPrice());
}

// 2️⃣ GREEN - Implementar
@Override
public Sale createSale(SaleDTO saleDTO) {
    Product product = productRepository.findById(saleDTO.getBookId())
        .orElseThrow(() -> new ProductNotFoundException("Produto não encontrado"));
    
    BigDecimal totalPrice = product.getPrice()
        .multiply(new BigDecimal(saleDTO.getQuantity()));
    
    Sale sale = new Sale();
    sale.setTotalPrice(totalPrice);
    sale.setDate(LocalDateTime.now());
    
    return saleRepository.save(sale);
}

// 3️⃣ REFACTOR - Melhorar depois
```

**RESOURCES:**
- 📚 Livro: "Test Driven Development: By Example" - Kent Beck
- 📺 YouTube: "TDD in Spring Boot" - Dan Vega

---

### 📅 SEMANA 5-6: JPA AVANÇADO & PERFORMANCE

**POR QUE APRENDER:**
Seu projeto tem potencial para problemas de performance (N+1, falta de paginação, etc).

#### **Tópico 1: N+1 Problem**

**O PROBLEMA:**
```java
// ❌ ISTO GERA 101 QUERIES!
List<Sale> sales = saleRepository.findAll(); // 1 query
for (Sale sale : sales) {
    sale.getItems().size(); // 100 queries (uma por sale)
}
```

**SOLUÇÃO 1: JOIN FETCH**
```java
@Query("SELECT s FROM Sale s JOIN FETCH s.items")
List<Sale> findAllWithItems();
```

**SOLUÇÃO 2: @EntityGraph**
```java
@EntityGraph(attributePaths = {"items", "user"})
List<Sale> findAll();
```

**SOLUÇÃO 3: Batch Fetch**
```java
@Entity
public class Sale {
    @OneToMany(mappedBy = "sale")
    @BatchSize(size = 10) // Carrega em lotes de 10
    private List<SaleItem> items;
}
```

---

#### **Tópico 2: Paginação e Ordenação**

```java
// Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    Page<Product> findByGenre(String genre, Pageable pageable);
}

// Service
public Page<Product> getProductsByGenre(String genre, int page, int size, String sortBy) {
    Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy).descending());
    return productRepository.findByGenre(genre, pageable);
}

// Controller
@GetMapping
public ResponseEntity<Page<ProductDTO>> getProducts(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "20") int size,
    @RequestParam(defaultValue = "title") String sort,
    @RequestParam(required = false) String genre
) {
    Page<Product> products = productService.getProductsByGenre(genre, page, size, sort);
    Page<ProductDTO> dtos = products.map(productMapper::toDTO);
    return ResponseEntity.ok(dtos);
}

// Resposta JSON
{
    "content": [...],
    "totalElements": 1000,
    "totalPages": 50,
    "size": 20,
    "number": 0,
    "first": true,
    "last": false
}
```

---

#### **Tópico 3: Projeções e DTOs**

**PROBLEMA:** Buscar entidade completa quando só precisa de 2 campos.

**SOLUÇÃO 1: Projection Interface**
```java
public interface ProductSummary {
    String getTitle();
    BigDecimal getPrice();
}

// Repository
List<ProductSummary> findBy();

// Retorna só title e price, não carrega todos os campos
```

**SOLUÇÃO 2: JPQL Constructor Expression**
```java
@Query("SELECT new com.products.dto.ProductDTO(p.title, p.price) FROM Product p")
List<ProductDTO> findAllSummaries();
```

---

#### **Tópico 4: Estratégias de Fetch**

```java
@Entity
public class Sale {
    
    // 🔴 LAZY (padrão) - Carrega sob demanda
    @ManyToOne(fetch = FetchType.LAZY)
    private User user;
    
    // ⚠️ EAGER - Carrega SEMPRE (cuidado!)
    @ManyToOne(fetch = FetchType.EAGER)
    private User user;
}
```

**REGRA DE OURO:**
- **@ManyToOne / @OneToOne:** Use LAZY (evita carregar desnecessariamente)
- **@OneToMany / @ManyToMany:** LAZY por padrão (nunca mude para EAGER!)

---

**RESOURCES:**
- 📚 Livro: "High-Performance Java Persistence" - Vlad Mihalcea (OBRIGATÓRIO!)
- 📖 [Hibernate Performance Tuning Guide](https://vladmihalcea.com/)
- 📺 YouTube: "JPA Performance Tips" - Thorben Janssen

**EXERCÍCIO PRÁTICO:**
1. Adicionar paginação em getAllProducts
2. Implementar busca com filtros dinâmicos (Specifications)
3. Otimizar queries com JOIN FETCH

---

### 📅 SEMANA 7-8: SPRING SECURITY

**POR QUE APRENDER:**
Seu projeto não tem NENHUMA segurança. Qualquer um pode deletar todos os produtos!

#### **Tópico 1: Autenticação Básica**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Desabilitar CSRF para APIs REST
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/products/**").permitAll() // Público
                .requestMatchers("/api/admin/**").hasRole("ADMIN") // Só admin
                .anyRequest().authenticated() // Resto precisa autenticar
            )
            .httpBasic(Customizer.withDefaults()); // Autenticação básica
        
        return http.build();
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // NUNCA armazenar senha em texto puro!
    }
}
```

---

#### **Tópico 2: JWT (JSON Web Token)**

**FLUXO:**
```
1. Cliente envia login/senha
   ↓
2. Servidor valida credenciais
   ↓
3. Servidor gera JWT token
   ↓
4. Cliente usa token em todas requisições (header: Authorization: Bearer <token>)
   ↓
5. Servidor valida token
```

**IMPLEMENTAÇÃO:**

```java
// Dependência
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>

// Gerador de Token
@Service
public class JwtService {
    
    @Value("${jwt.secret}")
    private String secret;
    
    public String generateToken(User user) {
        return Jwts.builder()
            .setSubject(user.getEmail())
            .claim("id", user.getId())
            .claim("role", user.getRole())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 24h
            .signWith(SignatureAlgorithm.HS256, secret)
            .compact();
    }
    
    public String extractEmail(String token) {
        return extractClaim(token, Claims::getSubject);
    }
    
    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String email = extractEmail(token);
        return email.equals(userDetails.getUsername()) && !isTokenExpired(token);
    }
}

// Filtro JWT
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Autowired
    private JwtService jwtService;
    
    @Autowired
    private UserDetailsService userDetailsService;
    
    @Override
    protected void doFilterInternal(
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws ServletException, IOException {
        
        final String authHeader = request.getHeader("Authorization");
        
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }
        
        final String jwt = authHeader.substring(7);
        final String userEmail = jwtService.extractEmail(jwt);
        
        if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = userDetailsService.loadUserByUsername(userEmail);
            
            if (jwtService.isTokenValid(jwt, userDetails)) {
                UsernamePasswordAuthenticationToken authToken = 
                    new UsernamePasswordAuthenticationToken(
                        userDetails, 
                        null, 
                        userDetails.getAuthorities()
                    );
                
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }
        
        filterChain.doFilter(request, response);
    }
}

// Controller de Autenticação
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtService jwtService;
    
    @Autowired
    private UserRepository userRepository;
    
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                request.getEmail(),
                request.getPassword()
            )
        );
        
        User user = userRepository.findByEmail(request.getEmail())
            .orElseThrow();
        
        String token = jwtService.generateToken(user);
        
        return ResponseEntity.ok(new AuthResponse(token));
    }
}
```

**RESOURCES:**
- 📚 Livro: "Spring Security in Action" - Laurentiu Spilca
- 📺 YouTube: "Spring Security JWT" - Amigoscode
- 📖 [Spring Security Reference](https://docs.spring.io/spring-security/reference/)

**EXERCÍCIO PRÁTICO:**
1. Implementar registro de usuário
2. Implementar login com JWT
3. Proteger endpoints com roles (USER, ADMIN)

---

### 📅 SEMANA 9-10: DESIGN PATTERNS & CLEAN CODE

#### **Padrões que Você Já Usa (sem saber!)**

**1. Repository Pattern**
```java
// Você já usa!
public interface ProductRepository extends JpaRepository<Product, Long> {}
```

**2. DTO Pattern**
```java
// Você já usa!
public class ProductDTO {}
```

**3. Strategy Pattern (Herança Product)**
```java
// Você já usa implicitamente!
abstract class Product {
    abstract String getProductType();
}
```

---

#### **Novos Padrões para Aprender**

**1. Builder Pattern (alternativa a setters)**

```java
// ❌ VERBOSO
Product product = new Product();
product.setTitle("1984");
product.setAuthor("Orwell");
product.setPrice(new BigDecimal("29.90"));
// ... 10 linhas mais

// ✅ FLUENTE E LEGÍVEL
Product product = Product.builder()
    .title("1984")
    .author("Orwell")
    .price(new BigDecimal("29.90"))
    .build();

// Com Lombok
@Data
@Builder
public class Product {
    private String title;
    private String author;
    private BigDecimal price;
}
```

---

**2. Factory Pattern**

```java
// Ao invés de if/else no Service
public interface ProductFactory {
    Product createProduct(ProductDTO dto);
}

@Component
public class BookFactory implements ProductFactory {
    public Product createProduct(ProductDTO dto) {
        Book book = new Book();
        // configurar...
        return book;
    }
}

@Component
public class MangaFactory implements ProductFactory {
    public Product createProduct(ProductDTO dto) {
        Manga manga = new Manga();
        // configurar...
        return manga;
    }
}

// Service usa Factory
@Service
public class ProductService {
    
    private final Map<String, ProductFactory> factories;
    
    public ProductService(List<ProductFactory> factoryList) {
        this.factories = factoryList.stream()
            .collect(Collectors.toMap(
                f -> f.getClass().getSimpleName().replace("Factory", "").toLowerCase(),
                f -> f
            ));
    }
    
    public Product createProduct(ProductDTO dto) {
        ProductFactory factory = factories.get(dto.getProduct_type());
        if (factory == null) {
            throw new IllegalArgumentException("Invalid product type");
        }
        return factory.createProduct(dto);
    }
}
```

---

**3. Specification Pattern (Queries Dinâmicas)**

```java
// Busca complexa: título, autor, ano, preço min/max, gênero
public class ProductSpecifications {
    
    public static Specification<Product> titleContains(String title) {
        return (root, query, cb) -> 
            title == null ? null : cb.like(cb.lower(root.get("title")), "%" + title.toLowerCase() + "%");
    }
    
    public static Specification<Product> authorEquals(String author) {
        return (root, query, cb) -> 
            author == null ? null : cb.equal(root.get("author"), author);
    }
    
    public static Specification<Product> priceGreaterThan(BigDecimal minPrice) {
        return (root, query, cb) -> 
            minPrice == null ? null : cb.greaterThanOrEqualTo(root.get("price"), minPrice);
    }
    
    public static Specification<Product> priceLessThan(BigDecimal maxPrice) {
        return (root, query, cb) -> 
            maxPrice == null ? null : cb.lessThanOrEqualTo(root.get("price"), maxPrice);
    }
}

// Repository
public interface ProductRepository extends 
    JpaRepository<Product, Long>,
    JpaSpecificationExecutor<Product> {
}

// Service
public Page<Product> search(ProductSearchFilter filter, Pageable pageable) {
    Specification<Product> spec = Specification.where(null);
    
    if (filter.getTitle() != null) {
        spec = spec.and(ProductSpecifications.titleContains(filter.getTitle()));
    }
    if (filter.getAuthor() != null) {
        spec = spec.and(ProductSpecifications.authorEquals(filter.getAuthor()));
    }
    if (filter.getMinPrice() != null) {
        spec = spec.and(ProductSpecifications.priceGreaterThan(filter.getMinPrice()));
    }
    if (filter.getMaxPrice() != null) {
        spec = spec.and(ProductSpecifications.priceLessThan(filter.getMaxPrice()));
    }
    
    return productRepository.findAll(spec, pageable);
}

// Controller
@GetMapping("/search")
public Page<ProductDTO> search(
    @RequestParam(required = false) String title,
    @RequestParam(required = false) String author,
    @RequestParam(required = false) BigDecimal minPrice,
    @RequestParam(required = false) BigDecimal maxPrice,
    Pageable pageable
) {
    ProductSearchFilter filter = new ProductSearchFilter(title, author, minPrice, maxPrice);
    return productService.search(filter, pageable).map(productMapper::toDTO);
}
```

---

**RESOURCES:**
- 📚 Livro: "Design Patterns: Elements of Reusable Object-Oriented Software" (Gang of Four)
- 📚 Livro: "Clean Code" - Robert C. Martin
- 📚 Livro: "Refactoring" - Martin Fowler
- 📺 YouTube: "Design Patterns in Java" - Programming with Mosh

---

### 📅 SEMANA 11-12: TÓPICOS AVANÇADOS

#### **1. Caching com Redis**

```java
// Dependência
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

// Config
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager(RedisConnectionFactory factory) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(10)) // TTL de 10 minutos
            .serializeValuesWith(
                RedisSerializationContext.SerializationPair.fromSerializer(
                    new GenericJackson2JsonRedisSerializer()
                )
            );
        
        return RedisCacheManager.builder(factory)
            .cacheDefaults(config)
            .build();
    }
}

// Service
@Service
public class ProductService {
    
    @Cacheable(value = "products", key = "#id")
    public Product getProductById(Long id) {
        // Só busca no banco se não estiver no cache
        return productRepository.findById(id)
            .orElseThrow(() -> new ProductNotFoundException("Product not found"));
    }
    
    @CacheEvict(value = "products", key = "#id")
    public void deleteProduct(Long id) {
        // Remove do cache ao deletar
        productRepository.deleteById(id);
    }
    
    @CachePut(value = "products", key = "#result.id")
    public Product updateProduct(Long id, ProductDTO dto) {
        // Atualiza o cache
        Product product = getProductById(id);
        // ... atualizar campos
        return productRepository.save(product);
    }
}
```

**QUANDO USAR CACHE:**
- ✅ Dados lidos frequentemente
- ✅ Dados que mudam raramente
- ✅ Queries custosas
- ❌ Dados que precisam estar sempre atualizados
- ❌ Dados personalizados por usuário

---

#### **2. Event-Driven Architecture**

```java
// Evento
public class ProductCreatedEvent {
    private final Product product;
    private final LocalDateTime timestamp;
    
    public ProductCreatedEvent(Product product) {
        this.product = product;
        this.timestamp = LocalDateTime.now();
    }
}

// Publisher (Service)
@Service
public class ProductService {
    
    @Autowired
    private ApplicationEventPublisher eventPublisher;
    
    public Product createProduct(ProductDTO dto) {
        Product product = // ... criar produto
        product = productRepository.save(product);
        
        // Publicar evento
        eventPublisher.publishEvent(new ProductCreatedEvent(product));
        
        return product;
    }
}

// Listener (outra parte da aplicação)
@Component
public class ProductEventListener {
    
    @Async
    @EventListener
    public void handleProductCreated(ProductCreatedEvent event) {
        // Enviar email de notificação
        // Atualizar cache
        // Registrar auditoria
        System.out.println("Product created: " + event.getProduct().getTitle());
    }
}

// Habilitar Async
@Configuration
@EnableAsync
public class AsyncConfig {
    
    @Bean
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-");
        executor.initialize();
        return executor;
    }
}
```

**POR QUE USAR EVENTOS:**
- ✅ Desacoplamento (Service não precisa conhecer quem vai reagir)
- ✅ Facilita adicionar novas funcionalidades
- ✅ Single Responsibility Principle

---

#### **3. API Versionamento**

```java
// Opção 1: URI Versioning
@RestController
@RequestMapping("/api/v1/products")
public class ProductControllerV1 {
    // Versão antiga
}

@RestController
@RequestMapping("/api/v2/products")
public class ProductControllerV2 {
    // Versão nova (breaking changes)
}

// Opção 2: Header Versioning
@RestController
@RequestMapping("/api/products")
public class ProductController {
    
    @GetMapping(headers = "X-API-VERSION=1")
    public List<ProductDTO> getProductsV1() {
        // ...
    }
    
    @GetMapping(headers = "X-API-VERSION=2")
    public Page<ProductDTO> getProductsV2(Pageable pageable) {
        // Versão nova com paginação
    }
}
```

---

#### **4. Logging Estruturado**

```java
// Dependência
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>7.3</version>
</dependency>

// Service
@Slf4j // Lombok
@Service
public class ProductService {
    
    public Product createProduct(ProductDTO dto) {
        log.info("Creating product: title={}, author={}", dto.getTitle(), dto.getAuthor());
        
        try {
            Product product = // ... criar
            
            log.info("Product created successfully: id={}", product.getId());
            return product;
            
        } catch (Exception e) {
            log.error("Failed to create product: title={}", dto.getTitle(), e);
            throw e;
        }
    }
}

// logback-spring.xml
<configuration>
    <appender name="JSON" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="net.logstash.logback.encoder.LogstashEncoder"/>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="JSON"/>
    </root>
</configuration>
```

---

#### **5. Monitoring com Actuator**

```java
// Dependência
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

// application.properties
management.endpoints.web.exposure.include=health,info,metrics,prometheus
management.endpoint.health.show-details=always

// Endpoints disponíveis:
// /actuator/health - Status da aplicação
// /actuator/metrics - Métricas (JVM, HTTP, DB)
// /actuator/prometheus - Formato Prometheus (para Grafana)

// Custom Health Indicator
@Component
public class DatabaseHealthIndicator implements HealthIndicator {
    
    @Autowired
    private DataSource dataSource;
    
    @Override
    public Health health() {
        try {
            dataSource.getConnection().close();
            return Health.up()
                .withDetail("database", "Available")
                .build();
        } catch (Exception e) {
            return Health.down()
                .withDetail("database", "Unavailable")
                .withDetail("error", e.getMessage())
                .build();
        }
    }
}
```

---

## 📚 RECURSOS ESSENCIAIS DE ESTUDO

### 📖 **Livros Obrigatórios** (em ordem de prioridade)

1. **"Spring in Action" - Craig Walls** ⭐⭐⭐⭐⭐
   - Nível: Júnior → Pleno
   - Cobre: Spring Boot completo
   - Por que: Melhor livro para iniciantes

2. **"High-Performance Java Persistence" - Vlad Mihalcea** ⭐⭐⭐⭐⭐
   - Nível: Pleno → Sênior
   - Cobre: JPA/Hibernate profundo
   - Por que: Essencial para performance

3. **"Clean Code" - Robert C. Martin** ⭐⭐⭐⭐⭐
   - Nível: Todos
   - Cobre: Boas práticas de código
   - Por que: Base para qualquer desenvolvedor

4. **"Effective Java" - Joshua Bloch** ⭐⭐⭐⭐⭐
   - Nível: Pleno → Sênior
   - Cobre: Java idiomático
   - Por que: Java da forma correta

5. **"Spring Security in Action" - Laurentiu Spilca**
   - Nível: Pleno
   - Cobre: Segurança completa
   - Por que: Segurança é crítica

---

### 🎥 **Cursos Online Recomendados**

1. **Spring Framework Master Class** - in28Minutes (Udemy)
   - Duração: 40h
   - Cobre: Spring Boot completo + Microservices
   - Nível: Júnior → Pleno

2. **Testing Spring Boot** - Spring Academy (Gratuito!)
   - Duração: 10h
   - Cobre: Testes completos
   - Link: https://spring.academy

3. **Java Spring Boot Microservices** - Amigoscode (YouTube)
   - Duração: 5-10h
   - Cobre: Microservices, Docker, Kubernetes
   - Gratuito

---

### 🛠️ **Ferramentas para Dominar**

1. **IntelliJ IDEA** (você já usa)
   - Aprenda: Shortcuts, Debugger, Refactoring tools
   - Tutorial: Help → Keyboard Shortcuts PDF

2. **Postman / Insomnia**
   - Testar APIs
   - Criar collections de testes

3. **Docker**
   ```bash
   # MySQL em container
   docker run --name mysql-dev \
     -e MYSQL_ROOT_PASSWORD=root \
     -e MYSQL_DATABASE=ecommerce \
     -p 3306:3306 \
     -d mysql:8.0
   ```

4. **Git Avançado**
   - Branching strategies (Git Flow)
   - Rebase vs Merge
   - Cherry-pick

---

## 🎯 EXERCÍCIOS PRÁTICOS COMPLETOS

### **PROJETO 1: Melhorar o Bookangá**

**Semanas 1-4:**
- [ ] Corrigir pom.xml
- [ ] Adicionar testes (cobertura 80%+)
- [ ] Implementar SaleService completo
- [ ] Adicionar paginação

**Semanas 5-8:**
- [ ] Implementar Spring Security com JWT
- [ ] Adicionar roles (USER, ADMIN)
- [ ] Proteger endpoints
- [ ] Implementar busca com filtros

**Semanas 9-12:**
- [ ] Adicionar cache (Redis)
- [ ] Implementar soft delete
- [ ] Adicionar auditoria
- [ ] Documentar com Swagger

---

### **PROJETO 2: API de Blog (do zero)**

Criar API REST para blog com:
- Posts (título, conteúdo, autor, tags)
- Comentários
- Likes
- Autenticação JWT
- Paginação e busca
- Testes completos
- Docker Compose (app + DB + Redis)

**Objetivo:** Consolidar TUDO que aprendeu

---

### **PROJETO 3: E-commerce Completo (Capstone)**

Expandir Bookangá para:
- Carrinho de compras
- Processamento de pagamento (integração Stripe/PagSeguro)
- Estoque
- Notificações por email
- Upload de imagens
- Relatórios de vendas
- Dashboard admin

---

## 🚀 DICAS DE OURO PARA ACELERAR O APRENDIZADO

### **1. Aprenda Fazendo (80/20)**
- 80% do tempo: CODANDO
- 20% do tempo: Lendo/assistindo

### **2. Debug é Seu Melhor Amigo**
```java
// Coloque breakpoints e ENTENDA o fluxo
@GetMapping("/{id}")
public Product get(@PathVariable Long id) {
    // ⬅️ Breakpoint aqui
    Product product = service.getById(id);
    // ⬅️ Breakpoint aqui
    return product;
}
```

### **3. Leia Código de Projetos Open Source**
- Spring Petclinic (exemplo oficial)
- Shopizer (e-commerce open source)
- Baeldung tutorials (GitHub)

### **4. Participe de Comunidades**
- Stack Overflow (responda perguntas!)
- Reddit: r/java, r/springframework
- Discord: Java/Spring servers

### **5. Code Review (Peça Feedback)**
- GitHub: faça PRs em projetos open source
- Peça reviews de desenvolvedores sêniores

### **6. Tenha um Portfolio no GitHub**
- README bem feito
- Código limpo
- Testes
- CI/CD (GitHub Actions)

---

## ✅ CHECKLIST DE PROGRESSO

Marque conforme for dominando:

### **Fundamentos**
- [ ] Maven profundo
- [ ] Spring Boot auto-configuration
- [ ] Dependency Injection (3 tipos)
- [ ] Profiles

### **Testes**
- [ ] JUnit 5
- [ ] Mockito
- [ ] @SpringBootTest
- [ ] @WebMvcTest
- [ ] TDD (Red-Green-Refactor)

### **JPA**
- [ ] N+1 Problem
- [ ] Paginação
- [ ] Specifications
- [ ] Fetch strategies
- [ ] Projeções

### **Segurança**
- [ ] Spring Security básico
- [ ] JWT
- [ ] Roles e authorities
- [ ] Password encoding

### **Avançado**
- [ ] Caching
- [ ] Events
- [ ] Async processing
- [ ] API versioning
- [ ] Logging
- [ ] Monitoring (Actuator)

### **Design Patterns**
- [ ] Builder
- [ ] Factory
- [ ] Strategy
- [ ] Specification
- [ ] Repository

---

## 🎓 CONCLUSÃO

**Seu nível atual:** Júnior/Pleno (60%)

**Após seguir este guia:** Pleno/Sênior (90%)

**Tempo estimado:** 3-6 meses (dedicando 2-3h/dia)

---

## 💪 MOTIVAÇÃO FINAL

Você **JÁ TEM** uma base sólida:
- ✅ Entende arquitetura em camadas
- ✅ Sabe usar Spring Boot básico
- ✅ Conhece JPA
- ✅ Implementou validações

O que falta é:
- 📚 Aprofundar conhecimentos
- 🧪 Adicionar testes
- 🔐 Implementar segurança
- ⚡ Otimizar performance

**Você CONSEGUE!** 🚀

Siga este guia passo a passo, faça os exercícios, e em alguns meses você estará pronto para vagas pleno/sênior.

---

**Próximos Passos Imediatos:**
1. Corrigir o `pom.xml` (URGENTE!)
2. Escrever primeiro teste
3. Implementar SaleService
4. Adicionar paginação

**Boa sorte na jornada! 💻🔥**
