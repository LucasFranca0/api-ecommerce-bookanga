# 🔑 GABARITO - Prova de Avaliação de Conhecimento

> **ATENÇÃO:** Só consulte este gabarito APÓS responder toda a prova!

---

## 📌 SEÇÃO 1: FUNDAMENTOS DE JAVA

### Questão 1.1 - Classes Abstratas (3 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Uma classe abstrata é uma classe que **não pode ser instanciada diretamente** e serve como modelo/base para outras classes. Pode conter métodos abstratos (sem implementação) e métodos concretos (com implementação). | 1 |
| b) | `Product` é abstrata porque representa um conceito genérico - todo produto é ou um `Book` ou um `Manga`, nunca "apenas um produto". Força as subclasses a implementar `getProductType()`. | 1 |
| c) | **Não**, tentar `new Product()` gera erro de compilação. Só podemos instanciar `new Book()` ou `new Manga()`. | 1 |

---

### Questão 1.2 - Herança (3 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `extends` indica que a classe **herda** de outra. `Book` e `Manga` herdam todos os atributos e métodos de `Product`. | 1 |
| b) | Herdam: `id`, `title`, `volume`, `author`, `publicationYear`, `genre`, `language`, `price`, `isbn` e todos os métodos públicos/protected. | 1 |
| c) | Porque `getProductType()` é um método **abstrato** em `Product`, então as subclasses são **obrigadas** a implementá-lo. Cada uma retorna seu tipo específico ("book" ou "manga"). | 1 |

---

### Questão 1.3 - Lombok (3 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Lombok é uma biblioteca que gera código boilerplate automaticamente em tempo de compilação usando anotações. | 1 |
| b) | `@Data` gera: `@Getter`, `@Setter`, `@ToString`, `@EqualsAndHashCode`, `@RequiredArgsConstructor` | 1 |
| c) | Vantagens: 1) Reduz código repetitivo, 2) Menos erros manuais, 3) Código mais limpo/legível, 4) Manutenção mais fácil | 1 |

---

### Questão 1.4 - Wrapper vs Primitivo (3 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `Integer` é uma classe (objeto) que "envolve" o primitivo `int`. `int` é um tipo primitivo que não aceita `null`. | 1 |
| b) | Campos opcionais podem não ter valor (`null`). `Integer` aceita `null`, `int` não - sempre tem um valor (0 por padrão). | 1 |
| c) | Gera `NullPointerException` em tempo de execução se tentarmos fazer unboxing de `null`. | 1 |

---

### Questão 1.5 - Generics (3 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `<Product, Long>` indica: tipo da entidade = `Product`, tipo da chave primária (ID) = `Long` | 1 |
| b) | Generics fornecem **type safety** em tempo de compilação, evitam casts e tornam o código reutilizável. | 1 |
| c) | Teríamos que usar `Object` e fazer casts manuais, perdendo segurança de tipos e arriscando `ClassCastException`. | 1 |

---

## 📌 SEÇÃO 2: SPRING BOOT & SPRING FRAMEWORK

### Questão 2.1 - Anotações Spring (5 pts)

| Anotação | O que faz? | Pts |
|----------|------------|-----|
| `@SpringBootApplication` | Combina `@Configuration`, `@EnableAutoConfiguration`, `@ComponentScan`. Ponto de entrada da aplicação. | 1 |
| `@RestController` | Combina `@Controller` + `@ResponseBody`. Indica controller REST que retorna JSON diretamente. | 1 |
| `@Service` | Marca classe como serviço (camada de negócio). Spring gerencia como bean. | 1 |
| `@Repository` | Marca classe como repositório (camada de dados). Traduz exceções de persistência. | 1 |
| `@Entity` | Marca classe como entidade JPA (será mapeada para tabela no banco). | 1 |

---

### Questão 2.2 - Injeção de Dependência (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | **Campo**: injeta diretamente no atributo. **Construtor**: injeta via parâmetro do construtor. | 1.5 |
| b) | **Construtor é melhor** porque: 1) Permite campos `final` (imutabilidade), 2) Facilita testes unitários, 3) Dependências obrigatórias são claras, 4) Não funciona com `null` | 2 |
| c) | IoC significa que o **container Spring** controla a criação e injeção de objetos, não o programador. Inversão do fluxo de controle tradicional. | 1.5 |

---

### Questão 2.3 - ControllerAdvice (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `@ControllerAdvice` intercepta exceções de **todos os controllers** da aplicação. É um "conselheiro" global. | 2 |
| b) | `@ExceptionHandler` define qual método trata qual tipo de exceção específica. | 1.5 |
| c) | Centralização evita duplicação de código, padroniza respostas de erro, separa lógica de erro da lógica de negócio. | 1.5 |

---

### Questão 2.4 - application.properties (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `none`: Hibernate não altera schema. Outras: `validate`, `update`, `create`, `create-drop` | 2 |
| b) | Porque o **Liquibase** é responsável pelo schema. Se ambos alterassem, haveria conflitos e inconsistências. | 2 |
| c) | Imprime as queries SQL no console para debug/desenvolvimento. | 1 |

---

