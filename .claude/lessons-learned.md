# Lessons Learned

Erkenntnisse, Korrekturen und Entscheidungen aus der Arbeit mit diesem Template.
Claude Code prüft diese Datei vor jeder Generierung.

---

## Quarkus – RabbitMQ Messaging Config

**Problem:** Falsche Property-Keys für RabbitMQ-Konfiguration.

**Richtig (SmallRye Reactive Messaging, `quarkus-messaging-rabbitmq`):**
```properties
# Globale Broker-Verbindung
rabbitmq-host=localhost
rabbitmq-port=5672
rabbitmq-username=app
rabbitmq-password=app

# Channel-Mapping – incoming → Queue, outgoing → Exchange
mp.messaging.incoming.[channel-name].connector=smallrye-rabbitmq
mp.messaging.incoming.[channel-name].queue.name=[queue-name]
mp.messaging.outgoing.[channel-name].connector=smallrye-rabbitmq
mp.messaging.outgoing.[channel-name].exchange.name=[exchange-name]
```

**Falsch (nicht verwenden):**
```properties
RABBITMQ_HOST=...         # Nur Docker Compose Umgebungsvariablen
quarkus.rabbitmq.*=...    # Quarkiverse RabbitMQ Client – anderes Produkt!
```

**Dev Services deaktivieren – pro Extension, nicht global:**
```properties
quarkus.rabbitmq.devservices.enabled=false   # RabbitMQ
quarkus.datasource.devservices.enabled=false  # PostgreSQL
```
`quarkus.devservices.enabled=false` greift für RabbitMQ **nicht**.

Dependency:
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-messaging-rabbitmq</artifactId>
</dependency>
```
Quelle: https://quarkus.io/guides/rabbitmq-reference

---

## Quarkus – @Blocking im Consumer

`@Incoming`-Methoden laufen auf I/O-Threads. Bei JPA/DB-Zugriff **immer**:
```java
@Incoming("orders-in")
@Blocking
@Transactional
public void handle(String payload) { ... }
```
Ohne `@Blocking` → Deadlock oder IllegalStateException bei JPA-Operationen.

---

## Quarkus – Dockerfile-Konvention

Quarkus legt Dockerfiles per Konvention in `src/main/docker/`:
- `Dockerfile.jvm` – Fast-JAR (Standard)
- `Dockerfile.native-micro` – GraalVM Native Image

**Nicht** im Projekt-Root anlegen (das ist Spring Boot Konvention).

Docker Compose referenziert:
```yaml
dockerfile: src/main/docker/Dockerfile.jvm
```

Typischer Build-Flow:
```bash
./mvnw package -DskipTests
docker build -f src/main/docker/Dockerfile.jvm -t my-service .
```

---

## Health Checks sind Pflicht

Jede Anwendung muss Health-Endpunkte bereitstellen:

| Framework | Endpunkt | Aktivierung |
|-----------|----------|------------|
| Spring Boot | `/actuator/health` | `spring-boot-starter-actuator` + `management.endpoint.health.probes.enabled=true` |
| Quarkus | `/q/health/live`, `/q/health/ready` | `quarkus-smallrye-health` |

Health Checks werden verwendet in:
- `HEALTHCHECK` Direktive im Dockerfile
- `healthcheck` Block im `docker-compose.yml` für die Anwendung selbst

---

## DevContainer – Dev Services vs. Docker Compose

Quarkus Dev Services starten per Testcontainers automatisch PostgreSQL und RabbitMQ.
Im DevContainer (Docker-in-Docker) kann das mit Docker Desktop kollidieren.
→ Dev Services pro Extension deaktivieren, echte Services via `docker compose up` starten.

---

## ANTHROPIC_API_KEY ist optional

Der Key kann über Umgebungsvariable gesetzt werden **oder** der Entwickler
loggt sich nach Container-Start direkt ein:
```bash
claude login
```
Kein Pflichtfeld mehr im `devcontainer.json`.

---

## GIT_TOKEN statt GITHUB_TOKEN

Token für Git-Registries (GitHub Packages, GitLab Registry, Gitea, Bitbucket) heißt
`GIT_TOKEN` – nicht `GITHUB_TOKEN`. Damit ist kein Vendor Lock-in impliziert.

---

## Taikai vs. ArchUnit

- **Taikai** – basiert auf ArchUnit, weniger Boilerplate, Quarkus-spezifische Regeln eingebaut → bevorzugen
- **ArchUnit** – direkter, mehr Flexibilität bei komplexen Custom-Rules

**Achtung:** Taikai's `NamingConfigurer` hat **kein** `classesShouldMatch(String package, String regex)`.
Für paket-spezifische Naming-Regeln (z.B. "Controller nur in boundary.rest") direkt ArchUnit verwenden:
```java
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;

