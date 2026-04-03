# 📚 Módulo 8: Maven - Gerenciamento de Dependências e Build

> **Tempo estimado:** 2-3 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Fundamental para qualquer projeto Java)

---

## 🎯 O que você vai aprender:

1. ✅ O que é Maven e por que usar
2. ✅ Estrutura do pom.xml
3. ✅ Ciclo de vida do Maven (lifecycle)
4. ✅ Gerenciamento de dependências
5. ✅ Plugins e configurações
6. ✅ Comandos Maven essenciais

---

## 📌 1. O QUE É MAVEN?

### 💡 Explicação Simples:

**Maven** é uma ferramenta de automação de build e gerenciamento de dependências para projetos Java.

### 🤔 O Problema que Maven Resolve:

```
Sem Maven:
1. Baixar JARs manualmente de vários sites ❌
2. Colocar na pasta lib/ do projeto ❌
3. Configurar classpath manualmente ❌
4. Gerenciar versões e conflitos manualmente ❌
5. Compilar com comandos complexos ❌

Com Maven:
1. Declara dependências no pom.xml ✅
2. Maven baixa automaticamente ✅
3. Classpath configurado automaticamente ✅
4. Resolve conflitos de versão ✅
5. Compila com um comando: mvn package ✅
```

---

## 📌 2. ESTRUTURA DO pom.xml DO BOOKANGA

### 🔍 Analisando cada seção:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
```

| Elemento | Significado |
|----------|-------------|
| `project` | Elemento raiz |
| `xmlns` | Namespace XML do Maven |
| `modelVersion` | Versão do modelo POM (sempre 4.0.0) |

---

### 📦 2.1 Parent POM (Herança)

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.0</version>
    <relativePath/>
</parent>
```

| Elemento | Significado |
|----------|-------------|
| `parent` | Herda configurações de outro POM |
| `spring-boot-starter-parent` | POM pai do Spring Boot |
| `version` | Versão do Spring Boot |

**🧠 O que o Parent fornece?**
- Versões de dependências pré-configuradas
- Configuração de plugins
- Encoding UTF-8
- Versão do Java
- Gerenciamento de dependências

---

### 🏷️ 2.2 Coordenadas do Projeto (GAV)

```xml
<groupId>com.ecommerce</groupId>
<artifactId>api-ecommerce</artifactId>
<packaging>jar</packaging>
<version>1.0-SNAPSHOT</version>
<name>ecommerce-book-manga</name>
<url>http://maven.apache.org</url>
```

| Elemento | Significado | Exemplo |
|----------|-------------|---------|
| `groupId` | Identificador da organização | `com.ecommerce` |
| `artifactId` | Nome do projeto | `api-ecommerce` |
| `version` | Versão do projeto | `1.0-SNAPSHOT` |
| `packaging` | Tipo de empacotamento | `jar`, `war`, `pom` |
| `name` | Nome legível | `ecommerce-book-manga` |

**🧠 O que é SNAPSHOT?**
```
1.0-SNAPSHOT = Versão em desenvolvimento (pode mudar)
1.0          = Versão estável (release)
1.0.1        = Correção de bugs
1.1.0        = Nova funcionalidade
2.0.0        = Mudança grande (breaking change)
```

---

### ⚙️ 2.3 Properties (Configurações)

```xml
<properties>
    <maven.compiler.source>21</maven.compiler.source>
    <maven.compiler.target>21</maven.compiler.target>
    <java.version>21</java.version>
</properties>
```

| Property | Significado |
|----------|-------------|
| `maven.compiler.source` | Versão do Java para compilar |
| `maven.compiler.target` | Versão do Java de destino |
| `java.version` | Usado pelo Spring Boot |

**💡 Você pode criar suas próprias properties:**
```xml
<properties>
    <java.version>21</java.version>
    <lombok.version>1.18.30</lombok.version>
    <postgresql.version>42.6.0</postgresql.version>
</properties>

<!-- Usar no dependency -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>${lombok.version}</version>  <!-- Usa a property -->
</dependency>
```

---

### 📚 2.4 Dependencies (Dependências)

