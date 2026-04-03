# 📮 Postman - Bookanga API

## 📥 Importar Coleção da API Bookanga

### Método 1: Via Arquivo
1. Abra o Postman
2. Clique em **Import** (canto superior esquerdo)
3. Selecione o arquivo:
   ```
   postman/Bookanga-API.postman_collection.json
   ```
4. Clique em **Import**

### Método 2: Via Link
1. Use o caminho do arquivo dentro do repositório:
   ```bash
   postman/Bookanga-API.postman_collection.json
   ```
2. No Postman, vá em **Import → Upload Files**
3. Selecione o arquivo

---

## 📋 Endpoints Disponíveis

### 📚 Products

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/v1/products` | Lista todos os produtos |
| GET | `/api/v1/products/{id}` | Busca produto por ID |
| POST | `/api/v1/products` | Cria novo produto |
| PUT | `/api/v1/products/{id}` | Atualiza produto |
| DELETE | `/api/v1/products/{id}` | Deleta produto |

### 📊 Monitoring

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/status` | Status da API e DB |
| GET | `/actuator/health` | Health check |
| GET | `/actuator/prometheus` | Métricas Prometheus |
| GET | `/actuator/metrics` | Todas métricas |

---

## 🎯 Exemplos de Uso

### 1. Listar todos os produtos
```http
GET http://localhost:8080/api/v1/products
```

**Resposta:**
```json
[
  {
    "id": 1,
    "title": "Dom Quixote",
    "author": "Miguel de Cervantes",
    "publicationYear": 1605,
    "price": 49.99,
    "isbn": "978-1-234567-89-0",
    "genre": "Fiction",
    "language": "Portuguese",
    "product_type": "book"
  }
]
```

### 2. Criar um livro
```http
POST http://localhost:8080/api/v1/products
Content-Type: application/json

{
  "title": "Clean Code",
  "author": "Robert C. Martin",
  "publicationYear": 2008,
  "price": 89.90,
  "isbn": "978-0132350884",
  "genre": "Programming",
  "language": "Portuguese",
  "product_type": "book"
}
```

### 3. Criar um mangá
```http
POST http://localhost:8080/api/v1/products
Content-Type: application/json

{
  "title": "One Piece",
  "author": "Eiichiro Oda",
  "publicationYear": 2020,
  "price": 29.90,
  "isbn": "978-8545702887",
  "genre": "Adventure",
  "language": "Portuguese",
  "volume": 98,
  "product_type": "manga"
}
```

### 4. Buscar produto por ID
```http
GET http://localhost:8080/api/v1/products/1
```

### 5. Verificar status da API
```http
GET http://localhost:8080/api/status
```

**Resposta:**
```json
{
  "database": {
    "name": "PostgreSQL",
    "status": "UP",
    "message": "Database connection is healthy"
  },
  "application": {
    "name": "Spring Boot API",
    "status": "UP",
    "message": "Application is running"
  },
  "timestamp": "2026-01-04T20:41:33.694914763"
}
```

---

## ⚙️ Variáveis de Ambiente

A coleção já vem configurada com a variável:

| Variável | Valor |
|----------|-------|
| `base_url` | `http://localhost:8080` |

Para alterar:
1. Clique em **Bookanga E-commerce API** (nome da coleção)
2. Vá na aba **Variables**
3. Altere o valor de `base_url`

---

## 🧪 Testes Automatizados

### Adicionar testes básicos

Você pode adicionar testes na aba **Tests** de cada request:

```javascript
// Verifica se status é 200
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Verifica se retorna JSON
pm.test("Response is JSON", function () {
    pm.response.to.be.json;
});

// Verifica se tem products
pm.test("Has products", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.be.an('array');
});
```

---

## 🔍 Dicas do Postman

### 1. Visualizar resposta formatada
- Clique em **Pretty** (abaixo da resposta)
- Use **JSON** para formatar

### 2. Salvar exemplos de resposta
- Após executar uma request, clique em **Save Response**
- Clique em **Save as example**

### 3. Organizar em pastas
- Crie pastas para agrupar requests relacionadas
- Use descrições claras

### 4. Duplicar requests
- Clique com botão direito na request
- Selecione **Duplicate**

### 5. Environment variables
- Crie ambientes diferentes (dev, prod)
- Use variáveis para URLs dinâmicas

---

## 🚨 Troubleshooting

### Erro: "Could not get response"
- Verifique se a API está rodando: `docker compose ps`
- Teste no navegador: http://localhost:8080/api/status

### Erro 404
- Verifique se o endpoint está correto
- Confira se está usando `{{base_url}}` corretamente

### Erro 500
- Veja os logs: `docker compose logs -f app`
- Verifique se o banco está funcionando

### Postman não abre
```bash
# Reinstalar
sudo snap remove postman
sudo snap install postman

# Ou executar diretamente
/opt/Postman/Postman
```

---

## 📚 Recursos Adicionais

- **Postman Learning Center**: https://learning.postman.com/
- **API Documentation**: Ver `README.md` do projeto
- **Swagger/OpenAPI**: (futuro) `/swagger-ui.html`

---

## 🎯 Próximos Passos

1. ✅ Instalar Postman
2. ✅ Importar coleção
3. ✅ Testar endpoints
4. 📝 Criar testes automatizados
5. 📊 Monitorar com Newman (CLI do Postman)
6. 🔄 Integrar com CI/CD

### Executar testes via CLI (Newman)
```bash
npm install -g newman
newman run postman/Bookanga-API.postman_collection.json
```
