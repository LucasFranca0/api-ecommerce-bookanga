# 📚 Módulo 13: Segurança - Spring Security (Introdução)

> **Tempo estimado:** 4-5 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Essencial para produção)  
> **Nota:** Este módulo é introdutório. O Bookanga ainda não implementa segurança.

---

## 🎯 O que você vai aprender:

1. ✅ Conceitos de segurança em APIs
2. ✅ Autenticação vs Autorização
3. ✅ Spring Security básico
4. ✅ JWT (JSON Web Token)
5. ✅ Boas práticas de segurança
6. ✅ Como implementar no Bookanga (futuro)

---

## 📌 1. CONCEITOS FUNDAMENTAIS

### 🔐 Autenticação vs Autorização:

| Conceito | Pergunta | Exemplo |
|----------|----------|---------|
| **Autenticação** | Quem é você? | Login com email/senha |
| **Autorização** | O que você pode fazer? | Admin pode deletar, user só pode ler |

```
┌─────────────────────────────────────────────────────────────────┐
│                      FLUXO DE SEGURANÇA                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   1. AUTENTICAÇÃO                    2. AUTORIZAÇÃO             │
│   ┌─────────────┐                    ┌─────────────┐           │
│   │             │   "Olá, sou        │             │           │
│   │   Usuário   │   lucas@email"     │   Sistema   │           │
│   │             │ ─────────────────► │             │           │
│   │             │   + senha          │   Verifica  │           │
│   │             │                    │   se é      │           │
│   │             │   "OK, você é      │   admin     │           │
│   │             │ ◄───────────────── │             │           │
│   │             │   Lucas"           │  "Pode      │           │
│   │             │                    │   acessar"  │           │
│   └─────────────┘                    └─────────────┘           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 📊 Tipos de Autenticação:

| Tipo | Descrição | Uso |
|------|-----------|-----|
| **Basic Auth** | Usuário:senha em base64 | Simples, não seguro para produção |
| **Session/Cookie** | Sessão no servidor | Apps tradicionais (MVC) |
| **Token (JWT)** | Token assinado | APIs REST, SPAs, Mobile |
| **OAuth2** | Delegação de autorização | Login com Google/Facebook |

---

## 📌 2. JWT (JSON Web Token)

### 💡 O que é?

Token que contém informações do usuário, assinado criptograficamente.

### 📊 Estrutura do JWT:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikx1Y2FzIiwicm9sZSI6IlVTRVIifQ.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

|_______________|_______________________________________________|______________|
    HEADER                        PAYLOAD                          SIGNATURE
```

| Parte | Conteúdo |
|-------|----------|
| **Header** | Algoritmo (HS256) e tipo (JWT) |
| **Payload** | Dados do usuário (id, nome, roles) |
| **Signature** | Assinatura para verificar integridade |

### 🔄 Fluxo de autenticação JWT:

```
1. Login
┌────────┐         POST /auth/login          ┌────────┐
│ Client │ ─────────────────────────────────►│ Server │
│        │  { email, password }              │        │
│        │                                   │        │
│        │          200 OK                   │        │
│        │ ◄─────────────────────────────────│        │
│        │  { token: "eyJhb..." }            │        │
└────────┘                                   └────────┘

2. Requisições autenticadas
┌────────┐    GET /api/products              ┌────────┐
│ Client │ ─────────────────────────────────►│ Server │
│        │    Header: Authorization:         │        │
│        │    Bearer eyJhb...                │        │
│        │                                   │  ✓     │
│        │          200 OK                   │Valida  │
│        │ ◄─────────────────────────────────│ token  │
│        │  [products...]                    │        │
└────────┘                                   └────────┘
```

---

## 📌 3. SPRING SECURITY BÁSICO

### 📦 Dependência:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- Para JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

### ⚠️ Comportamento padrão:

Ao adicionar spring-security, TUDO fica protegido:
- Gera senha aleatória no console
- Redireciona para página de login
- Bloqueia todas as requisições

