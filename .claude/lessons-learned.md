# Lessons Learned

Findings, corrections, and decisions from working with this template.
Claude Code checks this file before every generation.

---

## Quarkus – RabbitMQ Messaging Config

**Problem:** Wrong property keys for RabbitMQ configuration.

**Correct (SmallRye Reactive Messaging, `quarkus-messaging-rabbitmq`):**
```properties
# Global broker connection
rabbitmq-host=localhost
rabbitmq-port=5672
rabbitmq-username=app
rabbitmq-password=app

# Channel mapping – incoming → Queue, outgoing → Exchange
mp.messaging.incoming.[channel-name].connector=smallrye-rabbitmq
mp.messaging.incoming.[channel-name].queue.name=[queue-name]
mp.messaging.outgoing.[channel-name].connector=smallrye-rabbitmq
mp.messaging.outgoing.[channel-name].exchange.name=[exchange-name]
```

**Wrong (do not use):**
```properties
RABBITMQ_HOST=...         # Docker Compose environment variables only
quarkus.rabbitmq.*=...    # Quarkiverse RabbitMQ Client – different product!
```

**Disable Dev Services – per extension, not globally:**
```properties
quarkus.rabbitmq.devservices.enabled=false   # RabbitMQ
quarkus.datasource.devservices.enabled=false  # PostgreSQL
```
`quarkus.devservices.enabled=false` does **not** work for RabbitMQ.

Dependency:
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-messaging-rabbitmq</artifactId>
</dependency>
```
Source: https://quarkus.io/guides/rabbitmq-reference

---

## Quarkus – @Blocking in Consumer

`@Incoming` methods run on I/O threads. For JPA/DB access **always**:
```java
@Incoming("orders-in")
@Blocking
@Transactional
public void handle(String payload) { ... }
```
Without `@Blocking` → Deadlock or IllegalStateException during JPA operations.

---

## Quarkus – Dockerfile Convention

Quarkus places Dockerfiles by convention in `src/main/docker/`:
- `Dockerfile.jvm` – Fast-JAR (default)
- `Dockerfile.native-micro` – GraalVM Native Image

**Do not** place in the project root (that is the Spring Boot convention).

Docker Compose references:
```yaml
dockerfile: src/main/docker/Dockerfile.jvm
```

Typical build flow:
```bash
./mvnw package -DskipTests
docker build -f src/main/docker/Dockerfile.jvm -t my-service .
```

---

## Health Checks Are Mandatory

Every application must expose health endpoints:

| Framework | Endpoint | Activation |
|-----------|----------|------------|
| Spring Boot | `/actuator/health` | `spring-boot-starter-actuator` + `management.endpoint.health.probes.enabled=true` |
| Quarkus | `/q/health/live`, `/q/health/ready` | `quarkus-smallrye-health` |

Health checks are used in:
- `HEALTHCHECK` directive in Dockerfile
- `healthcheck` block in `docker-compose.yml` for the application itself

---

## DevContainer – Dev Services vs. Docker Compose

Quarkus Dev Services automatically start PostgreSQL and RabbitMQ via Testcontainers.
In DevContainer (Docker-in-Docker) this can conflict with Docker Desktop.
→ Disable Dev Services per extension, start real services via `docker compose up`.

---

## ANTHROPIC_API_KEY Is Optional

The key can be set via environment variable **or** the developer
logs in directly after container start:
```bash
claude login
```
No longer a required field in `devcontainer.json`.

---

## GIT_TOKEN Instead of GITHUB_TOKEN

The token for Git registries (GitHub Packages, GitLab Registry, Gitea, Bitbucket) is called
`GIT_TOKEN` – not `GITHUB_TOKEN`. This avoids implying vendor lock-in.

---

## Taikai vs. ArchUnit

- **Taikai** – based on ArchUnit, less boilerplate, Quarkus-specific rules built in → prefer this
- **ArchUnit** – more direct, more flexibility for complex custom rules

**Note:** Taikai's `NamingConfigurer` does **not** have `classesShouldMatch(String package, String regex)`.
For package-specific naming rules (e.g. "Controllers only in boundary.rest") use ArchUnit directly:
```java
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;

ArchRule rule = classes()
        .that().haveSimpleNameEndingWith("Controller")
        .should().resideInAPackage("..boundary.rest..");
rule.check(importedClasses);
```
ArchUnit is provided transitively via Taikai – no additional dependency needed.

Dependency (`test` scope only!):
```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version>1.60.0</version><!-- As of 2026-03-01 – check online before generation! -->
    <scope>test</scope>
