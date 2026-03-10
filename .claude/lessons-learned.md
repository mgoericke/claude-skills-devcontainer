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

---

## Quarkus LangChain4j – AI-Integration

### Dependencies und BOM

**Quarkiverse LangChain4j BOM** statt einzelner Versionen verwenden:
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.quarkiverse.langchain4j</groupId>
            <artifactId>quarkus-langchain4j-bom</artifactId>
            <version><!-- PRÜFEN: https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-bom --></version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

LLM-Provider Extensions:
- `io.quarkiverse.langchain4j:quarkus-langchain4j-openai` (OpenAI + kompatible APIs)
- `io.quarkiverse.langchain4j:quarkus-langchain4j-ollama` (lokales LLM)
- `io.quarkiverse.langchain4j:quarkus-langchain4j-anthropic` (Claude)

RAG-Vektorspeicher:
- `io.quarkiverse.langchain4j:quarkus-langchain4j-pgvector` (empfohlen, nutzt vorhandene PostgreSQL)

Aktuelle Version prüfen: https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-openai

---

## Quarkus LangChain4j – AI Service Patterns

### @RegisterAiService

Deklarative AI Services werden als Interface mit `@RegisterAiService` erstellt.
Quarkus generiert die Implementierung zur Build-Zeit:

```java
@SessionScoped  // oder @ApplicationScoped
@RegisterAiService
public interface MyAssistant {
    @SystemMessage("Du bist ein hilfreicher Assistent.")
    String chat(@UserMessage String userMessage);
}
```

**Scope-Wahl:**
- `@SessionScoped` → eigene Chat-Memory pro Session (WebSocket, HTTP-Session)
- `@ApplicationScoped` → shared, kein Memory (oder expliziter @MemoryId)

**Tools registrieren:** Per `@ToolBox` an der Methode oder `tools=` am Interface:
```java
@ToolBox(MyTool.class)
String chat(@UserMessage String message);
```

---

## Quarkus LangChain4j – Tools / Function Calling

**Wichtig:** `@Tool`-Methoden mit Datenbankzugriff immer `@Blocking` + `@Transactional`:
```java
@Tool("Beschreibung fuer das LLM")
@Blocking
@Transactional
public String findOrder(long orderId) { ... }
```

Ohne `@Blocking` → gleicher Fehler wie bei `@Incoming` (Deadlock auf I/O-Thread).

Tool-Klassen sind CDI-Beans (`@ApplicationScoped`) und liegen in `control/ai/`.
Tool-Beschreibungen muessen praezise sein – das LLM entscheidet anhand der Beschreibung.

---

## Quarkus LangChain4j – RAG mit PgVector

**Docker Image:** `pgvector/pgvector:pg17` statt `postgres:17-alpine` verwenden,
damit die PgVector Extension vorinstalliert ist.

**Konfiguration:**
```properties
quarkus.langchain4j.pgvector.dimension=1536  # OpenAI Embeddings
# oder 384 fuer Ollama nomic-embed-text
```

**Ingestion** beim Start via `@Startup` Bean.
**Retrieval** via `Supplier<RetrievalAugmentor>` CDI-Bean.

---

## Quarkus LangChain4j – Guardrails

**ACHTUNG:** Die Quarkus-eigene Guardrail-Implementierung wurde zugunsten der
Upstream-LangChain4j-Implementierung entfernt.

**Richtig:** `dev.langchain4j.guardrail.InputGuardrail` / `OutputGuardrail`
**Falsch:** `io.quarkiverse.langchain4j.guardrails.*` (deprecated/entfernt)

```properties
quarkus.langchain4j.guardrails.max-retries=3  # Default: 3
```

---

## Quarkus LangChain4j – Dev Services deaktivieren

Ollama Dev Services starten automatisch einen Container – im DevContainer deaktivieren:
```properties
quarkus.langchain4j.ollama.devservices.enabled=false
```

Gilt analog fuer alle Provider Dev Services. Echte Services via `docker compose up`.

---

## AI-Architektur im BCE-Pattern

AI-Komponenten im BCE-Pattern:
- `boundary/ai/` → AI Service Interfaces (`@RegisterAiService`)
- `control/ai/` → Tools, RAG-Komponenten, Guardrails
- `boundary/rest/` → REST-Endpunkte fuer AI Service

