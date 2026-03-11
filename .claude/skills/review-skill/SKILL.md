---
name: review-skill
description: Reviews changed or existing code against project conventions, architecture rules (BCE), and best practices. Automatically captures staged/unstaged changes or branch diffs. Use this skill for "review code", "check the code", "code review", "look at the code", "quality check" or when code should be reviewed before a commit or merge.
argument-hint: "[files-or-directory]"
---

# Review Skill

Systematic code review against project conventions, architecture rules, and best practices.

> **Philosophy:** A good review doesn't just find bugs – it ensures that code
> follows the project's conventions and remains maintainable long-term.

---

## What This Skill Does

1. **Captures changes** – Staged/unstaged changes, branch diff, or user-specified files
2. **Checks against rules** – BCE architecture, lessons-learned, security, code quality, configuration, tests
3. **Creates report** – Structured output with findings (Critical / Warning / Note) and positive feedback
4. **Offers fixes** – After confirmation, findings can be corrected directly

## How to Use

```
Check the code I changed
```

```
Review the changes on the current branch
```

```
Do a code review for src/main/java/com/example/
```

---

## Instructions

> **Before every review**:
> 1. Read `.claude/lessons-learned.md`
> 2. Use [references/review-checklist.md](references/review-checklist.md) as the review catalog

## Dynamic Context (automatically preloaded)

The following Git information is automatically injected on invocation:

- Staged changes: !`git diff --cached --name-only 2>/dev/null`
- Unstaged changes: !`git diff --name-only 2>/dev/null`
- Untracked files: !`git ls-files --others --exclude-standard 2>/dev/null`
- Current branch: !`git branch --show-current 2>/dev/null`

### Step 1 – Capture Changes

If `$ARGUMENTS` was provided (e.g. `/review-skill src/main/java/`), review those files/directories.

Otherwise, evaluate the **dynamic context** above – in this order:

| Priority | Source |
|----------|--------|
| 1 | `$ARGUMENTS` (explicitly provided files/directories) |
| 2 | Staged changes (from dynamic context) |
| 3 | Unstaged changes (from dynamic context) |
| 4 | Branch diff against main: `git diff main...HEAD --name-only` |

**Rules:**
- If staged or unstaged changes exist → review those
- If no local changes but branch != main → review branch diff
- If no changes at all → ask user: which files or directories should be reviewed?
- Only review relevant files (Java, Properties, YAML, SQL, Dockerfile, docker-compose) – ignore generated files (target/, .class)

**Read files:** Read all changed files completely, not just the diff. Context is important for evaluation.

### Step 2 – Perform Review

Check each changed file against the review catalog (`references/review-checklist.md`).

**Review categories (summary):**

#### 2.1 Architecture (BCE)

- Classes in the correct layer? (`boundary/rest/`, `boundary/messaging/`, `control/`, `entity/`)
- No direct repository calls from the boundary layer
- No REST/messaging logic in the entity layer
- Controller/Resource delegates to Service (Control), not to Repository (Entity)

#### 2.2 Lessons-Learned Comparison

Check `.claude/lessons-learned.md` against the changed code:

| Rule | Check |
|------|-------|
| `@Blocking` for Quarkus consumers | `@Incoming` without `@Blocking` with DB access? |
| Flyway instead of ddl-auto | `ddl-auto=create` or `update` in properties? |
| Health checks | Actuator/SmallRye-Health dependency present? |
| Dev Services disabled | Quarkus Dev Services still active? |
| Dockerfile convention | Spring Boot → root, Quarkus → `src/main/docker/` |
| RabbitMQ config | Wrong property keys (`quarkus.rabbitmq.*` instead of `rabbitmq-host`)? |

#### 2.3 Coding Standards

- **Language:** Comments/Javadoc in English, code (classes, methods, variables) in English
- **Naming:** Java conventions (CamelCase classes, camelCase methods, UPPER_SNAKE constants)
- **Packages:** `{{groupId}}.boundary.rest`, `{{groupId}}.control`, `{{groupId}}.entity`
- **Domain neutrality:** No domain-specific names in templates

#### 2.4 Security

- SQL injection: No string concatenation in queries (`"SELECT ... " + param`)
- Input validation: `@Valid` on controller/resource methods for request bodies
- Secrets: No hardcoded passwords, tokens, or keys in source code/properties
- CORS: Not `allowedOrigins("*")` in production
- Security config: Swagger UI paths permitted, but not everything `permitAll()`

#### 2.5 Code Quality

- Unnecessary complexity or over-engineering
- Duplication (same logic in multiple places)
- Missing or incorrect exception handling
- Unused imports, dead code paths
- Lombok used sensibly (not overloaded)

#### 2.6 Configuration

- `application.properties` complete (DB, messaging, health, Flyway)
- `docker-compose.yml`: Health checks for all services
- Flyway migration present for every new entity
- `versions-maven-plugin` in the POM
- `renovate.json` in the project root

#### 2.7 Tests

- Architecture test (Taikai) present?
- New business logic (control layer) has unit tests?
- Test classes in the correct package?

### Step 3 – Create Report

Result as structured Markdown output in the chat:

```
## Review Result

### Summary
- X files reviewed
- X findings (Y critical, Z warnings, W notes)

### Critical
| # | File | Line | Problem | Solution |
|---|------|------|---------|----------|
| 1 | ... | ... | ... | ... |

### Warning
| # | File | Line | Problem | Solution |
|---|------|------|---------|----------|

### Note
| # | File | Line | Problem | Solution |
|---|------|------|---------|----------|

### Positive
- What is well done (don't just look for bugs!)
```

**Categorization:**

| Category | Criteria |
|----------|----------|
| **Critical** | Security vulnerability, possible data loss, architecture violation, `ddl-auto=create` |
| **Warning** | Convention violation, missing test, missing validation |
| **Note** | Improvement suggestion, style, readability |

**After the report:** Ask if findings should be fixed directly.
Only fix after explicit confirmation – never automatically.

---

## References

| File | Description |
|------|-------------|
| `.claude/lessons-learned.md` | Findings and corrections – read before every review |
| [references/review-checklist.md](references/review-checklist.md) | Detailed review catalog with rules per category |

---

## Conventions

- The review skill **does not change code** without confirmation
- Give positive feedback – don't just list errors
- When uncertain, classify as note rather than critical
- No findings for generated code (target/, build/)
- Detect framework (Spring Boot vs. Quarkus) and apply appropriate rules

### Position in Workflow

```
[spec-feature-skill]      optional – business requirements
        |
[openapi-skill]           if OpenAPI spec needed
        |
[java-scaffold-skill]     framework: DB, messaging, infra
        |
[review-skill]            <-- code review
        |
[doc-skill]               project documentation
```
