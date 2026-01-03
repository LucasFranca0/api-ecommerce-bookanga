# 🔧 CORREÇÕES URGENTES - Guia Prático

Este documento contém as correções que você **DEVE FAZER IMEDIATAMENTE** para o projeto funcionar corretamente.

---

## ⚠️ PROBLEMA CRÍTICO 1: POM.XML Incorreto

### **O Problema**
Seu `pom.xml` atual tem dependências conflitantes e falta o parent do Spring Boot.

### **A Solução Completa**

Substitua TODO o conteúdo do `pom.xml` por:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- ✅ PARENT do Spring Boot (ESSENCIAL!) -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.0</version>
        <relativePath/>
    </parent>

    <groupId>com.ecommerce</groupId>
    <artifactId>api-ecommerce</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    <name>ecommerce-book-manga</name>
    <description>E-commerce API para livros e mangás</description>

    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- ✅ Spring Boot Web (SEM versão - herda do parent) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- ✅ Spring Boot Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- ✅ Spring Boot Validation (Jakarta, não Javax!) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>

        <!-- ✅ MySQL Connector NOVO (não deprecado) -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>

        <!-- ✅ Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- ✅ H2 Database (para testes) -->
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <scope>test</scope>
        </dependency>

        <!-- ✅ Spring Boot Test (JUnit 5 incluído) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- ✅ Plugin do Spring Boot para criar JAR executável -->
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

</project>
```

### **O Que Foi Corrigido?**
1. ✅ Adicionado `<parent>` do Spring Boot
2. ✅ Removidas todas as versões manuais de dependências
3. ✅ Atualizado MySQL connector (novo pacote)
4. ✅ JUnit 3.8.1 removido → JUnit 5 (via spring-boot-starter-test)
5. ✅ Validação corrigida (não mais conflito javax/jakarta)
6. ✅ Adicionado H2 para testes
7. ✅ Adicionado plugin do Spring Boot

### **Como Aplicar:**
```bash
# No terminal, dentro do projeto
mvn clean install
```

---

## ⚠️ PROBLEMA CRÍTICO 2: Imports javax.* ao invés de jakarta.*

### **O Problema**
Spring Boot 3.x usa **Jakarta EE** (pacote `jakarta.*`), não mais **Java EE** (pacote `javax.*`).

### **Arquivos que Precisam Ser Corrigidos**

#### **1. Product.java**
```java
// ❌ ERRADO
import javax.validation.constraints.*;

// ✅ CORRETO
import jakarta.validation.constraints.*;
```

#### **2. ProductDTO.java**
```java
// ❌ ERRADO
import javax.validation.constraints.*;

// ✅ CORRETO
import jakarta.validation.constraints.*;
```

#### **3. User.java**
```java
// ❌ ERRADO
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

// ✅ CORRETO
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
```

#### **4. SaleItem.java**
```java
// ❌ ERRADO
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

// ✅ CORRETO
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
```

#### **5. SaleDTO.java**
```java
// ❌ ERRADO
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

// ✅ CORRETO
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
```

#### **6. ProductController.java**
```java
// ❌ ERRADO
import javax.validation.Valid;

// ✅ CORRETO
import jakarta.validation.Valid;
```

#### **7. SaleController.java**
```java
// ❌ ERRADO
import javax.validation.Valid;

// ✅ CORRETO
import jakarta.validation.Valid;
```

### **Como Fazer em Massa no IntelliJ:**
1. Pressione `Ctrl + Shift + R` (Replace in Files)
2. Find: `import javax.validation`
3. Replace: `import jakarta.validation`
4. Clique em "Replace All"

---

## ⚠️ PROBLEMA 3: application.properties Inseguro

### **O Problema**
```properties
# ❌ PERIGO: create-drop deleta tudo ao reiniciar!
spring.jpa.hibernate.ddl-auto=create-drop
spring.datasource.password=
```

### **A Solução**

Atualize `src/main/resources/application.properties`:

```properties
# ============================================
# CONFIGURAÇÕES DO BANCO DE DADOS
# ============================================
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=sua_senha_aqui
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# ============================================
# CONFIGURAÇÕES DO JPA/HIBERNATE
# ============================================
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect

# ✅ DESENVOLVIMENTO: update (mantém dados)
# ✅ PRODUÇÃO: validate (não altera schema)
spring.jpa.hibernate.ddl-auto=update

# Mostrar SQLs no console (útil para debug)
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

# ============================================
# CONFIGURAÇÕES DE VALIDAÇÃO
# ============================================
spring.mvc.throw-exception-if-no-handler-found=true
spring.web.resources.add-mappings=false

# ============================================
# CONFIGURAÇÕES DE LOGGING
# ============================================
logging.level.com.products=DEBUG
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE

# ============================================
# CONFIGURAÇÕES DO SERVIDOR
# ============================================
server.port=8080
server.error.include-message=always
server.error.include-binding-errors=always
```

### **O Que Foi Corrigido?**
1. ✅ `create-drop` → `update` (não deleta dados)
2. ✅ Adicionado senha (NUNCA deixe vazio em produção)
3. ✅ Logs configurados para debug
4. ✅ Mensagens de erro detalhadas

---

## ⚠️ PROBLEMA 4: SaleServiceImpl Vazio

### **O Problema**
```java
@Override
public Sale createSale(SaleDTO saleDTO) {
    return null; // ❌ Não implementado!
}
```

### **A Solução**

Primeiro, crie os repositories faltantes:

#### **1. SaleRepository.java**
```java
package com.products.repository;

import com.products.model.Sale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SaleRepository extends JpaRepository<Sale, Long> {
}
```

#### **2. UserRepository.java**
```java
package com.products.repository;

import com.products.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}
```

#### **3. SaleItemRepository.java**
```java
package com.products.repository;

import com.products.model.SaleItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SaleItemRepository extends JpaRepository<SaleItem, Long> {
}
```

Agora, implemente o SaleService:

#### **4. Atualizar SaleDTO.java**
```java
package com.products.dto;

import lombok.Data;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Data
public class SaleDTO {

    @NotNull(message = "O ID do usuário é obrigatório")
    private Long userId;

    @NotNull(message = "Os itens são obrigatórios")
    private List<SaleItemDTO> items;

    @Data
    public static class SaleItemDTO {
        @NotNull(message = "O ID do produto é obrigatório")
        private Long productId;

        @NotNull(message = "A quantidade é obrigatória")
        @Min(value = 1, message = "A quantidade deve ser maior que zero")
        private Integer quantity;
    }
}
```

#### **5. Implementar SaleServiceImpl.java**
```java
package com.products.service;

