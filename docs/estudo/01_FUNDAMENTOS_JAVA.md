# 📚 Módulo 1: Fundamentos de Java que Você Precisa Dominar

> **Baseado nas lacunas da sua prova**  
> **Tempo estimado:** 4-6 horas  
> **Pré-requisito:** Conhecimento básico de programação

---

## 🎯 O que você vai aprender neste módulo:

1. ✅ Generics - O que são e por que usar
2. ✅ Wrapper Classes - Integer vs int
3. ✅ Lombok - Todas as anotações importantes
4. ✅ Classes Abstratas e Interfaces (revisão rápida)

---

## 📌 1. GENERICS EM JAVA

### 🤔 O que você não soube na prova:
> "Por que usamos Generics?" - Você respondeu: "Não sei"

### 💡 Explicação Simples:

Generics permitem que você escreva código que funciona com **qualquer tipo**, mantendo **segurança de tipos**.

#### Antes de Generics (Java 1.4 e anterior):

```java
// ❌ Sem Generics - PERIGOSO!
List lista = new ArrayList();
lista.add("texto");
lista.add(123);        // Aceita qualquer coisa!
lista.add(new Product());

// Na hora de usar, PROBLEMA:
String item = (String) lista.get(1);  // 💥 ClassCastException! Era Integer!
```

#### Com Generics (Java 5+):

```java
// ✅ Com Generics - SEGURO!
List<String> lista = new ArrayList<>();
lista.add("texto");
lista.add(123);        // ❌ ERRO DE COMPILAÇÃO! Não compila!
lista.add(new Product()); // ❌ ERRO DE COMPILAÇÃO!

// Na hora de usar, TRANQUILO:
String item = lista.get(0);  // Sem cast, sem risco!
```

### 🔍 Analisando o Código do Projeto Bookanga:

```java
public interface ProductRepository extends JpaRepository<Product, Long> { }
//                                                       ↑         ↑
//                                                  Entidade    Tipo do ID
```

**O que significa `<Product, Long>`?**

| Parâmetro | Significado | No nosso caso |
|-----------|-------------|---------------|
| 1º (T) | Tipo da Entidade | `Product` |
| 2º (ID) | Tipo da Chave Primária | `Long` |

**O que o Spring faz com isso?**

```java
// O Spring gera automaticamente métodos tipados:
Product findById(Long id);           // Retorna Product, não Object
List<Product> findAll();             // Lista de Product
void save(Product entity);           // Só aceita Product
void deleteById(Long id);            // ID deve ser Long
```

### 📝 Exercício Prático:

Abra o arquivo `ProductRepository.java` e adicione um método customizado:

```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // O Spring cria a query automaticamente pelo nome do método!
    List<Product> findByGenre(String genre);
    
    List<Product> findByAuthor(String author);
    
    List<Product> findByPriceLessThan(BigDecimal price);
}
```

### ✅ Checklist de Aprendizado:
- [ ] Entendi que Generics fornecem type safety
- [ ] Sei que `<Product, Long>` define entidade e tipo do ID
- [ ] Consigo criar query methods no Repository

---

## 📌 2. WRAPPER CLASSES (Integer vs int)

### 🤔 O que você não soube na prova:
> "Por que usamos Integer ao invés de int?" - Você respondeu: "Não sei"

### 💡 A Diferença Fundamental:

| Característica | `int` (primitivo) | `Integer` (wrapper) |
|----------------|-------------------|---------------------|
| Tipo | Primitivo | Objeto (classe) |
| Valor padrão | `0` | `null` |
| Aceita null? | ❌ NÃO | ✅ SIM |
| Métodos? | ❌ NÃO | ✅ SIM |
| Usado em Generics? | ❌ NÃO | ✅ SIM |

### 🔍 Por que isso importa no Bookanga?

Olhe a classe `Product`:

```java
@Column(name = "volume")
@Positive(message = "O volume deve ser maior que zero")
private Integer volume;  // ← É Integer, não int!
```

**Por que `Integer` e não `int`?**

O campo `volume` é **OPCIONAL**:
- Livros (Book) **não têm** volume → `volume = null`
- Mangás (Manga) **têm** volume → `volume = 1, 2, 3...`

```java
// Se fosse int:
private int volume;  // Sempre tem valor, padrão = 0

// PROBLEMA: Como saber se é "volume 0" ou "não tem volume"?
// Impossível diferenciar!

// Com Integer:
private Integer volume;  // Pode ser null

// Book: volume = null (não tem volume)
// Manga Vol.1: volume = 1
// Manga Vol.2: volume = 2
```

