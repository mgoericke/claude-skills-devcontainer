# Project Context for Claude Code

DevContainer template for Java projects with Spring Boot or Quarkus.

## Stack

| Layer | Technology |
|-------|------------|
| Backend | Java 25 + **Spring Boot 4.x** or **Quarkus 3.31+** |
| Database | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build | Maven 3.9.x |
| Architecture | Taikai (based on ArchUnit) |
| Auth / IAM | Keycloak 26.x |
| AI | Quarkus LangChain4j (OpenAI, Ollama, Anthropic) + PgVector |
| Infrastructure | Docker + Docker Compose |

## Skills & Knowledge Management

Skills: `.claude/skills/` – loaded automatically.
Findings and corrections: **always** record in `.claude/lessons-learned.md`.
Check `lessons-learned.md` before every generation.

| Skill | Trigger |
|-------|---------|
| `coworker-skill` | End-to-end project setup, phase-based with review |
| `java-scaffold-skill` | New project, new entity, Dockerfile, docker-compose, AI Service, LangChain4j |
| `spec-feature-skill` | Specify a feature before code is written |
| `openapi-skill` | Create, extend, or generate code from an OpenAPI spec |
| `review-skill` | Code review, quality check, review changed code |
| `doc-skill` | Create or update project documentation |
| `infografik-skill` | Infographic, visualization, diagram |
| `blog-post-skill` | Blog post, article, technical contribution |
| `frontend-skill` | Web UIs: Dashboards (TailAdmin), Landing Pages, SPAs (Tailwind CSS) |
| `skill-creator` | Create new skills, optimize existing skills, measure skill performance |

## Version Strategy (MANDATORY)

**Before every code generation**, dependency versions must be looked up on the internet.
Versions from memory are forbidden – they may be outdated.

Mandatory URLs:
- Spring Boot: https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent
- Quarkus: https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom
- Taikai: https://central.sonatype.com/artifact/com.enofex/taikai
- LangChain4j (for AI projects): https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-bom

Every generated `pom.xml` must contain:
- `versions-maven-plugin` (local version check via `./mvnw versions:display-dependency-updates`)
- `renovate.json` in the project root (automatic update PRs via Renovate Bot)

## Coding Standards

- **Architecture**: BCE pattern (Boundary / Control / Entity)
- **Architecture Tests**: Taikai – create for every new project (MANDATORY)
- **Health Checks**: Every application must expose `/actuator/health` (Spring) or `/q/health` (Quarkus) (MANDATORY)
- **Persistence**: Flyway – no `ddl-auto=create`
- **Messaging (Quarkus)**: SmallRye `mp.messaging.*` keys – details in `lessons-learned.md`
- **Quarkus `@Blocking`**: For DB access in `@Incoming` consumers and `@Tool` methods, always use `@Blocking @Transactional`
- **AI Architecture**: AI Services in `boundary/ai/`, Tools + RAG + Guardrails in `control/ai/`
- **Branches**: New features ALWAYS in a separate branch – never directly on `main`
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Language**: English in comments/docs and code
- **Examples**: Domain-neutral (`order`, `product`, `event`, `item`) – no domain-specific names

## Javadoc Co-Author

Every generated Java file must contain:
```
@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via java-scaffold-skill
```
Properties/YAML files as comment: `# Co-Author: Claude (claude-sonnet-4-6, Anthropic)`

## Dockerfile Conventions

| Framework | Location |
|-----------|----------|
| Spring Boot | `./Dockerfile` (project root) |
| Quarkus | `src/main/docker/Dockerfile.jvm` (Quarkus convention) |

## Sub-Agents for Parallel Reviews & AI Service Generation

Specialized sub-agents in `.claude/agents/`:
- **security-reviewer**: Security analysis (secrets, auth, input validation, OWASP)
- **architecture-reviewer**: BCE pattern & Taikai compliance
- **performance-reviewer**: N+1 queries, blocking operations, memory leaks
- **ai-service-generator**: LangChain4j AI service scaffolding with tools, RAG, guardrails

**Benefits**: Review in parallel after code changes or generate new AI services.
**Docs**: See [docs/sub-agents.md](docs/sub-agents.md)

## Notes

- `groupId`, `artifactId`, and framework must **always** be asked before scaffolding starts
- ANTHROPIC_API_KEY is optional – alternatively use `claude login` after container start
- GIT_TOKEN (not GITHUB_TOKEN) for Git registries of all providers
- Dev Services for Quarkus are disabled – real services via `docker compose up`
- Maven `.m2` cache is persistent (Docker volume)
