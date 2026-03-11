# Building a Project Template for AI-Assisted Coding

*A self-experiment in teaching an AI to scaffold production-ready Java projects -- consistently.*

---

Last year, I started using Claude Code for Java development. It was impressive -- until it wasn't. Every new project meant re-explaining the same conventions. "Use Flyway, not ddl-auto. Put controllers in boundary/rest/. Use Taikai for architecture tests." The AI wrote great code, but it had no memory of what "great" meant in *my* context.

So I built a template. Not a traditional Maven archetype or Yeoman generator -- a **living project template** that teaches Claude Code how to scaffold, specify, review, and document Java projects. Consistently. Every single time.

This is that template. It's a work in progress, constantly evolving -- and it already produced two fully working applications.

---

## Why? What Problem Does This Solve?

AI coding assistants are powerful, but they lack **institutional knowledge**. They don't know your team's architecture decisions. They don't remember that your last three projects all used the BCE pattern. They'll happily generate a `@Entity` with `ddl-auto=create` when you've spent months enforcing Flyway migrations.

The core idea is simple: **encode your conventions into skills that the AI follows every time.**

Instead of pasting instructions into every chat session, the template provides a set of **Claude Code Skills** -- structured instructions that Claude loads automatically. Each skill handles a specific concern: scaffolding, feature specification, API design, code review, documentation. The result is an AI assistant that works like a well-onboarded team member, not a generic autocomplete.

---

## DevContainers: The Foundation

