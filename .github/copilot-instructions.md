# Copilot Instructions

## Objetivo

Este arquivo concentra instruções gerais compartilhadas para agentes no repositório Bookanga.
Use este documento para evitar duplicação de contexto em arquivos especializados.

## Hierarquia de Contexto (arquivos do repositório)

Quando houver conflito entre arquivos locais de instrução, siga esta ordem:

1. `AGENTS.md` (contexto arquitetural e regras centrais do projeto)
2. `.github/copilot-instructions.md` (regras gerais de execução e qualidade)
3. `.github/agents/*.agent.md` (especialização por papel, ex: QA)
4. `.github/git-commit-instructions.md` (apenas quando a tarefa envolver commit)

Regra prática:
- Arquivo especializado complementa os níveis acima, não substitui.
- Se uma regra especializada conflitar com nível superior, prevalece o nível superior.
- Regras de commit não devem influenciar tarefas sem solicitação de commit.

## Contexto Arquitetural

Para arquitetura, contratos e limites funcionais do sistema, use `AGENTS.md` como fonte primária.
Não duplicar neste arquivo detalhes já documentados lá.

## Fluxo Operacional Padrão

Priorize scripts versionados em `utils/scripts/`:

- Setup: `./utils/scripts/setup-dev.sh`
- Run local: `./utils/scripts/run-local.sh`
- Build: `./utils/scripts/build.sh`
- Testes: `./utils/scripts/test.sh`
- Banco: `./utils/scripts/db-reset.sh` + `./utils/scripts/liquibase-update.sh`

## Guardrails Gerais

- Não inventar endpoints, tabelas, integrações ou convenções não presentes no código.
- Referenciar classes/arquivos concretos ao justificar comportamento.
- Tratar `README.md` raiz como potencialmente incompleto (pode estar vazio).
- Ao relatar qualidade, destacar riscos de regressão e limites conhecidos.

## Fontes de Verdade

- `AGENTS.md`
- `src/main/java/com/products/**`
- `src/main/resources/**`
- `utils/scripts/README.md`
- `postman/README.md`
- `docker-compose.yml`
