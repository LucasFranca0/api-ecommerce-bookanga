# 📝 PROVA DE AVALIAÇÃO DE CONHECIMENTO - Projeto Bookanga

> **Data:** Janeiro 2026  
> **Objetivo:** Avaliar seu nível de conhecimento nas tecnologias utilizadas no projeto  
> **Tempo sugerido:** 60-90 minutos  
> **Instruções:** Responda sem consultar material. Seja honesto para identificar suas lacunas de aprendizado.

---

## 📊 ESTRUTURA DA PROVA

| Seção | Tópico | Pontuação |
|-------|--------|-----------|
| 1 | Fundamentos de Java | 15 pts |
| 2 | Spring Boot & Spring Framework | 25 pts |
| 3 | JPA/Hibernate & Banco de Dados | 20 pts |
| 4 | Liquibase (Migrations) | 10 pts |
| 5 | Docker & Docker Compose | 15 pts |
| 6 | API REST & Boas Práticas | 10 pts |
| 7 | Monitoramento (Prometheus/Grafana) | 5 pts |
| **TOTAL** | | **100 pts** |

---

## 📌 SEÇÃO 1: FUNDAMENTOS DE JAVA (15 pontos)

### Questão 1.1 (3 pts)
No projeto, a classe `Product` é declarada como `abstract`. Explique:
- a) O que significa uma classe abstrata?
- b) Por que `Product` foi declarada como abstrata neste projeto?
- c) É possível criar uma instância de `Product` diretamente com `new Product()`?

```java
public abstract class Product {
    // ...
    public abstract String getProductType();
}
```

**Sua resposta:**
```
Uma classe abstrata é uma classe que não pode ser instanciada diretamente e pode conter métodos abstratos (sem implementação) que devem ser implementados pelas subclasses. No projeto, `Product` foi declarada como abstrata porque serve como uma base comum para diferentes tipos de produtos (como `Book` e `Manga`), garantindo que cada tipo implemente o método `getProductType()`. Não é possível criar uma instância de `Product` diretamente com `new Product()` porque ela é abstrata.
```

---

### Questão 1.2 (3 pts)
No código abaixo do projeto, explique o que é **herança** e como `Book` e `Manga` a utilizam:

```java
public class Book extends Product { ... }
public class Manga extends Product { ... }
```

- a) O que a palavra-chave `extends` significa?
- b) Quais atributos e métodos `Book` herda de `Product`?
- c) Por que ambas as classes implementam `getProductType()`?

**Sua resposta:**
```
extends significa que essa classe está extendendo outra, ou seja, herdando tudo que a classe pai tem. Herda tudo. Implementam para que cada classe tenha uma versão adaptada.
```

---

### Questão 1.3 (3 pts)
O projeto usa **Lombok** com a anotação `@Data`. 

```java
@Data
public class ProductDTO { ... }
```

- a) O que o Lombok faz?
- b) O que a anotação `@Data` gera automaticamente?
- c) Cite 2 vantagens de usar Lombok.

**Sua resposta:**
```
o lombok possibilita usar anotações, o que reduz o boilerplate, a redução de código verboso, é baseado em anotações. Gera o equals e hashcode. 
```

---

### Questão 1.4 (3 pts)
Explique a diferença entre:

```java
// Opção A
private Integer volume;

// Opção B  
private int volume;
```

- a) Qual a diferença entre `Integer` (wrapper) e `int` (primitivo)?
- b) Por que no projeto usamos `Integer` e não `int` para campos opcionais?
- c) O que acontece se tentarmos atribuir `null` a uma variável `int`?

**Sua resposta:**
```
Integer é a versao objeto de int. Integer possui métodos estáticos dentro. Não sei por que usamos Integer ao inves de int.  Nullpointer em caso de tentar atribuir null a uma variavel int.
```

---

### Questão 1.5 (3 pts)
Sobre **Generics** em Java, veja este código do projeto:

```java
public interface ProductRepository extends JpaRepository<Product, Long> { }
```

