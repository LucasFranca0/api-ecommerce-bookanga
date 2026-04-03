# 📚 Módulo 10: Testes - JUnit 5 e Mockito

> **Tempo estimado:** 4-5 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Essencial para qualidade de código)

---

## 🎯 O que você vai aprender:

1. ✅ Por que testar?
2. ✅ Tipos de testes (unitário, integração, e2e)
3. ✅ JUnit 5 - Estrutura e anotações
4. ✅ Mockito - Criando mocks
5. ✅ Testando Services, Controllers e Repositories
6. ✅ Boas práticas de teste

---

## 📌 1. POR QUE TESTAR?

### 💡 Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Confiança** | Sabe que o código funciona |
| **Documentação** | Testes mostram como usar |
| **Refatoração** | Muda código sem medo |
| **Menos bugs** | Pega erros cedo |
| **Design** | Força código testável (melhor design) |

### 📊 Pirâmide de Testes:

```
                    ▲
                   /│\
                  / │ \         E2E Tests
                 /  │  \        (poucos, lentos)
                /───┼───\
               /    │    \      Integration Tests
              /     │     \     (alguns, médios)
             /──────┼──────\
            /       │       \   Unit Tests
           /        │        \  (muitos, rápidos)
          /─────────┴─────────\
```

| Tipo | O que testa | Velocidade | Quantidade |
|------|-------------|------------|------------|
| **Unitário** | Uma classe/método | ⚡ Rápido | Muitos |
| **Integração** | Componentes juntos | 🔄 Médio | Alguns |
| **E2E** | Sistema completo | 🐢 Lento | Poucos |

---

## 📌 2. JUNIT 5 - FUNDAMENTOS

### 📦 Dependência:

```xml
<!-- Já incluído no spring-boot-starter-test -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

### 📋 Estrutura de um teste:

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CalculatorTest {

    @Test
    void shouldAddTwoNumbers() {
        // Arrange (Preparar)
        Calculator calculator = new Calculator();
        
        // Act (Agir)
        int result = calculator.add(2, 3);
        
        // Assert (Verificar)
        assertEquals(5, result);
    }
}
```

### 🏷️ Anotações principais:

| Anotação | Descrição |
|----------|-----------|
| `@Test` | Marca método como teste |
| `@BeforeEach` | Executa antes de CADA teste |
| `@AfterEach` | Executa depois de CADA teste |
| `@BeforeAll` | Executa UMA vez antes de todos |
| `@AfterAll` | Executa UMA vez depois de todos |
| `@DisplayName` | Nome legível do teste |
| `@Disabled` | Desativa o teste |
| `@Nested` | Agrupa testes relacionados |

### 🔍 Exemplo com anotações:

```java
class ProductServiceTest {

    private ProductService productService;
    private ProductRepository mockRepository;

    @BeforeEach
    void setUp() {
        mockRepository = mock(ProductRepository.class);
        productService = new ProductService(mockRepository);
    }

    @AfterEach
    void tearDown() {
        // Limpar recursos se necessário
    }

    @Test
    @DisplayName("Deve retornar produto quando ID existe")
    void shouldReturnProductWhenIdExists() {
        // teste
    }

    @Nested
    @DisplayName("Testes de criação")
    class CreateTests {
        
        @Test
        @DisplayName("Deve criar produto com dados válidos")
        void shouldCreateProductWithValidData() {
            // teste
        }
    }
}
```

---

## 📌 3. ASSERTIONS (Verificações)

### 📊 Assertions básicas:

```java
import static org.junit.jupiter.api.Assertions.*;

@Test
void assertionsExample() {
    // Igualdade
    assertEquals(expected, actual);
    assertEquals(expected, actual, "Mensagem de erro");
    
    // Verdadeiro/Falso
    assertTrue(condition);
    assertFalse(condition);
    
    // Nulo
    assertNull(object);
    assertNotNull(object);
    
    // Mesmo objeto
    assertSame(expected, actual);
    assertNotSame(expected, actual);
    
    // Arrays
    assertArrayEquals(expectedArray, actualArray);
    
    // Exceções
    assertThrows(ProductNotFoundException.class, () -> {
        service.getById(999L);
    });
    
    // Não lança exceção
    assertDoesNotThrow(() -> {
        service.save(validProduct);
    });
    
    // Múltiplas assertions
    assertAll(
        () -> assertEquals("1984", product.getTitle()),
        () -> assertEquals("Orwell", product.getAuthor()),
        () -> assertNotNull(product.getId())
    );
}
```

---

## 📌 4. MOCKITO - CRIANDO MOCKS

### 💡 O que é Mock?

**Mock** é um objeto falso que simula o comportamento de um objeto real.

### 🤔 Por que usar?

```
❌ Sem Mock:
- Teste precisa de banco de dados real
- Teste precisa de serviço externo real
- Lento, frágil, difícil de configurar

✅ Com Mock:
- Simula banco de dados
- Simula serviços externos
- Rápido, isolado, controlado
```

