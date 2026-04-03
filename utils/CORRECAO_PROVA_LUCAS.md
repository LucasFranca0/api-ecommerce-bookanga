# 📊 CORREÇÃO DA PROVA - Lucas

> **Data da Avaliação:** 31 de Janeiro de 2026  
> **Questões Respondidas:** 13 de 25  
> **Status:** Avaliação Parcial

---

## 📋 RESUMO DA CORREÇÃO

| Seção | Máximo | Obtido | % |
|-------|--------|--------|---|
| 1. Fundamentos Java | 15 pts | **10 pts** | 67% |
| 2. Spring Boot | 25 pts | **14 pts** | 56% |
| 3. JPA/Hibernate | 20 pts | **6 pts** | 30% |
| 4. Liquibase | 10 pts | **0 pts** | 0% (não respondido) |
| 5. Docker | 15 pts | **0 pts** | 0% (não respondido) |
| 6. API REST | 10 pts | **0 pts** | 0% (não respondido) |
| 7. Monitoramento | 5 pts | **0 pts** | 0% (não respondido) |
| **TOTAL (respondidas)** | **60 pts** | **30 pts** | **50%** |

---

## 📌 SEÇÃO 1: FUNDAMENTOS DE JAVA (10/15 pts)

### Questão 1.1 - Classes Abstratas ✅ **3/3 pts**
> Sua resposta foi **EXCELENTE!**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) Classe abstrata | "não pode ser instanciada diretamente e pode conter métodos abstratos" | ✅ Correto |
| b) Por que Product é abstrata | "serve como base comum para diferentes tipos de produtos" | ✅ Correto |
| c) Pode instanciar? | "Não é possível criar uma instância de Product diretamente" | ✅ Correto |

**Comentário:** Resposta completa e bem articulada! Você domina este conceito.

---

### Questão 1.2 - Herança 🟡 **2/3 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) extends | "está extendendo outra, herdando tudo que a classe pai tem" | ✅ Correto |
| b) O que herda | "Herda tudo" | 🟡 Parcial - poderia citar: id, title, author, price, isbn, etc. |
| c) Por que implementam getProductType() | "para que cada classe tenha uma versão adaptada" | 🟡 Parcial - faltou mencionar que é **obrigatório** pois é abstrato |

**O que faltou:**
- Citar que `getProductType()` é um **método abstrato**, então as subclasses são **obrigadas** a implementá-lo
- Listar especificamente alguns atributos herdados

---

### Questão 1.3 - Lombok 🟡 **1.5/3 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) O que Lombok faz | "possibilita usar anotações, reduz boilerplate" | 🟡 Parcial |
| b) O que @Data gera | "Gera o equals e hashcode" | 🟡 Incompleto - faltou: @Getter, @Setter, @ToString, @RequiredArgsConstructor |
| c) Vantagens | "redução de código verboso, baseado em anotações" | ✅ Correto |

**O que faltou:**
- Lombok gera código em **tempo de compilação**
- `@Data` gera MUITO mais: getters, setters, toString, equals, hashCode, construtor

---

### Questão 1.4 - Wrapper vs Primitivo 🟡 **2/3 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) Diferença Integer/int | "Integer é a versão objeto de int. Integer possui métodos estáticos" | ✅ Correto |
| b) Por que usamos Integer | "Não sei" | ❌ |
| c) Null em int | "NullPointerException" | ✅ Correto |

**O que faltou na letra b:**
> `Integer` aceita `null`, `int` não. Para campos **opcionais** (como volume de mangá), precisamos representar "ausência de valor", e `null` é a forma de fazer isso.

---

### Questão 1.5 - Generics 🟡 **1.5/3 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) O que significa <Product, Long> | "Significa que o ID do Product é Long" | 🟡 Parcial - faltou mencionar que `Product` é o tipo da entidade |
| b) Por que usamos Generics | "Não sei" | ❌ |
| c) Sem Generics? | "Não sei" | ❌ |

**Resposta completa:**
- `<Product, Long>` = Tipo da entidade é `Product`, tipo da chave primária é `Long`
- **Por que Generics?** Type safety em tempo de compilação, evita casts
- **Sem Generics?** Usaríamos `Object` e faríamos casts manuais, arriscando `ClassCastException`

---

## 📌 SEÇÃO 2: SPRING BOOT (14/25 pts)