### 🔧 Configuração básica (Spring Security 6.x):

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // Desabilita CSRF para APIs REST (stateless)
            .csrf(csrf -> csrf.disable())
            
            // Configura autorização
            .authorizeHttpRequests(auth -> auth
                // Públicos
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/actuator/health").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/v1/products/**").permitAll()
                
                // Requer autenticação
                .requestMatchers(HttpMethod.POST, "/api/v1/products/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.PUT, "/api/v1/products/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/api/v1/products/**").hasRole("ADMIN")
                
                // Qualquer outra requisição precisa autenticação
                .anyRequest().authenticated()
            )
            
            // Stateless (não usa sessão)
            .sessionManagement(session -> 
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );
        
        return http.build();
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

---

## 📌 4. IMPLEMENTAÇÃO COMPLETA JWT

### 📁 Estrutura de arquivos:

```
src/main/java/com/products/
├── security/
│   ├── SecurityConfig.java
│   ├── JwtTokenProvider.java
│   ├── JwtAuthenticationFilter.java
│   └── UserDetailsServiceImpl.java
├── controller/
│   └── AuthController.java
├── dto/
│   ├── LoginRequest.java
│   └── LoginResponse.java
└── model/
    └── User.java
```

### 🔧 JwtTokenProvider:

```java
@Component
public class JwtTokenProvider {

    @Value("${jwt.secret}")
    private String jwtSecret;
    
    @Value("${jwt.expiration}")
    private long jwtExpiration;

    public String generateToken(UserDetails userDetails) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);

        return Jwts.builder()
            .setSubject(userDetails.getUsername())
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .signWith(getSigningKey(), SignatureAlgorithm.HS256)
            .compact();
    }

    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
            .setSigningKey(getSigningKey())
            .build()
            .parseClaimsJws(token)
            .getBody();
        
        return claims.getSubject();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    private Key getSigningKey() {
        byte[] keyBytes = jwtSecret.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
```

### 🔧 JwtAuthenticationFilter:

```java
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider tokenProvider;
    private final UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String token = getTokenFromRequest(request);

        if (token != null && tokenProvider.validateToken(token)) {
            String username = tokenProvider.getUsernameFromToken(token);
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            
            UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities()
                );
            
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        filterChain.doFilter(request, response);
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
```

### 🔧 AuthController:

```java
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;
    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                request.getEmail(),
                request.getPassword()
            )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String token = tokenProvider.generateToken(userDetails);

        return ResponseEntity.ok(new LoginResponse(token));
    }

    @PostMapping("/register")
    public ResponseEntity<User> register(@Valid @RequestBody RegisterRequest request) {
        User user = userService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }
}
```

---

## 📌 5. CONFIGURAÇÃO application.properties

```properties
# JWT
jwt.secret=minhaChaveSecretaMuitoSeguraComMaisDe256Bits
jwt.expiration=86400000  # 24 horas em milissegundos
```

---

## 📌 6. ENTIDADE USER COM ROLES

```java
@Entity
@Table(name = "users")
@Data
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private String name;

    @Enumerated(EnumType.STRING)
    private Role role = Role.USER;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }
}

public enum Role {
    USER, ADMIN
}
```

---

## 📌 7. BOAS PRÁTICAS DE SEGURANÇA

### ✅ Faça:

| Prática | Descrição |
|---------|-----------|
| **Hash de senhas** | Use BCrypt, nunca armazene texto puro |
| **HTTPS** | Sempre em produção |
| **Validação de entrada** | Previne injection |
| **Rate limiting** | Previne brute force |
| **Tokens curtos** | JWT com expiração curta |
| **Refresh tokens** | Para renovar sem re-login |
| **Princípio do menor privilégio** | Apenas permissões necessárias |

### ❌ Não faça:

| Anti-padrão | Problema |
|-------------|----------|
| Senhas em texto | Exposição total |
| Segredos no código | Vaza no Git |
| Logs com dados sensíveis | Exposição em logs |
| CORS aberto (*) | Vulnerável a ataques |
| Mensagens de erro detalhadas | Info para atacantes |

---

## 📌 8. TESTANDO A AUTENTICAÇÃO

### 🧪 Com curl:

```bash
# Registrar usuário
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"lucas@email.com","password":"senha123","name":"Lucas"}'

# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"lucas@email.com","password":"senha123"}'

# Resposta: {"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."}

# Usar token
curl -X GET http://localhost:8080/api/v1/products \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 🧪 Com Postman:

1. Faça login em `/api/auth/login`
2. Copie o token da resposta
3. Em outras requisições:
   - Vá na aba "Authorization"
   - Tipo: "Bearer Token"
   - Cole o token

---

## 📌 9. PRÓXIMOS PASSOS PARA O BOOKANGA

Para implementar segurança no Bookanga:

1. **Adicionar dependências** no pom.xml
2. **Criar tabela users** via Liquibase
3. **Implementar entidade User** com roles
4. **Criar SecurityConfig**
5. **Implementar JWT** (provider, filter)
6. **Criar AuthController** (login, register)
7. **Testar endpoints**

---

## 🧪 EXERCÍCIOS

### Exercício 1: Analise um JWT

Acesse https://jwt.io e decodifique:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikx1Y2FzIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

### Exercício 2: Identifique permissões

Para o Bookanga, defina:
- Quais endpoints são públicos?
- Quais requerem USER?
- Quais requerem ADMIN?

### Exercício 3: Hash de senha

```java
// Use BCrypt para gerar hash
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String hash = encoder.encode("minhaSenha");
System.out.println(hash);

// Verificar
boolean matches = encoder.matches("minhaSenha", hash);
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Autenticação** | Verificar identidade (quem é você) |
| **Autorização** | Verificar permissões (o que pode fazer) |
| **JWT** | Token assinado com dados do usuário |
| **Bearer Token** | Formato de envio: "Bearer {token}" |
| **BCrypt** | Algoritmo de hash para senhas |
| **Role** | Papel do usuário (USER, ADMIN) |
| **SecurityFilterChain** | Configura segurança no Spring |

---

## 📚 Recursos Adicionais

- [Spring Security Reference](https://docs.spring.io/spring-security/reference/)
- [JWT.io](https://jwt.io/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

**🎉 Parabéns por completar o Módulo 13!**