- a) O que significa `<Product, Long>` neste contexto?
- b) Por que usamos Generics?
- c) O que aconteceria se Generics não existissem?

**Sua resposta:**
```
Significa que o ID do Product é Long. Não sei. Não sei
```

---

## 📌 SEÇÃO 2: SPRING BOOT & SPRING FRAMEWORK (25 pontos)

### Questão 2.1 (5 pts)
Explique as seguintes anotações usadas no projeto:

| Anotação | Onde é usada | O que faz? |
|----------|--------------|------------|
| `@SpringBootApplication` | EcommerceApplication | ? |
| `@RestController` | ProductController | ? |
| `@Service` | ProductService | ? |
| `@Repository` | ProductRepository | ? |
| `@Entity` | Product | ? |

**Sua resposta:**
```
Informa que é uma aplicação spring boot e pode ser inicializada por essa classe. 
RestController significa que é uma APi REST, mas não sei mais afundo
Service,  significa que a classe é um serviço
Repository representa um repositório onde é feita transações de banco de dados
Entity, informa que é uma entidade, uma tabela no banco de dados
```

---

### Questão 2.2 (5 pts)
No projeto temos dois tipos de **Injeção de Dependência**:

```java
// Tipo A - No ProductController
@Autowired
private ProductService productService;

// Tipo B - No ProductService
private final ProductRepository productRepository;

@Autowired
public ProductService(ProductRepository productRepository) {
    this.productRepository = productRepository;
}
```

- a) Qual é a diferença entre injeção por campo (A) e por construtor (B)?
- b) Qual é considerada a melhor prática? Por quê?
- c) O que significa "Inversão de Controle" (IoC)?

**Sua resposta:**
```
Uma injeção é automática, a outra é instanciada quando chama o construtor da service. Não sei. Não sei.
```

---

### Questão 2.3 (5 pts)
Sobre a anotação `@ControllerAdvice`:

```java
@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleBookNotFoundException(ProductNotFoundException ex) {
        // ...
    }
}
```

- a) O que `@ControllerAdvice` faz?
- b) O que `@ExceptionHandler` faz?
- c) Por que centralizamos o tratamento de exceções dessa forma?

**Sua resposta:**
```
Pega todas as exceções e centraliza nessa classe. Informa que as dependencias de ProductNotFoundException será tratada nesse método. Para que a classe possa distribuir as exceções para os responsáveis pelo tratamento.

```

---

### Questão 2.4 (5 pts)
Sobre o arquivo `application.properties`:

```properties
spring.jpa.hibernate.ddl-auto=none
spring.liquibase.enabled=true
spring.jpa.show-sql=true
```

- a) O que faz `ddl-auto=none`? Quais outras opções existem?
- b) Por que configuramos `ddl-auto=none` quando usamos Liquibase?
- c) Para que serve `show-sql=true`?

**Sua resposta:**
```
ddl-auto= nome é ter nenhuma ação sobre o banco, não atualizar, não deletar etc. O Liquibase já tem nos scripts a criação das tabelas e dados. show-sql é para mostrar informações do sql, como querys e consultas
```

---

### Questão 2.5 (5 pts)
O projeto usa validação com Bean Validation:

```java
@NotBlank(message = "O título é obrigatório.")
@Size(max = 255, message = "O título deve ter no máximo 255 caracteres.")
private String title;

@Valid @RequestBody ProductDTO productDTO
```

- a) O que a anotação `@Valid` faz no controller?
- b) O que `@NotBlank` valida (diferença para `@NotNull`)?
- c) Onde são definidas as mensagens de erro de validação?

**Sua resposta:**
```
Valida a requisição antes de processar. Valida que o campo  não está em branco " ". Os erros são definidos em ProductDTO
```

---

## 📌 SEÇÃO 3: JPA/HIBERNATE & BANCO DE DADOS (20 pontos)

### Questão 3.1 (5 pts)
Sobre a estratégia de herança no JPA:

```java
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "product_type", discriminatorType = DiscriminatorType.STRING)
public abstract class Product { ... }

@Entity
@DiscriminatorValue("book")
public class Book extends Product { ... }
```

- a) O que significa `SINGLE_TABLE` como estratégia de herança?
- b) O que é a coluna discriminadora (`product_type`)?
- c) Cite as outras estratégias de herança do JPA (pelo menos 2).

**Sua resposta:**
```
Significa que a Product vai ser uma única tabela, e as que a implementarem vão ser diferenciadas pelo discriminatorType, que pega o nome da classe. Não sei
```

---

### Questão 3.2 (5 pts)
Sobre mapeamentos JPA:

```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;

@Column(nullable = false, unique = true, length = 70)
private String title;
```

- a) O que `@GeneratedValue(strategy = GenerationType.IDENTITY)` faz?
- b) Quais constraints são definidas na coluna `title`?
- c) Qual a diferença entre `GenerationType.IDENTITY` e `GenerationType.SEQUENCE`?

**Sua resposta:**
```
Informa que é um campo ID e  gera o ID de forma sequencial. title não pode ser nulla, é única e tem tamanho 70. Não sei
```

---

### Questão 3.3 (5 pts)
Sobre relacionamentos JPA no projeto:

```java
@ManyToOne
@JoinColumn(name = "user_id", nullable = false)
private User user;

@OneToMany(mappedBy = "sale", cascade = CascadeType.ALL)
private List<SaleItem> items;
```

- a) O que significa `@ManyToOne` e `@OneToMany`?
- b) O que `cascade = CascadeType.ALL` faz?
- c) O que significa `mappedBy = "sale"`?

**Sua resposta:**
```
(escreva aqui)
```

---

### Questão 3.4 (5 pts)
Sobre o Repository Pattern:

```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> { }
```

- a) Por que `ProductRepository` é uma **interface** e não uma **classe**?
- b) Quais métodos já vêm prontos ao extender `JpaRepository`?
- c) Como você criaria um método para buscar produtos por gênero?

**Sua resposta:**
```
(escreva aqui)
```

---

## 📌 SEÇÃO 4: LIQUIBASE - MIGRATIONS (10 pontos)

### Questão 4.1 (5 pts)
Sobre o Liquibase no projeto:

```yaml
databaseChangeLog:
  - include:
      file: db/changelog/changes/001-create-product-table.yaml
  - include:
      file: db/changelog/changes/002-insert-test-data.yaml
```

- a) O que é uma "migration" de banco de dados?
- b) Por que numeramos os arquivos (001, 002, 003...)?
- c) Qual a vantagem de usar Liquibase ao invés de scripts SQL manuais?

**Sua resposta:**
```
(escreva aqui)
```

---

### Questão 4.2 (5 pts)
Analisando um changeset:

```yaml
- changeSet:
    id: 001-create-product-table
    author: bookanga
    changes:
      - createTable:
          tableName: product
          columns:
            - column:
                name: id
                type: BIGSERIAL
                constraints:
                  primaryKey: true
```

- a) O que é um `changeSet`?
- b) Por que cada changeSet precisa de um `id` único?
- c) O que acontece se você alterar um changeSet que já foi executado?

**Sua resposta:**
```
(escreva aqui)
```

---

## 📌 SEÇÃO 5: DOCKER & DOCKER COMPOSE (15 pontos)

### Questão 5.1 (5 pts)
Sobre o Dockerfile do projeto:

```dockerfile
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
COPY --from=build /app/target/*.jar app.jar
```

- a) O que é um "multi-stage build" e por que é usado?
- b) Por que copiamos `pom.xml` antes de copiar `src`?
- c) Qual a diferença entre JDK e JRE? Por que usamos JRE no runtime?

**Sua resposta:**
```
(escreva aqui)
```

---

### Questão 5.2 (5 pts)
Sobre o docker-compose.yml:

```yaml
services:
  app:
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://bookanga-postgres:5432/bookanga_db
```