### Questão 2.1 - Anotações Spring 🟡 **3/5 pts**

| Anotação | Sua Resposta | Avaliação |
|----------|--------------|-----------|
| @SpringBootApplication | "é uma aplicação spring boot e pode ser inicializada" | 🟡 Parcial - combina 3 anotações |
| @RestController | "é uma API REST, mas não sei mais afundo" | 🟡 Parcial - combina @Controller + @ResponseBody |
| @Service | "significa que a classe é um serviço" | ✅ Correto |
| @Repository | "transações de banco de dados" | ✅ Correto |
| @Entity | "é uma entidade, uma tabela no banco" | ✅ Correto |

**O que faltou:**
- `@SpringBootApplication` = `@Configuration` + `@EnableAutoConfiguration` + `@ComponentScan`
- `@RestController` = `@Controller` + `@ResponseBody` (retorna JSON diretamente)

---

### Questão 2.2 - Injeção de Dependência 🔴 **1.5/5 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) Diferença | "Uma injeção é automática, outra é instanciada quando chama o construtor" | 🟡 Parcial/Confuso |
| b) Melhor prática | "Não sei" | ❌ |
| c) IoC | "Não sei" | ❌ |

**Resposta correta:**
- **Injeção por campo (@Autowired):** Injeta diretamente no atributo
- **Injeção por construtor:** Injeta via parâmetro do construtor
- **Melhor prática:** Construtor! Porque permite `final`, facilita testes, dependências são obrigatórias
- **IoC (Inversão de Controle):** O **Spring** controla a criação de objetos, não você

---

### Questão 2.3 - ControllerAdvice ✅ **4/5 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) @ControllerAdvice | "Pega todas as exceções e centraliza nessa classe" | ✅ Correto |
| b) @ExceptionHandler | "informa que ProductNotFoundException será tratada nesse método" | ✅ Correto |
| c) Por que centralizar | "Para que a classe possa distribuir as exceções" | 🟡 Parcial - faltou: evita duplicação, padroniza respostas |

---

### Questão 2.4 - application.properties ✅ **4/5 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) ddl-auto=none | "ter nenhuma ação sobre o banco, não atualizar, não deletar" | ✅ Correto (faltou outras opções) |
| b) Por que none com Liquibase | "O Liquibase já tem nos scripts a criação das tabelas" | ✅ Correto |
| c) show-sql | "mostrar informações do sql, como querys e consultas" | ✅ Correto |

**Outras opções de ddl-auto:** `validate`, `update`, `create`, `create-drop`

---

### Questão 2.5 - Bean Validation 🟡 **1.5/5 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) @Valid | "Valida a requisição antes de processar" | ✅ Correto |
| b) @NotBlank | "Valida que o campo não está em branco" | 🟡 Parcial - faltou diferença para @NotNull |
| c) Onde são definidas mensagens | "em ProductDTO" | ❌ São no atributo `message` de cada anotação |

**Diferença importante:**
- `@NotNull` - apenas não pode ser `null`
- `@NotBlank` - não pode ser `null`, vazio (""), nem só espaços ("   ")

---

## 📌 SEÇÃO 3: JPA/HIBERNATE (6/20 pts)

### Questão 3.1 - Estratégia de Herança 🟡 **2.5/5 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) SINGLE_TABLE | "vai ser uma única tabela, diferenciadas pelo discriminatorType" | ✅ Correto |
| b) Coluna discriminadora | "pega o nome da classe" | 🟡 Impreciso - é uma coluna que identifica o tipo |
| c) Outras estratégias | "Não sei" | ❌ TABLE_PER_CLASS, JOINED |

---

### Questão 3.2 - Mapeamentos JPA 🟡 **3.5/5 pts**

| Item | Sua Resposta | Avaliação |
|------|--------------|-----------|
| a) @GeneratedValue | "gera o ID de forma sequencial" | ✅ Correto |
| b) Constraints title | "não pode ser nulla, é única e tem tamanho 70" | ✅ Correto |
| c) IDENTITY vs SEQUENCE | "Não sei" | ❌ |

**Diferença IDENTITY vs SEQUENCE:**
- `IDENTITY`: Banco gera ID (auto-increment) após INSERT
- `SEQUENCE`: Usa sequence do banco, mais eficiente para batch inserts

---

