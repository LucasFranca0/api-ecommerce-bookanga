# 📚 Módulo 14: Clean Code e SOLID

> **Tempo estimado:** 3-4 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Fundamental para código de qualidade)

---

## 🎯 O que você vai aprender:

1. ✅ Princípios de Clean Code
2. ✅ Nomes significativos
3. ✅ Funções limpas
4. ✅ SOLID - Os 5 princípios
5. ✅ Code Smells (cheiros de código ruim)
6. ✅ Refatoração

---

## 📌 1. O QUE É CLEAN CODE?

### 💡 Definição:

**Clean Code** é código que é fácil de ler, entender e modificar.

### 📊 Código Limpo vs Código Sujo:

```java
// ❌ CÓDIGO SUJO
public class U {
    private List<O> ol;
    
    public double c(int i) {
        O o = ol.get(i);
        double t = 0;
        for (P p : o.getP()) {
            t += p.getV() * p.getQ();
        }
        return t;
    }
}

// ✅ CÓDIGO LIMPO
public class OrderService {
    private List<Order> orders;
    
    public double calculateOrderTotal(int orderId) {
        Order order = orders.get(orderId);
        double total = 0;
        for (Product product : order.getProducts()) {
            total += product.getPrice() * product.getQuantity();
        }
        return total;
    }
}
```

### 🧠 Por que importa?

> "Qualquer tolo pode escrever código que um computador entende. 
> Bons programadores escrevem código que humanos entendem."
> — Martin Fowler

| Código Sujo | Código Limpo |
|-------------|--------------|
| Difícil de entender | Auto-explicativo |
| Difícil de modificar | Fácil de evoluir |
| Bugs frequentes | Menos bugs |
| Frustração | Produtividade |

---

## 📌 2. NOMES SIGNIFICATIVOS

### ✅ Regras de ouro:

#### 1. Use nomes que revelem intenção

```java
// ❌ RUIM
int d; // dias decorridos
List<int[]> list1;

// ✅ BOM
int elapsedDays;
List<Customer> activeCustomers;
```

#### 2. Evite desinformação

```java
// ❌ RUIM - não é uma List
List<Product> productList; // E se mudar para Set?

// ✅ BOM
List<Product> products;
Set<Product> uniqueProducts;
```

#### 3. Faça distinções significativas

```java
// ❌ RUIM
getActiveAccount();
getActiveAccountInfo();
getActiveAccountData();
// Qual a diferença?

// ✅ BOM
getAccount();
getAccountBalance();
getAccountTransactions();
```

#### 4. Use nomes pronunciáveis

```java
// ❌ RUIM
Date genymdhms; // generation year month day hour minute second
int pszqint;

// ✅ BOM
Date generationTimestamp;
int productQuantity;
```

#### 5. Use nomes buscáveis

```java
// ❌ RUIM
for (int i = 0; i < 7; i++) { } // O que é 7?

// ✅ BOM
private static final int DAYS_IN_WEEK = 7;
for (int day = 0; day < DAYS_IN_WEEK; day++) { }
```

### 📊 Convenções Java:

| Elemento | Convenção | Exemplo |
|----------|-----------|---------|
| Classes | PascalCase | `ProductService` |
| Métodos | camelCase | `calculateTotal()` |
| Variáveis | camelCase | `totalPrice` |
| Constantes | UPPER_SNAKE | `MAX_RETRY_COUNT` |
| Pacotes | lowercase | `com.products.service` |

---

## 📌 3. FUNÇÕES LIMPAS

### ✅ Regras para funções:

#### 1. Pequenas (máximo 20 linhas)

```java
// ❌ RUIM - função gigante
public void processOrder(Order order) {
    // 200 linhas de código fazendo tudo...
}

// ✅ BOM - funções pequenas e focadas
public void processOrder(Order order) {
    validateOrder(order);
    calculateTotal(order);
    applyDiscounts(order);
    processPayment(order);
    sendConfirmation(order);
}
```