### ⚠️ O Perigo do NullPointerException:

```java
// ❌ PERIGOSO - pode dar NullPointerException
Integer volume = null;
int volumePrimitivo = volume;  // 💥 NullPointerException!

// ✅ SEGURO - verificar antes
Integer volume = null;
if (volume != null) {
    int volumePrimitivo = volume;  // OK, é seguro
}

// ✅ MELHOR AINDA - usar Optional ou valor padrão
int volumePrimitivo = (volume != null) ? volume : 0;
```

### 📊 Tabela Completa de Wrappers:

| Primitivo | Wrapper | Quando usar Wrapper? |
|-----------|---------|---------------------|
| `int` | `Integer` | Campos opcionais, Generics |
| `long` | `Long` | IDs de entidades (pode ser null antes de salvar) |
| `double` | `Double` | Valores monetários opcionais |
| `boolean` | `Boolean` | Flags que podem ser "não definido" |
| `char` | `Character` | Raramente usado |

### 🔍 No Projeto Bookanga:

```java
// Por que o ID é Long e não long?
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;  // ← Long (wrapper)

// Porque ANTES de salvar no banco, o ID é NULL!
Product novoProduto = new Product();
System.out.println(novoProduto.getId());  // null

// DEPOIS de salvar:
productRepository.save(novoProduto);
System.out.println(novoProduto.getId());  // 1, 2, 3...
```

### ✅ Checklist de Aprendizado:
- [ ] Sei a diferença entre int e Integer
- [ ] Entendo quando usar cada um
- [ ] Sei que Integer aceita null e int não
- [ ] Entendo por que campos opcionais usam Wrapper

---

## 📌 3. LOMBOK - TODAS AS ANOTAÇÕES

### 🤔 O que você não soube na prova:
> "O que @Data gera?" - Você respondeu parcialmente: "Gera equals e hashcode"

### 💡 @Data gera MUITO mais!

```java
@Data  // ← Esta única anotação gera TUDO abaixo:
public class ProductDTO {
    private String title;
    private String author;
}
```

**Equivale a escrever manualmente:**

```java
public class ProductDTO {
    private String title;
    private String author;
    
    // @Getter - gerado automaticamente
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    
    // @Setter - gerado automaticamente
    public void setTitle(String title) { this.title = title; }
    public void setAuthor(String author) { this.author = author; }
    
    // @ToString - gerado automaticamente
    @Override
    public String toString() {
        return "ProductDTO(title=" + title + ", author=" + author + ")";
    }
    
    // @EqualsAndHashCode - gerado automaticamente
    @Override
    public boolean equals(Object o) { /* implementação */ }
    @Override
    public int hashCode() { /* implementação */ }
    
    // @RequiredArgsConstructor - construtor para campos final
}
```

### 📚 Guia Completo de Anotações Lombok:

| Anotação | O que gera | Quando usar |
|----------|-----------|-------------|
| `@Getter` | Métodos get para todos os campos | Sempre |
| `@Setter` | Métodos set para todos os campos | Quando precisa modificar |
| `@ToString` | Método toString() | Debug, logs |
| `@EqualsAndHashCode` | equals() e hashCode() | Comparações, Collections |
| `@NoArgsConstructor` | Construtor sem argumentos | JPA entities |
| `@AllArgsConstructor` | Construtor com todos os argumentos | Testes, builders |
| `@RequiredArgsConstructor` | Construtor para campos `final` | Injeção de dependência |
| `@Data` | Tudo acima (exceto construtores all/no args) | DTOs, POJOs |
| `@Builder` | Padrão Builder | Criação fluente de objetos |
| `@Value` | Classe imutável (campos final, sem setters) | Value Objects |
| `@Slf4j` | Logger SLF4J | Logging |

### 🔍 Exemplos Práticos no Projeto:

```java
// DTO com @Data (mais comum)
@Data
public class ProductDTO {
    private String title;
    private String author;
}

// Entity com anotações separadas (mais controle)
@Entity
@Getter
@Setter
@NoArgsConstructor  // JPA precisa de construtor vazio
public class Product {
    @Id
    private Long id;
    private String title;
}

// Serviço com @RequiredArgsConstructor
@Service
@RequiredArgsConstructor  // Gera construtor para o campo final
public class ProductService {
    private final ProductRepository productRepository; // ← final = injetado via construtor
}

// Builder para criação fluente
@Data
@Builder
public class ProductDTO {
    private String title;
    private String author;
}

// Uso do Builder:
ProductDTO dto = ProductDTO.builder()
    .title("1984")
    .author("George Orwell")
    .build();
```

