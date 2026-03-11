---
name: java-scaffold-skill
description: Scaffolding for Java projects with Spring Boot or Quarkus, PostgreSQL, RabbitMQ, LangChain4j AI, and Docker. Generates pom.xml, BCE package structure, Flyway migrations, architecture tests (Taikai), Dockerfile, and docker-compose. Supports AI business applications with LangChain4j (AI Services, Tools/Function Calling, RAG, Guardrails). Use this skill for new Java applications, new entities, Dockerfiles, docker-compose, architecture tests, AI services, or AI integrations – also for "create a new project", "scaffold", "new module", "new entity", "AI Service", "Chatbot", "RAG", "LangChain4j".
argument-hint: "[framework] [description]"
---

# Java Scaffold Skill

Scaffolding for Java projects with Spring Boot or Quarkus – including AI support via LangChain4j.

> **Philosophy:** Before every generation: check lessons-learned.md + query current versions
> from the internet – never use outdated versions from memory.

---

## What This Skill Does

1. **Queries project coordinates** – groupId, artifactId, framework (Spring Boot / Quarkus)
2. **Checks current versions** – Verify Spring Boot, Quarkus, Taikai, LangChain4j online
3. **Generates project structure** – pom.xml, application.properties, docker-compose.yml
4. **Creates BCE layers** – Entity, Repository, Service, Controller/Resource in BCE pattern
5. **Creates AI layers** (optional) – AI Service, Tools, RAG, Guardrails via LangChain4j
6. **Creates Flyway migration** – Initial SQL schema matching the entity
7. **Creates infrastructure** – Dockerfile, health checks, Swagger UI, Renovate config
8. **Creates architecture tests** – Taikai-based ArchitectureTest (incl. AI layer rules)

## How to Use

```
Create a new Quarkus project with PostgreSQL and AI support (LangChain4j)
```

```
Create a business application with chatbot and RAG (document search)
```

```
Create a new Spring Boot project with PostgreSQL and RabbitMQ
```

```
Create a new entity "Product" with name and price
```

```
Generate an AI service with tool integration for my Quarkus project
```

---

## Instructions

> **Before every generation**:
> 1. Check `.claude/lessons-learned.md`
> 2. **Query current versions from the internet** (Maven Central / GitHub Releases) – never use outdated versions from memory!

### Step 1 – Required Query

Before every new application or module – if not already known – **always ask all
the following questions before generating code**:

#### 1a – Project Coordinates

| # | Field | Example |
|---|-------|---------|
| 1 | `groupId` | `com.example.orders` |
| 2 | `artifactId` | `order-service` |
| 3 | **Framework** | `Spring Boot` or `Quarkus` |

#### 1b – OpenAPI Spec Available? (optional)

**Ask before scaffolding:** Is there an OpenAPI specification for this project?

- **Yes** → run `openapi-skill` first; then during scaffold
  **do not** regenerate `boundary/rest/` and `entity/dto/` – only the framework
  (pom.xml, docker-compose, application.properties, Flyway, architecture test, Dockerfile).
- **No** → proceed normally, generate all layers.

#### 1c – Required Services

Explicitly ask which services are actually needed:

| Service | Dependency (Spring) | Dependency (Quarkus) | Default |
|---------|---------------------|----------------------|---------|
| **Database** (PostgreSQL) | `spring-boot-starter-data-jpa`, `postgresql`, `spring-boot-starter-flyway`, `flyway-database-postgresql` | `quarkus-hibernate-orm-panache`, `quarkus-jdbc-postgresql`, Flyway | Yes |
| **REST / Swagger UI** | `springdoc-openapi-starter-webmvc-ui` | `quarkus-smallrye-openapi` | **Yes** (always for REST) |
| **Messaging** (RabbitMQ) | `spring-boot-starter-amqp` | `quarkus-messaging-rabbitmq` | No |
| **Auth / IAM** (Keycloak) | `spring-boot-starter-oauth2-resource-server` | `quarkus-oidc` | No |

Only confirmed services are included in `pom.xml`, `docker-compose.yml`, and `application.properties`.
Unneeded services are omitted entirely – no commented-out blocks.

Never guess or use defaults – always ask explicitly.

#### 1d – AI Support (LangChain4j) – optional

**Ask:** Should the application include AI functionality (LLM integration)?

If **Yes**, query the following details:

| # | Field | Options | Default |
|---|-------|---------|---------|
| 1 | **LLM Provider** | `OpenAI`, `Ollama` (local), `Anthropic` (Claude) | OpenAI |
| 2 | **AI Features** | `Chat` (simple AI service), `Tools` (function calling), `RAG` (document search), `Guardrails` (input/output validation), `Agents` (agentic workflows) | Chat |
| 3 | **RAG Vector Store** (only for RAG) | `PgVector` (PostgreSQL), `Chroma`, `Redis` | PgVector |
| 4 | **Fault Tolerance** (production) | `Yes` / `No` | No |

**AI Profile Overview (Quarkus):**

| Profile | Description | Dependencies | Templates |
|---------|-------------|-------------|-----------|
| **Chat** | Simple AI service with system/user prompt | `quarkus-langchain4j-{provider}` | AiService, AiResource |
| **Chat + Tools** | AI service with function calling (DB access, REST calls) | + no extra dep (part of core) | + AiTool |
| **Chat + RAG** | AI service with document search (vector database) | + `quarkus-langchain4j-pgvector` | + RagIngestion, RagRetriever |
| **Chat + Guardrails** | AI service with input/output validation | + no extra dep (part of core) | + AiGuardrail |
| **Agentic** | Autonomous agents with workflow orchestration | + `quarkus-langchain4j-agentic` | Agent, AgentWorkflow |
| **Fault Tolerant** | Production-ready setup with retry/timeout/fallback | + `quarkus-smallrye-fault-tolerance` | AiServiceWithFaultTolerance, AiServiceFallback |
| **Complete** | All features combined | All above | All templates |

### Step 2 – Version Check

Outdated dependency versions lead to incompatibilities and security vulnerabilities. Therefore, check current versions online before every code generation:

| Artifact | Where to check |
|----------|----------------|
| Spring Boot Parent POM | https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent |
| Quarkus BOM | https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom |
| Taikai | https://central.sonatype.com/artifact/com.enofex/taikai |
| versions-maven-plugin | https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin |
| quarkus-langchain4j | https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-openai |

**Known versions (as of 2026-03-01 – always verify online!):**

| Artifact | Version | Java 25 compatible |
|----------|---------|-------------------|
| Spring Boot | 4.0.3 | Yes (full Java 25 support) |
| Quarkus | 3.31.4 | Yes (full Java 25 support since 3.31) |
| Taikai | 1.60.0 | Yes |
| versions-maven-plugin | 2.21.0 | Yes |
| quarkus-langchain4j | 1.8.0.CR1 | Yes (check before generation!) |

> **Quarkus 3.27 (LTS) technically runs with Java 25 but produces warnings.**
> For Java 25, **Quarkus 3.31+** is required.

### Step 3 – Generate Code

Generation order:

1. `pom.xml` with all dependencies, versions-maven-plugin, Taikai
2. `application.properties` (DB, Flyway, health, optionally messaging, auth, AI)
3. Entity + Repository (`entity/`)
4. Service (`control/`)
5. Controller/Resource (`boundary/rest/`)
6. Consumer (`boundary/messaging/`) – only if RabbitMQ confirmed
7. Security config – only if Keycloak confirmed
8. **AI Service** (`boundary/ai/`) – only if AI support confirmed
9. **AI Tools** (`control/ai/`) – only if tools confirmed
10. **RAG Components** (`control/ai/`) – only if RAG confirmed
11. **Guardrails** (`control/ai/`) – only if guardrails confirmed
12. **AI REST Endpoint** (`boundary/rest/`) – if AI support confirmed
13. Flyway migration (`db/migration/V1__create_<entity>_table.sql`)
14. Architecture test (`ArchitectureTest.java`) – incl. AI layer rules if AI support
15. Dockerfile (Spring: root, Quarkus: `src/main/docker/Dockerfile.jvm`)
16. `docker-compose.yml` with health checks (for AI: `docker-compose-ai.yml` with PgVector/Ollama)
17. `renovate.json`

### Step 3a – AI Dependencies (Quarkus + LangChain4j)

For AI support, include the following dependencies in `pom.xml`:

**LLM Provider (choose exactly ONE):**

| Provider | Dependency (groupId:artifactId) | Version |
|----------|-------------------------------|---------|
| **OpenAI** (or compatible API) | `io.quarkiverse.langchain4j:quarkus-langchain4j-openai` | Part of Quarkiverse BOM |
| **Ollama** (local) | `io.quarkiverse.langchain4j:quarkus-langchain4j-ollama` | Part of Quarkiverse BOM |
| **Anthropic** (Claude) | `io.quarkiverse.langchain4j:quarkus-langchain4j-anthropic` | Part of Quarkiverse BOM |

