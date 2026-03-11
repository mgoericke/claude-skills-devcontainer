# Review Checklist

Detailed review catalog for the review.
Each rule contains: what is checked, what a violation looks like, and what the solution is.

---

## 1. Architecture – BCE Pattern

### 1.1 Boundary Layer (`boundary/rest/`, `boundary/messaging/`)

| Rule | Violation | Solution |
|------|-----------|----------|
| Controller/Resource only calls services | Direct repository access in controller | Create service method, controller delegates |
| No business logic in controller | if/else chains, calculations in controller | Move logic to service (control) |
| `@Valid` on request body parameters | `@RequestBody` without `@Valid` | Add `@Valid` |
| REST classes in `boundary/rest/` | Controller in wrong package | Move to `boundary/rest/` |
| Messaging classes in `boundary/messaging/` | Consumer in wrong package | Move to `boundary/messaging/` |

### 1.2 Control Layer (`control/`)

| Rule | Violation | Solution |
|------|-----------|----------|
| Services are `@Service` (Spring) or `@ApplicationScoped` (Quarkus) | Missing annotation | Add annotation |
| `@Transactional` on write methods | Write DB operation without transaction | Add `@Transactional` |
| `readOnly = true` on read methods (Spring) | Read method without `readOnly` | `@Transactional(readOnly = true)` |
| No direct access to HTTP artifacts | `HttpServletRequest` in service | Keep HTTP logic in boundary |

### 1.3 Entity Layer (`entity/`, `entity/dto/`)

| Rule | Violation | Solution |
|------|-----------|----------|
| JPA entity with `@Entity` and `@Table` | Missing annotations | Add them |
| UUID as ID type | `Long` or `Integer` as ID | Use `UUID` |
| Timestamps: `createdAt`, `updatedAt` | Missing audit fields | Add fields with `@CreationTimestamp`/`@UpdateTimestamp` |
| DTOs as Java Records | DTO as class instead of record | Rewrite as `record` |
| No business logic in entities | Service methods in entity class | Move to control layer |

---

## 2. Lessons-Learned Comparison

Reference: `.claude/lessons-learned.md`

### 2.1 Quarkus-specific

| Rule | Violation | Reference |
|------|-----------|-----------|
| `@Blocking @Transactional` on `@Incoming` with DB | `@Incoming` without `@Blocking` | Section "Quarkus – @Blocking in Consumer" |
| RabbitMQ: `rabbitmq-host`, not `quarkus.rabbitmq.*` | Wrong property keys | Section "Quarkus – RabbitMQ Messaging Config" |
| Disable dev services per extension | `quarkus.devservices.enabled=false` globally | Section "DevContainer – Dev Services vs. Docker Compose" |
| Dockerfile in `src/main/docker/` | Dockerfile in project root | Section "Quarkus – Dockerfile Convention" |
| Quarkus 3.31+ for Java 25 | Quarkus < 3.31 with Java 25 | Section "Quarkus – Java 25 Compatibility" |

### 2.2 Spring Boot-specific

| Rule | Violation | Reference |
|------|-----------|-----------|
| `ddl-auto=validate`, never `create`/`update` | `ddl-auto=create` or `update` | Section "Spring Boot – ddl-auto=validate" |
| Flyway migration for every entity | Entity without migration in `db/migration/` | Section "Spring Boot – ddl-auto=validate" |
| Dockerfile in project root | Dockerfile in `src/main/docker/` | Section "Quarkus – Dockerfile Convention" (inverse) |

### 2.3 Cross-framework

| Rule | Violation | Reference |
|------|-----------|-----------|
| Health checks present | No Actuator/SmallRye-Health dependency | Section "Health Checks are Mandatory" |
| Taikai architecture test present | No ArchitectureTest in project | Section "Taikai vs. ArchUnit" |
| Co-author in Javadoc | Generated file without `@author Co-Author` | Section "Javadoc Co-Author Mandatory" |
| Domain-neutral examples | Domain-specific names in templates | Section "Domain-Neutral Examples" |

---

## 3. Security

| Rule | Violation | Severity |
|------|-----------|----------|
| No SQL string concatenation | `"SELECT * FROM x WHERE id = " + id` | Critical |
| No hardcoded secrets | `password = "secret"` in code | Critical |
| `@Valid` on request bodies | Missing input validation | Warning |
| CORS not `*` in production | `allowedOrigins("*")` without profile separation | Warning |
| Swagger UI allowed in security config | 403 on `/swagger-ui/**` | Note |
| No sensitive data in logs | `log.info("Token: " + token)` | Critical |
| HTTPS/TLS for external calls | `http://` for external APIs | Warning |

---

## 4. Code Quality

| Rule | Violation | Severity |
|------|-----------|----------|
| No code duplication | Same logic copied > 2x | Warning |
| No empty catch blocks | `catch (Exception e) { }` | Warning |
| No magic numbers/strings | Hardcoded values without constant | Note |
| No unused imports | Import without usage | Note |
| Methods < 30 lines | Overly long methods | Note |
| Meaningful variable names | `x`, `temp`, `data` as variable names | Note |
| Lombok used sensibly | `@Data` on entity (ok), but not on DTOs (records!) | Note |

---

## 5. Configuration

| File | Rule | Violation |
|------|------|-----------|
| `pom.xml` | `versions-maven-plugin` present | Plugin missing |
| `pom.xml` | Taikai as test dependency | Missing or wrong scope |
| `renovate.json` | File in project root | File missing |
| `application.properties` | Health endpoints enabled | Actuator/SmallRye missing |
| `application.properties` | Flyway enabled | Flyway config missing |
| `docker-compose.yml` | Health checks for all services | `healthcheck` block missing |
| `Dockerfile` | `HEALTHCHECK` directive | Missing |

---

## 6. Tests

| Rule | Violation | Severity |
|------|-----------|----------|
| Architecture test (Taikai) present | No `ArchitectureTest.java` | Warning |
| Service logic has unit tests | New service method without test | Note |
| Test classes in correct package | Test not in mirror package | Note |
| Test naming: `should...When...` | Unclear test method names | Note |

---

## 7. Language & Naming

| Rule | Violation |
|------|-----------|
| Code (classes, methods, variables): **English** | German identifiers in code |
| Comments, Javadoc: **English** | Non-English comments |
| Packages: lowercase, no underscores | `com.example.Order_Service` |
| Classes: UpperCamelCase | `orderService` as class name |
| Methods: lowerCamelCase | `GetOrder` as method name |
| Constants: UPPER_SNAKE_CASE | `maxRetries` as constant |
