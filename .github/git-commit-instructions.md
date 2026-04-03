# Git Commit Instructions

## Escopo

Este arquivo define apenas regras de commit.
Não repetir contexto de arquitetura, QA ou execução geral (use `AGENTS.md` e `.github/copilot-instructions.md`).

## Formato de Mensagem

Use padrão Conventional Commits:

- `feat:` nova funcionalidade
- `fix:` correção de bug
- `refactor:` refatoração sem mudança funcional
- `test:` criação/ajuste de testes
- `docs:` documentação
- `chore:` manutenção

Formato recomendado:

`<type>(<escopo>): <resumo curto no imperativo>`

Exemplos:
- `fix(products): valida product_type no createProduct`
- `test(api): cobre erros de validacao no ProductController`
- `docs(agents): centraliza contexto em copilot-instructions`

## Qualidade do Commit

- Commits pequenos e coesos (um objetivo por commit).
- Não misturar refatoração ampla com correção funcional no mesmo commit.
- Em mudanças sensíveis, incluir contexto no corpo da mensagem (`why`, risco, impacto).
- Referenciar issue quando existir (`Refs: #123` ou chave equivalente).

## Checklist antes de Commit

- Build/testes relevantes executados para a mudança.
- Sem arquivos temporários, logs ou artefatos acidentais.
- Mensagem descreve o efeito real da alteração.
- Alterações de documentação acompanham mudanças de comportamento quando necessário.

