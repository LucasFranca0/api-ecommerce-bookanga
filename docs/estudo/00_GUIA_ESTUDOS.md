# 📚 GUIA DE ESTUDOS - Projeto Bookanga

> **Criado para:** Lucas  
> **Baseado na:** Prova de Avaliação (Nota: 30/60 = 50%)  
> **Nível atual:** 🟠 Básico  
> **Objetivo:** Chegar ao nível 🟢 Avançado

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

| Dia | Atividade | Tempo |
|-----|-----------|-------|
| Seg | Ler Módulo 1: Generics | 1.5h |
| Ter | Ler Módulo 1: Wrappers + Lombok | 1.5h |
| Qua | Ler Módulo 2: IoC (parte 1) | 1.5h |
| Qui | Ler Módulo 2: DI e tipos de injeção | 1.5h |
| Sex | Exercícios práticos no projeto | 2h |
| Sáb | Revisar e anotar dúvidas | 1h |

**Entregas da Semana 1:**
- [ ] Refatorar `ProductController` para injeção por construtor
- [ ] Usar `@RequiredArgsConstructor` no `ProductService`
- [ ] Adicionar 3 Query Methods no `ProductRepository`

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
- [x] @Service, @Repository, @Controller (parcial)
- [ ] @ControllerAdvice (parcial)
- [ ] Bean Validation

#### JPA/Hibernate
- [x] Entities básicas
- [ ] Relacionamentos ← Estudar!
- [ ] Cascade Types ← Estudar!
- [ ] Fetch Types ← Estudar!
- [ ] Query Methods

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

