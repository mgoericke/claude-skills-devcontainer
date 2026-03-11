# AI-Powered Scaffolding: Project Setup in Minutes Instead of Hours

**How DevContainers and Claude Code Skills are revolutionizing Java bootstrapping**

---

Setting up Docker Compose, configuring Maven, installing the right Java version, integrating Flyway, not forgetting health checks – was it `ddl-auto=validate` or `ddl-auto=create`?

With DevContainers and AI-powered skills, this takes less than five minutes. Whether it's a productive microservice project or a quick prototype.

---

## Quick Start: Just Try It Out

**Set API key** (optional – alternatively `claude login` in the DevContainer):

```bash
# on the host in ~/.zshrc or ~/.bashrc
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Clone the repo and open in VS Code:**

```bash
git clone git@github.com:<your-org>/claude-skills-devcontainer.git
code claude-skills-devcontainer
# → Choose "Reopen in Container" – done after ~3–5 min.
```

**Get started:**

```
Create a new Spring Boot project
```

Claude asks for `groupId`, `artifactId`, and the required services – then everything is generated: project structure, configuration, Dockerfile, architecture tests.

That's it. No manual setup. No forgotten conventions.

---

## What's Behind It?

### The Template: Technical Specifications and Conventions in One

The template is not an empty starting point. It defines clear technical specifications for how applications are generated – and also delivers company conventions along the way:

- **Base image, Java version, Git** – defined in `devcontainer.json`, not "install Java 25 somehow"
- **Docker-in-Docker** – build containers and use `docker compose` directly in the DevContainer
- **BOM and dependency versions** – the `java-scaffold-skill` queries current versions live and generates a `pom.xml` with `versions-maven-plugin` and `renovate.json`
- **Architecture specifications** – BCE pattern, Taikai architecture tests, Flyway instead of ddl-auto
- **Infrastructure** – PostgreSQL, RabbitMQ, Keycloak ready to start via `docker compose up -d`
- **Health checks** – `/actuator/health` (Spring) or `/q/health` (Quarkus) are mandatory

Everything is under version control. **Defined, controllable, repeatable.** Changes are traceable in the Git log.

### Claude Code Skills: Team Knowledge Codified

Skills in `.claude/skills/` teach Claude Code how the team works. Not vague prompts, but codified knowledge:

| Skill | What it does |
|-------|-------------|
| `java-scaffold-skill` | Generates projects, entities, Dockerfiles, **AI services** according to team conventions |
| `spec-feature-skill` | Gathers business requirements via interview, creates specs |
| `openapi-skill` | Creates, extends, or implements OpenAPI specs via interview |
| `review-skill` | Checks code against architecture rules and best practices |
| `doc-skill` | Creates and updates project documentation |
| `infografik-skill` | Generates infographics via Hugging Face API |
| `blog-post-skill` | Creates technical blog posts (like this one) |
| `frontend-skill` | Builds web UIs: dashboards (TailAdmin), landing pages (Tailwind CSS) |

Besides skills, the template also includes an **MCP server for PostgreSQL**. This allows querying database contents directly in the chat – in natural language, without opening a SQL client.

The skills are not generic. They know the team's stack. The `java-scaffold-skill` knows that Flyway is mandatory, that health checks are part of the deal, that Taikai architecture tests must be in every project.

The conventions are in `CLAUDE.md` – readable by both humans and machines:

```markdown
## Coding Standards
- **Architecture**: BCE pattern (Boundary / Control / Entity)
- **Architecture tests**: Taikai – create for every new project (MANDATORY)
- **Health checks**: Every application must provide /actuator/health (MANDATORY)
- **Persistence**: Flyway – no ddl-auto=create
```

### The Tech Stack

| Layer | Technology |
|-------|------------|
| Java | 25 (Microsoft OpenJDK) |
| Frameworks | Spring Boot 4.x or Quarkus 3.31+ |
| Database | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (Spring AMQP / SmallRye) |
| Build | Maven 3.9 |
| Architecture Tests | Taikai (ArchUnit) |
| Auth / IAM | Keycloak 26.x |
| AI (Developer Tool) | Claude Code |
| AI (in the Application) | Quarkus LangChain4j (OpenAI, Ollama, Anthropic) + PgVector |

### Local Models and Data Sovereignty

An important point for many companies: when using the Anthropic Cloud API, prompts, context, and **source code** are sent to external servers. For sensitive projects, internal architectures, or regulated environments, that's not an option.

The template therefore also supports local models – for example via **Ollama** or **LM Studio**. Configuration is done via two environment variables, no code changes needed:

```bash
export ANTHROPIC_BASE_URL="http://host.docker.internal:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
```

The code then never leaves the machine. Self-hosted deployments within the corporate network are also possible. Skills, `CLAUDE.md`, and the entire workflow function identically – regardless of whether the model runs in the cloud or locally.

---

## What Can I Do With This?

### Set Up a New Project

```
> Create a new Spring Boot project for an Order Service