**Architekturtest** im `ArchitectureTest.java.template` enthält Regeln:
- `@RegisterAiService` Interfaces → `boundary.ai`
- `@Tool` Klassen → `control.ai`

---

## Quarkus LangChain4j – Agentic Workflows

### @Agent vs. @RegisterAiService

| Aspekt | `@RegisterAiService` | `@Agent` |
|--------|---------------------|----------|
| Zweck | Deklarativer AI Service (Chat, Q&A) | Autonomer Agent mit Tool-Zugriff |
| Methoden | Mehrere Methoden erlaubt | **Genau EINE Methode** (Single Responsibility) |
| Verhalten | Reaktiv (antwortet auf Fragen) | Proaktiv (loest Aufgaben selbststaendig) |
| Workflow | Standalone | Kombinierbar in Workflows |

### Workflow-Patterns (quarkus-langchain4j-agentic)

Dependency: `io.quarkiverse.langchain4j:quarkus-langchain4j-agentic`

| Pattern | Annotation | Beschreibung |
|---------|-----------|-------------|
| **Sequence** | `@SequenceAgent` | Agents nacheinander (A → B → C) |
| **Parallel** | `@ParallelAgent` | Agents gleichzeitig auf separaten Threads |
| **Conditional** | `@ConditionalAgent` | Bedingte Ausfuehrung via `@ActivationCondition` |
| **Loop** | `@LoopAgent` | Iterativ bis Exit-Bedingung erfuellt |
| **Supervisor** | `@SupervisorAgent` | LLM entscheidet dynamisch, welcher Agent laeuft |
| **A2A** | `@A2AClientAgent` | Remote-Agent via Agent-to-Agent Protokoll |

### AgenticScope – gemeinsamer Zustand

Alle Agents in einem Workflow teilen sich einen `AgenticScope`.
Daten werden ueber `outputKey` zwischen Agents weitergegeben.
`@Output` Methode extrahiert Werte aus dem Scope fuer das Endergebnis.

### Builder API (programmatisch)

```java
// Loop mit Exit-Bedingung
var loop = AgenticServices.loopBuilder(MyLoop.class)
    .subAgents(writer, reviewer)
    .outputKey("result")
    .exitCondition(scope -> scope.readState("score", 0.0) >= 0.8)
    .maxIterations(5)
    .build();
```

---

## Quarkus LangChain4j – Fault Tolerance (Produktion)

**PFLICHT fuer Produktionsanwendungen.** LLM-Aufrufe koennen jederzeit fehlschlagen.

Dependency: `io.quarkus:quarkus-smallrye-fault-tolerance`

```java
@Timeout(5000)
@Retry(maxRetries = 3, delay = 100)
@Fallback(MyFallback.class)
String chat(@UserMessage String message);
```

Fallback-Handler gibt benutzerfreundliche Fehlermeldung zurueck.

---

## Quarkus LangChain4j – Easy RAG (einfachste Variante)

Dependency: `io.quarkiverse.langchain4j:quarkus-langchain4j-easy-rag`

Automatische Ingestion aus Verzeichnis – keine Programmierung noetig:
```properties
quarkus.langchain4j.easy-rag.path=src/main/resources/rag
quarkus.langchain4j.easy-rag.max-segment-size=100
quarkus.langchain4j.easy-rag.max-overlap-size=25
quarkus.langchain4j.easy-rag.max-results=3
```

Fuer produktionsreife Anwendungen → PgVector + eigene Ingestion-Pipeline bevorzugen.

---

## Quarkus LangChain4j – RAG Best Practices

1. **Gleiches Embedding-Modell** fuer Ingestion und Retrieval verwenden (PFLICHT)
2. **Segment-Groesse** ist kritisch: zu gross → ungenaue Ergebnisse, zu klein → fehlender Kontext
3. **PgVector Dimension** muss zum Embedding-Modell passen:
   - OpenAI `text-embedding-ada-002`: **1536**
   - Ollama `nomic-embed-text`: **384**
   - ONNX `bge-small-en-q` (lokal): **384**
4. Lokale Embedding-Modelle (ONNX) bevorzugen wenn keine Daten das System verlassen sollen