**RAG – Vector Store (only for RAG feature):**

| Store | Dependency | Note |
|-------|-----------|------|
| **PgVector** | `io.quarkiverse.langchain4j:quarkus-langchain4j-pgvector` | Uses existing PostgreSQL DB |
| **Easy RAG** | `io.quarkiverse.langchain4j:quarkus-langchain4j-easy-rag` | Simplest variant, auto-ingestion from directory |
| Chroma | `io.quarkiverse.langchain4j:quarkus-langchain4j-chroma` | External service needed |
| Redis | `io.quarkiverse.langchain4j:quarkus-langchain4j-redis` | External service needed |

**Agentic Workflows (only for agents feature):**

| Feature | Dependency | Note |
|---------|-----------|------|
| Agentic | `io.quarkiverse.langchain4j:quarkus-langchain4j-agentic` | @Agent, workflow patterns |
| MCP Client | `io.quarkiverse.langchain4j:quarkus-langchain4j-mcp` | Remote tools via Model Context Protocol |

**Fault Tolerance (recommended for production):**

| Feature | Dependency | Note |
|---------|-----------|------|
| Fault Tolerance | `io.quarkus:quarkus-smallrye-fault-tolerance` | @Timeout, @Retry, @Fallback |

**Quarkiverse BOM** – use the BOM instead of individual versions:
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.quarkiverse.langchain4j</groupId>
            <artifactId>quarkus-langchain4j-bom</artifactId>
            <version><!-- CHECK BEFORE GENERATION: https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-bom --></version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### Step 3b – AI Package Structure (BCE)

AI components follow the BCE pattern with dedicated sub-packages:

```
src/main/java/{{GROUP_ID}}/
├── boundary/
│   ├── ai/              ← AI Services (@RegisterAiService interfaces)
│   ├── rest/            ← REST endpoints (incl. AI resource)
│   └── messaging/       ← RabbitMQ consumers (optional)
├── control/
│   ├── ai/              ← AI Tools, RAG, Guardrails
│   └── ...              ← Business services
└── entity/
    └── ...              ← JPA entities, DTOs
```

**Architecture rules for AI layers:**
- `@RegisterAiService` interfaces → `boundary/ai/`
- `@Tool` classes → `control/ai/`
- RAG components (ingestion, retriever) → `control/ai/`
- Guardrails → `control/ai/`
- AI REST endpoints → `boundary/rest/`

### Step 3c – AI application.properties

Use AI-specific properties from template `templates/quarkus/ai/application-ai.properties` as reference.
**When generating, only include the chosen provider** – the template contains all three providers as reference,
but only the chosen provider is included in the generated `application.properties` (without commented-out alternatives).

Important configuration per provider:

| Provider | API Key Property | Model Property |
|----------|-----------------|---------------|
| OpenAI | `quarkus.langchain4j.openai.api-key` | `quarkus.langchain4j.openai.chat-model.model-name` |
| Ollama | (no key needed) | `quarkus.langchain4j.ollama.chat-model.model-id` |
| Anthropic | `quarkus.langchain4j.anthropic.api-key` | `quarkus.langchain4j.anthropic.chat-model.model-name` |

**Disable AI Dev Services** (real services via Docker Compose):
```properties
quarkus.langchain4j.ollama.devservices.enabled=false
```

### Step 4 – Swagger UI

Every application with REST endpoints gets a **Swagger UI**:

| Framework | Dependency (groupId:artifactId) | Swagger UI URL | OpenAPI JSON URL |
|-----------|---------------------------------|---------------|-----------------|
| **Spring Boot** | `org.springdoc:springdoc-openapi-starter-webmvc-ui` | `/swagger-ui.html` | `/v3/api-docs` |
| **Quarkus** | `io.quarkus:quarkus-smallrye-openapi` | `/q/swagger-ui` | `/q/openapi` |

**Check versions before generation:**
- Spring Boot: https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-starter-webmvc-ui
- Quarkus: Part of the Quarkus BOM – no separate version needed

**Important with Security (Spring Boot):** The `SecurityConfig` must explicitly
permit Swagger UI paths (already included in template):
```java
.requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**").permitAll()
```

