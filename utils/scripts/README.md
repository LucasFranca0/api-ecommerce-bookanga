# Scripts Úteis - API Ecommerce Bookanga

Esta pasta contém scripts úteis para facilitar o desenvolvimento e manutenção do projeto.

## 📋 Scripts Disponíveis

### 🔨 build.sh
Compila e empacota o projeto completo.
```bash
./utils/scripts/build.sh
```

### 🚀 run-local.sh
Inicia a aplicação localmente (verifica e inicia PostgreSQL se necessário).
```bash
./utils/scripts/run-local.sh
```

### 🧪 test.sh
Executa todos os testes do projeto.
```bash
./utils/scripts/test.sh
```

### 🗄️ db-reset.sh
Reseta o banco de dados completamente (remove e recria).
```bash
./utils/scripts/db-reset.sh
```

### 🔄 liquibase-update.sh
Executa as migrations do Liquibase.
```bash
./utils/scripts/liquibase-update.sh
```

### ⏪ liquibase-rollback.sh
Reverte um número específico de changesets do Liquibase.
```bash
./utils/scripts/liquibase-rollback.sh 1
```

### 📋 logs.sh
Exibe os logs de um serviço Docker (padrão: app).
```bash
./utils/scripts/logs.sh [service_name]
```

### 🧹 clean.sh
Limpa arquivos gerados pelo build.
```bash
./utils/scripts/clean.sh
```

## 💡 Dicas de Uso

- Todos os scripts são executáveis. Se necessário: `chmod +x utils/scripts/*.sh`
- Use os scripts a partir da raiz do projeto
- Para desenvolvimento rápido: `./utils/scripts/run-local.sh`
- Antes de commitar: `./utils/scripts/test.sh`
