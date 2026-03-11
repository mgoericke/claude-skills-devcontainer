---
name: openapi
description: Creates, extends, and implements OpenAPI 3.x specifications. Three modes – create spec (from scratch), extend spec (add to existing spec), and generate code (Java classes in BCE pattern). Use this skill for "create an API spec", "define the API", "extend the API", "generate code from the OpenAPI spec", "new OpenAPI spec" or when a REST API needs to be designed.
argument-hint: "[api-name or spec-path]"
---

# OpenAPI Skill

Creates, extends, and implements OpenAPI 3.x specifications.
Supports three modes: **create** spec (from scratch), **extend** spec (add to existing spec),
and **generate code** (Java classes in BCE pattern from a spec).

> **Philosophy:** The OpenAPI spec is the contract. Whether it's being created, extended, or
> implemented – the contract is at the center. Design first, then build.

---

## What This Skill Does

1. **Detects the mode** – Create spec, extend spec, or generate code
2. **Creates OpenAPI specs** – Via structured interview: data models, endpoints, auth
3. **Extends existing specs** – Reads existing spec, adds new paths/schemas
4. **Generates code from specs** – DTOs, REST endpoints, and service stubs in BCE pattern

## How to Use

```
Create a new API spec for an order service
```

```
Extend the API in api/orders.yaml with a product endpoint
```

```
Generate code from the OpenAPI spec in api/openapi.yaml
```

```
Define a REST API for orders and products
```

---

## Instructions

> **Before every execution**:
> 1. Check `.claude/lessons-learned.md`

### Step 0 – Detect Mode

The three modes (create, extend, generate code) lead to completely different workflows. Clarify the mode first with `AskUserQuestion` so no unnecessary work is done.

```
What would you like to do?
```

Options:
- **Create new spec** – Design a new OpenAPI spec from scratch
- **Extend existing spec** – Add new endpoints or schemas to an existing spec
- **Generate code from spec** – Generate Java code (DTOs, controllers, services) from an existing spec

Jump to the corresponding steps based on mode:
- **Create new spec** → Steps A1–A4
- **Extend existing spec** → Steps B1–B4
- **Generate code from spec** → Steps 1–4 (existing behavior)

---

### Mode A: Create New Spec

#### Step A1 – Basics

**Ask with `AskUserQuestion`:**

| # | Question | Hint |
|---|----------|------|
| 1 | **API name** | Short name, becomes filename: `api/<name>.yaml` |
| 2 | **Description** | One sentence: What does this API do? |
| 3 | **Base path** | e.g. `/api/v1` – Default: `/api/v1` |

**Second question via `AskUserQuestion`:**

```
What auth scheme should the API use?
```

Options:
- **Bearer JWT (Recommended)** – Standard for Keycloak / OAuth2-based systems
- **API Key** – Simple, for internal services
- **OAuth2** – Full OAuth2 flow with scopes
- **No authentication** – Public API

#### Step A2 – Data Models

**First:** Scan existing entities in the project (directories `entity/`, `entity/model/`, `entity/dto/`).

If entities are found, offer via `AskUserQuestion` (multiSelect):

```
The following entities were found in the project. Which should be adopted into the API?
```

Options: list found entity classes (max 4, rest via "Other").

**Then:** For each new data model, ask interactively:

| # | Question | Hint |
|---|----------|------|
| 1 | **Schema name** | PascalCase, e.g. `Order`, `Product`, `OrderItem` |
| 2 | **Fields** | Name, type (`string`, `integer`, `number`, `boolean`, `array`, `$ref`), required? |
| 3 | **Relationships** | References to other schemas (`$ref: '#/components/schemas/...'`) |

Repeat the query until the user signals that all models are defined.

**Request/Response variants:** For each schema, check if separate request and response variants are needed (e.g. `CreateOrderRequest` without `id`, `OrderResponse` with `id` and timestamps).

#### Step A3 – Endpoints

Per data model, ask via `AskUserQuestion`:

```
What operations should the resource [SchemaName] support?
```

Options (multiSelect):
- **CRUD Set (Recommended)** – GET (list + detail), POST, PUT, DELETE
- **Read Only** – GET (list + detail)
- **Create + Read** – POST + GET
- **Define individually** – Specify custom endpoints