### 📦 Criando Mocks:

```java
import org.mockito.Mock;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)  // Habilita Mockito
class ProductServiceTest {

    @Mock  // Cria mock
    private ProductRepository productRepository;

    @InjectMocks  // Injeta mocks automaticamente
    private ProductService productService;

    @Test
    void shouldFindProductById() {
        // Arrange - Configurar comportamento do mock
        Product product = new Product();
        product.setId(1L);
        product.setTitle("1984");
        
        when(productRepository.findById(1L))
            .thenReturn(Optional.of(product));

        // Act
        Product result = productService.getProductById(1L);

        // Assert
        assertEquals("1984", result.getTitle());
        
        // Verificar se o método foi chamado
        verify(productRepository).findById(1L);
    }
}
```

### 🔧 Configurando comportamento:

```java
// Retornar valor
when(mock.method()).thenReturn(value);

// Retornar valores diferentes em chamadas consecutivas
when(mock.method())
    .thenReturn(value1)
    .thenReturn(value2);

// Lançar exceção
when(mock.method()).thenThrow(new RuntimeException());

// Para métodos void
doNothing().when(mock).voidMethod();
doThrow(new RuntimeException()).when(mock).voidMethod();

// Qualquer argumento
when(mock.findById(anyLong())).thenReturn(Optional.of(product));
when(mock.save(any(Product.class))).thenReturn(product);

// Argumento específico
when(mock.findByTitle(eq("1984"))).thenReturn(product);
```

### ✅ Verificando chamadas:

```java
// Verificar que método foi chamado
verify(mock).method();

// Verificar número de chamadas
verify(mock, times(2)).method();
verify(mock, never()).method();
verify(mock, atLeastOnce()).method();
verify(mock, atMost(3)).method();

// Verificar argumento
verify(mock).save(argThat(product -> 
    product.getTitle().equals("1984")
));

// Verificar ordem
InOrder inOrder = inOrder(mock1, mock2);
inOrder.verify(mock1).method1();
inOrder.verify(mock2).method2();
```

---

## 📌 5. TESTANDO O BOOKANGA

### 🧪 Teste do Service:

```java
@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private ProductService productService;

    @Test
    @DisplayName("Deve retornar todos os produtos")
    void shouldReturnAllProducts() {
        // Arrange
        List<Product> products = List.of(
            createProduct(1L, "1984"),
            createProduct(2L, "Brave New World")
        );
        when(productRepository.findAll()).thenReturn(products);

        // Act
        List<Product> result = productService.getAllProducts();

        // Assert
        assertEquals(2, result.size());
        verify(productRepository).findAll();
    }

    @Test
    @DisplayName("Deve lançar exceção quando produto não existe")
    void shouldThrowExceptionWhenProductNotFound() {
        // Arrange
        when(productRepository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ProductNotFoundException.class, () -> {
            productService.getProductById(999L);
        });
    }

    @Test
    @DisplayName("Deve criar produto com dados válidos")
    void shouldCreateProductWithValidData() {
        // Arrange
        ProductDTO dto = new ProductDTO();
        dto.setTitle("1984");
        dto.setAuthor("George Orwell");
        
        Product savedProduct = new Product();
        savedProduct.setId(1L);
        savedProduct.setTitle("1984");
        
        when(productRepository.save(any(Product.class)))
            .thenReturn(savedProduct);

        // Act
        Product result = productService.createProduct(dto);

        // Assert
        assertNotNull(result.getId());
        assertEquals("1984", result.getTitle());
        verify(productRepository).save(any(Product.class));
    }

    // Helper method
    private Product createProduct(Long id, String title) {
        Product product = new Book();
        product.setId(id);
        product.setTitle(title);
        return product;
    }
}
```

### 🧪 Teste do Controller:

```java
@WebMvcTest(ProductController.class)  // Carrega só o Controller
class ProductControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean  // Mock no contexto Spring
    private ProductService productService;

    @Test
    @DisplayName("GET /products deve retornar lista de produtos")
    void shouldReturnAllProducts() throws Exception {
        // Arrange
        List<Product> products = List.of(createProduct(1L, "1984"));
        when(productService.getAllProducts()).thenReturn(products);

        // Act & Assert
        mockMvc.perform(get("/api/v1/products")
                .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(1)))
            .andExpect(jsonPath("$[0].title", is("1984")));
    }

    @Test
    @DisplayName("GET /products/{id} deve retornar 404 quando não encontrado")
    void shouldReturn404WhenProductNotFound() throws Exception {
        // Arrange
        when(productService.getProductById(999L))
            .thenThrow(new ProductNotFoundException("Produto não encontrado"));

        // Act & Assert
        mockMvc.perform(get("/api/v1/products/999"))
            .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("POST /products deve criar produto")
    void shouldCreateProduct() throws Exception {
        // Arrange
        Product product = createProduct(1L, "1984");
        when(productService.createProduct(any(ProductDTO.class)))
            .thenReturn(product);

        String json = """
            {
                "title": "1984",
                "author": "George Orwell",
                "price": 29.90,
                "isbn": "9780451524935"
            }
            """;

        // Act & Assert
        mockMvc.perform(post("/api/v1/products")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id", is(1)))
            .andExpect(jsonPath("$.title", is("1984")));
    }
}
```

