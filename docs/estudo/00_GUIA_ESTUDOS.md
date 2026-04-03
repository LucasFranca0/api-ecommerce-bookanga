# 📚 GUIA DE ESTUDOS - Projeto Bookanga
---

## 🗺️ MAPA DE ESTUDOS

```
SEMANA 1                    SEMANA 2                    SEMANA 3                    SEMANA 4
    │                           │                           │                           │
    ▼                           ▼                           ▼                           ▼
┌─────────┐              ┌─────────┐              ┌─────────┐              ┌─────────┐
│ Módulo 1│              │ Módulo 3│              │ Módulo 4│              │ Módulo 6│
│  Java   │──────────────│   JPA   │──────────────│ Docker  │──────────────│API REST │
│Fundament│              │Relaciona│              │Compose  │              │Boas Prát│
└─────────┘              └─────────┘              └─────────┘              └─────────┘
    │                           │                           │                           │
    ▼                           │                           ▼                           │
┌─────────┐                     │                    ┌─────────┐                       │
│ Módulo 2│                     │                    │ Módulo 5│                       │
│  IoC/DI │◄────────────────────┘                    │Liquibase│                       │
│ Spring  │                                          │Migrations                       │
└─────────┘                                          └─────────┘                       │
                                                                                       ▼
                                                                               ┌─────────┐
                                                                               │ Módulo 7│
                                                                               │Monitoram│
                                                                               │Prometheus│
                                                                               └─────────┘
```

---

## 📖 MÓDULOS DE ESTUDO

### ✅ TODOS OS MÓDULOS CRIADOS

| # | Módulo | Arquivo | Tempo | Status |
|---|--------|---------|-------|--------|
| 1 | Fundamentos Java | `01_FUNDAMENTOS_JAVA.md` | 4-6h | ✅ Criado |
| 2 | IoC e Injeção de Dependência | `02_IOC_INJECAO_DEPENDENCIA.md` | 3-4h | ✅ Criado |
| 3 | JPA e Relacionamentos | `03_JPA_RELACIONAMENTOS.md` | 4-5h | ✅ Criado |
| 4 | Docker e Docker Compose | `04_DOCKER_COMPOSE.md` | 4-5h | ✅ Criado |
| 5 | Liquibase | `05_LIQUIBASE.md` | 2-3h | ✅ Criado |
| 6 | API REST | `06_API_REST.md` | 3-4h | ✅ Criado |
| 7 | Monitoramento | `07_MONITORAMENTO.md` | 2-3h | ✅ Criado |
| 8 | Maven | `08_MAVEN.md` | 2-3h | ✅ Criado |
| 9 | Git & GitHub | `09_GIT_GITHUB.md` | 3-4h | ✅ Criado |
| 10 | Testes | `10_TESTES.md` | 4-5h | ✅ Criado |
| 11 | Padrões de Projeto | `11_PADROES_PROJETO.md` | 3-4h | ✅ Criado |
| 12 | SQL & PostgreSQL | `12_SQL_POSTGRESQL.md` | 3-4h | ✅ Criado |
| 13 | Segurança | `13_SEGURANCA.md` | 4-5h | ✅ Criado |
| 14 | Clean Code e SOLID | `14_CLEAN_CODE_SOLID.md` | 3-4h | ✅ Criado |

**📊 Total: 14 módulos | ~45-55 horas de estudo**
| 14 | Clean Code | SOLID, Boas Práticas, Refatoração | 3-4h |

---

## 🎯 PLANO DE ESTUDOS SEMANAL

### 📅 SEMANA 1: Fundamentos (7-10 horas)

> 📖 **[VER ROTEIRO DETALHADO DA SEMANA 1](ROTEIRO_SEMANA_1.md)** ← Passo a passo completo!

| Dia | Atividade | Tempo |
|-----|-----------|-------|
| Seg | Ler Módulo 1: Generics | 1.5h |
| Ter | Ler Módulo 1: Wrappers + Lombok | 1.5h |
| Qua | Ler Módulo 2: IoC (parte 1) | 1.5h |
| Qui | Ler Módulo 2: DI e tipos de injeção | 1.5h |
| Sex | Exercícios práticos no projeto | 2h |
| Sáb | Revisar e anotar dúvidas | 1h |

