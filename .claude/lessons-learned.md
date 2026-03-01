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

Dependency (nur `test` scope!):
```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version>1.49.0</version>
    <scope>test</scope>
</dependency>
```
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