```xml
<dependencies>
    <!-- Spring Boot Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- Spring Boot Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- PostgreSQL Driver -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.30</version>
        <optional>true</optional>
    </dependency>
    
    <!-- Testes -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

---

### 📊 2.5 Scopes de Dependência

| Scope | Quando disponível | Exemplo |
|-------|-------------------|---------|
| `compile` (padrão) | Compilação, testes, runtime | spring-boot-starter-web |
| `runtime` | Somente em runtime | postgresql (driver) |
| `test` | Somente em testes | spring-boot-starter-test |
| `provided` | Compilação, mas não empacotado | servlet-api (container fornece) |
| `optional` | Não é transitivo | lombok |

```xml
<!-- compile (padrão) - sempre disponível -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <!-- scope omitido = compile -->
</dependency>

<!-- runtime - só em execução -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>

<!-- test - só em testes -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

---

### 🔌 2.6 Plugins

```xml
<build>
    <plugins>
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
    </plugins>
</build>
```

| Plugin | Função |
|--------|--------|
| `spring-boot-maven-plugin` | Cria JAR executável |
| `maven-compiler-plugin` | Compila o código |
| `maven-surefire-plugin` | Executa testes |
| `maven-jar-plugin` | Cria o JAR |

**🧠 Por que excluir Lombok?**
Lombok só é necessário em tempo de compilação. Não precisa ir no JAR final.

---

## 📌 3. CICLO DE VIDA DO MAVEN (Lifecycle)

### 🔄 As 3 fases principais:

```
┌─────────────────────────────────────────────────────────────────┐
│                     MAVEN LIFECYCLE                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. CLEAN          2. DEFAULT              3. SITE              │
│  (limpar)          (build)                 (documentação)       │
│                                                                 │
│  ┌─────────┐      ┌─────────────┐         ┌────────────┐       │
│  │ clean   │      │ validate    │         │ site       │       │
│  └─────────┘      │ compile     │         │ site-deploy│       │
│                   │ test        │         └────────────┘       │
│                   │ package     │                               │
│                   │ verify      │                               │
│                   │ install     │                               │
│                   │ deploy      │                               │
│                   └─────────────┘                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 📊 Fases do Default Lifecycle:

| Fase | O que faz | Comando |
|------|-----------|---------|
| `validate` | Valida projeto | `mvn validate` |
| `compile` | Compila código fonte | `mvn compile` |
| `test` | Executa testes unitários | `mvn test` |
| `package` | Cria JAR/WAR | `mvn package` |
| `verify` | Verifica qualidade | `mvn verify` |
| `install` | Instala no repo local | `mvn install` |
| `deploy` | Deploy em repo remoto | `mvn deploy` |

**🧠 Fases são cumulativas!**
```bash
mvn package  # Executa: validate → compile → test → package
mvn install  # Executa: validate → compile → test → package → verify → install
```

---

## 📌 4. COMANDOS MAVEN ESSENCIAIS

### 🛠️ Comandos do dia a dia:

```bash
# Compilar o projeto
mvn compile

# Executar testes
mvn test

# Criar o JAR (sem testes)
mvn package -DskipTests

# Limpar e criar JAR
mvn clean package

# Instalar no repositório local
mvn install

# Baixar dependências
mvn dependency:resolve

# Ver árvore de dependências
mvn dependency:tree

# Atualizar dependências
mvn versions:display-dependency-updates

# Executar aplicação Spring Boot
mvn spring-boot:run

