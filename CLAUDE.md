# Projektkontext für Claude Code

DevContainer-Template für Java-Projekte mit Spring Boot oder Quarkus.

## Stack

| Schicht | Technologie |
|---------|-------------|
| Backend | Java 25 + **Spring Boot 3.x** oder **Quarkus 3.x** |
| Datenbank | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build | Maven 3.9.x |
| Architektur | Taikai (basiert auf ArchUnit) |
| Infrastruktur | Docker + Docker Compose |
| Scripting | Python 3.12 |

## Skills

Skills liegen unter `.claude/skills/` und werden automatisch geladen.  
Erkenntnisse und Korrekturen immer in `.claude/lessons-learned.md` festhalten.

## Coding-Standards

- **Architektur**: BCE-Pattern (Boundary / Control / Entity)
- **Architekturtests**: Taikai – bei jedem neuen Projekt anlegen
- **Persistenz**: Flyway – kein `ddl-auto=create`
- **Messaging (Quarkus)**: SmallRye `mp.messaging.*` Keys – Details in `lessons-learned.md`
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Sprache**: Deutsch in Kommentaren/Doku, Englisch im Code
- **Beispiele**: Fachlich neutrale Namen (`order`, `product`, `event`, `item`)

## Hinweise

- Bei neuer Anwendung: `groupId`, `artifactId` und Framework **immer** abfragen
- Vor Generierung `.claude/lessons-learned.md` prüfen
- Quarkus: Dev Services sind deaktiviert – echte Services via `docker compose up`
- Umgebungsvariablen (Tokens) werden vom Host durchgereicht – nie im Code hardcoden
- Maven `.m2` Cache ist persistent (Docker Volume) – kein Re-Download nach Neustart
