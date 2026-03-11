---
name: spec-feature-skill
description: Spec Driven Development – gathers business features through a structured interview sequence (context, behavior, technical hints, quality) and creates a specification file in specs/. Use this skill for "specify a feature", "create a spec", "describe the feature", "what should the system do?" or when requirements should be captured in a structured way before code is written.
argument-hint: "[feature-name]"
---

# Spec Feature Skill

Structured interview for capturing business requirements.
The result is a spec file in `specs/` that serves as the foundation for implementation,
tests, and documentation.

> **Philosophy:** First understand, then build. The spec is the shared language
> between business requirements and code.

---

## What This Skill Does

1. **Conducts structured interview** – 4 question groups (Context, Behavior, Technical Hints, Quality) asked sequentially
2. **Summarizes answers** – Compact summary for confirmation
3. **Creates spec file** – `specs/<feature-name-kebab-case>.md` from template

## How to Use

```
I want to specify a new feature
```

```
Create a spec for order processing
```

```
Describe the feature user registration before we implement
```

---

## Instructions

### Step 1 – Interview

The interview is the content foundation for the entire spec. Ask questions sequentially – one group at a time, so the user can answer with focus. Collect answers and summarize at the end of each phase.

#### Group 1 – Context

1. **What is the feature called?** _(short, business-oriented name – becomes the filename)_
2. **What is the goal?** _(1–3 sentences: what problem is being solved?)_
3. **Who uses it?** _(role / actor, e.g. "case worker", "external API client")_

#### Group 2 – Behavior

4. **What should the system do?** _(main flow in simple sentences)_
5. **What variants / edge cases exist?** _(alternative flows, error cases)_
6. **What should the system explicitly NOT do?** _(boundaries – prevents scope creep)_

#### Group 3 – Technical Hints

7. **Are there API endpoints?** _(method + path, e.g. `POST /orders`)_
8. **What data is involved?** _(fields, types – rough is fine)_
9. **Are there messaging events?** _(published / consumed, channel names)_
10. **Are there dependencies on other features / services?**

#### Group 4 – Quality

11. **What acceptance criteria must be met?** _(measurable, testable)_
12. **Are there non-functional requirements?** _(performance, security, availability)_
13. **Are there any open questions / assumptions?**

### Step 2 – Summary

After the interview: summarize all answers compactly and get confirmation.
Only write the spec file after confirmation.

### Step 3 – Create Spec File

Filename: `specs/<feature-name-kebab-case>.md`
Template: see `templates/feature-spec.md.template`

---

## References

| File | Description |
|------|-------------|
| [templates/feature-spec.md.template](templates/feature-spec.md.template) | Template for the spec file |

---

## Conventions

- **Filename:** kebab-case, English (`order-creation.md`)
- **Feature name (heading):** Title case, English (`Order Creation`)
- **Code artifacts in the proposal:** English (`OrderService`, `createOrder`)

### Integration with java-scaffold-skill

After spec creation, the `java-scaffold-skill` can use the spec as input:

```
Implement the feature according to specs/order-creation.md
```

The scaffold skill reads the spec and derives:
- Boundary: REST endpoints and/or messaging consumers
- Control: Service classes for business logic
- Entity: JPA entities, Flyway migration, repositories

### Position in Workflow

```
[spec-feature-skill]      <-- capture business requirements
        |
[openapi-skill]           if OpenAPI spec needed
        |
[java-scaffold-skill]     framework: DB, messaging, infra
        |
[review-skill]            code review
        |
[doc-skill]               project documentation
```
