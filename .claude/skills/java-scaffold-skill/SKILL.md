---
name: java-scaffold-skill
description: Scaffolding für Java-Projekte mit Spring Boot oder Quarkus, PostgreSQL, RabbitMQ und Docker. Verwende diesen Skill immer wenn eine neue Java-Anwendung, ein Modul, eine Entity, ein Dockerfile, eine Docker Compose Datei, Architekturtests oder Konfigurationsdateien erstellt werden sollen. Fragt immer nach groupId, artifactId und Framework bevor Code generiert wird.
---

# Java Scaffold Skill

Scaffolding für Java-Projekte mit Spring Boot oder Quarkus.

> **Vor jeder Generierung**:
> 1. `.claude/lessons-learned.md` prüfen
> 2. **Aktuelle Versionen im Internet abfragen** (Maven Central / GitHub Releases) – niemals veraltete Versionen aus dem Gedächtnis verwenden!

## ⚠️ Pflicht: Versionsprüfung vor jeder Generierung

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

---

## ⚠️ Pflichtabfrage

Vor jeder neuen Anwendung oder jedem Modul – sofern nicht bereits bekannt – **immer alle
folgenden Fragen stellen, bevor Code generiert wird**:

### Schritt 1 – Projekt-Koordinaten

| # | Angabe | Beispiel |
|---|--------|---------|
| 1 | `groupId` | `com.example.orders` |
| 2 | `artifactId` | `order-service` |
| 3 | **Framework** | `Spring Boot` oder `Quarkus` |

### Schritt 1b – OpenAPI Spec vorhanden? (optional)

**Vor dem Scaffold fragen:** Gibt es eine OpenAPI-Spezifikation für dieses Projekt?

- **Ja** → zuerst `openapi-skill` ausführen lassen; danach beim Scaffold
  `boundary/rest/` und `entity/dto/` **nicht** nochmal generieren – nur Rahmen
  (pom.xml, docker-compose, application.properties, Flyway, Architekturtest, Dockerfile).
- **Nein** → normal weitermachen, alle Schichten generieren.

### Schritt 2 – Benötigte Dienste

Explizit abfragen, welche Dienste tatsächlich benötigt werden:

| Dienst | Abhängigkeit (Spring) | Abhängigkeit (Quarkus) | Standard |
|--------|----------------------|------------------------|---------|
| **Datenbank** (PostgreSQL) | `spring-boot-starter-data-jpa`, `postgresql`, Flyway | `quarkus-hibernate-orm-panache`, `quarkus-jdbc-postgresql`, Flyway | Ja |
| **Messaging** (RabbitMQ) | `spring-boot-starter-amqp` | `quarkus-messaging-rabbitmq` | Nein |
| **Auth / IAM** (Keycloak) | `spring-boot-starter-oauth2-resource-server` | `quarkus-oidc` | Nein |

Nur bestätigte Dienste werden in `pom.xml`, `docker-compose.yml` und `application.properties`
aufgenommen. Nicht benötigte Dienste vollständig weglassen – keine auskommentierten Blöcke.

Nie raten oder Defaults verwenden – immer explizit fragen.

---

## Stack

- **Java 25** · **Spring Boot 4.x** oder **Quarkus 3.31+**
- **PostgreSQL 17** · **RabbitMQ 4** · **Keycloak 26.x**
- **Maven 3.9** · **Docker + Docker Compose**
- **Taikai** (Architektur-Tests, nur `test` scope)

---

## Templates

| Framework | Pfad |
|-----------|------|
| Spring Boot | `templates/spring/` |
| Quarkus | `templates/quarkus/` + `templates/quarkus/src-main-docker/` |
| Architektur-Tests | `templates/arch/` |

**Spring Boot Templates (templates/spring/):**

| Template | Schicht | Beschreibung |
|----------|---------|-------------|
| `Entity.java.template` | entity | JPA-Entity mit UUID, Timestamps, Lombok |
| `Repository.java.template` | entity | `JpaRepository<Entity, UUID>` mit Custom-Query-Hints |
| `Service.java.template` | control | `@Service @Transactional` mit CRUD + `readOnly` auf Lesemethoden |
| `Controller.java.template` | boundary/rest | `@RestController` mit vollständigem CRUD, `@Valid`, `ResponseEntity` |
| `Consumer.java.template` | boundary/messaging | `@RabbitListener` mit SLF4J Logger und Service-Delegation |
| `RabbitMqConfig.java.template` | boundary/messaging | Queue, DirectExchange, Binding, Jackson2JsonMessageConverter |
| `SecurityConfig.java.template` | boundary/rest | `SecurityFilterChain` (modern, kein WebSecurityConfigurerAdapter) |
| `Dockerfile` | – | Multi-Stage Build (JDK → JRE Alpine) |
| `application.properties` | – | PostgreSQL, Flyway, RabbitMQ, Actuator, CORS, Caching |
| `docker-compose.yml` | – | PostgreSQL, RabbitMQ, Keycloak, App mit Health Checks |

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
    <version><!-- VOR GENERIERUNG AKTUELLE VERSION PRÜFEN: https://central.sonatype.com/artifact/com.enofex/taikai --></version>
    <scope>test</scope>
</dependency>
```

Stand 2026-03-01: `1.60.0` – **immer im Internet verifizieren!**

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

## versions-maven-plugin – PFLICHT in jeder POM

Jede generierte `pom.xml` enthält das `versions-maven-plugin` im `<build><pluginManagement>` Block.
Es erlaubt lokale Versionsabfragen ohne externe Tools:

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

Stand 2026-03-01: `2.21.0` – **immer im Internet verifizieren!**

Nützliche Befehle für Entwickler:
```bash
# Veraltete Dependencies anzeigen
./mvnw versions:display-dependency-updates

# Veraltete Plugins anzeigen
./mvnw versions:display-plugin-updates

# Parent POM prüfen
./mvnw versions:display-parent-updates
```

---

## Renovate – automatisches Dependency-Update

> **Renovate ist kein Maven-Plugin**, sondern ein externer Bot (GitHub App / selbst-gehostet),
> der automatisch Pull Requests für Dependency-Updates erstellt.
> Konfiguriert wird er via `renovate.json` im Projekt-Root.

Jedes generierte Projekt erhält die Datei `renovate.json` aus dem Template
`templates/renovate.json`. Sie wird unverändert in den Projekt-Root kopiert.

Renovate aktivieren (einmalig pro Repository):
1. GitHub App installieren: https://github.com/apps/renovate
2. Repository freischalten
3. Renovate erstellt automatisch einen initialen PR mit `renovate.json`

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