### Questão 2.5 - Bean Validation (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `@Valid` ativa a validação do objeto. Se falhar, lança `MethodArgumentNotValidException`. | 2 |
| b) | `@NotBlank`: não pode ser `null`, vazio, ou só espaços. `@NotNull`: apenas não pode ser `null` (aceita string vazia). | 2 |
| c) | No atributo `message` de cada anotação. Ex: `@NotBlank(message = "O título é obrigatório.")` | 1 |

---

## 📌 SEÇÃO 3: JPA/HIBERNATE & BANCO DE DADOS

### Questão 3.1 - Estratégia de Herança (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `SINGLE_TABLE`: todas as subclasses ficam em **uma única tabela**. Uma coluna discriminadora diferencia os tipos. | 2 |
| b) | Coluna que identifica qual subclasse cada registro representa (ex: "book" ou "manga"). | 1.5 |
| c) | `TABLE_PER_CLASS` (uma tabela por classe concreta), `JOINED` (uma tabela base + tabelas específicas com FK) | 1.5 |

---

### Questão 3.2 - Mapeamentos JPA (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | O banco gera o ID automaticamente (auto-increment). O ID é gerado após o INSERT. | 2 |
| b) | `nullable = false` (obrigatório), `unique = true` (valor único), `length = 70` (máximo 70 chars) | 2 |
| c) | `IDENTITY`: banco gera (auto-increment). `SEQUENCE`: usa sequence do banco (mais eficiente para batch inserts). | 1 |

---

### Questão 3.3 - Relacionamentos JPA (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | `@ManyToOne`: muitos (Sales) para um (User). `@OneToMany`: um (Sale) para muitos (SaleItems). | 2 |
| b) | Operações em `Sale` são propagadas para `items`. Ex: salvar Sale também salva seus SaleItems. | 1.5 |
| c) | Indica o campo na outra entidade que "possui" o relacionamento. Evita tabela intermediária. | 1.5 |

---

### Questão 3.4 - Repository Pattern (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | O Spring Data JPA gera a implementação automaticamente em runtime. Interface define o contrato. | 2 |
| b) | `save()`, `findById()`, `findAll()`, `deleteById()`, `count()`, `existsById()`, etc. | 1.5 |
| c) | `List<Product> findByGenre(String genre);` - Spring cria a query automaticamente pelo nome do método. | 1.5 |

---

## 📌 SEÇÃO 4: LIQUIBASE - MIGRATIONS

### Questão 4.1 - Conceitos Liquibase (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Migration = script versionado que altera o schema do banco de forma controlada e rastreável. | 2 |
| b) | Garante ordem de execução. Migrations são aplicadas sequencialmente. Evita conflitos. | 1.5 |
| c) | Versionamento, rollback automático, independência de banco, histórico de alterações, trabalho em equipe. | 1.5 |

---

### Questão 4.2 - ChangeSets (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | ChangeSet = unidade atômica de mudança. Pode conter várias alterações que são executadas juntas. | 2 |
| b) | Liquibase rastreia quais changesets já foram executados pelo ID. ID duplicado causa erro. | 1.5 |
| c) | Liquibase detecta a mudança (hash diferente) e **falha** a execução. Changesets devem ser **imutáveis** após execução. | 1.5 |

---

## 📌 SEÇÃO 5: DOCKER & DOCKER COMPOSE

### Questão 5.1 - Dockerfile Multi-stage (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Multi-stage usa múltiplos `FROM`. Primeiro stage compila, segundo executa. Imagem final é menor (sem ferramentas de build). | 2 |
| b) | **Cache de layers**. Se pom.xml não mudar, dependências não são baixadas novamente. Build mais rápido. | 1.5 |
| c) | JDK = Java Development Kit (compilar + executar). JRE = Java Runtime Environment (apenas executar). JRE é menor. | 1.5 |

---

### Questão 5.2 - Docker Compose (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Espera o postgres estar **saudável** (healthcheck passar) antes de iniciar a app. Não apenas "iniciado". | 2 |
| b) | Containers se comunicam por uma rede interna Docker. O nome do container vira um DNS interno. `localhost` seria o próprio container. | 1.5 |
| c) | Variáveis passadas para o container. Sobrescrevem configurações. Úteis para diferentes ambientes (dev/prod). | 1.5 |

---

### Questão 5.3 - Volumes e Networks (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Volumes persistem dados fora do container. Sem volume, dados do postgres seriam perdidos ao remover o container. | 2 |
| b) | Rede customizada permite containers se comunicarem por nome. Isolamento de outros containers. | 1.5 |
| c) | **Nomeado**: gerenciado pelo Docker, persiste. **Bind mount**: monta diretório do host, útil para desenvolvimento. | 1.5 |

---

## 📌 SEÇÃO 6: API REST & BOAS PRÁTICAS

### Questão 6.1 - Métodos HTTP e REST (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | GET: buscar, POST: criar, PUT: atualizar (completo), DELETE: remover. (PATCH: atualização parcial) | 2 |
| b) | `@PathVariable`: valor da URL (ex: `/products/5` → id=5). `@RequestBody`: corpo JSON da requisição. | 2 |
| c) | DELETE não retorna dados do recurso deletado. `Void` indica ausência de corpo na resposta (204 No Content). | 1 |

