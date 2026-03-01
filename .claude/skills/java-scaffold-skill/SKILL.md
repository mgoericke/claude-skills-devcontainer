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

Nach Framework-Wahl nur den relevanten Ordner lesen:

| Framework | Pfad |
|-----------|------|
| Spring Boot | `templates/spring/` |
| Quarkus | `templates/quarkus/` |
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

## Projektstruktur (BCE)

```
src/main/java/{{PACKAGE_PATH}}/
├── boundary/
│   ├── rest/          # REST-Endpunkte
│   └── messaging/     # Consumer/Listener
├── control/           # Business-Logik (@Service / @ApplicationScoped)
└── entity/            # Entities, Repositories, DTOs
```

---

## Architekturtests

Taikai-Test **immer** anlegen – verhindert BCE-Verletzungen zur Build-Zeit.
Template: `templates/arch/ArchitectureTest.java.template`

```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version>1.49.0</version>
    <scope>test</scope>
</dependency>
```

---

## Coding-Konventionen

- BCE-Pattern strikt (Boundary / Control / Entity)
- Entities: Lombok `@Data` + `@Builder`
- Flyway für alle Migrationen – kein `ddl-auto=create`
- RabbitMQ-Consumer **immer** in `boundary/messaging/`
- Quarkus: `@Blocking` + `@Transactional` bei DB-Zugriffen im Consumer
- Conventional Commits: `feat:` `fix:` `docs:` `chore:`
- Sprache: Deutsch in Doku, Englisch im Code
