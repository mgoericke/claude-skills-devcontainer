---
name: coworker
description: Phase-based coworker for end-to-end project setup. Guides through specification, API design, and code generation with review after each phase. Use this skill when a new project needs to be set up from scratch or when the developer wants to be guided through the complete workflow. Also for "start a new project", "coworker", "guide me through the setup", "I need a new project", or "set up a project end-to-end".
argument-hint: "[project-name or topic]"
disable-model-invocation: true
---

# Coworker Skill

Phase-based coworker for end-to-end setup of new projects.
Orchestrates the existing skills in the right order – with review
and feedback opportunity after each phase.

> **Philosophy:** A good coworker thinks ahead, suggests the next steps,
> and leaves the developer in control. Each phase has a clear outcome.
> Nothing happens without confirmation.

---

## What This Skill Does

1. **Guides through phases** – Specification, API design, code generation
2. **Orchestrates existing skills** – Uses `spec-feature`, `openapi`, `java-scaffold`
3. **Review after each phase** – Check results, give feedback, adjust or continue
4. **Flexibly skip** – Phases can be skipped if artifacts already exist

## How to Use

```
Start the coworker for a new project
```

```
I need a new project for an order service
```

```
Coworker: set up a new project
```

---

## Instructions

> **Before every execution**:
> 1. Check `.claude/lessons-learned.md`
> 2. Check if artifacts already exist (`specs/`, `api/`, `pom.xml`)

### Overview: The Phases

```
Phase 1: Project context           → Fundamental decisions (framework, name, scope)
         ↓ Confirmation
Phase 2: Specify feature            → specs/<feature>.md
         ↓ Review & confirmation
Phase 3: Design API                 → api/<service>.yaml
         ↓ Review & confirmation
Phase 4: Generate code              → Java project with BCE, tests, Docker, infra
         ↓ Review & confirmation
Phase 5: Summary                    → What was created, next steps
```

---

### Step 0 – Inventory check

Before starting, check what already exists:

- Is there a `pom.xml`? → Project already exists, phases 1+4 may be skippable
- Are there files in `specs/`? → Phase 2 may be skippable
- Are there files in `api/`? → Phase 3 may be skippable

Communicate the result to the user:

```
Inventory check:
  Project:  ✅ exists (order-service, Spring Boot)
  Specs:    ❌ none found
  API Spec: ❌ none found

Recommendation: Start with Phase 2 (specify feature).
```

Or for an empty project:

```
Inventory check:
  Project:  ❌ no project found
  Specs:    ❌ none found
  API Spec: ❌ none found

Recommendation: Start with Phase 1 (project context).
```

---

### Phase 1 – Project Context

**Goal:** Make the fundamental decisions before getting started.

**Ask with `AskUserQuestion`:**

#### Question 1 – Project name and purpose

| # | Question | Hint |
|---|----------|------|
| 1 | **Project name** | Short name, e.g. `order-service` |
| 2 | **What should the project do?** | One sentence – used for spec and docs |

#### Question 2 – Framework

```
Which framework should be used?
```

Options:
- **Spring Boot (Recommended)** – Spring Boot 4.x with Spring AMQP, Actuator, Flyway
- **Quarkus** – Quarkus 3.31+ with SmallRye, MicroProfile Health, Flyway

#### Question 3 – Services

```
What services does the project need?
```

Options (multiSelect):
- **PostgreSQL** – Relational database
- **RabbitMQ** – Messaging / event communication
- **Keycloak** – Authentication and authorization

**Phase transition:**

```
Phase 1 completed ✅

  Project:   order-service
  Framework: Spring Boot
  Services:  PostgreSQL, RabbitMQ

  Next phase: Specify feature
  → The spec-feature conducts an interview and creates a spec file.

Continue with Phase 2?
```

Confirm via `AskUserQuestion`:
- **Continue with Phase 2** – Specify feature
- **Skip Phase 2** – Go directly to Phase 3 (design API)
- **Stop here** – Continue later

---

### Phase 2 – Specify Feature

**Goal:** Create a business specification before writing code.

**Delegation to `spec-feature`:**

Execute the `spec-feature` – with the project context from Phase 1 as prior knowledge.
The skill conducts its own interview (4 question groups) and creates `specs/<feature>.md`.

**After completion:**

```
Phase 2 completed ✅

  Created: specs/order-creation.md

  Summary:
    Feature: Create and manage orders
    Actors: Customer, Admin
    Endpoints: 5 (CRUD + status change)
    Messaging: OrderCreatedEvent to RabbitMQ

  Next phase: Design API
  → The openapi creates an OpenAPI spec based on the feature spec.

Continue with Phase 3?
```

Via `AskUserQuestion`:
- **Continue with Phase 3** – Create API spec
- **Repeat Phase 2** – Specify another feature
- **Skip Phase 3** – Go directly to Phase 4 (generate code)
- **Stop here** – Continue later

---

### Phase 3 – Design API

**Goal:** Create an OpenAPI spec that defines the API contract.

**Delegation to `openapi` (Mode A: Create new spec):**

