---
name: java-scaffold-skill
description: Scaffolding für Java-Projekte mit Spring Boot oder Quarkus, PostgreSQL, RabbitMQ und Docker. Verwende diesen Skill immer wenn eine neue Java-Anwendung, ein Modul, eine Entity, ein Dockerfile, eine Docker Compose Datei, Architekturtests oder Konfigurationsdateien erstellt werden sollen. Fragt immer nach groupId, artifactId und Framework bevor Code generiert wird.
---

# Java Scaffold Skill

Scaffolding für Java-Projekte mit Spring Boot oder Quarkus.

> **Vor jeder Generierung**: `.claude/lessons-learned.md` prüfen!

## ⚠️ Pflichtabfrage

Vor jeder neuen Anwendung oder jedem Modul – sofern nicht bereits bekannt:

| # | Angabe | Beispiel |
|---|--------|---------|
| 1 | `groupId` | `com.example.orders` |
| 2 | `artifactId` | `order-service` |
| 3 | **Framework** | `Spring Boot` oder `Quarkus` |

Nie raten oder Defaults verwenden – immer explizit fragen.

---

## Stack

- **Java 25** · **Spring Boot 3.x** oder **Quarkus 3.x**
- **PostgreSQL 17** · **RabbitMQ 4**
- **Maven 3.9** · **Docker + Docker Compose**
- **Taikai** (Architektur-Tests, nur `test` scope)

---

## Templates

| Framework | Pfad |
|-----------|------|
| Spring Boot | `templates/spring/` |
| Quarkus | `templates/quarkus/` + `templates/quarkus/src-main-docker/` |
| Architektur-Tests | `templates/arch/` |

**Platzhalter:**

| Platzhalter | Beispiel |
|-------------|---------|
| `{{GROUP_ID}}` | `com.example.orders` |
| `{{ARTIFACT_ID}}` | `order-service` |
| `{{PACKAGE_PATH}}` | `com/example/orders` |
| `{{ENTITY_NAME}}` | `Order` |
| `{{ENTITY_NAME_LOWER}}` | `order` |
| `{{CHANNEL_IN}}` | `orders-in` |
| `{{CHANNEL_OUT}}` | `orders-out` |

---

## Dockerfile-Konventionen

| Framework | Speicherort | Build |
|-----------|-------------|-------|
| **Spring Boot** | `./Dockerfile` (Projekt-Root) | `docker build -t {{ARTIFACT_ID}} .` |
| **Quarkus JVM** | `src/main/docker/Dockerfile.jvm` | `./mvnw package -DskipTests` → `docker build -f src/main/docker/Dockerfile.jvm` |
| **Quarkus Native** | `src/main/docker/Dockerfile.native-micro` | `./mvnw package -Pnative` |

Quarkus-Projekte verwenden **immer** die Dockerfiles in `src/main/docker/` – das ist die offizielle Quarkus-Konvention.

---

## Health Checks – PFLICHT

Jede Anwendung **muss** Health-Endpunkte bereitstellen:

| Framework | Endpunkt | Dependency |
|-----------|----------|-----------|
| Spring Boot | `/actuator/health` | `spring-boot-starter-actuator` |
| Quarkus | `/q/health/live`, `/q/health/ready` | `quarkus-smallrye-health` |

Health Checks werden verwendet in:
- `HEALTHCHECK` im Dockerfile
- `healthcheck` im `docker-compose.yml`

---

## Architekturtests – PFLICHT

Taikai-Test **immer** anlegen. Template: `templates/arch/ArchitectureTest.java.template`

```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version>1.49.0</version>
    <scope>test</scope>
</dependency>
```

---

## Javadoc Co-Author

**Jede generierte Datei** erhält einen Javadoc/Kommentar-Header mit:
```java
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill
```
In nicht-Java-Dateien (Properties, YAML) als Kommentar:
```
# Co-Author: Claude (claude-sonnet-4-6, Anthropic)
```

---

## Coding-Konventionen

- BCE-Pattern strikt (Boundary / Control / Entity)
- Entities: Lombok `@Data` + `@Builder`
- Flyway für alle Migrationen – kein `ddl-auto=create`
- RabbitMQ-Consumer **immer** in `boundary/messaging/`
- Quarkus: `@Blocking` + `@Transactional` bei DB-Zugriffen im Consumer
- Fachlich neutrale Beispiele: `order`, `product`, `event`, `item`
- Conventional Commits: `feat:` `fix:` `docs:` `chore:`
- Sprache: Deutsch in Doku, Englisch im Code
