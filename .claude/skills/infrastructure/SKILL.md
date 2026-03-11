---
name: infrastructure
description: Infrastructure scaffolding for Java projects – Dockerfiles, docker-compose, Helm Charts, and CI/CD pipelines. Reads existing pom.xml and application.properties to detect framework, services, and health endpoints automatically. Use this skill for "create a Dockerfile", "docker-compose", "Helm chart", "CI/CD pipeline", "infrastructure", "containerize", or "deploy".
argument-hint: "[infrastructure type] [description]"
---

# Infrastructure Skill

Infrastructure scaffolding for Java projects – framework-agnostic, reads project configuration to generate the right artifacts.

> **Philosophy:** Always read existing project files (pom.xml, application.properties) first – never guess the framework, services, or configuration.

---

## What This Skill Does

1. **Reads project configuration** – detects framework (Spring Boot / Quarkus), services, health endpoints
2. **Generates Dockerfiles** – multi-stage builds with health checks, non-root user
3. **Generates docker-compose** – all required services with health checks and volumes
4. **Generates Helm Charts** (future) – Kubernetes deployment manifests
5. **Generates CI/CD pipelines** (future) – GitHub Actions, GitLab CI

## How to Use

```
Create a Dockerfile for this project
```

```
Generate docker-compose with PostgreSQL and RabbitMQ
```

```
Create infrastructure for the order-service
```

---

## Instructions

> **Before every generation:**
> 1. Read `pom.xml` to detect framework, dependencies, and artifactId
> 2. Read `application.properties` / `application.yml` to detect configured services
> 3. Check `.claude/lessons-learned.md` for infrastructure-related findings

### Step 1 – Detect Project Configuration

Read the project files and determine:

| What | How to detect |
|------|---------------|
| **Framework** | `spring-boot-starter-parent` in pom.xml → Spring Boot; `quarkus-bom` → Quarkus |
| **artifactId** | `<artifactId>` in pom.xml |
| **PostgreSQL** | `postgresql` or `quarkus-jdbc-postgresql` dependency |
| **RabbitMQ** | `spring-boot-starter-amqp` or `quarkus-messaging-rabbitmq` dependency |
| **Keycloak** | `spring-boot-starter-oauth2-resource-server` or `quarkus-oidc` dependency |
| **AI / PgVector** | `quarkus-langchain4j-pgvector` dependency → use `pgvector/pgvector:pg17` image |
| **Health endpoint** | Spring Boot: `/actuator/health`; Quarkus: `/q/health/live` |

**Never ask what the user already has in their project files.** Only ask if files are missing or ambiguous.

### Step 2 – Generate Dockerfile

#### Dockerfile Conventions

| Framework | Location | Base image |
|-----------|----------|------------|
| Spring Boot | `./Dockerfile` (project root) | `eclipse-temurin:25-jdk-alpine` (build) + `eclipse-temurin:25-jre-alpine` (runtime) |
| Quarkus JVM | `src/main/docker/Dockerfile.jvm` | `eclipse-temurin:25-jre-alpine` |
| Quarkus Native | `src/main/docker/Dockerfile.native-micro` | `quay.io/quarkus/quarkus-micro-image:2.0` |

**Mandatory Dockerfile rules:**
- Multi-stage build for Spring Boot (build + runtime)
- Non-root user (`appuser` / `appgroup`)
- `HEALTHCHECK` using the framework's health endpoint
- `EXPOSE 8080`

Use templates in `templates/` as reference.

### Step 3 – Generate docker-compose

**Mandatory docker-compose rules:**
- Only include services that the project actually uses (detected in Step 1)
- Every service must have a `healthcheck`
- Application service uses `depends_on` with `condition: service_healthy`
- Use named volumes for data persistence
- Keycloak: `start-dev` mode for development, comment pointing to production setup
- AI projects with PgVector: use `pgvector/pgvector:pg17` instead of `postgres:17-alpine`

### Step 4 – Generate Helm Chart (future)

Reserved for Kubernetes deployment manifests. Not yet implemented.

### Step 5 – Generate CI/CD Pipeline (future)

Reserved for GitHub Actions / GitLab CI pipelines. Not yet implemented.

---

## References

| File | Description |
|------|-------------|
| `.claude/lessons-learned.md` | Findings and corrections – check before every generation |
| [templates/spring/](templates/spring/) | Spring Boot templates (Dockerfile, docker-compose) |
| [templates/quarkus/](templates/quarkus/) | Quarkus templates (Dockerfile.jvm, Dockerfile.native-micro, docker-compose) |
| [templates/quarkus/ai/](templates/quarkus/ai/) | AI docker-compose with PgVector and optional Ollama |

### Placeholders

| Placeholder | Example |
|-------------|---------|
| `{{ARTIFACT_ID}}` | `order-service` |

---

## Conventions

- **Language:** English in comments
- **Commits:** Conventional Commits (`chore:` for infrastructure changes)
- **Co-Author:** `# Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via infrastructure`

### Position in Workflow

```
[java-scaffold-skill]     application code, pom.xml, BCE, Flyway
        |
[infrastructure]    Dockerfile, docker-compose, Helm, CI/CD
        |
[review-skill]            code review
        |
[doc-skill]               project documentation
```