# Gerar relatório de testes
mvn surefire-report:report
```

### 📂 Onde ficam as coisas?

```
projeto/
├── src/
│   ├── main/
│   │   ├── java/          ← Código fonte
│   │   └── resources/     ← Configurações
│   └── test/
│       ├── java/          ← Testes
│       └── resources/     ← Configs de teste
├── target/                 ← Arquivos gerados
│   ├── classes/           ← .class compilados
│   ├── test-classes/      ← Testes compilados
│   └── *.jar              ← JAR final
├── pom.xml                ← Configuração Maven
└── .mvn/                  ← Maven Wrapper
```

---

## 📌 5. DEPENDÊNCIAS TRANSITIVAS

### 💡 O que são?

Quando você adiciona uma dependência, ela pode trazer outras dependências.

```xml
<!-- Você adiciona isso: -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- Maven traz automaticamente: -->
<!-- spring-boot-starter -->
<!--   spring-boot -->
<!--   spring-boot-autoconfigure -->
<!--   spring-core -->
<!--   spring-web -->
<!--   spring-webmvc -->
<!--   tomcat-embed-core -->
<!--   jackson-databind -->
<!--   ... muitas outras! -->
```

### 🔍 Ver dependências transitivas:

```bash
mvn dependency:tree
```

Resultado:
```
[INFO] com.ecommerce:api-ecommerce:jar:1.0-SNAPSHOT
[INFO] +- org.springframework.boot:spring-boot-starter-web:jar:3.1.0
[INFO] |  +- org.springframework.boot:spring-boot-starter:jar:3.1.0
[INFO] |  |  +- org.springframework.boot:spring-boot:jar:3.1.0
[INFO] |  |  +- org.springframework:spring-core:jar:6.0.9
[INFO] |  +- org.springframework:spring-webmvc:jar:6.0.9
[INFO] |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.8
```

---

## 📌 6. CONFLITOS DE VERSÃO

### 🤔 O Problema:

```
Lib A → precisa de jackson 2.14
Lib B → precisa de jackson 2.15
Qual versão usar? 🤷
```

### ✅ Regras do Maven:

1. **Dependência mais próxima vence** (menor profundidade na árvore)
2. **Primeira declarada vence** (se mesma profundidade)
3. **Você pode forçar versão** com `<dependencyManagement>` ou exclusão

### 🔧 Excluindo dependências transitivas:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.apache.tomcat.embed</groupId>
            <artifactId>tomcat-embed-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

---

## 📌 7. MAVEN WRAPPER (mvnw)

### 💡 O que é?

Script que baixa e usa versão específica do Maven, garantindo consistência.

```bash
# Ao invés de:
mvn clean package

# Use:
./mvnw clean package  # Linux/Mac
mvnw.cmd clean package  # Windows
```

### ✅ Vantagens:

1. Não precisa instalar Maven
2. Todos usam mesma versão
3. CI/CD funciona sem Maven instalado

### 🔧 Gerar Maven Wrapper:

```bash
mvn wrapper:wrapper
```

---

## 📌 8. REPOSITÓRIOS

### 📦 Tipos de repositórios:

| Tipo | Localização | Uso |
|------|-------------|-----|
| **Local** | `~/.m2/repository` | Cache das dependências |
| **Central** | repo.maven.apache.org | Repositório público |
| **Remoto** | Nexus, Artifactory | Repositório corporativo |

### 🔧 Configurar repositório adicional:

```xml
<repositories>
    <repository>
        <id>spring-milestones</id>
        <name>Spring Milestones</name>
        <url>https://repo.spring.io/milestone</url>
    </repository>
</repositories>
```

---

## 📌 9. PROFILES

### 💡 Para diferentes ambientes:

```xml
<profiles>
    <!-- Perfil de desenvolvimento -->
    <profile>
        <id>dev</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <spring.profiles.active>dev</spring.profiles.active>
        </properties>
    </profile>
    
    <!-- Perfil de produção -->
    <profile>
        <id>prod</id>
        <properties>
            <spring.profiles.active>prod</spring.profiles.active>
        </properties>
    </profile>
</profiles>
```

```bash
# Ativar perfil:
mvn package -Pprod
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Analise o pom.xml

Abra o `pom.xml` do Bookanga e identifique:
1. Qual versão do Spring Boot está sendo usada?
2. Quantas dependências diretas existem?
3. Quais dependências têm scope `test`?

### Exercício 2: Comandos Maven

Execute e analise:
```bash
# Ver árvore de dependências
mvn dependency:tree

# Ver dependências que podem ser atualizadas
mvn versions:display-dependency-updates
```

### Exercício 3: Adicione uma dependência

Adicione a dependência do Swagger/OpenAPI ao projeto:
```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.2.0</version>
</dependency>
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **pom.xml** | Arquivo de configuração do Maven |
| **GAV** | GroupId, ArtifactId, Version (identificador único) |
| **Dependency** | Biblioteca que o projeto usa |
| **Scope** | Quando a dependência está disponível |
| **Plugin** | Ferramenta que estende o Maven |
| **Lifecycle** | Fases do build (validate→deploy) |
| **Transitiva** | Dependência de dependência |
| **Repository** | Local onde Maven busca JARs |
| **Wrapper** | Script para usar Maven sem instalar |
| **Profile** | Configurações para diferentes ambientes |

---

## ⏭️ Próximo Módulo

**Módulo 9: Git & GitHub**
- Versionamento de código
- Branches, commits, merges
- Pull Requests e colaboração

---

**🎉 Parabéns por completar o Módulo 8!**