ArchRule rule = classes()
        .that().haveSimpleNameEndingWith("Controller")
        .should().resideInAPackage("..boundary.rest..");
rule.check(importedClasses);
```
ArchUnit wird transitiv über Taikai mitgeliefert – keine zusätzliche Dependency nötig.

Dependency (nur `test` scope!):
```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version>1.60.0</version><!-- Stand 2026-03-01 – vor Generierung im Internet prüfen! -->
    <scope>test</scope>
</dependency>
```
Aktuelle Version prüfen: https://central.sonatype.com/artifact/com.enofex/taikai
Quelle: https://www.the-main-thread.com/p/architecture-testing-java-quarkus-taikai

---

## Javadoc Co-Author Pflicht

Jede generierte Datei erhält einen Co-Author-Hinweis:
```java
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill
```
In Properties/YAML als Kommentar:
```
# Co-Author: Claude (claude-sonnet-4-6, Anthropic)
```

---

## Fachlich neutrale Beispiele

Templates verwenden neutrale Domänenbegriffe: `order`, `product`, `event`, `item`.
Keine domänenspezifischen Namen wie `Antrag`, `Akte`, `Buergerservice` in Templates.

---

## Versionspflicht – vor jeder Generierung Internet prüfen

**Niemals Versionen aus dem Gedächtnis verwenden.** Vor jedem Scaffold die aktuellen
Versionen im Internet abfragen. Bekannte Versionen (Stand 2026-03-01):

| Artifact | Version | Quelle |
|----------|---------|--------|
| Spring Boot | 4.0.3 | https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent |
| Quarkus BOM | 3.31.4 | https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom |
| Taikai | 1.60.0 | https://central.sonatype.com/artifact/com.enofex/taikai |
| versions-maven-plugin | 2.21.0 | https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin |

---

## Quarkus – Java 25 Kompatibilität

**Quarkus 3.27 (LTS)** läuft technisch mit Java 25, produziert aber Warnungen.
Für Java 25 **zwingend Quarkus 3.31+** verwenden (volle Java 25 Unterstützung seit 3.31.0).

---

## Spring Boot 4.x – Breaking Changes gegenüber 3.x

Spring Boot 4.0 (November 2025) bringt:
- Basiert auf **Spring Framework 7** und **Jakarta EE 11**
- Servlet 6.1 als Baseline (Servlet 5.x nicht mehr unterstützt)
- **Vollständige Java 25 Unterstützung**
- **Modularisierte Auto-Configuration** (kleinere, fokussierte JARs)

**WICHTIG – Modularisierung:** In Spring Boot 4.x reicht `flyway-core` allein NICHT mehr
für die Auto-Configuration. Statt `flyway-core` muss `spring-boot-starter-flyway` verwendet werden:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-flyway</artifactId>
</dependency>
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-database-postgresql</artifactId>
</dependency>
```
Ohne `spring-boot-starter-flyway` wird Flyway nicht gestartet und Hibernate `validate`
schlägt fehl mit "missing table".

Migration von 3.x: https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Migration-Guide

---

## Keycloak – Konfiguration für Spring Boot und Quarkus

Keycloak läuft im Dev-Modus (`start-dev`) mit H2 file-basierter Datenbank (dev-file).
Kein externer Datenbankserver nötig – Daten werden im Container gespeichert (nicht persistent).

**Port:** 8180 (extern) → 8080 (intern im Container)
**Admin-Zugang (nur dev):** http://localhost:8180 · `admin` / `admin`

