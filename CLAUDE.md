# Projektkontext für Claude Code

DevContainer-Template für Java-Projekte mit Spring Boot oder Quarkus.

## Stack

| Schicht | Technologie |
|---------|-------------|
| Backend | Java 25 + **Spring Boot 4.x** oder **Quarkus 3.31+** |
| Datenbank | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build | Maven 3.9.x |
| Architektur | Taikai (basiert auf ArchUnit) |
| Auth / IAM | Keycloak 26.x |
| Infrastruktur | Docker + Docker Compose |

## Skills & Wissensmanagement

Skills: `.claude/skills/` – automatisch geladen.
Erkenntnisse und Korrekturen: **immer** in `.claude/lessons-learned.md` festhalten.
Vor jeder Generierung `lessons-learned.md` prüfen.

| Skill | Trigger |
|-------|---------|
| `java-scaffold-skill` | Neues Projekt, neue Entity, Dockerfile, docker-compose |
| `spec-feature-skill` | Feature spezifizieren, bevor Code entsteht |
| `openapi-skill` | OpenAPI Spec → REST-Endpunkte + DTOs (optional, wenn Spec vorhanden) |
| `doc-skill` | Projektdokumentation erstellen oder aktualisieren |
| `infografik-skill` | Infografik, Visualisierung, Diagramm |

## Versionsstrategie (PFLICHT)

**Vor jeder Code-Generierung** müssen Dependency-Versionen im Internet abgefragt werden.
Versionen aus dem Gedächtnis sind verboten – sie können veraltet sein.

Pflicht-URLs:
- Spring Boot: https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent
- Quarkus: https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom
- Taikai: https://central.sonatype.com/artifact/com.enofex/taikai

Jede generierte `pom.xml` enthält:
- `versions-maven-plugin` (lokale Versionsabfrage via `./mvnw versions:display-dependency-updates`)
- `renovate.json` im Projekt-Root (automatische Update-PRs via Renovate Bot)

## Coding-Standards

- **Architektur**: BCE-Pattern (Boundary / Control / Entity)
- **Architekturtests**: Taikai – bei jedem neuen Projekt anlegen (PFLICHT)
- **Health Checks**: Jede Anwendung muss `/actuator/health` (Spring) oder `/q/health` (Quarkus) bereitstellen (PFLICHT)
- **Persistenz**: Flyway – kein `ddl-auto=create`
- **Messaging (Quarkus)**: SmallRye `mp.messaging.*` Keys – Details in `lessons-learned.md`
- **Quarkus `@Blocking`**: Bei DB-Zugriffen im `@Incoming`-Consumer immer `@Blocking @Transactional`
- **Branches**: Neue Features IMMER in einem separaten Branch umsetzen – niemals direkt auf `main` (gilt auch für Forks dieses Projekts)
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Sprache**: Deutsch in Kommentaren/Doku, Englisch im Code
- **Beispiele**: Fachlich neutral (`order`, `product`, `event`, `item`) – keine Domänennamen

## Javadoc Co-Author

Jede generierte Java-Datei enthält:
```
@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill
```
Properties/YAML-Dateien als Kommentar: `# Co-Author: Claude (claude-sonnet-4-6, Anthropic)`

## Dockerfile-Konventionen

| Framework | Speicherort |
|-----------|-------------|
| Spring Boot | `./Dockerfile` (Projekt-Root) |
| Quarkus | `src/main/docker/Dockerfile.jvm` (Quarkus-Konvention) |

## Hinweise

- `groupId`, `artifactId` und Framework **immer** abfragen bevor Scaffolding startet
- ANTHROPIC_API_KEY ist optional – alternativ `claude login` nach Container-Start
- GIT_TOKEN (nicht GITHUB_TOKEN) für Git-Registries aller Anbieter
- Dev Services für Quarkus sind deaktiviert – echte Services via `docker compose up`
- Maven `.m2` Cache ist persistent (Docker Volume)
