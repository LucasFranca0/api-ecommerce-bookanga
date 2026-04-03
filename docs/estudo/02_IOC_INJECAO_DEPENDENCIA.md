# 📚 Módulo 2: Inversão de Controle (IoC) e Injeção de Dependência (DI)

> **Esta foi sua maior lacuna na prova!**  
> **Tempo estimado:** 3-4 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Fundamental para entender Spring)

---

## 🎯 O que você vai aprender:

1. ✅ O que é Inversão de Controle (IoC)
2. ✅ O que é Injeção de Dependência (DI)
3. ✅ Tipos de injeção: Campo, Construtor, Setter
4. ✅ Por que injeção por construtor é melhor
5. ✅ Como o Spring Container funciona

---

## 📌 1. O PROBLEMA: Código Acoplado

### 🤔 Seu conhecimento atual:
> Na prova você disse: "Uma injeção é automática, a outra é instanciada quando chama o construtor"
> Sobre IoC: "Não sei"

Vamos começar do zero!

### ❌ Código SEM Inversão de Controle:

```java
// O JEITO ERRADO (sem Spring)
public class ProductController {
    
    // O Controller CRIA suas próprias dependências
    private ProductService productService = new ProductService();
    
    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }
}

public class ProductService {
    
    // O Service CRIA suas próprias dependências
    private ProductRepository productRepository = new ProductRepository();
    
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
}
```

### 🔴 Problemas desse código:

| Problema | Descrição |
|----------|-----------|
| **Alto acoplamento** | Controller conhece a implementação exata de Service |
| **Difícil testar** | Não dá pra substituir por um Mock |
| **Inflexível** | Se ProductService mudar o construtor, quebra tudo |
| **Difícil manter** | Mudanças propagam em cascata |

```java
// Exemplo: E se ProductService precisar de outro parâmetro?
public class ProductService {
    private ProductRepository productRepository;
    private EmailService emailService;  // NOVO!
    
    public ProductService(ProductRepository repo, EmailService email) {
        // Agora ProductController QUEBRA porque criava sem parâmetros!
    }
}
```

---

## 📌 2. A SOLUÇÃO: Inversão de Controle (IoC)

### 💡 O que é IoC?

**Inversão de Controle** significa que você **NÃO controla** a criação dos objetos.
O **Container Spring** controla.

| Sem IoC | Com IoC |
|---------|---------|
| VOCÊ cria objetos com `new` | SPRING cria objetos pra você |
| VOCÊ gerencia dependências | SPRING gerencia dependências |
| VOCÊ controla o ciclo de vida | SPRING controla o ciclo de vida |

### 🔄 Visualizando a Inversão:

```
❌ SEM IoC (Controle Normal):
┌─────────────────────────────────────────────┐
│ ProductController                           │
│   └── new ProductService()                  │
│         └── new ProductRepository()         │
│               └── new DataSource()          │
└─────────────────────────────────────────────┘
O Controller controla TUDO (ruim!)

✅ COM IoC (Controle Invertido):
┌─────────────────────────────────────────────┐
│ Spring Container (IoC Container)            │
│   ├── Cria DataSource                       │
│   ├── Cria ProductRepository(dataSource)    │
│   ├── Cria ProductService(repository)       │
│   └── Cria ProductController(service)       │
└─────────────────────────────────────────────┘
O Container controla TUDO (bom!)
```

---

## 📌 3. INJEÇÃO DE DEPENDÊNCIA (DI)

### 💡 O que é DI?

**Injeção de Dependência** é uma FORMA de implementar IoC.
As dependências são "injetadas" (passadas) para o objeto, ao invés de ele criá-las.

### ✅ Código COM Injeção de Dependência:

```java
// O JEITO CERTO (com Spring)
@RestController
public class ProductController {
    
    // Não cria, RECEBE pronto!
    private final ProductService productService;
    
    // Dependência INJETADA via construtor
    public ProductController(ProductService productService) {
        this.productService = productService;
    }
}

@Service
public class ProductService {
    
    // Não cria, RECEBE pronto!
    private final ProductRepository productRepository;
    
    // Dependência INJETADA via construtor
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}
```

### 🟢 Benefícios:

| Benefício | Descrição |
|-----------|-----------|
| **Baixo acoplamento** | Classes não conhecem implementações |
| **Fácil testar** | Pode injetar Mocks nos testes |
| **Flexível** | Troca implementações sem mudar código |
| **Manutenível** | Mudanças são isoladas |

```java
// Teste unitário com Mock (impossível sem DI!)
@Test
void testGetAllProducts() {
    // Cria um Mock do repository
    ProductRepository mockRepo = mock(ProductRepository.class);
    when(mockRepo.findAll()).thenReturn(List.of(new Product()));
    
    // Injeta o Mock no Service
    ProductService service = new ProductService(mockRepo);
    
    // Testa!
    List<Product> result = service.getAllProducts();
    assertEquals(1, result.size());
}
```

---

## 📌 4. TIPOS DE INJEÇÃO DE DEPENDÊNCIA

### No projeto Bookanga temos DOIS tipos:

### Tipo A: Injeção por CAMPO (@Autowired no campo)

```java
@RestController
public class ProductController {
    
    @Autowired  // ← Injeção por campo
    private ProductService productService;
    
    // Sem construtor!
}
```

### Tipo B: Injeção por CONSTRUTOR (@Autowired no construtor)

```java
@Service
public class ProductService {
    
    private final ProductRepository productRepository;  // ← final!
    
    @Autowired  // ← Injeção por construtor
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}
```

### Tipo C: Injeção por SETTER (menos comum)

```java
@Service
public class ProductService {
    
    private ProductRepository productRepository;
    
    @Autowired  // ← Injeção por setter
    public void setProductRepository(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}
```

---

## 📌 5. POR QUE CONSTRUTOR É MELHOR?

### 🏆 Injeção por Construtor é a MELHOR PRÁTICA!

| Critério | Campo | Setter | Construtor ✅ |
|----------|-------|--------|--------------|
| Campos `final` | ❌ Não | ❌ Não | ✅ Sim |
| Imutabilidade | ❌ Não | ❌ Não | ✅ Sim |
| Dependências obrigatórias | ❌ Não garante | ❌ Não garante | ✅ Garante |
| Testabilidade | 🟡 Precisa de reflexão | 🟡 Precisa chamar setter | ✅ Passa no construtor |
| Null Safety | ❌ Pode ser null | ❌ Pode ser null | ✅ Valida na criação |

### 🔍 Por que `final` é importante?

```java
// Com final - IMUTÁVEL e SEGURO
private final ProductRepository productRepository;

// O campo:
// 1. DEVE ser inicializado no construtor
// 2. NÃO pode ser alterado depois
// 3. NUNCA será null após construção

// Sem final - MUTÁVEL e ARRISCADO
private ProductRepository productRepository;

// O campo:
// 1. Pode ser null em algum momento
// 2. Pode ser alterado por engano
// 3. Mais difícil de debugar
```

### 💡 Dica: Com um único construtor, @Autowired é opcional!

```java
// Spring 4.3+ : @Autowired é opcional se só tem um construtor
@Service
public class ProductService {
    
    private final ProductRepository productRepository;
    
    // @Autowired ← não precisa!
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}
```

### 🚀 Melhor ainda: Use Lombok!

```java
@Service
@RequiredArgsConstructor  // ← Gera construtor para campos final
public class ProductService {
    
    private final ProductRepository productRepository;
    // Lombok gera o construtor automaticamente!
}
```

---

## 📌 6. COMO O SPRING CONTAINER FUNCIONA

### 🔄 Ciclo de vida simplificado:

```
1. Aplicação inicia
   ↓
2. Spring escaneia classes com @Component, @Service, @Repository, @Controller
   ↓
3. Para cada classe encontrada:
   a) Analisa dependências (construtor, campos com @Autowired)
   b) Resolve dependências (cria ou pega do container)
   c) Cria instância (Bean)
   d) Armazena no Container
   ↓
4. Quando alguém precisa de uma dependência:
   a) Spring busca no Container
   b) Injeta a instância existente
```

### 🗃️ O Container é como um "mapa":