Claude: Before I generate the project, I need a few details:

  groupId?        com.acme
  artifactId?     order-service
  Services?       PostgreSQL, RabbitMQ

Claude generates the project …

pom.xml             – Spring Boot 4.0.3, PostgreSQL Driver, Spring AMQP
BCE package structure – boundary/, control/, entity/
Taikai tests        – Architecture rules as unit tests
Flyway              – db/migration/ with initial migration
Health check        – /actuator/health incl. DB and RabbitMQ indicator
Dockerfile          – Multi-stage build in project root
docker-compose.yml  – PostgreSQL 17, RabbitMQ 4, Keycloak 26
renovate.json       – Automatic dependency updates
application.yml     – Datasource, RabbitMQ connection, Flyway configured

Project order-service is ready. Start with:
  docker compose up -d && ./mvnw spring-boot:run
```

Claude only asks for the essentials – everything else comes from the team conventions in the template. Dependency versions are queried live, not from memory.

### Prototypes in Minutes

Especially valuable for prototypes and proofs of concept. Instead of investing half a day in setup, the runnable foundation is ready in minutes – with an architecture that also holds up when the prototype becomes a production system.

### Specify Features

```
Specify feature: Send orders via event to RabbitMQ
```

The `spec-feature-skill` conducts a structured interview and creates a specification in `specs/`. Only then is code written – based on the spec, not on assumptions.

### Design APIs

```
Create a new API spec for the Order Service
```

The `openapi-skill` guides through an interview: data models, endpoints, auth schema. The result is a valid OpenAPI 3.x spec in `api/`. Existing entities in the project are detected and offered for adoption. From the finished spec, Java code can be generated directly – DTOs, controllers, service stubs.

### AI Business Applications with LangChain4j

Since the last update, the `java-scaffold-skill` can also generate **AI-powered business applications**. Instead of just building CRUD services, complete LLM integrations can now be scaffolded:

```
> Create a new Quarkus project with AI support (LangChain4j)

Claude: What AI features do you need?

  LLM provider?        OpenAI
  AI features?         Chat + Tools + RAG
  Vector store?        PgVector
  Fault tolerance?     Yes

Claude generates the AI project …

pom.xml              – Quarkus 3.31+, LangChain4j BOM, PgVector, Fault Tolerance
AI Service           – @RegisterAiService with SystemMessage and ToolBox
AI Tools             – @Tool classes for function calling (DB access)
RAG Pipeline         – Document ingestion + RetrievalAugmentor with PgVector
Guardrails           – Input validation against prompt injection
REST endpoint        – /ai/chat as JSON API
Fault Tolerance      – @Timeout, @Retry, @Fallback for production
docker-compose-ai.yml – pgvector/pgvector:pg17 + optional Ollama
Architecture tests   – AI services in boundary/ai/, tools in control/ai/
```

**7 AI profiles** are available – from a simple chatbot to agentic workflows with autonomous agents:

| Profile | Description |
|---------|-------------|
| **Chat** | Simple AI service with system/user prompt |
| **Chat + Tools** | Function calling – the LLM accesses databases and REST APIs |
| **Chat + RAG** | Document search via PgVector (Retrieval Augmented Generation) |
| **Chat + Guardrails** | Input/output validation against prompt injection |
| **Agentic** | Autonomous agents with workflow orchestration (Sequence, Parallel, Loop, Supervisor) |
| **Fault Tolerant** | Production-ready setup with retry, timeout, and fallback |
| **Complete** | All features combined |

The AI components follow the same BCE pattern as the rest of the application:
- **AI Services** (`@RegisterAiService`) are located in `boundary/ai/`
- **Tools, RAG, Guardrails** are located in `control/ai/`
- **REST endpoints** for the AI service in `boundary/rest/`

The architecture tests enforce this structure automatically – a `@Tool` in `boundary/rest/` will fail the build.

**Three LLM providers** are supported:
- **OpenAI** (or compatible APIs like vLLM, LM Studio)
- **Ollama** (local, without API key – perfect for data-sensitive projects)
- **Anthropic** (Claude)

### More Prompts to Try

```
Create a business application with chatbot and RAG (document search)
```
```
Generate an AI service with tool integration for my Quarkus project
```
```
Extend the API in api/orders.yaml with a product endpoint
```
```
Generate code from the OpenAPI spec api/openapi.yaml
```
```
Document the project
```
```
Create an infographic about microservice communication
```

---

## Conclusion

DevContainers make the environment reproducible. Claude Code Skills make the **decisions** reproducible. The template delivers both together – technical specifications and conventions that don't gather dust in documentation, but live in the repository: as `CLAUDE.md`, as skills, as `lessons-learned.md`. Versioned, reviewable, and executable by an AI assistant.

**Every new project on the team starts convention-compliant – not because someone remembered, but because there's no other way.**

---

*Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via blog-post-skill*