</dependency>
```
Check current version: https://central.sonatype.com/artifact/com.enofex/taikai
Source: https://www.the-main-thread.com/p/architecture-testing-java-quarkus-taikai

---

## Javadoc Co-Author Mandatory

Every generated file receives a co-author note:
```java
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via java-scaffold
```
In properties/YAML as comment:
```
# Co-Author: Claude (claude-sonnet-4-6, Anthropic)
```

---

## Domain-Neutral Examples

Templates use neutral domain terms: `order`, `product`, `event`, `item`.
No domain-specific names like `Antrag`, `Akte`, `Buergerservice` in templates.

---

## Version Requirement – Check Online Before Every Generation

**Never use versions from memory.** Before each scaffold, query current
versions from the internet. Known versions (as of 2026-03-01):

| Artifact | Version | Source |
|----------|---------|--------|
| Spring Boot | 4.0.3 | https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent |
| Quarkus BOM | 3.31.4 | https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom |
| Taikai | 1.60.0 | https://central.sonatype.com/artifact/com.enofex/taikai |
| versions-maven-plugin | 2.21.0 | https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin |

---

## Quarkus – Java 25 Compatibility

**Quarkus 3.27 (LTS)** technically runs with Java 25 but produces warnings.
For Java 25, **Quarkus 3.31+ is required** (full Java 25 support since 3.31.0).

---

## Spring Boot 4.x – Breaking Changes vs. 3.x

Spring Boot 4.0 (November 2025) brings:
- Based on **Spring Framework 7** and **Jakarta EE 11**
- Servlet 6.1 as baseline (Servlet 5.x no longer supported)
- **Full Java 25 support**
- **Modularized auto-configuration** (smaller, focused JARs)

**IMPORTANT – Modularization:** In Spring Boot 4.x, `flyway-core` alone is NO LONGER sufficient
for auto-configuration. Instead of `flyway-core`, use `spring-boot-starter-flyway`:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-flyway</artifactId>
</dependency>
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-database-postgresql</artifactId>
</dependency>
```
Without `spring-boot-starter-flyway`, Flyway will not start and Hibernate `validate`
fails with "missing table".

Migration from 3.x: https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Migration-Guide

---

## Keycloak – Configuration for Spring Boot and Quarkus

Keycloak runs in dev mode (`start-dev`) with H2 file-based database (dev-file).
No external database server needed – data is stored in the container (not persistent).

**Port:** 8180 (external) → 8080 (internal in container)
**Admin access (dev only):** http://localhost:8180 · `admin` / `admin`

### Spring Boot – Resource Server (JWT)

Dependency:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

`application.properties`:
```properties
spring.security.oauth2.resourceserver.jwt.issuer-uri=http://localhost:8180/realms/<realm-name>
```

### Quarkus – OIDC

Dependency:
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-oidc</artifactId>
</dependency>
```

`application.properties`:
```properties
quarkus.oidc.auth-server-url=http://keycloak:8080/realms/<realm-name>
quarkus.oidc.client-id=<client-id>
quarkus.oidc.application-type=service
# LOCAL DEVELOPMENT ONLY – never use in staging or production.
# In production, use a valid TLS certificate and remove this line entirely.
%dev.quarkus.oidc.tls.verification=none
```

> **Note:** In docker-compose, the application uses the service name `keycloak:8080` (internal).
> For local development outside Docker: `localhost:8180`.

### Keycloak – Production Configuration (PostgreSQL)

For production, switch KC_DB to postgres.
**Never use default credentials in any network-accessible environment, including internal staging.**
```yaml
environment:
  KC_DB: postgres
  KC_DB_URL: jdbc:postgresql://postgres:5432/keycloakdb
  KC_DB_USERNAME: ${KC_DB_USERNAME}                    # REQUIRED: set via environment variable
  KC_DB_PASSWORD: ${KC_DB_PASSWORD}                    # REQUIRED: set via environment variable
  KEYCLOAK_ADMIN: ${KEYCLOAK_ADMIN}                    # REQUIRED: set via environment variable
  KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD}  # REQUIRED: set via environment variable
