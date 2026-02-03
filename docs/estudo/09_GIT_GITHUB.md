# 📚 Módulo 9: Git e GitHub

> **Tempo estimado:** 3-4 horas  
> **Importância:** ⭐⭐⭐⭐⭐ (Essencial para qualquer desenvolvedor)

---

## 🎯 O que você vai aprender:

1. ✅ O que é Git e por que usar
2. ✅ Conceitos fundamentais (commits, branches)
3. ✅ Comandos Git essenciais
4. ✅ Fluxo de trabalho com branches
5. ✅ GitHub e colaboração
6. ✅ Gitflow e convenções

---

## 📌 1. O QUE É GIT?

### 💡 Definição:

**Git** é um sistema de controle de versão distribuído que rastreia mudanças em arquivos.

### 🤔 O Problema que Git Resolve:

```
Sem Git:
- projeto_final.zip
- projeto_final_v2.zip
- projeto_final_v2_corrigido.zip
- projeto_final_v2_corrigido_FINAL.zip
- projeto_final_v2_corrigido_FINAL_DE_VERDADE.zip 😱

Com Git:
- Um repositório com histórico completo
- Sabe quem mudou o quê e quando
- Pode voltar a qualquer versão
- Múltiplas pessoas trabalhando ao mesmo tempo
```

### 🔄 Git vs GitHub:

| Git | GitHub |
|-----|--------|
| Ferramenta de controle de versão | Plataforma de hospedagem |
| Roda localmente | Na nuvem |
| Gratuito e open source | Gratuito (com planos pagos) |
| Linha de comando | Interface web |

---

## 📌 2. CONCEITOS FUNDAMENTAIS

### 📦 Repository (Repositório):

Pasta que contém seu projeto + histórico Git (pasta `.git`).

```bash
# Criar novo repositório
git init

# Clonar repositório existente
git clone https://github.com/user/repo.git
```

### 📸 Commit:

Um "snapshot" (foto) do projeto em um momento específico.

```
┌─────────────────────────────────────────────────────────────────┐
│                    LINHA DO TEMPO                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Commit 1          Commit 2          Commit 3          Commit 4 │
│  "inicial"         "add login"       "fix bug"         "v1.0"   │
│       │                 │                 │                │    │
│       ▼                 ▼                 ▼                ▼    │
│  ┌─────────┐       ┌─────────┐       ┌─────────┐       ┌─────────┐
│  │ abc123  │ ────► │ def456  │ ────► │ ghi789  │ ────► │ jkl012  │
│  └─────────┘       └─────────┘       └─────────┘       └─────────┘
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 🌿 Branch:

Linha de desenvolvimento independente.

```
                         feature/login
                              │
                         ┌────●────●────┐
                         │              │
  ─────●────●────●────●──┴──────────────┴──●────●────►  main
       │    │    │    │                    │    │
      c1   c2   c3   c4                   c5   c6
                                         (merge)
```

### 📊 As 3 áreas do Git:

```
┌─────────────────┐      git add       ┌─────────────────┐     git commit     ┌─────────────────┐
│  Working        │  ─────────────────►│  Staging        │  ─────────────────►│  Repository     │
│  Directory      │                    │  Area           │                    │  (.git)         │
│  (arquivos)     │                    │  (índice)       │                    │  (histórico)    │
└─────────────────┘                    └─────────────────┘                    └─────────────────┘
     Modificado          →              Preparado           →                    Commitado
```

---

## 📌 3. COMANDOS GIT ESSENCIAIS

### 🚀 Começando:

```bash
# Configurar identidade (só uma vez)
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"

# Iniciar repositório
git init

# Clonar repositório
git clone https://github.com/user/repo.git
```

### 📊 Verificando status:

```bash
# Ver status (modificados, staged, etc)
git status

# Ver histórico de commits
git log

# Ver histórico resumido
git log --oneline

# Ver diferenças
git diff                 # Modificados vs último commit
git diff --staged        # Staged vs último commit
```

### ✏️ Fazendo commits:

```bash
# Adicionar arquivo ao stage
git add arquivo.txt

# Adicionar todos os arquivos
git add .

# Fazer commit
git commit -m "Mensagem descritiva do que foi feito"

# Adicionar e commitar em um comando
git commit -am "Mensagem" # Só para arquivos já rastreados
```

### 🌿 Trabalhando com branches:

```bash
# Listar branches
git branch

# Criar nova branch
git branch feature/nova-funcionalidade

