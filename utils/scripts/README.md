# 🧰 Scripts Uteis - API Ecommerce Bookanga

Esta pasta centraliza os scripts de automacao para desenvolvimento local.

## 📌 Scripts disponiveis

### 🔨 `build.sh`
Compila e empacota o projeto.
```bash
./utils/scripts/build.sh
```

### 🚀 `run-local.sh`
Inicia a aplicacao localmente (sobe PostgreSQL com Docker quando necessario).
```bash
./utils/scripts/run-local.sh
```

### 🧪 `test.sh`
Executa os testes do projeto.
```bash
./utils/scripts/test.sh
```

### 🗄️ `db-reset.sh`
Reseta o banco local.
```bash
./utils/scripts/db-reset.sh
```

### 🔄 `liquibase-update.sh`
Executa migrations do Liquibase.
```bash
./utils/scripts/liquibase-update.sh
```

### ⏪ `liquibase-rollback.sh`
Faz rollback de changesets do Liquibase.
```bash
./utils/scripts/liquibase-rollback.sh 1
```

### 📋 `logs.sh`
Mostra logs de servico Docker (padrao: `app`).
```bash
./utils/scripts/logs.sh [service_name]
```

### 🧹 `clean.sh`
Script interativo: voce decide em tempo de execucao o que limpar (`y/n`), sem precisar decorar flags.
```bash
./utils/scripts/clean.sh
```

Atalho nao interativo (aceita fluxo padrao):
```bash
./utils/scripts/clean.sh --yes
```

Modo simulacao (nao remove nada):
```bash
./utils/scripts/clean.sh --dry-run
```

## ⚙️ Setup completo da maquina - `setup-dev.sh`

O script `setup-dev.sh` prepara o ambiente para voce conseguir **buildar e rodar o projeto**.
Fluxo principal agora e interativo: no terminal voce responde `y/n` para cada acao.

### ✅ O que ele faz
- valida e instala ferramentas faltantes automaticamente
- configura Git (incluindo `credential.helper`)
- opcionalmente configura `~/.bashrc` (`JAVA_HOME`) e `~/.npmrc`
- baixa dependencias Maven e valida compilacao

### 🧩 Ferramentas cobertas no setup base
- `git`
- `java` (alvo Java 21)
- `mvn`
- `docker`
- `docker compose` (ou `docker-compose`)
- `aws` (AWS CLI)
- `pg_isready` (cliente PostgreSQL)
- `curl`
- `unzip`

Node.js/npm podem ser incluidos com `--with-node`.

### ▶️ Uso rapido

Setup interativo (recomendado):
```bash
./utils/scripts/setup-dev.sh
```

Setup nao interativo:
```bash
./utils/scripts/setup-dev.sh --yes
```

Modo simulacao:
```bash
./utils/scripts/setup-dev.sh --dry-run
```

Apenas validar sem instalar:
```bash
./utils/scripts/setup-dev.sh --skip-install --skip-maven
```

Sem usar flags: basta executar e responder `y/n` no terminal para cada acao.

## 💡 Dicas

- garanta permissao de execucao: `chmod +x utils/scripts/*.sh`
- execute os scripts a partir da raiz do projeto
- fluxo rapido de desenvolvimento: `./utils/scripts/run-local.sh`
- antes de commitar: `./utils/scripts/test.sh`