command: start --optimized
```

---

## Spring Boot – ddl-auto=validate Fails on Empty Database

**Problem:** `spring.jpa.hibernate.ddl-auto=validate` throws an error on first start
when no Flyway migration exists and the database is empty – Hibernate finds
no tables to validate.

**Wrong (do not use):**
```properties
spring.jpa.hibernate.ddl-auto=update  # Hibernate manages the schema → no clear migration history
spring.jpa.hibernate.ddl-auto=create  # Deletes data on every start
```

**Correct (Option B – always generate initial migration):**
```properties
spring.jpa.hibernate.ddl-auto=validate  # Hibernate only checks; Flyway manages the schema
```

For every entity, **always** create an initial Flyway migration:
```
src/main/resources/db/migration/V1__create_<entity>_table.sql
```

Template available at: `templates/db/V1__create_{{ENTITY_NAME_LOWER}}_table.sql.template`

Flyway runs the migration before Hibernate → schema exists → validate works.

---

## Renovate vs. versions-maven-plugin

| Tool | Type | Purpose |
|------|------|---------|
| **Renovate** | GitHub/GitLab Bot | Automatically creates PRs for dependency updates; configured via `renovate.json` in project root |
| **versions-maven-plugin** | Maven plugin in `pom.xml` | Local version check via `./mvnw versions:display-dependency-updates` |

Both complement each other. Renovate is **not** a Maven dependency – it is an external service.
GitHub App: https://github.com/apps/renovate

---

## Lombok – Annotation Processor Mandatory (Spring Boot + Maven)

**Problem:** Lombok `@Data`, `@Builder` etc. generate getters/setters at compile time.
Without explicit annotation processor configuration in `maven-compiler-plugin`,
the compiler cannot find the generated methods → `cannot find symbol` for getters/setters.

**Solution:** In the `<build><plugins>` block, configure `maven-compiler-plugin` with Lombok as
`annotationProcessorPath`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <configuration>
        <annotationProcessorPaths>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

**Additionally:** Exclude Lombok from the final JAR (Spring Boot Maven Plugin):
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <excludes>
            <exclude>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
            </exclude>
        </excludes>
    </configuration>
</plugin>
```

Both plugin entries are **MANDATORY** for every Spring Boot project with Lombok.

---

## Quarkus LangChain4j – AI Integration

### Dependencies and BOM

Use the **Quarkiverse LangChain4j BOM** instead of individual versions:
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.quarkiverse.langchain4j</groupId>
            <artifactId>quarkus-langchain4j-bom</artifactId>
            <version><!-- CHECK: https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-bom --></version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

LLM provider extensions:
- `io.quarkiverse.langchain4j:quarkus-langchain4j-openai` (OpenAI + compatible APIs)
- `io.quarkiverse.langchain4j:quarkus-langchain4j-ollama` (local LLM)
- `io.quarkiverse.langchain4j:quarkus-langchain4j-anthropic` (Claude)

RAG vector store:
- `io.quarkiverse.langchain4j:quarkus-langchain4j-pgvector` (recommended, uses existing PostgreSQL)

Check current version: https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-openai

---

## Quarkus LangChain4j – AI Service Patterns

### @RegisterAiService

Declarative AI Services are created as interfaces with `@RegisterAiService`.
Quarkus generates the implementation at build time:

```java
@SessionScoped  // or @ApplicationScoped
@RegisterAiService
public interface MyAssistant {
    @SystemMessage("You are a helpful assistant.")
    String chat(@UserMessage String userMessage);
}
```

**Scope choice:**
- `@SessionScoped` → separate chat memory per session (WebSocket, HTTP session)
- `@ApplicationScoped` → shared, no memory (or explicit @MemoryId)

**Register tools:** Via `@ToolBox` on the method or `tools=` on the interface:
```java
@ToolBox(MyTool.class)
String chat(@UserMessage String message);
```

---

## Quarkus LangChain4j – Tools / Function Calling

**Important:** `@Tool` methods with database access always require `@Blocking` + `@Transactional`:
```java
@Tool("Description for the LLM")
@Blocking
@Transactional
public String findOrder(long orderId) { ... }
```

Without `@Blocking` → same error as with `@Incoming` (deadlock on I/O thread).

Tool classes are CDI beans (`@ApplicationScoped`) and reside in `control/ai/`.
Tool descriptions must be precise – the LLM decides based on the description.

---

## Quarkus LangChain4j – RAG with PgVector

**Docker image:** Use `pgvector/pgvector:pg17` instead of `postgres:17-alpine`,
so the PgVector extension is pre-installed.

**Configuration:**
```properties
quarkus.langchain4j.pgvector.dimension=1536  # OpenAI Embeddings
# or 384 for Ollama nomic-embed-text
```

**Ingestion** at startup via `@Startup` bean.
**Retrieval** via `Supplier<RetrievalAugmentor>` CDI bean.