**Entregas da Semana 1:**
- [x] Refatorar `ProductController` para injeção por construtor ✅ **CONCLUÍDO!**
- [x] Usar `@RequiredArgsConstructor` no `ProductService` ✅ **CONCLUÍDO!**
- [x] Adicionar 3 Query Methods no `ProductRepository` ✅ **CONCLUÍDO! (10 queries implementadas)**

---

### 📅 SEMANA 2: JPA e Banco de Dados (6-8 horas)

| Dia | Atividade | Tempo |
|-----|-----------|-------|
| Seg | Ler Módulo 3: Entities e Mapeamentos | 1.5h |
| Ter | Ler Módulo 3: Relacionamentos | 1.5h |
| Qua | Ler Módulo 3: Cascade e Fetch | 1.5h |
| Qui | Ler Módulo 3: Query Methods | 1h |
| Sex | Exercícios práticos no projeto | 2h |

**Entregas da Semana 2:**
- [ ] Entender relacionamentos Sale ↔ SaleItem
- [ ] Criar queries customizadas
- [ ] Implementar paginação

---

### 📅 SEMANA 3: Docker e Infraestrutura (6-8 horas)

| Dia | Atividade | Tempo |
|-----|-----------|-------|
| Seg | Ler Módulo 4: Conceitos Docker | 1.5h |
| Ter | Ler Módulo 4: Dockerfile | 1.5h |
| Qua | Ler Módulo 4: Docker Compose | 1.5h |
| Qui | Ler Módulo 5: Liquibase | 1.5h |
| Sex | Praticar com docker-compose | 2h |

**Entregas da Semana 3:**
- [ ] Subir projeto com docker-compose
- [ ] Entender logs do container
- [ ] Criar nova migration no Liquibase

---

### 📅 SEMANA 4: APIs e Monitoramento (5-7 horas)

| Dia | Atividade | Tempo |
|-----|-----------|-------|
| Seg | Ler Módulo 6: REST APIs | 1.5h |
| Ter | Ler Módulo 6: Boas Práticas | 1.5h |
| Qua | Ler Módulo 7: Monitoramento | 1.5h |
| Qui | Revisar tudo | 1.5h |
| Sex | Refazer a prova! | 1h |

**Entregas da Semana 4:**
- [ ] Refazer a prova de avaliação
- [ ] Comparar notas (antes vs depois)
- [ ] Listar próximos passos

---

## 📊 PROGRESSO ATUAL (Atualizado em 03/02/2026)

### 🎉 Conquistas Recentes

**✅ SEMANA 1 - CONCLUÍDA!**

| Item | Status | Detalhes |
|------|--------|----------|
| Injeção por Construtor | ✅ | `ProductController` refatorado |
| Lombok @RequiredArgsConstructor | ✅ | `ProductService` implementado |
| Query Methods | ✅ | **10 queries** implementadas (meta era 3!) |
| Documentação Confluence | ✅ | Guia completo criado |

**🏆 Destaques:**
- ✅ Você **superou a meta** de Query Methods (10 implementadas vs 3 pedidas)
- ✅ Dominou: `Containing`, `IgnoreCase`, `Between`, `Top`, `OrderBy`
- ✅ Criou documentação profissional para Confluence
- ✅ Entendeu quando usar `Optional` vs `List` vs `boolean`

### 📈 Progresso por Categoria

| Categoria | Progresso | Próximo Passo |
|-----------|-----------|---------------|
| **Java Fundamentos** | 🟡 60% | Estudar Generics e Wrappers |
| **Spring Framework** | 🟡 40% | Estudar IoC e DI em profundidade |
| **JPA/Hibernate** | 🟢 70% | Estudar Relacionamentos (@ManyToOne, @OneToMany) |
| **Docker** | 🔴 20% | Estudar Docker Compose |
| **Liquibase** | 🔴 30% | Resolver erro de inicialização |
| **API REST** | 🟡 50% | Boas práticas e validações |
| **Testes** | 🔴 0% | Criar testes unitários |

**Legenda:** 🟢 Avançado | 🟡 Intermediário | 🔴 Iniciante

### 🎯 Métricas de Aprendizado

```
Módulos Estudados:    1/14  (Query Methods aprofundado)
Horas de Estudo:      ~4h   (de 45-55h totais)
Entregas Práticas:    3/3   (SEMANA 1 - 100%)
Progresso Geral:      ~10%  
```

### 📝 O Que Você Domina Agora