```java
// Internamente, o Spring mantém algo assim:
Map<Class<?>, Object> container = new HashMap<>();

// Quando inicia:
container.put(ProductRepository.class, new ProductRepositoryImpl());
container.put(ProductService.class, new ProductService(container.get(ProductRepository.class)));
container.put(ProductController.class, new ProductController(container.get(ProductService.class)));

// Quando você precisa:
ProductService service = container.get(ProductService.class);
```

### 📊 Visualização do Container Bookanga:

```
┌─────────────────────────────────────────────────────────────┐
│                    SPRING IoC CONTAINER                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────┐                                      │
│  │ DataSource       │ ← Configurado pelo Spring Boot       │
│  │ (conexão BD)     │                                      │
│  └────────┬─────────┘                                      │
│           │ injeta                                         │
│           ▼                                                │
│  ┌──────────────────┐                                      │
│  │ProductRepository │ ← @Repository                        │
│  │ (Bean)           │                                      │
│  └────────┬─────────┘                                      │
│           │ injeta                                         │
│           ▼                                                │
│  ┌──────────────────┐                                      │
│  │ ProductService   │ ← @Service                           │
│  │ (Bean)           │                                      │
│  └────────┬─────────┘                                      │
│           │ injeta                                         │
│           ▼                                                │
│  ┌──────────────────┐                                      │
│  │ProductController │ ← @RestController                    │
│  │ (Bean)           │                                      │
│  └──────────────────┘                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📌 7. ANOTAÇÕES QUE REGISTRAM BEANS

O Spring só gerencia classes marcadas com certas anotações:

| Anotação | Camada | Significado |
|----------|--------|-------------|
| `@Component` | Qualquer | Bean genérico |
| `@Service` | Negócio | Bean de serviço (lógica de negócio) |
| `@Repository` | Dados | Bean de repositório (acesso a dados) |
| `@Controller` | Web | Bean de controller MVC |
| `@RestController` | Web | Bean de controller REST |
| `@Configuration` | Config | Bean de configuração |

### 💡 Todas são "especializações" de @Component:

```java
// Internamente:
@Component  // ← Base
public @interface Service { }

@Component  // ← Base
public @interface Repository { }

@Component  // ← Base
public @interface Controller { }
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Identifique o tipo de injeção

Olhe o código do projeto e identifique:

```java
// ProductController.java - Qual tipo de injeção?
@Autowired
private ProductService productService;
// Resposta: _________________

// ProductService.java - Qual tipo de injeção?
private final ProductRepository productRepository;
@Autowired
public ProductService(ProductRepository productRepository) {
    this.productRepository = productRepository;
}
// Resposta: _________________
```

### Exercício 2: Refatore para melhor prática

Refatore o `ProductController` para usar injeção por construtor:

```java
// Antes:
@RestController
public class ProductController {
    @Autowired
    private ProductService productService;
}

// Depois (faça você):
@RestController
public class ProductController {
    // ???
}
```

### Exercício 3: Use Lombok

Simplifique usando `@RequiredArgsConstructor`:

```java
// Antes:
@Service
public class ProductService {
    private final ProductRepository productRepository;
    
    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}

// Depois (faça você):
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **IoC (Inversão de Controle)** | O Spring controla a criação de objetos, não você |
| **DI (Injeção de Dependência)** | Dependências são passadas, não criadas internamente |
| **Container/Context** | "Mapa" que armazena todos os Beans |
| **Bean** | Objeto gerenciado pelo Spring |
| **Injeção por Construtor** | Melhor prática! Permite `final` e testes |
| **@Autowired** | Marca onde Spring deve injetar |
| **@RequiredArgsConstructor** | Lombok gera construtor para campos `final` |

---

## 🎯 CHECKLIST DE APRENDIZADO

- [ ] Sei explicar o que é IoC
- [ ] Sei explicar o que é DI
- [ ] Conheço os 3 tipos de injeção (campo, construtor, setter)
- [ ] Sei por que construtor é a melhor prática
- [ ] Entendo o que são Beans
- [ ] Sei como o Container funciona
- [ ] Consigo usar @RequiredArgsConstructor

---

## ⏭️ Próximo Módulo

**Módulo 3: JPA e Relacionamentos**
- @ManyToOne, @OneToMany
- Cascade Types
- FetchType (LAZY vs EAGER)

---

**🎉 Parabéns por completar o Módulo 2!**

Agora você entende o coração do Spring Framework!

