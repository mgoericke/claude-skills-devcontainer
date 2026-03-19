# AI-Powered Project Scaffolding

This template enables rapid setup of new Java projects with full
AI support through Claude Code. You describe your project in natural language –
Claude handles scaffolding, specification, architecture, and code generation.

## Features

- **Spring Boot 4.x or Quarkus 3.31+** – fully preconfigured, including health checks
- **PostgreSQL + RabbitMQ + Keycloak** – local infrastructure ready to go via `docker compose up -d`
- **BCE Architecture** (Boundary / Control / Entity) with automatic architecture tests via Taikai
- **Flyway** for database migrations – no unsafe `ddl-auto=create`
- **MCP Data Access** – natural language queries on PostgreSQL directly in the chat
- **[Backlog.md](https://github.com/The-Dave-Stack/backlog.md)** – a full Kanban board that lives right inside your project. Plan, prioritize, and track tasks with status workflows – all versioned in Git alongside your code, no external tools needed. Includes CLI and WebUI for full visibility. Managed directly from Claude Code via MCP. Every task follows the **User Story** pattern: _"As a [user], I want [goal] so that [benefit]"_

### Skills

Interactive, prompt-driven workflows that guide you through a task step by step.

| Skill | Description |
|-------|-------------|
| **java-scaffold** | Scaffolds new Java projects, entities, and AI services (pom.xml, BCE, Flyway, Taikai) |
| **infrastructure** | Dockerfiles, docker-compose, Helm Charts, and CI/CD pipelines |
| **spec-feature** | Structured feature interview that produces a spec file before code is written |
| **openapi** | Create, extend, or generate Java code from an OpenAPI 3.x spec |
| **review** | Code review against project conventions, architecture rules (BCE), and best practices |
| **doc** | Reads source code and configuration, creates project documentation in `docs/` |
| **blog-post** | Creates technical blog posts with structured interviews and audience adaptation |
| **frontend** | Web UIs: Simple HTML pages, Dashboards (TailAdmin), Landing Pages with Tailwind CSS |
| **infografik** | AI image generation via Hugging Face FLUX.1 |
| **arc42** | Arc42 architecture documentation – analyzes project artifacts, fills all 12 sections with Mermaid diagrams |
| **skill-creator** | Create new skills, optimize existing skills, and measure skill performance |

### Agents

Specialized sub-agents that run autonomously and can be executed in parallel for fast feedback.

| Agent | Description |
|-------|-------------|
| **security-reviewer** | Security analysis – secrets, auth, input validation, OWASP Top 10 |
| **architecture-reviewer** | BCE pattern compliance and Taikai architecture rule validation |
| **performance-reviewer** | N+1 queries, blocking operations, memory leaks, reactive pattern violations |
| **ai-service-generator** | LangChain4j AI service scaffolding with tools, RAG, and guardrails |
| **arc42-updater** | Automatically updates arc42 sections when architecture changes occur |

## Quick Start

**1 – Set API Key** (`~/.zshrc` or `~/.bashrc` on the host):

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

**2 – Open in VS Code:**

```bash
git clone <repository-url>
code <your-repo>
# → Select "Reopen in Container" – ready after ~3–5 min.
```

**3 – Enter your first prompt:**

```
Create a new Spring Boot project
```

Claude will ask for `groupId`, `artifactId`, and the required services – then
everything is generated: project structure, configuration, Dockerfile, architecture tests.

## Example Prompts

```
Create a new Quarkus project
```
```
I want to specify a new feature
```
```
Implement the feature according to specs/order-creation.md
```
```
Generate code from the OpenAPI spec api/openapi.yaml
```
```
Document the project
```
```
Show all products
```
```
Create an infographic about microservice communication
```

## Stack

| Layer             | Technology                               |
| ----------------- | ---------------------------------------- |
| Java              | 25 (Microsoft OpenJDK)                   |
| Frameworks        | Spring Boot 4.x or Quarkus 3.31+        |
| Database          | PostgreSQL 17                            |
| Messaging         | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build             | Maven 3.9                                |
| Architecture Tests| Taikai (ArchUnit)                        |
| Auth / IAM        | Keycloak 26.x                            |
| AI                | Claude Code                              |

## Local Infrastructure

```bash
docker compose up -d
```

| Service              | Address                                          |
| -------------------- | ------------------------------------------------ |
| PostgreSQL           | `localhost:5432`                                 |
| RabbitMQ Management  | http://localhost:15672 (`app` / `app`)           |
| Keycloak Admin       | http://localhost:8180 (`admin` / `admin`)        |
| Application (Spring) | http://localhost:8080/actuator/health            |
| Application (Quarkus)| http://localhost:8080/q/health                   |

## Backlog & Task Management with Backlog.md

This template uses **[Backlog.md](https://github.com/The-Dave-Stack/backlog.md)** for local-first, Git-based task management. All tasks are stored as Markdown files in `backlog/tasks/` and managed directly from Claude Code via MCP.

### Why Backlog.md?

- **Git-native** – tasks live alongside the code, versioned and branchable
- **No external tools** – no Jira, no Trello, no cloud dependency
- **MCP integration** – Claude Code can read, create, and edit tasks directly in the chat
- **User Story format** – every task follows the pattern: _"As a [user], I want [goal] so that [benefit]"_

### Usage

**Create and manage tasks via Claude Code:**

```
Create a new task for user authentication
Show me all open tasks
Move task-001 to "In Progress"
```

Claude uses the Backlog.md MCP tools automatically – just describe what you need.

**Browse tasks in the browser:**

```bash
backlog browser --port 4000
```

This starts a local web UI at [http://localhost:4000](http://localhost:4000) where you can view and manage your backlog visually.

**Configuration:** The backlog is configured in [backlog/config.yaml](backlog/config.yaml). Tasks use the statuses `To Do`, `In Progress`, and `Done`.

### Task Structure

Each task file in `backlog/tasks/` contains:

- **Description** – User Story format (mandatory)
- **Acceptance Criteria** – clear, testable conditions
- **Definition of Done** – quality gates
- **Plan** – implementation steps

For more details, see the [Backlog.md documentation](https://github.com/The-Dave-Stack/backlog.md).

## Further Documentation

| Topic | Document |
|-------|----------|
| Detailed setup (env vars, Artifactory) | [docs/setup.md](docs/setup.md) |
| Skills & workflow overview | [docs/skills.md](docs/skills.md) |
| MCP data access (PostgreSQL, RabbitMQ) | [docs/mcp.md](docs/mcp.md) |
| Local models (Ollama / LM Studio) | [docs/local-models.md](docs/local-models.md) |
| **Sub-Agents overview** | **[docs/sub-agents.md](docs/sub-agents.md)** |
| Sub-Agents quick-start guide | [docs/agents-quickstart.md](docs/agents-quickstart.md) |
| Sub-Agents architecture & flows | [docs/agents-architecture.md](docs/agents-architecture.md) |
| Arc42 architecture documentation | [docs/arc42/](docs/arc42/) |
| Backlog.md task management | [Backlog.md on GitHub](https://github.com/The-Dave-Stack/backlog.md) |