### Questão 3.3 e 3.4 - Não Respondidas ❌ **0/10 pts**

---

## 📌 SEÇÕES 4-7: NÃO RESPONDIDAS ❌ **0/40 pts**

---

## 🎯 ANÁLISE DO SEU NÍVEL

### Pontuação Final (questões respondidas): **30/60 pts = 50%**

### Classificação: 🟠 **NÍVEL BÁSICO**

---

## 📈 MAPA DE FORÇAS E FRAQUEZAS

### ✅ O QUE VOCÊ DOMINA:
1. **Classes Abstratas e Herança** - Excelente compreensão
2. **Conceito de Anotações Spring** (@Service, @Repository, @Entity)
3. **Tratamento de Exceções** (@ControllerAdvice, @ExceptionHandler)
4. **Propósito do Liquibase** - Entende por que usar

### 🟡 PRECISA REVISAR:
1. **Lombok** - Sabe o conceito, falta detalhes
2. **Bean Validation** - @NotBlank vs @NotNull
3. **Mapeamentos JPA** - Entende básico, falta profundidade

### ❌ LACUNAS IMPORTANTES (Prioridade de Estudo):
1. **Inversão de Controle (IoC) e Injeção de Dependência**
2. **Generics em Java** - Por que e para que servem
3. **Wrapper Classes** (Integer vs int) - Quando usar cada
4. **Estratégias de Herança JPA** (SINGLE_TABLE, JOINED, TABLE_PER_CLASS)
5. **Docker e Docker Compose** - Não respondeu
6. **Relacionamentos JPA** (@ManyToOne, @OneToMany, cascade)

---

## 📚 PLANO DE ESTUDOS PERSONALIZADO

### 🔴 SEMANA 1: Fundamentos que faltam
| Dia | Tópico | Tempo |
|-----|--------|-------|
| Seg | Generics em Java | 1h |
| Ter | Wrapper Classes (Integer, Long, Boolean) | 1h |
| Qua | IoC e Injeção de Dependência | 1.5h |
| Qui | Lombok (todas anotações) | 1h |
| Sex | Praticar no projeto Bookanga | 2h |

### 🟠 SEMANA 2: JPA/Hibernate
| Dia | Tópico | Tempo |
|-----|--------|-------|
| Seg | Relacionamentos: @ManyToOne, @OneToMany | 1.5h |
| Ter | Cascade Types e FetchType | 1h |
| Qua | Estratégias de Herança JPA | 1h |
| Qui | Query Methods do Spring Data | 1h |
| Sex | Implementar no Bookanga | 2h |

### 🟡 SEMANA 3: Docker (você não respondeu nada!)
| Dia | Tópico | Tempo |
|-----|--------|-------|
| Seg | Conceitos Docker: imagem vs container | 1h |
| Ter | Dockerfile: entender multi-stage build | 1h |
| Qua | Docker Compose: services, networks, volumes | 1.5h |
| Qui | Variáveis de ambiente e healthchecks | 1h |
| Sex | Rodar Bookanga com docker-compose | 2h |

### 🟢 SEMANA 4: API REST e Boas Práticas
| Dia | Tópico | Tempo |
|-----|--------|-------|
| Seg | Métodos HTTP: GET, POST, PUT, DELETE, PATCH | 1h |
| Ter | Status Codes HTTP (200, 201, 400, 404, 500) | 1h |
| Qua | DTO Pattern - por que usar | 1h |
| Qui | Arquitetura em camadas | 1h |
| Sex | Refatorar endpoints do Bookanga | 2h |

---

## 💡 RECOMENDAÇÕES IMEDIATAS

1. **Complete a prova!** As seções 4-7 (Docker, REST, Monitoramento) são essenciais
2. **Foque em IoC/DI** - É fundamental para Spring
3. **Estude Docker** - Você não respondeu nada e precisa para rodar o projeto
4. **Pratique Generics** - Aparece em todo lugar no código Java

---

## 🔄 PRÓXIMOS PASSOS

1. ✅ Complete as questões que faltam
2. 📖 Siga o plano de estudos acima
3. 🔧 Vamos corrigir o erro do Liquibase no projeto
4. 📚 Criarei documentação detalhada para você estudar

---

**Parabéns por ser honesto nas respostas! Isso é essencial para aprender de verdade.** 🚀

