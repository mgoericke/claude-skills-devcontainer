---
name: java-scaffold-skill
description: Scaffolding für Java-Projekte mit Spring Boot oder Quarkus, PostgreSQL, RabbitMQ und Docker. Verwende diesen Skill wenn eine neue Java-Anwendung, Entity, Dockerfile oder docker-compose erstellt werden soll.
argument-hint: "[framework] [beschreibung]"
---

# Java Scaffold Skill

Scaffolding für Java-Projekte mit Spring Boot oder Quarkus.

> **Philosophie:** Vor jeder Generierung: lessons-learned.md prüfen + aktuelle Versionen
> im Internet abfragen – niemals veraltete Versionen aus dem Gedächtnis verwenden.

---

## When to Use This Skill

- Ein neues Java-Projekt (Spring Boot oder Quarkus) soll erstellt werden
- Eine neue Entity mit Repository, Service und Controller/Resource wird benötigt
- Ein Dockerfile oder eine Docker Compose Datei soll generiert werden
- Architekturtests (Taikai) sollen angelegt werden
- Konfigurationsdateien (`application.properties`, `pom.xml`) sollen erstellt werden
- Eine Flyway-Migration für eine neue Entity wird benötigt
- Formulierungen wie "erstelle ein neues Projekt", "scaffold", "neues Modul", "neue Entity"

## What This Skill Does

1. **Fragt Projekt-Koordinaten ab** – groupId, artifactId, Framework (Spring Boot / Quarkus)
2. **Prüft aktuelle Versionen** – Spring Boot, Quarkus, Taikai im Internet verifizieren
3. **Generiert Projektstruktur** – pom.xml, application.properties, docker-compose.yml
4. **Erstellt BCE-Schichten** – Entity, Repository, Service, Controller/Resource im BCE-Pattern
5. **Erstellt Flyway-Migration** – Initiales SQL-Schema passend zur Entity
6. **Erstellt Infrastruktur** – Dockerfile, Health Checks, Swagger UI, Renovate-Config
7. **Erstellt Architekturtests** – Taikai-basierter ArchitectureTest

## How to Use

```
Erstelle ein neues Spring Boot Projekt mit PostgreSQL und RabbitMQ
```

```
Erstelle eine neue Entity "Product" mit Name und Preis
```

```
Generiere ein Dockerfile für mein Quarkus-Projekt
```

```
Erstelle eine docker-compose.yml mit PostgreSQL und Keycloak
```

---

## Instructions

> **Vor jeder Generierung**:
> 1. `.claude/lessons-learned.md` prüfen
> 2. **Aktuelle Versionen im Internet abfragen** (Maven Central / GitHub Releases) – niemals veraltete Versionen aus dem Gedächtnis verwenden!

### Schritt 1 – Pflichtabfrage

Vor jeder neuen Anwendung oder jedem Modul – sofern nicht bereits bekannt – **immer alle
folgenden Fragen stellen, bevor Code generiert wird**:

#### 1a – Projekt-Koordinaten

| # | Angabe | Beispiel |
|---|--------|---------|
| 1 | `groupId` | `com.example.orders` |
| 2 | `artifactId` | `order-service` |
| 3 | **Framework** | `Spring Boot` oder `Quarkus` |

#### 1b – OpenAPI Spec vorhanden? (optional)

**Vor dem Scaffold fragen:** Gibt es eine OpenAPI-Spezifikation für dieses Projekt?

- **Ja** → zuerst `openapi-skill` ausführen lassen; danach beim Scaffold
  `boundary/rest/` und `entity/dto/` **nicht** nochmal generieren – nur Rahmen
  (pom.xml, docker-compose, application.properties, Flyway, Architekturtest, Dockerfile).
- **Nein** → normal weitermachen, alle Schichten generieren.

#### 1c – Benötigte Dienste

Explizit abfragen, welche Dienste tatsächlich benötigt werden:

| Dienst | Abhängigkeit (Spring) | Abhängigkeit (Quarkus) | Standard |
|--------|----------------------|------------------------|---------|
| **Datenbank** (PostgreSQL) | `spring-boot-starter-data-jpa`, `postgresql`, Flyway | `quarkus-hibernate-orm-panache`, `quarkus-jdbc-postgresql`, Flyway | Ja |
| **REST / Swagger UI** | `springdoc-openapi-starter-webmvc-ui` | `quarkus-smallrye-openapi` | **Ja** (immer bei REST) |
| **Messaging** (RabbitMQ) | `spring-boot-starter-amqp` | `quarkus-messaging-rabbitmq` | Nein |
| **Auth / IAM** (Keycloak) | `spring-boot-starter-oauth2-resource-server` | `quarkus-oidc` | Nein |

Nur bestätigte Dienste werden in `pom.xml`, `docker-compose.yml` und `application.properties`
aufgenommen. Nicht benötigte Dienste vollständig weglassen – keine auskommentierten Blöcke.

Nie raten oder Defaults verwenden – immer explizit fragen.

### Schritt 2 – Versionsprüfung (PFLICHT)

**Bevor Code generiert wird**, müssen folgende Versionen aktuell abgefragt werden:

| Artifact | Wo prüfen |
|----------|-----------|
| Spring Boot Parent POM | https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent |
| Quarkus BOM | https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom |
| Taikai | https://central.sonatype.com/artifact/com.enofex/taikai |
| versions-maven-plugin | https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin |

**Bekannte Versionen (Stand 2026-03-01 – immer im Internet verifizieren!):**

| Artifact | Version | Java 25 kompatibel |
|----------|---------|-------------------|
| Spring Boot | 4.0.3 | ✅ (volles Java 25 Support) |
| Quarkus | 3.31.4 | ✅ (volles Java 25 Support ab 3.31) |
| Taikai | 1.60.0 | ✅ |
| versions-maven-plugin | 2.21.0 | ✅ |

> ⚠️ **Quarkus 3.27 (LTS) läuft zwar mit Java 25, produziert aber Warnungen.**
> Für Java 25 zwingend **Quarkus 3.31+** verwenden.

### Schritt 3 – Code generieren

Reihenfolge der Generierung:

1. `pom.xml` mit allen Dependencies, versions-maven-plugin, Taikai
2. `application.properties` (DB, Flyway, Health, ggf. Messaging, Auth)
3. Entity + Repository (`entity/`)
4. Service (`control/`)
5. Controller/Resource (`boundary/rest/`)
6. Consumer (`boundary/messaging/`) – nur wenn RabbitMQ bestätigt
7. Security-Config – nur wenn Keycloak bestätigt
8. Flyway-Migration (`db/migration/V1__create_<entity>_table.sql`)
9. Architekturtest (`ArchitectureTest.java`)
10. Dockerfile (Spring: Root, Quarkus: `src/main/docker/Dockerfile.jvm`)
11. `docker-compose.yml` mit Health Checks
12. `renovate.json`

### Schritt 4 – Swagger UI (PFLICHT bei REST)

Jede Anwendung mit REST-Endpunkten erhält eine **Swagger UI**:

| Framework | Dependency (groupId:artifactId) | Swagger-UI-URL | OpenAPI-JSON-URL |
|-----------|---------------------------------|---------------|-----------------|
| **Spring Boot** | `org.springdoc:springdoc-openapi-starter-webmvc-ui` | `/swagger-ui.html` | `/v3/api-docs` |
| **Quarkus** | `io.quarkus:quarkus-smallrye-openapi` | `/q/swagger-ui` | `/q/openapi` |

**Versionen vor Generierung im Internet prüfen:**
- Spring Boot: https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-starter-webmvc-ui
- Quarkus: Teil des Quarkus BOM – keine eigene Version nötig

**Wichtig bei Security (Spring Boot):** Die `SecurityConfig` muss Swagger-UI-Pfade explizit
freigeben (bereits im Template enthalten):
```java
.requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**").permitAll()
```