import com.products.dto.SaleDTO;
import com.products.exception.ProductNotFoundException;
import com.products.model.Product;
import com.products.model.Sale;
import com.products.model.SaleItem;
import com.products.model.User;
import com.products.repository.ProductRepository;
import com.products.repository.SaleRepository;
import com.products.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class SaleServiceImpl implements SaleService {

    private final SaleRepository saleRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    @Autowired
    public SaleServiceImpl(
            SaleRepository saleRepository,
            UserRepository userRepository,
            ProductRepository productRepository
    ) {
        this.saleRepository = saleRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
    }

    @Override
    @Transactional
    public Sale createSale(SaleDTO saleDTO) {
        // 1. Buscar usuário
        User user = userRepository.findById(saleDTO.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // 2. Criar venda
        Sale sale = new Sale();
        sale.setUser(user);
        sale.setDate(LocalDateTime.now());

        // 3. Criar itens da venda
        List<SaleItem> saleItems = new ArrayList<>();
        BigDecimal totalPrice = BigDecimal.ZERO;

        for (SaleDTO.SaleItemDTO itemDTO : saleDTO.getItems()) {
            // Buscar produto
            Product product = productRepository.findById(itemDTO.getProductId())
                    .orElseThrow(() -> new ProductNotFoundException(
                            "Produto não encontrado: " + itemDTO.getProductId()
                    ));

            // Criar item
            SaleItem saleItem = new SaleItem();
            saleItem.setProduct(product);
            saleItem.setQuantity(itemDTO.getQuantity());
            saleItem.setSale(sale);

            saleItems.add(saleItem);

            // Calcular total
            BigDecimal itemTotal = product.getPrice()
                    .multiply(new BigDecimal(itemDTO.getQuantity()));
            totalPrice = totalPrice.add(itemTotal);
        }

        sale.setItems(saleItems);
        sale.setTotalPrice(totalPrice);

        // 4. Salvar venda (cascade salva os itens também)
        return saleRepository.save(sale);
    }
}
```

### **O Que Foi Implementado?**
1. ✅ Busca o usuário
2. ✅ Cria a venda
3. ✅ Cria os itens da venda
4. ✅ Calcula o total
5. ✅ Salva no banco
6. ✅ Usa `@Transactional` (tudo ou nada)

---

## ⚠️ PROBLEMA 5: Validação Duplicada no Service

### **O Problema**
```java
// ❌ DESNECESSÁRIO - Bean Validation já valida!
if (productDTO.getTitle().trim().isEmpty() || productDTO.getAuthor().trim().isEmpty()) {
    throw new InvalidProductDataException("Título e autor do livro/mangá são obrigatórios.");
}
```

### **A Solução**

Remova as validações manuais do `ProductService.java`:

```java
package com.products.service;

import com.products.dto.ProductDTO;
import com.products.exception.ProductNotFoundException;
import com.products.model.Book;
import com.products.model.Manga;
import com.products.model.Product;
import com.products.repository.ProductRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ProductService {
    
    private final ProductRepository productRepository;

    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Transactional(readOnly = true)
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(
                        "Livro/Mangá não encontrado com o ID: " + id
                ));
    }

    public Product createProduct(ProductDTO productDTO) {
        // ✅ REMOVIDO validações manuais (Bean Validation já faz)
        
        Product product;
        
        // Determinar tipo por volume
        if (productDTO.getVolume() == null) {
            product = new Book();
        } else {
            product = new Manga();
        }
        
        BeanUtils.copyProperties(productDTO, product);
        return productRepository.save(product);
    }

    public Product updateProduct(Long id, ProductDTO productDTO) {
        // Verificar se existe
        Product product = getProductById(id);

        // ✅ REMOVIDO validações manuais
        
        // Atualizar campos
        BeanUtils.copyProperties(productDTO, product, "id");
        return productRepository.save(product);
    }

    public void deleteProduct(Long id) {
        // Verificar se existe antes de excluir
        getProductById(id);
        productRepository.deleteById(id);
    }

    public void deleteAllProducts() {
        productRepository.deleteAll();
    }
}
```

### **O Que Foi Corrigido?**
1. ✅ Removidas validações duplicadas (Bean Validation já faz)
2. ✅ Adicionado `@Transactional`
3. ✅ Adicionado `readOnly = true` em consultas
4. ✅ Ignorar `id` no BeanUtils do update

---

## 🚀 CHECKLIST DE CORREÇÕES

Marque conforme for corrigindo:

- [ ] **1. Substituir pom.xml completo**
- [ ] **2. Executar `mvn clean install`**
- [ ] **3. Trocar todos `javax.validation` por `jakarta.validation`**
- [ ] **4. Atualizar application.properties**
- [ ] **5. Criar SaleRepository**
- [ ] **6. Criar UserRepository**
- [ ] **7. Criar SaleItemRepository**
- [ ] **8. Atualizar SaleDTO**
- [ ] **9. Implementar SaleServiceImpl**
- [ ] **10. Remover validações duplicadas do ProductService**
- [ ] **11. Testar a aplicação**

---

## 🧪 TESTANDO AS CORREÇÕES

### **1. Compilar o projeto**
```bash
mvn clean install
```

**Esperado:** BUILD SUCCESS (sem erros)

### **2. Executar a aplicação**
```bash
mvn spring-boot:run
```

**Esperado:** Aplicação sobe sem erros

### **3. Testar endpoint**
```bash
curl http://localhost:8080/api/products
```

**Esperado:** Retorna `[]` ou lista de produtos

### **4. Criar um produto**
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Book",
    "author": "Test Author",
    "publication_year": 2023,
    "price": 29.90,
    "isbn": "1234567890",
    "genre": "Test",
    "language": "Portuguese",
    "product_type": "book"
  }'
```

**Esperado:** Status 201 Created + JSON do produto criado

---

## 📞 PROBLEMAS COMUNS

### **Erro: "package javax.validation does not exist"**
**Causa:** Não trocou `javax` por `jakarta`  
**Solução:** Veja seção "PROBLEMA 2"

### **Erro: "No qualifying bean of type 'ProductRepository'"**
**Causa:** Falta `@Repository` ou `@EnableJpaRepositories`  
**Solução:** Verificar se `@SpringBootApplication` está no pacote raiz `com.products`

### **Erro: "Table 'ecommerce.product' doesn't exist"**
**Causa:** Banco não criado ou ddl-auto incorreto  
**Solução:** Criar database manualmente: `CREATE DATABASE ecommerce;`

### **Erro ao compilar Lombok**
**Causa:** IntelliJ não reconhece Lombok  
**Solução:** 
1. File → Settings → Plugins
2. Instalar "Lombok"
3. File → Settings → Build → Compiler → Annotation Processors
4. Marcar "Enable annotation processing"

---

## ✅ PRÓXIMOS PASSOS (DEPOIS DAS CORREÇÕES)

Após corrigir tudo acima:

1. **Escrever testes** (veja GUIA_DE_APRENDIZADO.md)
2. **Adicionar paginação**
3. **Implementar Spring Security**
4. **Documentar com Swagger**

---

**Boa sorte com as correções! 🚀**

Qualquer dúvida, consulte:
- `AVALIACAO_COMPLETA.md` - Análise detalhada
- `GUIA_DE_APRENDIZADO.md` - Plano de estudos
- `README_EDUCATIVO.md` - Explicações conceituais