### 🧪 Teste de Integração:

```java
@SpringBootTest  // Carrega contexto completo
@AutoConfigureTestDatabase  // Usa banco em memória
@Transactional  // Rollback após cada teste
class ProductIntegrationTest {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductService productService;

    @Test
    @DisplayName("Deve salvar e buscar produto do banco")
    void shouldSaveAndFindProduct() {
        // Arrange
        ProductDTO dto = new ProductDTO();
        dto.setTitle("1984");
        dto.setAuthor("George Orwell");
        dto.setPrice(new BigDecimal("29.90"));
        dto.setIsbn("9780451524935");

        // Act
        Product saved = productService.createProduct(dto);
        Product found = productService.getProductById(saved.getId());

        // Assert
        assertEquals("1984", found.getTitle());
        assertEquals("George Orwell", found.getAuthor());
    }
}
```

---

## 📌 6. BOAS PRÁTICAS

### ✅ Faça:

1. **Nomes descritivos**
   ```java
   // BOM
   @Test
   void shouldThrowExceptionWhenProductNotFound() { }
   
   // RUIM
   @Test
   void test1() { }
   ```

2. **Um assert por conceito**
   ```java
   // BOM - testa uma coisa
   @Test
   void shouldReturnCorrectTitle() {
       assertEquals("1984", product.getTitle());
   }
   ```

3. **Arrange-Act-Assert (AAA)**
   ```java
   @Test
   void example() {
       // Arrange - preparar
       Product product = new Product();
       
       // Act - executar
       String result = product.getTitle();
       
       // Assert - verificar
       assertEquals("1984", result);
   }
   ```

4. **Testes independentes**
   - Cada teste deve poder rodar sozinho
   - Não depender de outros testes
   - Não depender de ordem

5. **Teste edge cases**
   ```java
   @Test void shouldHandleEmptyList() { }
   @Test void shouldHandleNullInput() { }
   @Test void shouldHandleMaxValue() { }
   ```

### ❌ Não faça:

1. **Testar implementação, não comportamento**
   ```java
   // RUIM - testa como faz
   verify(repository).findById(1L);
   verify(repository).save(product);
   
   // BOM - testa o que faz
   assertEquals("1984", result.getTitle());
   ```

2. **Testes frágeis**
   ```java
   // RUIM - quebra com qualquer mudança
   assertEquals("Product{id=1, title='1984'}", product.toString());
   ```

3. **Lógica condicional em testes**
   ```java
   // RUIM
   if (result != null) {
       assertEquals("1984", result.getTitle());
   }
   ```

---

## 📌 7. COBERTURA DE TESTES

### 📊 O que medir:

| Métrica | Descrição | Meta |
|---------|-----------|------|
| **Line Coverage** | % de linhas executadas | 70-80% |
| **Branch Coverage** | % de branches (if/else) | 70-80% |
| **Method Coverage** | % de métodos testados | 80%+ |

### 🔧 Ferramentas:

```xml
<!-- JaCoCo para cobertura -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.10</version>
</plugin>
```

```bash
# Gerar relatório
mvn test jacoco:report

# Ver relatório em target/site/jacoco/index.html
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Primeiro teste

Crie um teste para `ProductService.deleteProduct()`:

```java
@Test
void shouldDeleteProduct() {
    // Arrange - criar mock que retorna produto
    // Act - chamar deleteProduct
    // Assert - verificar que deleteById foi chamado
}
```

### Exercício 2: Teste de exceção

Teste que `createProduct` lança exceção para dados inválidos:

```java
@Test
void shouldThrowExceptionForInvalidData() {
    // DTO com título vazio
    // assertThrows(InvalidProductDataException.class, ...)
}
```

### Exercício 3: Teste de Controller

Teste o endpoint DELETE:

```java
@Test
void shouldDeleteProductAndReturn204() throws Exception {
    mockMvc.perform(delete("/api/v1/products/1"))
        .andExpect(status().isNoContent());
}
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Teste Unitário** | Testa uma unidade isolada |
| **Teste Integração** | Testa componentes juntos |
| **Mock** | Objeto falso que simula comportamento |
| **@Test** | Marca método como teste |
| **@Mock** | Cria mock com Mockito |
| **@InjectMocks** | Injeta mocks na classe testada |
| **when().thenReturn()** | Configura comportamento do mock |
| **verify()** | Verifica se método foi chamado |
| **AAA** | Arrange-Act-Assert |

---

## ⏭️ Próximo Módulo

**Módulo 11: Padrões de Projeto**

---

**🎉 Parabéns por completar o Módulo 10!**