---

### Questão 6.2 - Arquitetura em Camadas (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Controller: recebe requisições, valida, retorna respostas. Service: lógica de negócio. Repository: acesso a dados. | 2 |
| b) | Separação de responsabilidades, facilita testes, manutenção, mudanças isoladas, reuso de código. | 1.5 |
| c) | DTO: 1) Esconde detalhes internos da Entity, 2) Permite formatos diferentes entrada/saída, 3) Segurança (não expõe tudo), 4) Desacopla API da estrutura do banco. | 1.5 |

---

## 📌 SEÇÃO 7: MONITORAMENTO

### Questão 7.1 - Prometheus/Grafana/Actuator (5 pts)

| Critério | Resposta Esperada | Pts |
|----------|-------------------|-----|
| a) | Prometheus: sistema de monitoramento que coleta e armazena métricas em séries temporais. Faz "scraping" de endpoints. | 2 |
| b) | Actuator: módulo Spring que expõe endpoints de gerenciamento (health, metrics, info, etc.). | 1.5 |
| c) | Grafana: ferramenta de visualização. Cria dashboards com gráficos. Consulta dados do Prometheus para exibição. | 1.5 |

---

## 📊 TABELA DE PONTUAÇÃO FINAL

Calcule sua pontuação:

| Seção | Máximo | Sua Pontuação |
|-------|--------|---------------|
| 1. Fundamentos Java | 15 | _____ |
| 2. Spring Boot | 25 | _____ |
| 3. JPA/Hibernate | 20 | _____ |
| 4. Liquibase | 10 | _____ |
| 5. Docker | 15 | _____ |
| 6. API REST | 10 | _____ |
| 7. Monitoramento | 5 | _____ |
| **TOTAL** | **100** | **_____** |

---

## 📚 PLANO DE ESTUDOS POR NÍVEL

### 🔴 Iniciante (0-30 pts)
**Foco prioritário:**
1. **Java Básico** - Classes, objetos, herança, interfaces
2. **Spring Boot Intro** - Annotations, IoC, DI
3. **SQL Básico** - SELECT, INSERT, UPDATE, DELETE

**Recursos:**
- Curso: "Java COMPLETO" - Nélio Alves (Udemy)
- Livro: "Head First Java"
- Documentação Spring: https://spring.io/guides

### 🟠 Básico (31-50 pts)
**Foco:**
1. **Spring Data JPA** - Repositories, Entities
2. **REST APIs** - Métodos HTTP, status codes
3. **Docker Basics** - Containers, images

**Recursos:**
- Curso: "Spring Boot + JPA" - Nélio Alves
- Docker: https://docs.docker.com/get-started/

### 🟡 Intermediário (51-70 pts)
**Foco:**
1. **JPA Avançado** - Relacionamentos, estratégias de herança
2. **Docker Compose** - Multi-container apps
3. **Liquibase** - Migrations na prática

**Recursos:**
- Baeldung.com (tutoriais Spring/JPA)
- Liquibase docs: https://docs.liquibase.com/

### 🟢 Avançado (71-85 pts)
**Foco:**
1. **Padrões de Projeto** - Repository, DTO, Service
2. **Testes** - JUnit, Mockito, Integration tests
3. **Observabilidade** - Prometheus, Grafana

**Recursos:**
- Livro: "Clean Code" - Robert Martin
- Spring Testing Guide

### 🔵 Expert (86-100 pts)
**Foco:**
1. **Arquitetura** - Microservices, DDD
2. **Performance** - Caching, otimização queries
3. **Segurança** - Spring Security, OAuth2

---

## ✅ CHECKLIST DE CONCEITOS DOMINADOS

Marque o que você domina:

```
JAVA CORE
[ ] Classes e Objetos
[ ] Herança e Polimorfismo
[ ] Classes Abstratas e Interfaces
[ ] Generics
[ ] Collections
[ ] Exceções
[ ] Annotations

SPRING
[ ] IoC / DI
[ ] Beans e Component Scan
[ ] Anotações (@Service, @Controller, etc)
[ ] Bean Validation
[ ] Exception Handling
[ ] Profiles

JPA/HIBERNATE
[ ] Entities e Mapeamentos
[ ] Relacionamentos (1:1, 1:N, N:N)
[ ] Estratégias de Herança
[ ] JPQL/Query Methods
[ ] Transactions

DATABASE
[ ] SQL Básico
[ ] Migrations (Liquibase/Flyway)
[ ] Índices
[ ] Constraints

DOCKER
[ ] Containers vs VMs
[ ] Dockerfile
[ ] Docker Compose
[ ] Volumes e Networks

REST APIs
[ ] Métodos HTTP
[ ] Status Codes
[ ] Design de URLs
[ ] DTOs

MONITORAMENTO
[ ] Actuator
[ ] Prometheus
[ ] Grafana
```

---

**Parabéns por completar a avaliação! 🎉**

Use os resultados para criar seu plano de estudos personalizado.