**Important for Quarkus:** Enable `quarkus.swagger-ui.always-include=true` so the
Swagger UI remains available in production mode (not just `quarkus:dev`).

### Step 5 – Health Checks

Health endpoints are the foundation for Docker health checks and Kubernetes probes. Without them, neither Docker nor an orchestrator can check the application's state:

| Framework | Endpoint | Dependency |
|-----------|----------|-----------|
| Spring Boot | `/actuator/health` | `spring-boot-starter-actuator` |
| Quarkus | `/q/health/live`, `/q/health/ready` | `quarkus-smallrye-health` |

Health checks are used in:
- `HEALTHCHECK` in Dockerfile
- `healthcheck` in `docker-compose.yml`

### Step 6 – Architecture Tests

Architecture tests with Taikai ensure that BCE layer separation is maintained even as the project grows. Template: `templates/arch/ArchitectureTest.java.template`

For AI projects, the ArchitectureTest contains additional rules:
- `@RegisterAiService` interfaces must reside in `boundary.ai`
- `@Tool` classes must reside in `control.ai`

```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version><!-- CHECK CURRENT VERSION BEFORE GENERATION: https://central.sonatype.com/artifact/com.enofex/taikai --></version>
    <scope>test</scope>
</dependency>
```

### Step 7 – versions-maven-plugin

The versions-maven-plugin enables developers to detect outdated dependencies locally – complementing Renovate for the CI/CD workflow. Configure in every `pom.xml` in the `<build><pluginManagement>` block:

```xml
<build>
  <pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>versions-maven-plugin</artifactId>
        <version><!-- CURRENT VERSION: https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin --></version>
        <configuration>
          <generateBackupPoms>false</generateBackupPoms>
        </configuration>
      </plugin>
    </plugins>
  </pluginManagement>
</build>
```

Useful commands for developers:
```bash
./mvnw versions:display-dependency-updates
./mvnw versions:display-plugin-updates
./mvnw versions:display-parent-updates
```

### Step 8 – Renovate

Renovate automatically creates pull requests for dependency updates and keeps the project current. Every generated project receives `renovate.json` from `templates/renovate.json`.

---

## References

| File | Description |
|------|-------------|
| `.claude/lessons-learned.md` | Findings and corrections – check before every generation |
| [templates/spring/](templates/spring/) | Spring Boot templates (Entity, Controller, Service, Consumer, Security, Dockerfile, Properties, docker-compose) |
| [templates/quarkus/](templates/quarkus/) | Quarkus templates (Entity, Resource, Service) + `src-main-docker/` for Dockerfiles |
| [templates/quarkus/ai/](templates/quarkus/ai/) | **Quarkus AI templates** (AI Service, Tools, RAG, Guardrails, Properties, docker-compose) |
| [templates/arch/ArchitectureTest.java.template](templates/arch/ArchitectureTest.java.template) | Taikai-based architecture test (incl. AI layer rules) |
| [templates/db/V1__create_table.sql.template](templates/db/V1__create_{{ENTITY_NAME_LOWER}}_table.sql.template) | Initial Flyway migration |
| [templates/renovate.json](templates/renovate.json) | Renovate configuration for automatic dependency updates |

### AI Templates (Quarkus + LangChain4j)