#### 2. Faça uma coisa só

```java
// ❌ RUIM - faz várias coisas
public void saveAndNotifyAndLog(Product product) {
    repository.save(product);
    emailService.notify(product);
    logger.info("Product saved");
}

// ✅ BOM - cada função faz uma coisa
public void saveProduct(Product product) {
    repository.save(product);
}

public void notifyProductCreated(Product product) {
    emailService.notify(product);
}
```

#### 3. Poucos parâmetros (máximo 3)

```java
// ❌ RUIM - muitos parâmetros
public Product createProduct(String title, String author, BigDecimal price, 
                            String isbn, String genre, String language, 
                            Integer volume, String type) {
    // ...
}

// ✅ BOM - use objeto
public Product createProduct(ProductDTO dto) {
    // ...
}
```

#### 4. Evite efeitos colaterais

```java
// ❌ RUIM - efeito colateral escondido
public boolean validatePassword(String password) {
    if (isValid(password)) {
        Session.initialize(); // Efeito colateral!
        return true;
    }
    return false;
}

// ✅ BOM - sem efeitos colaterais
public boolean validatePassword(String password) {
    return isValid(password);
}
```

#### 5. Prefira exceções a códigos de erro

```java
// ❌ RUIM
public int deleteProduct(Long id) {
    if (productNotFound) return -1;
    if (hasOrders) return -2;
    // ...
    return 0;
}

// ✅ BOM
public void deleteProduct(Long id) {
    if (productNotFound) {
        throw new ProductNotFoundException(id);
    }
    if (hasOrders) {
        throw new ProductHasOrdersException(id);
    }
    repository.delete(id);
}
```

---

## 📌 4. SOLID - Os 5 Princípios

### 📊 Visão Geral:

| Letra | Princípio | Significado |
|-------|-----------|-------------|
| **S** | Single Responsibility | Uma classe, uma responsabilidade |
| **O** | Open/Closed | Aberto para extensão, fechado para modificação |
| **L** | Liskov Substitution | Subclasses substituíveis |
| **I** | Interface Segregation | Interfaces específicas |
| **D** | Dependency Inversion | Dependa de abstrações |

---

### S - Single Responsibility Principle (SRP)

> Uma classe deve ter apenas UM motivo para mudar.

```java
// ❌ VIOLANDO SRP - faz muitas coisas
public class Product {
    private String title;
    private BigDecimal price;
    
    public void save() { /* salva no banco */ }
    public void sendEmail() { /* envia email */ }
    public String generatePDF() { /* gera PDF */ }
    public void validate() { /* valida */ }
}

// ✅ SEGUINDO SRP - cada classe faz uma coisa
public class Product {
    private String title;
    private BigDecimal price;
    // Apenas dados do produto
}

public class ProductRepository {
    public void save(Product product) { /* salva */ }
}

public class ProductNotificationService {
    public void sendEmail(Product product) { /* email */ }
}

public class ProductPDFGenerator {
    public String generate(Product product) { /* PDF */ }
}

public class ProductValidator {
    public void validate(Product product) { /* valida */ }
}
```

---

### O - Open/Closed Principle (OCP)

> Aberto para extensão, fechado para modificação.

```java
// ❌ VIOLANDO OCP - precisa modificar para adicionar desconto
public class DiscountCalculator {
    public BigDecimal calculate(String type, BigDecimal price) {
        if (type.equals("VIP")) {
            return price.multiply(new BigDecimal("0.8"));
        } else if (type.equals("REGULAR")) {
            return price.multiply(new BigDecimal("0.95"));
        } else if (type.equals("NEW")) { // Novo tipo = modificar classe!
            return price.multiply(new BigDecimal("0.9"));
        }
        return price;
    }
}

// ✅ SEGUINDO OCP - estende sem modificar
public interface DiscountStrategy {
    BigDecimal apply(BigDecimal price);
}

public class VIPDiscount implements DiscountStrategy {
    public BigDecimal apply(BigDecimal price) {
        return price.multiply(new BigDecimal("0.8"));
    }
}

public class RegularDiscount implements DiscountStrategy {
    public BigDecimal apply(BigDecimal price) {
        return price.multiply(new BigDecimal("0.95"));
    }
}

// Novo tipo = nova classe, sem modificar existentes!
public class BlackFridayDiscount implements DiscountStrategy {
    public BigDecimal apply(BigDecimal price) {
        return price.multiply(new BigDecimal("0.5"));
    }
}
```

