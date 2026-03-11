---
name: doc
description: Creates or updates project documentation as a Markdown page in docs/. Automatically analyzes pom.xml, properties, docker-compose, and source code – only asks what cannot be derived from the code. Use this skill for "document the project", "write docs", "update the docs", "create a README" or when a new project needs technical documentation.
argument-hint: "[artifactId]"
---

# Doc Skill

Creates or updates `docs/<artifactId>.md` based on the existing project
and a structured interview.

> **Philosophy:** Documentation is not an appendix – it is part of the product.
> Good docs emerge from the source code, not alongside it.

---

## What This Skill Does

1. **Analyzes the project** – automatically evaluates pom.xml, properties, docker-compose, source code
2. **Fills gaps via interview** – only asks what cannot be derived from the code
3. **Creates or updates** – `docs/<artifactId>.md` from template or targeted additions

## How to Use

```
Document the project
```

```
Create docs for my Spring Boot project
```

```
Update the docs with the new messaging feature
```

---

## Instructions

### Step 1 – Analyze Project (automatic)

Before the interview, read and evaluate existing project artifacts:

| File | Extracted Information |
|------|---------------------|
| `pom.xml` | groupId, artifactId, framework, active dependencies (DB, messaging, Keycloak) |
| `src/main/resources/application.properties` | Configured ports, database name, realm |
| `docker-compose.yml` | Services, ports, credentials |
| `specs/*.md` | Existing feature specs as basis for API documentation |
| `src/main/java/**/boundary/rest/` | REST endpoints (paths, methods) |
| `src/main/java/**/boundary/messaging/` | Messaging consumers (channels) |
| `src/main/java/**/entity/` | Entities / data model |
| `src/main/resources/db/migration/` | Flyway migrations → database schema |

Already determined information **must not be asked again**.

### Step 2 – Interview (only fill gaps)

Only ask what cannot be clearly derived from the source code:

| # | Question | Only ask when |
|---|----------|--------------|
| 1 | **Brief project description** (1–2 sentences: what does it do?) | No `README.md` present |
| 2 | **Target audience / users** (internal API, public, other team?) | Unclear from code |
| 3 | **Special configuration notes** (secrets, external systems) | Not in `application.properties` |
| 4 | **Known limitations / open TODOs** | Always ask |
| 5 | **Should all template sections be filled?** | Always ask – some sections may be omitted |

### Step 3 – Create or Update

**Create:** `docs/<artifactId>.md` does not exist
→ Generate file from template `templates/project-doc.md.template`, fill all placeholders.

**Update:** `docs/<artifactId>.md` already exists
→ Read file, replace or add changed/new content in a targeted way.
→ **Do not overwrite** existing manual additions by the user – only update empty or
  outdated sections.
→ Add an update note at the end of the file:
  `_Last updated: {{DATE}} (doc)_`

### Template Sections

| Section | Required | Source |
|---------|----------|--------|
| Project Overview | Yes | Interview + pom.xml |
| Stack & Versions | Yes | pom.xml |
| Local Development | Yes | docker-compose.yml, application.properties |
| Architecture (BCE) | Yes | Package structure |
| API Reference | If REST present | boundary/rest/** |
| Messaging | If RabbitMQ active | boundary/messaging/**, application.properties |
| Auth / Keycloak | If quarkus-oidc / oauth2-resource-server active | application.properties |
| Configuration Reference | Yes | application.properties |
| Deployment | Yes | Dockerfile, docker-compose.yml |
| Known Limitations | Yes | Interview |

---

## References

| File | Description |
|------|-------------|
| [templates/project-doc.md.template](templates/project-doc.md.template) | Template for project documentation |

### Output Path

```
docs/<artifactId>.md
```

The `docs/` directory is created if it does not exist.

---

## Conventions

- **Language:** English in prose, headings, and code blocks
- **Filename:** `<artifactId>.md` in kebab-case
- Version numbers taken from `pom.xml` – no guessing
- Passwords / secrets only as placeholders (`<your-secret>`) – never real values
- **Co-Author:** `<!-- Generated via doc · Co-Author: Claude (claude-sonnet-4-6, Anthropic) -->`

### Position in Workflow

```
[spec-feature]      optional – business requirements
        |
[openapi]           if OpenAPI spec needed
        |
[java-scaffold]     framework: DB, messaging, infra
        |
[review]            code review
        |
[doc]               <-- project documentation
```