### ⚠️ Cuidados com Lombok:

```java
// ❌ CUIDADO com @Data em Entities com relacionamentos
@Data  // Pode causar StackOverflow em relacionamentos bidirecionais!
@Entity
public class Sale {
    @OneToMany(mappedBy = "sale")
    private List<SaleItem> items;  // toString() pode entrar em loop!
}

// ✅ MELHOR: usar anotações separadas e excluir campos problemáticos
@Entity
@Getter
@Setter
@ToString(exclude = "items")  // Exclui do toString
@EqualsAndHashCode(exclude = "items")  // Exclui do equals/hashCode
public class Sale {
    @OneToMany(mappedBy = "sale")
    private List<SaleItem> items;
}
```

### ✅ Checklist de Aprendizado:
- [ ] Sei tudo que @Data gera
- [ ] Conheço @Getter, @Setter, @ToString
- [ ] Entendo @RequiredArgsConstructor para injeção
- [ ] Sei quando usar @Builder
- [ ] Conheço os cuidados com Entities

---

## 📌 4. REVISÃO: CLASSES ABSTRATAS vs INTERFACES

### 💡 Você já sabe bastante! Mas vamos consolidar:

| Característica | Classe Abstrata | Interface |
|----------------|-----------------|-----------|
| Palavra-chave | `abstract class` | `interface` |
| Instanciar? | ❌ Não | ❌ Não |
| Herança múltipla? | ❌ Não (só 1 classe pai) | ✅ Sim (várias interfaces) |
| Construtores? | ✅ Sim | ❌ Não |
| Atributos? | ✅ Qualquer tipo | Apenas `public static final` |
| Métodos concretos? | ✅ Sim | ✅ Sim (default methods, Java 8+) |

### 🔍 No Projeto Bookanga:

**Classe Abstrata (Product):**
```java
public abstract class Product {
    // Atributos comuns
    private Long id;
    private String title;
    private String author;
    
    // Método abstrato - subclasses DEVEM implementar
    public abstract String getProductType();
    
    // Métodos concretos - subclasses herdam
    public String getFullDescription() {
        return title + " by " + author;
    }
}
```

**Interface (Repository):**
```java
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Define contrato - Spring implementa
    List<Product> findByGenre(String genre);
}
```

### 🎯 Quando usar cada um?

| Use Classe Abstrata quando... | Use Interface quando... |
|------------------------------|------------------------|
| Classes filhas são "tipos de" (IS-A) | Quer definir comportamento (CAN-DO) |
| Precisa compartilhar código | Quer permitir múltiplas implementações |
| Precisa de construtores | Quer contrato sem implementação |
| Ex: `Book` IS-A `Product` | Ex: `ProductRepository` CAN-DO `findAll()` |

### ✅ Checklist de Aprendizado:
- [ ] Sei a diferença entre classe abstrata e interface
- [ ] Entendo quando usar cada uma
- [ ] Sei que interface permite "herança múltipla"

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Generics
Crie um método no `ProductRepository` que busque produtos por faixa de preço:

```java
// Adicione no ProductRepository.java:
List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);
```

### Exercício 2: Wrapper Classes
Analise o `ProductDTO.java`. Identifique:
- Quais campos são obrigatórios (não podem ser null)?
- Quais campos são opcionais (podem ser null)?

### Exercício 3: Lombok
Refatore o `ProductService` para usar `@RequiredArgsConstructor`:

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

// Depois: (faça você!)
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Ponto-chave |
|----------|-------------|
| **Generics** | Type safety em tempo de compilação |
| **Wrappers** | Permitem `null` para valores opcionais |
| **Lombok @Data** | Gera getter, setter, toString, equals, hashCode |
| **@RequiredArgsConstructor** | Construtor para campos `final` |
| **Classe Abstrata** | Base comum com código compartilhado |
| **Interface** | Contrato sem implementação |

---

## ⏭️ Próximo Módulo

**Módulo 2: Inversão de Controle (IoC) e Injeção de Dependência**
- O que você não soube na prova e é FUNDAMENTAL para Spring!

---

**🎉 Parabéns por completar o Módulo 1!**