The whole setup runs inside a [DevContainer](https://containers.dev/) -- a Docker-based development environment defined in a single `devcontainer.json` file.

Why DevContainers? Three reasons:

- **Reproducible**: Java 25, Maven 3.9, Docker-in-Docker, Claude Code -- all pre-installed. Clone, open, code.
- **Isolated**: Your host stays clean. Dependencies live in the container.
- **Portable**: Works on any machine with VS Code and Docker. No "it works on my machine" discussions.

The container comes pre-configured with Java 25 (Microsoft OpenJDK), Maven, Docker-in-Docker for running PostgreSQL/RabbitMQ/Keycloak locally, and the Claude Code extension ready to go. Set your `ANTHROPIC_API_KEY` on the host, open in VS Code, choose "Reopen in Container" -- that's it.

---

## The Skills System: Teaching AI Your Conventions

This is where it gets interesting. The `.claude/skills/` directory contains **10 specialized skills**, each with its own instructions, templates, and references. Claude Code loads them automatically and decides which skill to invoke based on your prompt.

### How Skills Work

Each skill is a `SKILL.md` file -- a structured instruction set with frontmatter metadata:

```yaml
---
name: java-scaffold
description: Scaffolding for Java projects with Spring Boot or Quarkus,
  PostgreSQL, RabbitMQ, LangChain4j AI and Docker.
argument-hint: "[framework] [project-name]"
---
# Java Scaffold Skill

## Instructions

### Step 1 -- Gather Requirements
Ask for groupId, artifactId, framework choice, required services...

### Step 2 -- Check Versions Online
Query current versions from Maven Central (never from memory)...

### Step 3 -- Generate Project
Use templates to create pom.xml, docker-compose, Dockerfile...
```

Skills follow the [Agent Skills](https://agentskills.io) open standard. They can include templates, reference material, and even dynamic context injection via shell commands.

### The Question-Answer Approach

Instead of guessing, skills **interview you** before generating anything. The `spec-feature`, for example, walks through four groups of questions -- Context, Behavior, Technical Hints, Quality -- before producing a specification file in `specs/`. That spec then feeds into code generation.

This means the AI doesn't just write code. It first **understands what it should build**, documents that understanding, gets your confirmation, and *then* generates.

### A Lessons-Learned Feedback Loop

Every correction, every "that's not how we do it" gets captured in `.claude/lessons-learned.md`. Before every generation, Claude checks this file. Found a wrong RabbitMQ config pattern? Fixed once, remembered forever.

```markdown
## Quarkus -- @Blocking in Consumer

`@Incoming` methods run on I/O threads. For JPA/DB access **always**:

@Incoming("orders-in")
@Blocking
@Transactional
public void handle(String payload) { ... }

Without `@Blocking` → Deadlock or IllegalStateException.
```

This isn't just documentation -- it's **active memory** that prevents the same mistake from happening twice.

---

## What It Generates

The template supports two major Java frameworks and a comprehensive infrastructure stack:

### The Stack

| Layer | Technology |
|-------|-----------|
| Backend | Java 25 + **Spring Boot 4.x** or **Quarkus 3.31+** |
| Database | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build | Maven 3.9.x |
| Architecture Tests | Taikai (based on ArchUnit) |
| Auth / IAM | Keycloak 26.x |
| AI | Quarkus LangChain4j (OpenAI, Ollama, Anthropic) + PgVector |
| Infrastructure | Docker + Docker Compose |

### Generated Artifacts

When you say "Create a new Quarkus project", Claude asks a few questions and generates:

- **`pom.xml`** with current dependency versions (always fetched from Maven Central, never from memory)
- **`docker-compose.yml`** with only the services you confirmed (PostgreSQL, RabbitMQ, Keycloak)
- **`application.properties`** pre-configured for the chosen framework
- **`Dockerfile`** following framework conventions (project root for Spring Boot, `src/main/docker/` for Quarkus)
- **`ArchitectureTest.java`** with Taikai-based BCE rules -- enforcing that controllers live in `boundary.rest`, services in `control`, entities in `entity`
- **`renovate.json`** for automated dependency update PRs
- **Flyway migrations** for every entity -- no `ddl-auto=create`, ever
- **Health check endpoints** (`/actuator/health` or `/q/health`) -- mandatory for every application

### AI-Powered Applications with LangChain4j

For Quarkus projects, the template supports full **LangChain4j AI integration** with selectable profiles:

| Profile | What You Get |
|---------|-------------|
| Chat | AI Service interface with `@RegisterAiService`, system/user prompts |
| Chat + Tools | Function Calling with `@Tool` classes for database lookups, calculations |
| Chat + RAG | Document ingestion pipeline + PgVector retrieval augmentor |
| Chat + Guardrails | Input/output validation to prevent prompt injection |
| **Agentic Workflows** | **Autonomous agents with workflow patterns (Sequence, Parallel, Loop, Supervisor)** |
| Fault Tolerant | `@Timeout`, `@Retry`, `@Fallback` for production resilience |

The **Agentic Workflows** profile deserves special attention. Using `quarkus-langchain4j-agentic`, the template can generate complete multi-agent systems where agents collaborate to solve complex tasks -- with patterns like `@SequenceAgent` (A then B then C), `@ParallelAgent` (run concurrently), `@SupervisorAgent` (LLM decides which agent runs), and `@LoopAgent` (iterate until exit condition). All agents share state through an `AgenticScope`. See the [Quarkus LangChain4j Agentic documentation](https://docs.quarkiverse.io/quarkus-langchain4j/dev/agent-and-tools.html) for details.

Here's what a generated AI Service looks like in the BCE architecture:

```java
// boundary/ai/DocumentReviewAssistant.java
@SessionScoped
@RegisterAiService
public interface DocumentReviewAssistant {

    @SystemMessage("You are a document review assistant...")
    String review(@UserMessage String document);
}
```

```java
// control/ai/DocumentLookupTool.java
@ApplicationScoped
public class DocumentLookupTool {

    @Tool("Find documents by category")
    @Blocking
    @Transactional
    public List<Document> findByCategory(String category) {
        return Document.find("category", category).list();
    }
}
```

AI components follow the BCE pattern: services in `boundary/ai/`, tools and RAG components in `control/ai/`, architecture tests enforce this automatically.

---

## The Full Skill Lineup

Beyond scaffolding, the template includes skills for the entire development lifecycle:

| Skill | What It Does |
|-------|-------------|
| `java-scaffold` | Project scaffolding (Spring Boot / Quarkus, AI profiles) |
| `spec-feature` | Structured feature interviews before coding |
| `openapi` | Create, extend, and generate code from OpenAPI 3.x specs |
| `coworker` | End-to-end orchestration across all skills with review gates |
| `review` | Automated code review against project conventions and BCE rules |
| `doc` | Project documentation from source code analysis |
| `frontend` | Web UIs with Tailwind CSS (dashboards, landing pages) |
| `blog-post` | Technical blog posts with audience-specific depth |
| `infografik` | AI-generated infographics via Hugging Face FLUX |
| `skill-creator` | Create and optimize new skills, measure skill performance |

The `coworker` is particularly useful -- it orchestrates a full project setup across phases (specify, design API, generate code, document) with review gates between each step. Think of it as a guided project wizard.

Want to create your own skill? There's a `SKILL.md.template` in the repo. Copy it, fill in the placeholders, and Claude picks it up automatically.

---

## Two Real Projects, Built With This Template

This isn't theoretical. I've built two fully working applications using this template:

### 1. Knitting Webshop

A classic e-commerce application built with **Spring Boot 4.x**, **PostgreSQL**, and **RabbitMQ**. Product catalog, order management, event-driven messaging between services. The entire project structure -- entities, REST endpoints, Flyway migrations, Docker setup, architecture tests -- was scaffolded through the template's skills. From first prompt to running application with `docker compose up`.

### 2. AI-Powered Document Review Workflow

A more ambitious project: an intelligent document review system built with **Quarkus**, **LangChain4j**, **OpenAI**, and **PostgreSQL**. This one uses **Agentic Workflows** -- multiple AI agents collaborating in a structured pipeline to analyze, classify, and review documents. One agent extracts content, another checks compliance rules, a supervisor agent coordinates the flow. Built entirely through the template's AI profiles and the `quarkus-langchain4j-agentic` extension.

Two very different applications. Same template. Same conventions. Same quality guarantees.

---

## Getting Started

**Prerequisites:** Docker Desktop + VS Code with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

**Step 1** -- Set your API key on the host:

```bash
# ~/.zshrc or ~/.bashrc
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Step 2** -- Clone and open:

```bash
git clone https://github.com/mgoericke/claude-skills-devcontainer.git
cd claude-skills-devcontainer
code .
# → Choose "Reopen in Container" -- ready in ~3-5 minutes
```

**Step 3** -- Start building:

```
Create a new Quarkus project with PostgreSQL and RabbitMQ
```

Claude will ask for your `groupId`, `artifactId`, and which services you need. Then it generates everything -- structure, config, Dockerfile, tests, documentation.

Other things you can try:

```
I want to specify a new feature
```
```
Create an OpenAPI spec for a product service
```
```
Set up an AI service with RAG and PgVector
```

---

## What's Next

This is a **work in progress**. I use this template daily, and it evolves with every project. New lessons get captured, skills get refined, templates get better. Some things I'm exploring:

- More framework-specific templates (Micronaut?)
- Tighter integration between spec-feature and test generation
- Community contributions -- the skill system is open and extensible

The repository is public: **[github.com/mgoericke/claude-skills-devcontainer](https://github.com/mgoericke/claude-skills-devcontainer)**

If you're using Claude Code for Java development, give it a try. Clone it, open it, and see what happens when you tell an AI assistant: "Create a new project." The difference between that generic response and what this template produces might surprise you.

---

*The best AI coding assistant isn't the one that writes the most code. It's the one that writes the right code -- every time.*

---

*Co-Author: Claude (claude-opus-4-6, Anthropic) -- generated via blog-post*