For each endpoint, define:
- HTTP method + path (derive from resource: `/orders`, `/orders/{id}`)
- Request body (reference to schema from A2)
- Response body + status codes (200, 201, 204, 400, 404)
- Query parameters (pagination: `page`, `size`, filtering)

#### Step A4 – Confirmation and Generation

Output compact summary:

```
API: Order Service (v1.0.0)
Auth: Bearer JWT
Base: /api/v1

Schemas (4):
  CreateOrderRequest, OrderResponse, ProductResponse, ErrorResponse

Endpoints (5):
  GET    /api/v1/orders          → OrderResponse[]
  POST   /api/v1/orders          → OrderResponse
  GET    /api/v1/orders/{id}     → OrderResponse
  GET    /api/v1/products        → ProductResponse[]
  GET    /api/v1/products/{id}   → ProductResponse

File: api/order-service.yaml

Generate?
```

**Only after confirmation** generate the YAML file. Template: `templates/openapi-spec.yaml.template`.

After generation, ask:

```
Should code be generated directly from the new spec?
```

If yes → continue with Steps 1–4 (generate code).

---

### Mode B: Extend Existing Spec

#### Step B1 – Read Spec

Ask for path to existing spec (if not passed as argument).
Read and analyze spec:

```
Existing spec: api/orders.yaml (v1.0.0)

Existing schemas (3):
  CreateOrderRequest, OrderResponse, ErrorResponse

Existing endpoints (3):
  GET    /api/v1/orders
  POST   /api/v1/orders
  GET    /api/v1/orders/{id}
```

#### Step B2 – New Data Models

Like Step A2, but additionally show existing schemas as reference.
Existing schemas can be used in `$ref` references of new schemas.

#### Step B3 – New Endpoints

Like Step A3, but only for new resources or additional operations on existing resources.

#### Step B4 – Confirmation and Merge

Summary shows only the **new** elements:

```
New schemas (2):
  ProductResponse, CreateProductRequest

New endpoints (2):
  GET    /api/v1/products        → ProductResponse[]
  POST   /api/v1/products        → ProductResponse

Existing spec will be extended: api/orders.yaml

Proceed?
```

Read existing YAML, add new paths and schemas, overwrite file.
Existing paths and schemas remain unchanged.

---

### Mode C: Generate Code from Spec

### Step 1 – Required Query

Before generation – if not already known:

If the skill is called with arguments (`/openapi api/openapi.yaml`), `$ARGUMENTS` is used as the spec path.

| # | Question | Hint |
|---|----------|------|
| 1 | **Path to OpenAPI spec** | `.yaml`, `.yml` or `.json`; relative to project root. Omitted if passed as `$ARGUMENTS`. |
| 2 | **Framework** | `Spring Boot` or `Quarkus` |
| 3 | **groupId / package** | e.g. `com.example.orders` |
| 4 | **DTO style** | `Java Record` (default) or `Class with Lombok` |
| 5 | **Include security annotations?** | Yes → `@RolesAllowed` / `@PreAuthorize` from spec security section |

### Step 2 – Read and Analyze Spec

Read the OpenAPI spec and extract the following:

| What | From |
|------|------|
| All paths + methods (GET, POST, PUT, DELETE, PATCH) | `paths` |
| Request bodies (schema references) | `requestBody.content.*.schema` |
| Response schemas (all status codes) | `responses.*.content.*.schema` |
| Path and query parameters | `parameters` |
| Schema definitions | `components/schemas` |
| Security definitions | `components/securitySchemes` + `security` per operation |
| Tags | `tags` – used for grouping |

### Step 3 – Output Summary

Before code generation, output a brief overview and get confirmation:

```
Found endpoints: 5
Found schemas (DTOs): 4
Framework: Quarkus
Package: com.example.orders

Planned files:
  boundary/rest/OrderResource.java      (3 endpoints: GET /orders, POST /orders, GET /orders/{id})
  boundary/rest/ProductResource.java    (2 endpoints: GET /products, GET /products/{id})
  entity/dto/OrderRequest.java          (Record)
  entity/dto/OrderResponse.java         (Record)
  entity/dto/ProductResponse.java       (Record)
  entity/dto/ErrorResponse.java         (Record)

Proceed?
```

### Step 4 – Generate Code

Order: DTOs first, then endpoints, then service stubs.

#### DTOs (entity/dto/)