---

### L - Liskov Substitution Principle (LSP)

> Subclasses devem ser substituíveis por suas classes base.

```java
// ❌ VIOLANDO LSP
public class Bird {
    public void fly() { /* voa */ }
}

public class Penguin extends Bird {
    @Override
    public void fly() {
        throw new UnsupportedOperationException("Pinguins não voam!");
    }
}

// Código quebra quando usa Bird genérico:
void makeBirdFly(Bird bird) {
    bird.fly(); // 💥 Quebra com Penguin!
}

// ✅ SEGUINDO LSP
public abstract class Bird {
    public abstract void move();
}

public class FlyingBird extends Bird {
    @Override
    public void move() { fly(); }
    public void fly() { /* voa */ }
}

public class Penguin extends Bird {
    @Override
    public void move() { swim(); }
    public void swim() { /* nada */ }
}
```

---

### I - Interface Segregation Principle (ISP)

> Muitas interfaces específicas são melhores que uma interface geral.

```java
// ❌ VIOLANDO ISP - interface "gorda"
public interface Animal {
    void fly();
    void swim();
    void walk();
    void run();
}

public class Dog implements Animal {
    public void fly() { /* Dog não voa! */ }  // Forçado a implementar
    public void swim() { /* ok */ }
    public void walk() { /* ok */ }
    public void run() { /* ok */ }
}

// ✅ SEGUINDO ISP - interfaces específicas
public interface Flyable {
    void fly();
}

public interface Swimmable {
    void swim();
}

public interface Walkable {
    void walk();
}

public class Dog implements Swimmable, Walkable {
    public void swim() { /* ok */ }
    public void walk() { /* ok */ }
    // Não precisa implementar fly()!
}

public class Bird implements Flyable, Walkable {
    public void fly() { /* ok */ }
    public void walk() { /* ok */ }
}
```

---

### D - Dependency Inversion Principle (DIP)

> Dependa de abstrações, não de implementações.

```java
// ❌ VIOLANDO DIP - depende de implementação concreta
public class ProductService {
    private MySQLProductRepository repository = new MySQLProductRepository();
    
    public void save(Product product) {
        repository.save(product);
    }
}

// ✅ SEGUINDO DIP - depende de abstração
public interface ProductRepository {
    void save(Product product);
}

public class MySQLProductRepository implements ProductRepository {
    public void save(Product product) { /* MySQL */ }
}

public class MongoProductRepository implements ProductRepository {
    public void save(Product product) { /* MongoDB */ }
}

public class ProductService {
    private final ProductRepository repository;  // Abstração!
    
    public ProductService(ProductRepository repository) {
        this.repository = repository;  // Injetado!
    }
    
    public void save(Product product) {
        repository.save(product);
    }
}
```

---

## 📌 5. CODE SMELLS

### 🦨 O que são?

Indícios de problemas no código (não são bugs, mas sinalizam design ruim).

### 📊 Code Smells comuns:

| Smell | Descrição | Solução |
|-------|-----------|---------|
| **Long Method** | Método muito grande | Extrair métodos |
| **Large Class** | Classe faz demais | Dividir em classes |
| **Long Parameter List** | Muitos parâmetros | Criar objeto |
| **Duplicate Code** | Código repetido | Extrair para método/classe |
| **Dead Code** | Código não usado | Deletar |
| **Magic Numbers** | Números sem nome | Criar constantes |
| **Comments** | Comentários explicando código confuso | Refatorar código |
| **Feature Envy** | Método usa mais outra classe | Mover método |
| **Data Clumps** | Dados sempre juntos | Criar classe |

