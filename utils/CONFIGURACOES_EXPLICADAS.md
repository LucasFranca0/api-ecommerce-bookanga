# 📚 Explicação Detalhada das Configurações

## 🔧 pom.xml

### Parent POM
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.0</version>
</parent>
```
**Por quê?** Centraliza o gerenciamento de versões de todas as dependências do Spring Boot, evitando conflitos e garantindo compatibilidade entre bibliotecas.

---

### Properties
```xml
<maven.compiler.source>17</maven.compiler.source>
<maven.compiler.target>17</maven.compiler.target>
<java.version>17</java.version>
```
**Por quê?** Define Java 17 como versão de compilação e runtime. Spring Boot 3.x requer no mínimo Java 17.

---

### Dependências

#### 1. `spring-boot-starter-web`
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```
**Por quê?** Inclui:
- Tomcat (servidor web embutido)
- Spring MVC (criar REST APIs)
- Jackson (JSON serialização/deserialização)
- Validação básica

#### 2. `spring-boot-starter-data-jpa`
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```
**Por quê?** Fornece:
- Hibernate (ORM - mapeamento objeto-relacional)
- Spring Data JPA (repositórios automáticos)
- Gerenciamento de transações
- Permite usar anotações @Entity, @Repository

#### 3. `spring-boot-starter-validation`
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```
**Por quê?** Habilita validações com anotações como:
- `@NotNull`, `@NotEmpty`, `@Size`
- `@Min`, `@Max`, `@Email`
- `@Valid` para validar objetos automaticamente

#### 4. `postgresql`
```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```
**Por quê?** 
- Driver JDBC para conectar ao PostgreSQL
- `scope>runtime` = só necessário em execução, não em compilação

#### 5. `lombok`
```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```
**Por quê?** Reduz código boilerplate com anotações:
- `@Data` = gera getters, setters, toString, equals, hashCode
- `@NoArgsConstructor`, `@AllArgsConstructor`
- `@Builder` para padrão builder
- `optional>true` = não propaga para projetos dependentes

#### 6. `liquibase-core`
```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-core</artifactId>
</dependency>
```
**Por quê?** Gerencia migrações de banco de dados:
- Controle de versão do schema
- Changesets rastreáveis
- Rollback de mudanças
- Sincronização entre ambientes (dev, prod)

#### 7. `spring-boot-starter-test`
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```
**Por quê?** Inclui frameworks de teste:
- JUnit 5 (testes unitários)
- Mockito (mocks)
- AssertJ (assertions fluentes)
- Spring Test (contexto de teste)

---

### Plugin
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <excludes>
            <exclude>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
            </exclude>
        </excludes>
    </configuration>
</plugin>
```
**Por quê?** 
- Cria JAR executável com `mvn package`
- Exclui Lombok do JAR final (só necessário em compilação)
- Empacota todas as dependências em um único arquivo

---

## ⚙️ application.properties