**✅ Query Methods (Spring Data JPA)**
- Prefixos: `find`, `count`, `exists`, `delete`
- Operadores: `Containing`, `IgnoreCase`, `Between`, `LessThan`, `GreaterThan`
- Modificadores: `Top`, `OrderBy`, `Distinct`
- Tipos de retorno: `Optional<T>`, `List<T>`, `boolean`, `long`
- Quando usar Query Methods vs `@Query`

**✅ Injeção de Dependência**
- Injeção por construtor (melhor prática)
- `@RequiredArgsConstructor` do Lombok
- Campos `final` para imutabilidade

**✅ JPA Básico**
- Entidades com `@Entity`
- Mapeamento de campos com `@Column`
- Constraints (`unique`, `nullable`)
- Repository pattern

---

## 📊 PROGRESSO

### Checklist de Conceitos

#### Java Core
- [x] Classes e Objetos (você sabe!)
- [x] Herança (você sabe!)
- [x] Classes Abstratas (você sabe!)
- [ ] Generics ← Estudar!
- [ ] Wrapper Classes ← Estudar!

#### Spring Framework
- [ ] IoC (Inversão de Controle) ← Estudar!
- [ ] Injeção de Dependência ← Estudar!
- [x] @Service, @Repository, @Controller ✅
- [x] Injeção por Construtor ✅
- [x] @RequiredArgsConstructor (Lombok) ✅
- [ ] @ControllerAdvice (parcial)
- [ ] Bean Validation

#### JPA/Hibernate
- [x] Entities básicas ✅
- [ ] Relacionamentos ← Estudar!
- [ ] Cascade Types ← Estudar!
- [ ] Fetch Types ← Estudar!
- [x] Query Methods ✅ **DOMINADO!**

#### Docker
- [ ] Dockerfile ← Estudar!
- [ ] Docker Compose ← Estudar!
- [ ] Volumes ← Estudar!
- [ ] Networks ← Estudar!

#### Liquibase
- [x] Conceito básico
- [ ] ChangeSets
- [ ] Rollback

---

## 🎯 PRÓXIMOS PASSOS RECOMENDADOS

### 🚀 Opção 1: Continuar Sequencial (Recomendado para Iniciantes)

Seguir o plano da **SEMANA 2** - JPA e Relacionamentos:

**Por quê?** Você já domina Query Methods, agora precisa entender como trabalhar com múltiplas tabelas relacionadas.

**Estudar:**
1. **Relacionamentos JPA** (`@ManyToOne`, `@OneToMany`)
2. **Cascade Types** (quando deletar/salvar em cascata)
3. **Fetch Types** (`LAZY` vs `EAGER`)
4. **Queries com JOIN**

**Arquivo:** `docs/estudo/03_JPA_RELACIONAMENTOS.md`

**Entregável Prático:**
- Entender como `Sale` se relaciona com `SaleItem`
- Criar queries que buscam vendas com seus itens
- Implementar paginação em listagens

---

### 🔥 Opção 2: Resolver Problemas Práticos

Focar em **corrigir erros** e **melhorar o projeto** antes de estudar teoria:

**Problemas para Resolver:**

1. **Erro do Liquibase** (Alta Prioridade)
   - Projeto não inicia corretamente
   - Estudar: `05_LIQUIBASE.md`
   - Corrigir changesets duplicados

2. **Docker Compose** (Média Prioridade)
   - Subir banco de dados com Docker
   - Estudar: `04_DOCKER_COMPOSE.md`
   - Simplificar desenvolvimento local

3. **Validações de API** (Média Prioridade)
   - Adicionar `@Valid` e Bean Validation
   - Melhorar tratamento de erros
   - Estudar: `06_API_REST.md`

---

### 📚 Opção 3: Fortalecer Fundamentos

Voltar aos **conceitos base** antes de avançar:

**Por quê?** Alguns conceitos fundamentais ainda não estão dominados (IoC, Generics).

**Estudar:**
1. **IoC e Injeção de Dependência** (Módulo 2)
   - Entender o Spring Container
   - Ciclo de vida dos Beans
   - Tipos de injeção

2. **Generics** (Módulo 1)
   - Entender `List<Product>`, `Optional<Product>`
   - Criar métodos genéricos
   - Type safety

3. **Lombok** (Módulo 1)
   - Outras anotações úteis
   - `@Data`, `@Builder`, `@Slf4j`

---

### 💡 Minha Recomendação Pessoal

**HOJE (1-2h):**
- ✅ Leia o `03_JPA_RELACIONAMENTOS.md` (seção sobre `@ManyToOne` e `@OneToMany`)
- ✅ Entenda como `Sale` e `SaleItem` se relacionam no seu projeto