- a) O que `depends_on` com `condition: service_healthy` faz?
- b) Por que usamos `bookanga-postgres` (nome do container) ao invés de `localhost`?
- c) O que são variáveis de ambiente no Docker e por que as usamos?

**Sua resposta:**
```
(escreva aqui)
```

---

### Questão 5.3 (5 pts)
Sobre volumes e networks:

```yaml
volumes:
  postgres_data:

networks:
  bookanga-network:
    driver: bridge
```

- a) O que são Docker volumes? Por que são importantes para o postgres?
- b) O que é uma Docker network? Por que criamos uma rede customizada?
- c) Qual a diferença entre volume nomeado (`postgres_data:`) e bind mount (`./data:/data`)?

**Sua resposta:**
```
(escreva aqui)
```

---

## 📌 SEÇÃO 6: API REST & BOAS PRÁTICAS (10 pontos)

### Questão 6.1 (5 pts)
Sobre os endpoints do projeto:

```java
@GetMapping("/{id}")
public ResponseEntity<Product> getProductById(@PathVariable Long id) { }

@PostMapping
public ResponseEntity<Product> createProduct(@Valid @RequestBody ProductDTO productDTO) { }

@DeleteMapping("/{id}")
public ResponseEntity<Void> deleteProduct(@PathVariable Long id) { }
```

- a) Explique os métodos HTTP: GET, POST, PUT, DELETE
- b) O que é `@PathVariable` vs `@RequestBody`?
- c) Por que retornamos `ResponseEntity<Void>` no DELETE?

**Sua resposta:**
```
(escreva aqui)
```

---

### Questão 6.2 (5 pts)
Sobre arquitetura em camadas:

```
Controller → Service → Repository → Database
```

- a) Qual a responsabilidade de cada camada?
- b) Por que separamos em camadas?
- c) Por que usamos DTO (Data Transfer Object) ao invés de passar a Entity diretamente?

**Sua resposta:**
```
(escreva aqui)
```

---

## 📌 SEÇÃO 7: MONITORAMENTO - PROMETHEUS/GRAFANA (5 pontos)

### Questão 7.1 (5 pts)
Sobre o monitoramento no projeto:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'bookanga-api'
    metrics_path: '/actuator/prometheus'
```

```properties
# application.properties
management.endpoints.web.exposure.include=health,info,metrics,prometheus
```

- a) O que é Prometheus e para que serve?
- b) O que é o Spring Actuator?
- c) O que é Grafana e qual sua relação com Prometheus?

**Sua resposta:**
```
(escreva aqui)
```

---

## 📊 GABARITO E AUTOAVALIAÇÃO

Após responder, compare suas respostas com o gabarito que será disponibilizado.

### Sistema de Pontuação:
| Faixa | Nível | Próximos Passos |
|-------|-------|-----------------|
| 0-30 pts | 🔴 Iniciante | Foque nos fundamentos de Java e Spring |
| 31-50 pts | 🟠 Básico | Aprofunde em Spring Boot e JPA |
| 51-70 pts | 🟡 Intermediário | Estude Docker e boas práticas |
| 71-85 pts | 🟢 Avançado | Refine detalhes e padrões de projeto |
| 86-100 pts | 🔵 Expert | Explore tópicos avançados |

---

## 📝 SUAS ANOTAÇÕES

Use este espaço para anotar dúvidas e tópicos que precisa estudar:

```
Tópicos que não soube responder:
1. 
2. 
3. 

Conceitos que preciso revisar:
1. 
2. 
3. 

Próximos passos de estudo:
1. 
2. 
3. 
```

---

## 🔑 COMO USAR ESTA PROVA

1. **Responda honestamente** - O objetivo é identificar lacunas, não tirar nota alta
2. **Marque o tempo** - Veja quanto tempo cada seção levou
3. **Revise suas respostas** - Compare com o gabarito
4. **Crie um plano de estudos** - Baseado nas questões que errou
5. **Refaça em 2-4 semanas** - Para medir seu progresso

---

**BOA PROVA! 🚀**

> Após responder, salve este arquivo e solicite o gabarito para correção.