### Spring Boot – Resource Server (JWT)

Dependency:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

`application.properties`:
```properties
spring.security.oauth2.resourceserver.jwt.issuer-uri=http://localhost:8180/realms/<realm-name>
```

### Quarkus – OIDC

Dependency:
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-oidc</artifactId>
</dependency>
```

`application.properties`:
```properties
quarkus.oidc.auth-server-url=http://keycloak:8080/realms/<realm-name>
quarkus.oidc.client-id=<client-id>
quarkus.oidc.application-type=service
# Dev-Konfiguration (kein TLS-Check)
quarkus.oidc.tls.verification=none
```

> **Hinweis:** Im docker-compose nutzt die Anwendung den Servicenamen `keycloak:8080` (intern).
> Für lokale Entwicklung außerhalb Docker: `localhost:8180`.

### Keycloak – Produktions-Konfiguration (PostgreSQL)

Für Produktion KC_DB auf postgres umstellen:
```yaml
environment:
  KC_DB: postgres
  KC_DB_URL: jdbc:postgresql://postgres:5432/keycloakdb
  KC_DB_USERNAME: keycloak
  KC_DB_PASSWORD: keycloak
  KEYCLOAK_ADMIN: admin
  KEYCLOAK_ADMIN_PASSWORD: admin
command: start --optimized
```

---

## Spring Boot – ddl-auto=validate schlägt auf leerer Datenbank fehl

**Problem:** `spring.jpa.hibernate.ddl-auto=validate` wirft beim ersten Start einen Fehler,
wenn noch keine Flyway-Migration existiert und die Datenbank leer ist – Hibernate findet
keine Tabellen zum Validieren.

**Falsch (nicht verwenden):**
```properties
spring.jpa.hibernate.ddl-auto=update  # Hibernate verwaltet das Schema → keine klare Migrationshistorie
spring.jpa.hibernate.ddl-auto=create  # Löscht Daten bei jedem Start
```

**Richtig (Option B – immer Initial-Migration generieren):**
```properties
spring.jpa.hibernate.ddl-auto=validate  # Hibernate prüft nur; Flyway verwaltet das Schema
```

Zu jeder Entity **immer** eine initiale Flyway-Migration anlegen:
```
src/main/resources/db/migration/V1__create_<entity>_table.sql
```

Template verfügbar unter: `templates/db/V1__create_{{ENTITY_NAME_LOWER}}_table.sql.template`

Flyway führt die Migration vor Hibernate aus → Schema existiert → Validate funktioniert.

---

## Renovate vs. versions-maven-plugin

| Tool | Art | Zweck |
|------|-----|-------|
| **Renovate** | GitHub/GitLab Bot | Erstellt automatisch PRs für Dependency-Updates; konfiguriert via `renovate.json` im Projekt-Root |
| **versions-maven-plugin** | Maven-Plugin in `pom.xml` | Lokale Versionsabfrage per `./mvnw versions:display-dependency-updates` |

Beide ergänzen sich. Renovate ist **kein** Maven-Dependency – es ist ein externer Service.
GitHub App: https://github.com/apps/renovate

---

## Lombok – Annotation Processor Pflicht (Spring Boot + Maven)

**Problem:** Lombok `@Data`, `@Builder` etc. erzeugen Getter/Setter zur Compile-Zeit.
Ohne explizite Annotation-Processor-Konfiguration im `maven-compiler-plugin` findet
der Compiler die generierten Methoden nicht → `cannot find symbol` für Getter/Setter.

**Lösung:** Im `<build><plugins>` Block den `maven-compiler-plugin` mit Lombok als
`annotationProcessorPath` konfigurieren:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <configuration>
        <annotationProcessorPaths>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

**Zusätzlich:** Lombok aus dem finalen JAR ausschließen (Spring Boot Maven Plugin):
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <excludes>
            <exclude>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
            </exclude>
        </excludes>
    </configuration>
</plugin>
```

Beide Plugin-Einträge sind **PFLICHT** bei jedem Spring Boot Projekt mit Lombok.