### 🔍 Exemplos:

```java
// ❌ MAGIC NUMBERS
if (age >= 18) { }
if (price > 100) { }

// ✅ CONSTANTES NOMEADAS
private static final int LEGAL_AGE = 18;
private static final BigDecimal FREE_SHIPPING_THRESHOLD = new BigDecimal("100");

if (age >= LEGAL_AGE) { }
if (price.compareTo(FREE_SHIPPING_THRESHOLD) > 0) { }
```

```java
// ❌ DATA CLUMPS - sempre juntos
void createUser(String street, String city, String zipCode, String country);
void updateUser(String street, String city, String zipCode, String country);
void validateAddress(String street, String city, String zipCode, String country);

// ✅ CRIAR CLASSE
class Address {
    String street;
    String city;
    String zipCode;
    String country;
}

void createUser(Address address);
void updateUser(Address address);
void validateAddress(Address address);
```

---

## 📌 6. REFATORAÇÃO

### 💡 O que é?

Melhorar a estrutura do código sem mudar seu comportamento.

### 🔧 Técnicas comuns:

#### Extract Method

```java
// Antes
void printInvoice() {
    // Imprime cabeçalho
    System.out.println("=== INVOICE ===");
    System.out.println("Date: " + date);
    
    // Imprime itens
    for (Item item : items) {
        System.out.println(item.name + ": " + item.price);
    }
    
    // Imprime total
    System.out.println("Total: " + calculateTotal());
}

// Depois
void printInvoice() {
    printHeader();
    printItems();
    printTotal();
}

private void printHeader() { /* ... */ }
private void printItems() { /* ... */ }
private void printTotal() { /* ... */ }
```

#### Replace Magic Number with Constant

```java
// Antes
double circumference = 2 * 3.14159 * radius;

// Depois
private static final double PI = 3.14159;
double circumference = 2 * PI * radius;
```

#### Introduce Parameter Object

```java
// Antes
List<Product> search(String title, String author, BigDecimal minPrice, 
                     BigDecimal maxPrice, String genre);

// Depois
class ProductSearchCriteria {
    String title;
    String author;
    BigDecimal minPrice;
    BigDecimal maxPrice;
    String genre;
}

List<Product> search(ProductSearchCriteria criteria);
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Identifique problemas

Olhe o código do Bookanga e identifique:
1. Nomes que poderiam ser melhores
2. Funções que fazem mais de uma coisa
3. Violações de SOLID

### Exercício 2: Refatore

```java
// Refatore este código:
public void p(List<Product> l) {
    double t = 0;
    for (int i = 0; i < l.size(); i++) {
        Product x = l.get(i);
        if (x.getPrice() > 0) {
            t = t + x.getPrice();
            if (t > 100) {
                System.out.println("Free shipping!");
            }
        }
    }
}
```

### Exercício 3: Aplique SOLID

Refatore `ProductService` para seguir melhor os princípios SOLID.

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Clean Code** | Código legível e manutenível |
| **SRP** | Uma responsabilidade por classe |
| **OCP** | Extensível sem modificação |
| **LSP** | Subclasses substituíveis |
| **ISP** | Interfaces específicas |
| **DIP** | Depender de abstrações |
| **Code Smell** | Indício de problema |
| **Refatoração** | Melhorar sem mudar comportamento |

---

## 📚 Leitura Recomendada

- **Clean Code** - Robert C. Martin
- **Refactoring** - Martin Fowler
- **Clean Architecture** - Robert C. Martin

---

**🎉 Parabéns por completar o Módulo 14!**

Este é o último módulo! Você agora tem uma base sólida para continuar evoluindo como desenvolvedor.