| Template | Package | Description |
|----------|---------|-------------|
| [AiService.java.template](templates/quarkus/ai/AiService.java.template) | `boundary.ai` | Simple declarative AI service (`@RegisterAiService`) |
| [AiServiceWithTools.java.template](templates/quarkus/ai/AiServiceWithTools.java.template) | `boundary.ai` | AI service with `@ToolBox` integration |
| [AiServiceWithRag.java.template](templates/quarkus/ai/AiServiceWithRag.java.template) | `boundary.ai` | AI service with RAG (RetrievalAugmentor) |
| [AiTool.java.template](templates/quarkus/ai/AiTool.java.template) | `control.ai` | Tool class with `@Tool` annotation for function calling |
| [RagIngestion.java.template](templates/quarkus/ai/RagIngestion.java.template) | `control.ai` | Document ingestion at startup (EmbeddingStore) |
| [RagRetriever.java.template](templates/quarkus/ai/RagRetriever.java.template) | `control.ai` | RetrievalAugmentor supplier for PgVector |
| [AiGuardrail.java.template](templates/quarkus/ai/AiGuardrail.java.template) | `control.ai` | Input/output guardrails for validation |
| [Agent.java.template](templates/quarkus/ai/Agent.java.template) | `boundary.ai` | Autonomous agent with `@Agent` and `@ToolBox` |
| [AgentWorkflow.java.template](templates/quarkus/ai/AgentWorkflow.java.template) | `boundary.ai` | Workflow orchestration (Sequence, Parallel, Loop, Supervisor) |
| [AiServiceWithFaultTolerance.java.template](templates/quarkus/ai/AiServiceWithFaultTolerance.java.template) | `boundary.ai` | AI service with `@Timeout`, `@Retry`, `@Fallback` |
| [AiServiceFallback.java.template](templates/quarkus/ai/AiServiceFallback.java.template) | `control.ai` | Fallback handler for LLM failures |
| [AiResource.java.template](templates/quarkus/ai/AiResource.java.template) | `boundary.rest` | REST endpoint `/ai/chat` for the AI service |
| [application-ai.properties](templates/quarkus/ai/application-ai.properties) | – | AI-specific properties (provider, RAG, guardrails) |
| [docker-compose-ai.yml](templates/quarkus/ai/docker-compose-ai.yml) | – | Docker Compose with PgVector and optional Ollama |

### Placeholders

| Placeholder | Example |
|-------------|---------|
| `{{GROUP_ID}}` | `com.example.orders` |
| `{{ARTIFACT_ID}}` | `order-service` |
| `{{PACKAGE_PATH}}` | `com/example/orders` |
| `{{ENTITY_NAME}}` | `Order` |
| `{{ENTITY_NAME_LOWER}}` | `order` |
| `{{CHANNEL_IN}}` | `orders-in` |
| `{{CHANNEL_OUT}}` | `orders-out` |
| `{{AI_SERVICE_NAME}}` | `OrderAssistant` |
| `{{TOOL_CLASS_NAME}}` | `OrderTools` |
| `{{TOOL_METHOD_NAME}}` | `findOrderById` |
| `{{RAG_INGESTION_CLASS}}` | `DocumentIngestion` |
| `{{RAG_RETRIEVER_CLASS}}` | `DocumentRetriever` |
| `{{INPUT_GUARDRAIL_NAME}}` | `InputValidator` |
| `{{AI_RESOURCE_NAME}}` | `AiResource` |
| `{{AGENT_NAME}}` | `OrderAgent` |
| `{{AGENT_DESCRIPTION}}` | `Order specialist` |
| `{{AGENT_TASK_DESCRIPTION}}` | `Process the following order request` |
| `{{WORKFLOW_NAME}}` | `OrderWorkflow` |
| `{{DOMAIN_DESCRIPTION}}` | `Order management` |

---

## Conventions

- **Stack:** Java 25 · Spring Boot 4.x or Quarkus 3.31+ · PostgreSQL 17 · RabbitMQ 4 · Keycloak 26.x · Maven 3.9 · Docker
- **AI Stack:** Quarkus LangChain4j · OpenAI / Ollama / Anthropic · PgVector (RAG)
- **Architecture:** BCE pattern strict (Boundary / Control / Entity)
- **AI Architecture:** AI Services in `boundary/ai/`, Tools + RAG + Guardrails in `control/ai/`
- **Entities:** Lombok `@Data` + `@Builder` – `maven-compiler-plugin` must configure Lombok as `annotationProcessorPath`
- **Persistence:** Flyway for all migrations – no `ddl-auto=create`
- **Messaging:** RabbitMQ consumers always in `boundary/messaging/`; Quarkus: `@Blocking` + `@Transactional` for DB access in consumers
- **AI Tools:** `@Blocking` + `@Transactional` for database access in tools
- **Dockerfile:** Spring Boot → `./Dockerfile` (root); Quarkus → `src/main/docker/Dockerfile.jvm`
- **Docker Compose AI:** `pgvector/pgvector:pg17` instead of `postgres:17-alpine` (PgVector extension pre-installed)
- **Examples:** Domain-neutral (`order`, `product`, `event`, `item`)
- **Language:** English in comments/docs and code
- **Commits:** Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via java-scaffold-skill`

### Position in Workflow

```
[spec-feature-skill]      optional – business requirements
        |
[openapi-skill]           if OpenAPI spec available
        |
[java-scaffold-skill]     framework: DB, messaging, AI, infra
        |
[review-skill]            code review
        |
[doc-skill]               project documentation
```