### Conexão PostgreSQL
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/bookanga_db
spring.datasource.username=bookanga
spring.datasource.password=bookanga123
spring.datasource.driver-class-name=org.postgresql.Driver
```
**Por quê?**
- `url`: Localização do banco (host:porta/database)
- `username/password`: Credenciais de acesso
- `driver-class-name`: Driver JDBC específico do PostgreSQL

---

### Configurações do Hibernate (JPA)

#### 1. `spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect`
**Por quê?** Informa ao Hibernate qual SQL dialeto usar. PostgreSQL tem sintaxe específica (tipos de dados, funções) diferente de MySQL, Oracle, etc.

#### 2. `spring.jpa.hibernate.ddl-auto=none`
**Por quê?** Desabilita criação/atualização automática de tabelas pelo Hibernate. **IMPORTANTE**: Com Liquibase, ele gerencia o schema - evita conflitos.

Valores possíveis:
- `none` = nada (recomendado com Liquibase)
- `validate` = valida schema mas não altera
- `update` = atualiza schema (perigoso em produção)
- `create` = recria schema toda vez
- `create-drop` = cria e destroi ao fechar

#### 3. `spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true`
**Por quê?** Fix para PostgreSQL com tipos BLOB/CLOB. Sem isso, pode dar erro ao mapear campos grandes.

#### 4. `spring.jpa.show-sql=true`
**Por quê?** Mostra os SQLs executados no console. Útil para debug. **Dica**: desabilitar em produção por performance.

#### 5. `spring.jpa.properties.hibernate.format_sql=true`
**Por quê?** Formata os SQLs de forma legível (quebras de linha, indentação). Facilita leitura nos logs.

#### 6. `spring.jpa.open-in-view=false`
**Por quê?** 
- Desabilita padrão anti-pattern "Open Session in View"
- Evita lazy loading na camada de apresentação
- Melhora performance e previne bugs
- Força boas práticas (buscar dados na camada de serviço)

---

### Liquibase

#### 1. `spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.yaml`
**Por quê?** Aponta para o arquivo mestre que orquestra todas as migrações. Liquibase lê este arquivo e aplica changesets na ordem.

#### 2. `spring.liquibase.enabled=true`
**Por quê?** Ativa o Liquibase na inicialização. Se `false`, migrações não são executadas.

---

### Inicialização SQL

#### `spring.sql.init.mode=never`
**Por quê?** Desabilita execução de `data.sql` e `schema.sql`. Como usamos Liquibase, esses scripts antigos causariam conflito e duplicação.

---

### Validação

#### `spring.mvc.throw-exception-if-no-handler-found=true`
**Por quê?** Quando uma rota não existe (404), lança exceção que pode ser capturada por `@ControllerAdvice` para retornar JSON customizado em vez de página HTML padrão.

---

### Logs (comentados)
```properties
#logging.level.com.products.controller=DEBUG
#logging.level.org.springframework=DEBUG
```
**Por quê?** Úteis para debug. Descomente quando precisar investigar problemas:
- Primeira linha: logs dos seus controllers
- Segunda linha: logs internos do Spring (muito verboso)

---

## 🎯 Resumo da Arquitetura

```
┌─────────────────────────────────────────────┐
│  Banner Star Wars + Spring Boot Startup     │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  Spring Boot App (Tomcat na porta 8080)     │
├─────────────────────────────────────────────┤
│  Controllers (REST API - JSON)              │
│         @RestController + @Valid            │
├─────────────────────────────────────────────┤
│  Services (Lógica de Negócio)               │
├─────────────────────────────────────────────┤
│  Repositories (Spring Data JPA)             │
│         @Repository + queries automáticas   │
├─────────────────────────────────────────────┤
│  Hibernate (ORM)                            │
│         Converte Objetos ↔ SQL              │
├─────────────────────────────────────────────┤
│  Liquibase (Migrations)                     │
│         Cria/Atualiza tabelas               │
├─────────────────────────────────────────────┤
│  PostgreSQL Driver                          │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  PostgreSQL Database (porta 5432)           │
│  Database: bookanga_db                      │
└─────────────────────────────────────────────┘
```

---

## 🚀 Fluxo de Inicialização

1. **Spring Boot** lê `application.properties`
2. **HikariCP** cria pool de conexões com PostgreSQL
3. **Liquibase** verifica migrações e atualiza schema se necessário
4. **Hibernate** mapeia entidades (`@Entity`) para tabelas
5. **Spring Data JPA** cria implementações dos repositories
6. **Tomcat** inicia servidor na porta 8080
7. **Controllers** ficam prontos para receber requisições HTTP

---

## ⚡ Dicas de Performance

- `spring.jpa.open-in-view=false` ✅ (já configurado)
- `spring.jpa.show-sql=false` em produção
- Usar índices no banco para queries frequentes
- Cache com `@Cacheable` se necessário
- Connection pool configurado (HikariCP padrão é ótimo)

---

## 🔒 Segurança

⚠️ **Atenção**: Credenciais em texto puro em `application.properties` é **perigoso**!

**Melhorias recomendadas:**
- Usar variáveis de ambiente: `${DB_PASSWORD}`
- Spring Cloud Config para configurações centralizadas
- Vault para secrets em produção
- Profiles diferentes (dev, staging, prod)

Exemplo:
```properties
spring.datasource.password=${DB_PASSWORD:bookanga123}
```
(usa variável de ambiente ou fallback para dev)
