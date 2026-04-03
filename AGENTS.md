# AGENTS.md

## Project Focus
- Spring Boot 3.1 / Java 21 REST API for books + manga catalog (`src/main/java/com/products`).
- Runtime stack is Docker Compose: API + PostgreSQL + Prometheus + Grafana (`docker-compose.yml`).
- Database schema is managed only by Liquibase changelogs (`src/main/resources/db/changelog/**`), with `spring.jpa.hibernate.ddl-auto=none`.

## Architecture You Need First
- Main request path: `ProductController` -> `ProductService` -> `ProductRepository` -> PostgreSQL.
- `ProductController` exposes CRUD plus query endpoints under `/search/**`, `/top/**`, and `/count/**`; mirror this shape when adding new finder routes.
- Product model uses single-table inheritance (`Product`, `Book`, `Manga`) with discriminator column `product_type`.
- Product type is chosen from DTO input in service layer switch (`ProductService#createProduct`), not in controller.
- Error contract is centralized in `GlobalExceptionHandler` with `ErrorResponse` payloads.
- Monitoring path is built in: Actuator + Micrometer Prometheus (`application.properties`, `monitoring/prometheus/prometheus.yml`).
- Sales flow is scaffolded but incomplete (`SaleServiceImpl#createSale` currently returns `null`); treat `/sales` as not production-ready.

## Developer Workflows (Preferred)
- Use project scripts instead of ad-hoc commands (`utils/scripts/README.md`).
- First-time machine/project bootstrap: `./utils/scripts/setup-dev.sh` (interactive by default; use `--yes` for non-interactive).
- Local run (auto-starts Postgres if needed): `./utils/scripts/run-local.sh`.
- Build pipeline script runs clean/compile/test/package: `./utils/scripts/build.sh`.
- Test script: `./utils/scripts/test.sh` (writes logs to `logs/` and surefire reports to `target/surefire-reports/`).
- DB reset + migrations flow: `./utils/scripts/db-reset.sh` then `./utils/scripts/liquibase-update.sh`.
- Docker log helper: `./utils/scripts/logs.sh [service_name]` (default service is `app`).
- Cleanup helper is interactive by default: `./utils/scripts/clean.sh` (`--yes` / `--dry-run` supported).
- Full container stack for observability checks: `docker compose up --build -d`.

## Project-Specific Conventions
- API base path supports both `/api/v1/products` and legacy `/api/products` (`@RequestMapping` in `ProductController`).
- JSON field for product type is `product_type` (mapped in `ProductDTO` and `Product#getProductType()`).
- Validation is duplicated intentionally: bean validation annotations in DTO/model plus manual guard clauses in `ProductService`.
- Repository queries rely on Spring Data method names (`findTop10ByGenreIgnoreCaseOrderByPriceAsc`, etc.); preserve naming style.
- Portuguese domain/error messages are common; keep message language consistent when extending existing handlers.

## Data + Audit Behavior
- Liquibase seeds sample product data by default (`002-insert-test-data.yaml`), so non-empty DB is expected after first startup.
- Audit/history tables and triggers are created in migrations (`003-create-history-tables.yaml`, `004-create-triggers.yaml`).
- Product INSERT/UPDATE/DELETE writes into `product_hist`; price changes also write to `price_history` via PostgreSQL trigger function.

## Integration Points
- PostgreSQL connection defaults: `jdbc:postgresql://localhost:5432/bookanga_db`, user `bookanga`, password `bookanga123`.
- Docker overrides datasource host to `bookanga-postgres` for container-to-container networking.
- `run-local.sh` auto-loads `.env.local` when present (for example `SPRING_DATASOURCE_URL=...`) before `mvn spring-boot:run`.
- Health/status endpoints to verify environment quickly:
  - `GET /api/status` (`StatusController` custom DB + app status)
  - `GET /actuator/health`
  - `GET /actuator/prometheus`
- Postman collection for endpoint smoke tests: `postman/Bookanga-API.postman_collection.json`.

## Existing AI Guidance Sources Checked
- `.github/copilot-instructions.md`
- `.github/git-commit-instructions.md`
- `.github/agents/copilot-qa.agent.md`
- `AGENTS.md` (this file)
- `README.md`
- `postman/README.md`
- `utils/scripts/README.md`