**Wichtig bei Quarkus:** `quarkus.swagger-ui.always-include=true` aktivieren, damit die
Swagger UI auch im Produktions-Modus (nicht nur `quarkus:dev`) verfügbar bleibt.

### Schritt 5 – Health Checks (PFLICHT)

Jede Anwendung **muss** Health-Endpunkte bereitstellen:

| Framework | Endpunkt | Dependency |
|-----------|----------|-----------|
| Spring Boot | `/actuator/health` | `spring-boot-starter-actuator` |
| Quarkus | `/q/health/live`, `/q/health/ready` | `quarkus-smallrye-health` |

Health Checks werden verwendet in:
- `HEALTHCHECK` im Dockerfile
- `healthcheck` im `docker-compose.yml`

### Schritt 6 – Architekturtests (PFLICHT)

Taikai-Test **immer** anlegen. Template: `templates/arch/ArchitectureTest.java.template`

```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version><!-- VOR GENERIERUNG AKTUELLE VERSION PRÜFEN: https://central.sonatype.com/artifact/com.enofex/taikai --></version>
    <scope>test</scope>
</dependency>
```

### Schritt 7 – versions-maven-plugin (PFLICHT)

Jede generierte `pom.xml` enthält das `versions-maven-plugin` im `<build><pluginManagement>` Block:

```xml
<build>
  <pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>versions-maven-plugin</artifactId>
        <version><!-- AKTUELLE VERSION: https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin --></version>
        <configuration>
          <generateBackupPoms>false</generateBackupPoms>
        </configuration>
      </plugin>
    </plugins>
  </pluginManagement>
</build>
```

Nützliche Befehle für Entwickler:
```bash
./mvnw versions:display-dependency-updates
./mvnw versions:display-plugin-updates
./mvnw versions:display-parent-updates
```

### Schritt 8 – Renovate (PFLICHT)

Jedes generierte Projekt erhält `renovate.json` aus `templates/renovate.json`.

---

## References

| Datei | Beschreibung |
|-------|-------------|
| `.claude/lessons-learned.md` | Erkenntnisse und Korrekturen – vor jeder Generierung prüfen |
| [templates/spring/](templates/spring/) | Spring Boot Templates (Entity, Controller, Service, Consumer, Security, Dockerfile, Properties, docker-compose) |
| [templates/quarkus/](templates/quarkus/) | Quarkus Templates (Entity, Resource, Service) + `src-main-docker/` für Dockerfiles |
| [templates/arch/ArchitectureTest.java.template](templates/arch/ArchitectureTest.java.template) | Taikai-basierter Architekturtest |
| [templates/db/V1__create_table.sql.template](templates/db/V1__create_{{ENTITY_NAME_LOWER}}_table.sql.template) | Initiale Flyway-Migration |
| [templates/renovate.json](templates/renovate.json) | Renovate-Konfiguration für automatische Dependency-Updates |

### Platzhalter

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

## Conventions

- **Stack:** Java 25 · Spring Boot 4.x oder Quarkus 3.31+ · PostgreSQL 17 · RabbitMQ 4 · Keycloak 26.x · Maven 3.9 · Docker
- **Architektur:** BCE-Pattern strikt (Boundary / Control / Entity)
- **Entities:** Lombok `@Data` + `@Builder`
- **Persistenz:** Flyway für alle Migrationen – kein `ddl-auto=create`
- **Messaging:** RabbitMQ-Consumer immer in `boundary/messaging/`; Quarkus: `@Blocking` + `@Transactional` bei DB-Zugriffen im Consumer
- **Dockerfile:** Spring Boot → `./Dockerfile` (Root); Quarkus → `src/main/docker/Dockerfile.jvm`
- **Beispiele:** Fachlich neutral (`order`, `product`, `event`, `item`)
- **Sprache:** Deutsch in Kommentaren/Doku, Englisch im Code
- **Commits:** Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill`

### Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[openapi-skill]           wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               Projektdokumentation
```