Execute the `openapi` in "Create new spec" mode.
Pass along the information from Phase 1 (framework, services) and Phase 2 (feature spec) as context.

If endpoints and data models were already defined in Phase 2, offer them as suggestions
instead of asking again.

**After completion:**

```
Phase 3 completed ✅

  Created: api/order-service.yaml (OpenAPI 3.1.0)

  Schemas:   CreateOrderRequest, OrderResponse, ErrorResponse
  Endpoints: 5
    GET    /api/v1/orders
    POST   /api/v1/orders
    GET    /api/v1/orders/{id}
    PUT    /api/v1/orders/{id}
    DELETE /api/v1/orders/{id}

  Next phase: Generate code
  → The java-scaffold creates the project, the openapi generates code from the spec.

Continue with Phase 4?
```

Via `AskUserQuestion`:
- **Continue with Phase 4** – Generate project and code
- **Repeat Phase 3** – Adjust API spec
- **Stop here** – Continue later

---

### Phase 4 – Generate Code

**Goal:** Create the runnable project – structure, code, infra, tests.

This phase combines two skills:

**Step 4a – Project scaffolding (java-scaffold):**
- `pom.xml`, BCE package structure, Flyway, Docker, health checks
- `docker-compose.yml` with the selected services from Phase 1
- Taikai architecture tests
- `renovate.json`, `.gitignore`

**Step 4b – Code from API spec (openapi, Mode C):**
- DTOs in `entity/dto/` from the OpenAPI spec
- REST controllers/resources in `boundary/rest/`
- Service stubs in `control/`

**After completion:**

```
Phase 4 completed ✅

  Generated:
    ✅ pom.xml             – Spring Boot, PostgreSQL, Spring AMQP
    ✅ BCE package structure – boundary/, control/, entity/
    ✅ Taikai tests         – Architecture rules as unit tests
    ✅ Flyway               – db/migration/ with initial migration
    ✅ Health check          – /actuator/health
    ✅ Dockerfile            – Multi-stage build
    ✅ docker-compose.yml    – PostgreSQL, RabbitMQ
    ✅ REST endpoints        – 5 endpoints from the API spec
    ✅ DTOs                  – 3 records with validation
    ✅ Service stubs         – Business logic placeholders

  Start with:
    docker compose up -d && ./mvnw spring-boot:run

Continue with Phase 5 (summary)?
```

---

### Phase 5 – Summary and Next Steps

**Goal:** Overview of everything created and recommendations for next steps.

```
Project order-service – Setup completed ✅

Created artifacts:
  specs/order-creation.md          – Feature specification
  api/order-service.yaml           – OpenAPI 3.1.0 spec
  pom.xml                          – Spring Boot 4.x project
  src/main/java/...                – BCE structure with 5 endpoints
  src/test/java/...                – Architecture tests
  docker-compose.yml               – PostgreSQL, RabbitMQ
  Dockerfile                       – Multi-stage build

Recommended next steps:
  1. docker compose up -d           – Start infrastructure
  2. ./mvnw spring-boot:run         – Start application
  3. Implement service stubs        – Business logic in control/
  4. Adjust Flyway migrations       – Tables for entities
  5. /review                  – Run code review
  6. /doc                     – Create project documentation
```

---

## Phase Control

### Skipping Phases

The coworker automatically detects which phases can be skipped:

| If present | Phase skippable |
|------------|----------------|
| `pom.xml` | Phase 1 + 4a (scaffolding) |
| `specs/*.md` | Phase 2 (spec) |
| `api/*.yaml` | Phase 3 (API design) |
| Classes in `boundary/rest/` | Phase 4b (code from spec) |

### Repeating Phases

Each phase can be repeated – e.g. to specify another feature
or extend the API spec. The coworker asks explicitly after each phase.

### Stopping and Resuming

The coworker can be stopped after each phase. On the next invocation,
the inventory check (Step 0) detects where the developer left off.

---

## References

| File | Description |
|------|-------------|
| `.claude/lessons-learned.md` | Findings and corrections |
| `.claude/skills/spec-feature/SKILL.md` | Feature specification (Phase 2) |
| `.claude/skills/openapi/SKILL.md` | API design + code generation (Phase 3 + 4b) |
| `.claude/skills/java-scaffold/SKILL.md` | Project scaffolding (Phase 4a) |
| `.claude/skills/review/SKILL.md` | Code review (recommended next step) |
| `.claude/skills/doc/SKILL.md` | Project documentation (recommended next step) |

---

## Conventions

- **Language:** English in code, documentation language follows user preference
- **Phase transitions:** Always confirm via `AskUserQuestion`
- **Delegation:** Use existing skills, don't duplicate their logic
- **Pass context forward:** Pass information from earlier phases into later phases
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via coworker`

### Position in Workflow

```
[coworker]          < Orchestrates the entire workflow
        │
        ├── [spec-feature]     Phase 2
        ├── [openapi]          Phase 3 + 4b
        ├── [java-scaffold]    Phase 4a
        │
        └── recommends afterwards:
            ├── [review]       Code review
            └── [doc]          Documentation
```