- **Default: Java Record** – immutable, no boilerplate
- Lombok variant only on explicit request
- Field names 1:1 from the spec (camelCase)
- Nullable fields: `@Nullable` (JSpecify) + `Optional<T>` only when explicitly needed
- Validation annotations from spec:
  - `minLength` / `maxLength` → `@Size`
  - `minimum` / `maximum` → `@Min` / `@Max`
  - `required` → `@NotNull` / `@NotBlank`
  - `pattern` → `@Pattern`
- Enum values from spec as separate `enum` types in the same package

**Naming convention:**

| Spec Schema | Java Class |
|-------------|------------|
| `OrderRequest` | `OrderRequest.java` (Record) |
| `OrderResponse` | `OrderResponse.java` (Record) |
| `CreateOrderRequest` | `CreateOrderRequest.java` (Record) |
| Anonymous inline schema | Derive a descriptive name |

#### REST Endpoints (boundary/rest/)

Grouping by **OpenAPI tag**: One tag → one class.
No tag → name class after first path segment (`/orders/*` → `OrderResource`).

**Spring Boot Controller:**
```java
@RestController
@RequestMapping("/path")
@Validated
public class {{TAG}}Controller {
    private final {{TAG}}Service {{tag}}Service;
    // Constructor injection
    @GetMapping("/{id}")
    public ResponseEntity<{{ResponseDTO}}> findById(@PathVariable Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

**Quarkus Resource:**
```java
@Path("/path")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class {{TAG}}Resource {
    @Inject
    {{TAG}}Service {{tag}}Service;
    @GET
    @Path("/{id}")
    public {{ResponseDTO}} findById(@PathParam("id") Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

#### Service Stub (control/)

For each controller/resource, a matching **empty service stub** is created:

```java
@ApplicationScoped  // Quarkus
// @Service          // Spring Boot
public class {{TAG}}Service {
    public {{ResponseDTO}} findById(Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

---

## References

| File | Description |
|------|-------------|
| `.claude/lessons-learned.md` | Findings and corrections |
| [templates/openapi-spec.yaml.template](templates/openapi-spec.yaml.template) | OpenAPI spec template (Mode A/B) |
| [templates/spring/Controller.java.template](templates/spring/Controller.java.template) | Spring Boot controller template (Mode C) |
| [templates/quarkus/Resource.java.template](templates/quarkus/Resource.java.template) | Quarkus resource template (Mode C) |
| [templates/Dto.java.template](templates/Dto.java.template) | DTO template (Java Record, Mode C) |
| [templates/Service.java.template](templates/Service.java.template) | Service stub template (Mode C) |

### Supported OpenAPI Features

| Feature | Supported | Note |
|---------|-----------|------|
| OpenAPI 3.0.x / 3.1.x | Yes | |
| `$ref` to `components/schemas` | Yes | Resolved |
| Inline schemas | Yes | Name is derived |
| `oneOf` / `anyOf` / `allOf` | Partial | Simplified to interface or common base class |
| Path parameters | Yes | |
| Query parameters | Yes | |
| Header parameters | Yes | |
| Request body | Yes | |
| Response body | Yes | Only 2xx responses |
| Security (`bearer`, `oauth2`) | Yes | → `@RolesAllowed` / `@PreAuthorize` when enabled |
| Multipart / file upload | Partial | `MultipartFormDataInput` (Quarkus) / `MultipartFile` (Spring) |
| Webhooks | No | Not supported |

---

## Conventions

- **Language:** English in code and Javadoc comments
- **Packages:** `{{GROUP_ID}}.boundary.rest` (endpoints), `{{GROUP_ID}}.entity.dto` (DTOs), `{{GROUP_ID}}.control` (service stubs)
- No Hibernate / JPA in DTOs – these are pure transfer objects
- No business logic in controller/resource – only delegation to service
- `UnsupportedOperationException` as placeholder – signals "not yet implemented"
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via openapi`

### Position in Workflow

```
[spec-feature]      optional – business requirements
        |
[openapi]           <-- create spec OR extend OR generate code
        |
[java-scaffold]     framework: DB, messaging, infra – do NOT regenerate REST/DTOs
        |
[review]            code review
        |
[doc]               project documentation
```

**Important for java-scaffold:** If openapi has already generated code,
**do not** regenerate `boundary/rest/` and `entity/dto/` classes – only generate the rest
of the project framework (pom.xml, docker-compose, application.properties, Flyway, architecture test).