# Mudar para branch
git checkout feature/nova-funcionalidade

# Criar e mudar (atalho)
git checkout -b feature/nova-funcionalidade

# Versão moderna (Git 2.23+)
git switch feature/nova-funcionalidade
git switch -c feature/nova-funcionalidade  # Criar e mudar

# Voltar para main
git checkout main

# Deletar branch
git branch -d feature/ja-mergeada
git branch -D feature/forcar-delete
```

### 🔀 Merge e Rebase:

```bash
# Merge: une branches mantendo histórico
git checkout main
git merge feature/login

# Rebase: reaplica commits em cima de outra branch
git checkout feature/login
git rebase main
```

### ☁️ Trabalhando com remoto:

```bash
# Ver remotos configurados
git remote -v

# Adicionar remoto
git remote add origin https://github.com/user/repo.git

# Enviar para remoto
git push origin main

# Primeira vez (configura upstream)
git push -u origin main

# Baixar atualizações
git fetch origin

# Baixar e aplicar (fetch + merge)
git pull origin main
```

### ↩️ Desfazendo:

```bash
# Descartar mudanças em arquivo (antes de add)
git checkout -- arquivo.txt
git restore arquivo.txt  # Git 2.23+

# Tirar do stage (depois de add, antes de commit)
git reset HEAD arquivo.txt
git restore --staged arquivo.txt  # Git 2.23+

# Desfazer último commit (mantém mudanças)
git reset --soft HEAD~1

# Desfazer último commit (descarta mudanças) ⚠️ CUIDADO
git reset --hard HEAD~1

# Criar commit que desfaz outro (mais seguro)
git revert abc123
```

---

## 📌 4. FLUXO DE TRABALHO

### 🔄 Fluxo básico:

```bash
# 1. Atualizar main
git checkout main
git pull origin main

# 2. Criar branch para feature
git checkout -b feature/nova-funcionalidade

# 3. Fazer alterações e commits
git add .
git commit -m "feat: implementar nova funcionalidade"

# 4. Enviar para remoto
git push origin feature/nova-funcionalidade

# 5. Abrir Pull Request no GitHub

# 6. Após aprovação, merge na main
git checkout main
git merge feature/nova-funcionalidade
git push origin main

# 7. Deletar branch
git branch -d feature/nova-funcionalidade
git push origin --delete feature/nova-funcionalidade
```

---

## 📌 5. GITFLOW

### 📊 Estrutura de branches:

```
┌─────────────────────────────────────────────────────────────────┐
│                         GITFLOW                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  main ─────●──────────────────●──────────────────●────────────► │
│            │                  │                  │              │
│            │ tag v1.0         │ tag v1.1         │ tag v2.0     │
│            │                  ▲                  ▲              │
│            │                  │                  │              │
│  release ──┼──────────────────●                  │              │
│            │                  │                  │              │
│  develop ──●────●────●────●───┴────●────●────●───┴────●────────►│
│            │    │    │    │        │    │    │        │         │
│            │    │    │    │        │    │    │        │         │
│  feature/a │    ●────●────┤        │    │    │        │         │
│            │              │        │    │    │        │         │
│  feature/b │              └────────●────●────┤        │         │
│            │                                 │        │         │
│  hotfix    │                                 └────────●         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 📋 Tipos de branches:

| Branch | Propósito | Origem | Destino |
|--------|-----------|--------|---------|
| `main` | Produção | - | - |
| `develop` | Desenvolvimento | main | main |
| `feature/*` | Nova funcionalidade | develop | develop |
| `release/*` | Preparar release | develop | main + develop |
| `hotfix/*` | Correção urgente | main | main + develop |

---

## 📌 6. CONVENÇÕES DE COMMITS

### 📝 Conventional Commits:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### 📊 Tipos de commit:

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| `feat` | Nova funcionalidade | `feat: add login page` |
| `fix` | Correção de bug | `fix: resolve null pointer in cart` |
| `docs` | Documentação | `docs: update README` |
| `style` | Formatação (não afeta código) | `style: format with prettier` |
| `refactor` | Refatoração | `refactor: extract validation logic` |
| `test` | Testes | `test: add unit tests for cart` |
| `chore` | Manutenção | `chore: update dependencies` |
| `perf` | Performance | `perf: optimize database query` |

### 📝 Exemplos bons:

```bash
# Funcionalidade
git commit -m "feat(auth): implement JWT authentication"

# Bug fix
git commit -m "fix(cart): prevent negative quantities"

# Breaking change
git commit -m "feat!: change API response format

BREAKING CHANGE: response now uses camelCase"

# Com escopo
git commit -m "feat(products): add search by category"
```

### ❌ Exemplos ruins:

```bash
# Muito vago
git commit -m "fix"
git commit -m "update"
git commit -m "changes"

# Muito longo
git commit -m "I fixed the bug that was causing the application to crash when..."

# Sem contexto
git commit -m "fix bug"
```

---

## 📌 7. GITHUB

### 🔄 Pull Request (PR):

Solicitação para incorporar mudanças de uma branch em outra.

```
1. Crie branch feature
2. Faça commits
3. Push para GitHub
4. Abra Pull Request
5. Revisão de código (code review)
6. Aprovação
7. Merge
```

### 📋 Template de PR:

```markdown
## Descrição
Breve descrição do que foi feito.

## Tipo de mudança
- [ ] Bug fix
- [ ] Nova feature
- [ ] Breaking change
- [ ] Documentação

## Checklist
- [ ] Código segue os padrões do projeto
- [ ] Testes adicionados/atualizados
- [ ] Documentação atualizada
- [ ] Sem conflitos com main

## Screenshots (se aplicável)
```

### 🔧 .gitignore:

Arquivo que define o que NÃO deve ser versionado:

```gitignore
# Compilados Java
target/
*.class
*.jar

# IDE
.idea/
*.iml
.vscode/

# Logs
*.log
logs/

# Ambiente
.env
.env.local

# Sistema
.DS_Store
Thumbs.db

# Dependências
node_modules/
```

---

## 📌 8. RESOLVENDO CONFLITOS

### 🤔 Quando acontece?

Quando duas pessoas modificam a mesma linha do mesmo arquivo.

### 📊 Anatomia de um conflito:

```
<<<<<<< HEAD
código da sua branch
=======
código da outra branch
>>>>>>> feature/outra
```

### 🔧 Resolvendo:

```bash
# 1. Identifique arquivos com conflito
git status

# 2. Abra o arquivo e escolha o código correto
# 3. Remova os marcadores <<<<, ====, >>>>
# 4. Add e commit
git add arquivo.txt
git commit -m "fix: resolve merge conflict in arquivo.txt"
```

---

## 📌 9. COMANDOS AVANÇADOS

```bash
# Stash - guardar mudanças temporariamente
git stash                    # Guarda
git stash pop                # Recupera e remove do stash
git stash list               # Lista stashes

# Cherry-pick - aplicar commit específico
git cherry-pick abc123

# Bisect - encontrar commit que introduziu bug
git bisect start
git bisect bad               # Commit atual tem bug
git bisect good abc123       # Este commit era bom

# Amend - modificar último commit
git commit --amend -m "Nova mensagem"

# Rebase interativo - reorganizar commits
git rebase -i HEAD~3

# Log bonito
git log --oneline --graph --all

# Blame - ver quem modificou cada linha
git blame arquivo.txt
```

---

## 🧪 EXERCÍCIOS PRÁTICOS

### Exercício 1: Criar repositório

```bash
# Crie um repositório local
mkdir meu-projeto
cd meu-projeto
git init
echo "# Meu Projeto" > README.md
git add README.md
git commit -m "feat: initial commit"
```

### Exercício 2: Branches

```bash
# Crie uma branch, faça mudanças e merge
git checkout -b feature/teste
echo "Nova linha" >> README.md
git commit -am "feat: add content to README"
git checkout main
git merge feature/teste
```

### Exercício 3: Simular conflito

```bash
# Em main, edite README.md linha 1
# Crie branch, edite mesma linha diferente
# Tente merge e resolva o conflito
```

---

## 📋 RESUMO DO MÓDULO

| Conceito | Definição |
|----------|-----------|
| **Repository** | Projeto com histórico Git |
| **Commit** | Snapshot do projeto |
| **Branch** | Linha de desenvolvimento |
| **Merge** | Unir branches |
| **Push** | Enviar para remoto |
| **Pull** | Baixar do remoto |
| **Clone** | Copiar repositório |
| **Stash** | Guardar mudanças temporárias |
| **Pull Request** | Solicitação de merge |
| **Conflict** | Mudanças incompatíveis |

---

## ⏭️ Próximo Módulo

**Módulo 10: Testes - JUnit e Mockito**

---

**🎉 Parabéns por completar o Módulo 9!**