**AMANHÃ (1-2h):**
- ✅ Corrija o erro do Liquibase (use `05_LIQUIBASE.md`)
- ✅ Faça o projeto inicializar sem erros

**ESTA SEMANA:**
- ✅ Complete a **SEMANA 2** do plano
- ✅ Implemente paginação em `ProductRepository`
- ✅ Crie queries que usem relacionamentos

**Razão:** Você tem momentum com JPA, aproveite para dominar relacionamentos antes de mudar de contexto!

---

## 🏆 METAS

### Curto Prazo (1 mês)
- [ ] Completar todos os módulos de estudo
- [ ] Refazer a prova e tirar > 70 pontos
- [ ] Corrigir o erro do Liquibase no projeto
- [ ] Projeto rodando com docker-compose

### Médio Prazo (3 meses)
- [ ] Implementar testes unitários
- [ ] Adicionar Spring Security
- [ ] Implementar cache (Redis)
- [ ] Deploy em cloud (AWS/GCP)

### Longo Prazo (6 meses)
- [ ] Refatorar para arquitetura hexagonal
- [ ] Implementar mensageria (RabbitMQ/Kafka)
- [ ] Adicionar busca com Elasticsearch
- [ ] CI/CD com GitHub Actions

---

## 📚 RECURSOS ADICIONAIS

### Documentação Oficial
- [Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [Docker](https://docs.docker.com/)
- [Liquibase](https://docs.liquibase.com/)

### Cursos Recomendados
- Nélio Alves - Java COMPLETO (Udemy)
- Nélio Alves - Spring Boot + JPA (Udemy)
- Docker para Desenvolvedores (Udemy)

### Sites para Prática
- [Baeldung](https://www.baeldung.com/) - Tutoriais Spring
- [HackerRank](https://www.hackerrank.com/) - Exercícios Java
- [Play with Docker](https://labs.play-with-docker.com/) - Praticar Docker online

---

## 📁 ESTRUTURA DOS ARQUIVOS DE ESTUDO

```
docs/
└── estudo/
    ├── 00_GUIA_ESTUDOS.md            ← Este arquivo (índice)
    │
    │   === FUNDAMENTOS ===
    ├── 01_FUNDAMENTOS_JAVA.md        ← Módulo 1: Generics, Wrappers, Lombok
    ├── 02_IOC_INJECAO_DEPENDENCIA.md ← Módulo 2: IoC, DI, Spring Container
    │
    │   === PERSISTÊNCIA ===
    ├── 03_JPA_RELACIONAMENTOS.md     ← Módulo 3: Entities, ManyToOne, Cascade
    ├── 05_LIQUIBASE.md               ← Módulo 5: Migrations (a criar)
    ├── 12_SQL_POSTGRESQL.md          ← Módulo 12: SQL avançado (a criar)
    │
    │   === INFRAESTRUTURA ===
    ├── 04_DOCKER_COMPOSE.md          ← Módulo 4: Docker, Compose, Volumes
    ├── 08_MAVEN.md                   ← Módulo 8: pom.xml, lifecycle (a criar)
    ├── 09_GIT_GITHUB.md              ← Módulo 9: Versionamento (a criar)
    │
    │   === API & WEB ===
    ├── 06_API_REST.md                ← Módulo 6: HTTP, REST (a criar)
    ├── 07_MONITORAMENTO.md           ← Módulo 7: Actuator, Prometheus (a criar)
    │
    │   === QUALIDADE ===
    ├── 10_TESTES.md                  ← Módulo 10: JUnit, Mockito (a criar)
    ├── 11_PADROES_PROJETO.md         ← Módulo 11: Design Patterns (a criar)
    ├── 13_SEGURANCA.md               ← Módulo 13: Spring Security (a criar)
    └── 14_CLEAN_CODE.md              ← Módulo 14: SOLID, boas práticas (a criar)
```

---

## 🆘 PRECISA DE AJUDA?

Solicite:
1. **"Crie o módulo X"** - Para criar um módulo que falta
2. **"Corrija o erro do Liquibase"** - Para resolver o problema de inicialização
3. **"Organize o projeto"** - Para refatorar e melhorar o código
4. **"Crie documentação para Confluence"** - Para documentação formal
5. **"Crie mais exercícios"** - Para praticar mais

---

**Bons estudos! 🚀**