---

## Quarkus LangChain4j – Guardrails

**WARNING:** The Quarkus-specific guardrail implementation has been removed in favor of the
upstream LangChain4j implementation.

**Correct:** `dev.langchain4j.guardrail.InputGuardrail` / `OutputGuardrail`
**Wrong:** `io.quarkiverse.langchain4j.guardrails.*` (deprecated/removed)

```properties
quarkus.langchain4j.guardrails.max-retries=3  # Default: 3
```

---

## Quarkus LangChain4j – Disable Dev Services

Ollama Dev Services automatically start a container – disable in DevContainer:
```properties
quarkus.langchain4j.ollama.devservices.enabled=false
```

Same applies to all provider Dev Services. Use real services via `docker compose up`.

---

## AI Architecture in BCE Pattern

AI components in the BCE pattern:
- `boundary/ai/` → AI Service interfaces (`@RegisterAiService`)
- `control/ai/` → Tools, RAG components, guardrails
- `boundary/rest/` → REST endpoints for AI service

**Architecture test** in `ArchitectureTest.java.template` contains rules:
- `@RegisterAiService` interfaces → `boundary.ai`
- `@Tool` classes → `control.ai`

---

## Quarkus LangChain4j – Agentic Workflows

### @Agent vs. @RegisterAiService

| Aspect | `@RegisterAiService` | `@Agent` |
|--------|---------------------|----------|
| Purpose | Declarative AI Service (Chat, Q&A) | Autonomous agent with tool access |
| Methods | Multiple methods allowed | **Exactly ONE method** (Single Responsibility) |
| Behavior | Reactive (responds to questions) | Proactive (solves tasks autonomously) |
| Workflow | Standalone | Combinable in workflows |

### Workflow Patterns (quarkus-langchain4j-agentic)

Dependency: `io.quarkiverse.langchain4j:quarkus-langchain4j-agentic`

| Pattern | Annotation | Description |
|---------|-----------|-------------|
| **Sequence** | `@SequenceAgent` | Agents sequentially (A → B → C) |
| **Parallel** | `@ParallelAgent` | Agents concurrently on separate threads |
| **Conditional** | `@ConditionalAgent` | Conditional execution via `@ActivationCondition` |
| **Loop** | `@LoopAgent` | Iterative until exit condition is met |
| **Supervisor** | `@SupervisorAgent` | LLM dynamically decides which agent runs |
| **A2A** | `@A2AClientAgent` | Remote agent via Agent-to-Agent protocol |

### AgenticScope – Shared State

All agents in a workflow share an `AgenticScope`.
Data is passed between agents via `outputKey`.
`@Output` method extracts values from the scope for the final result.

### Builder API (Programmatic)

```java
// Loop with exit condition
var loop = AgenticServices.loopBuilder(MyLoop.class)
    .subAgents(writer, reviewer)
    .outputKey("result")
    .exitCondition(scope -> scope.readState("score", 0.0) >= 0.8)
    .maxIterations(5)
    .build();
```

---

## Quarkus LangChain4j – Fault Tolerance (Production)

**MANDATORY for production applications.** LLM calls can fail at any time.

Dependency: `io.quarkus:quarkus-smallrye-fault-tolerance`

```java
@Timeout(5000)
@Retry(maxRetries = 3, delay = 100)
@Fallback(MyFallback.class)
String chat(@UserMessage String message);
```

Fallback handler returns a user-friendly error message.

---

## Quarkus LangChain4j – Easy RAG (Simplest Variant)

Dependency: `io.quarkiverse.langchain4j:quarkus-langchain4j-easy-rag`

Automatic ingestion from directory – no programming needed:
```properties
quarkus.langchain4j.easy-rag.path=src/main/resources/rag
quarkus.langchain4j.easy-rag.max-segment-size=100
quarkus.langchain4j.easy-rag.max-overlap-size=25
quarkus.langchain4j.easy-rag.max-results=3
```

For production-ready applications → prefer PgVector + custom ingestion pipeline.

---

## Quarkus LangChain4j – RAG Best Practices

1. **Same embedding model** for ingestion and retrieval (MANDATORY)
2. **Segment size** is critical: too large → imprecise results, too small → missing context
3. **PgVector dimension** must match the embedding model:
   - OpenAI `text-embedding-ada-002`: **1536**
   - Ollama `nomic-embed-text`: **384**
   - ONNX `bge-small-en-q` (local): **384**
4. Prefer local embedding models (ONNX) when data must not leave the system
