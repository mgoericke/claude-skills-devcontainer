# KI-gestütztes Projekt-Scaffolding

Dieses Template ermöglicht das schnelle Aufsetzen neuer Java-Projekte mit vollständiger
KI-Unterstützung durch Claude Code. Du beschreibst dein Vorhaben in natürlicher Sprache –
Claude übernimmt Scaffolding, Spezifikation, Architektur und Code-Generierung.

## Features

- **Spring Boot 4.x oder Quarkus 3.31+** – vollständig vorkonfiguriert, inklusive Health Checks
- **PostgreSQL + RabbitMQ + Keycloak** – lokale Infrastruktur per `docker compose up -d` startklar
- **BCE-Architektur** (Boundary / Control / Entity) mit automatischen Architekturtests via Taikai
- **Spec Driven Development** – strukturiertes Feature-Interview erzeugt eine Spec-Datei, bevor Code entsteht
- **Flyway** für Datenbankmigrationen – kein unsicheres `ddl-auto=create`
- **MCP-Datenzugriff** – natürlichsprachliche Abfragen auf PostgreSQL direkt im Chat
- **OpenAPI → Java** – REST-Endpunkte + DTOs aus einer OpenAPI 3.x Spec generieren (optional)
- **Projekt-Dokumentation** – liest Quellcode und Konfiguration aus, erstellt `docs/<projekt>.md`
- **Infografik-Skill** – KI-Bildgenerierung via Hugging Face FLUX.1 (optional)
- **Fork-Workflow** – Template-Updates lassen sich jederzeit per `git merge` einspielen

## Schnellstart

**1 – Fork erstellen**

Schaltfläche **"Fork"** oben rechts auf der Repository-Seite klicken.

**2 – API Key setzen** (`~/.zshrc` oder `~/.bashrc` auf dem Host):

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

**3 – In VS Code öffnen:**

```bash
git clone git@github.com:<deine-org>/<dein-repo>.git
code <dein-repo>
# → "Reopen in Container" wählen – fertig nach ~3–5 Min.
```

**4 – Ersten Prompt eingeben:**

```
Erstelle ein neues Spring Boot Projekt
```

Claude fragt nach `groupId`, `artifactId` und den benötigten Diensten – dann wird
alles generiert: Projektstruktur, Konfiguration, Dockerfile, Architekturtests.

## Beispiel-Prompts

```
Erstelle ein neues Quarkus-Projekt
```
```
Ich möchte ein neues Feature spezifizieren
```
```
Implementiere das Feature gemäß specs/order-creation.md
```
```
Generiere Code aus der OpenAPI Spec api/openapi.yaml
```
```
Dokumentiere das Projekt
```
```
Zeige alle Produkte
```
```
Erstelle eine Infografik zum Thema Microservice-Kommunikation
```

## Stack

| Schicht           | Technologie                              |
| ----------------- | ---------------------------------------- |
| Java              | 25 (Microsoft OpenJDK)                   |
| Frameworks        | Spring Boot 4.x oder Quarkus 3.31+       |
| Datenbank         | PostgreSQL 17                            |
| Messaging         | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build             | Maven 3.9                                |
| Architektur-Tests | Taikai (ArchUnit)                        |
| Auth / IAM        | Keycloak 26.x                            |
| KI                | Claude Code                              |

## Lokale Infrastruktur

```bash
docker compose up -d
```

| Service              | Adresse                                          |
| -------------------- | ------------------------------------------------ |
| PostgreSQL           | `localhost:5432`                                 |
| RabbitMQ Management  | http://localhost:15672 (`app` / `app`)           |
| Keycloak Admin       | http://localhost:8180 (`admin` / `admin`)        |
| Anwendung (Spring)   | http://localhost:8080/actuator/health            |
| Anwendung (Quarkus)  | http://localhost:8080/q/health                   |

## Weiterführende Dokumentation

| Thema | Dokument |
|-------|---------|
| Detailliertes Setup (Fork, Env Vars, Artifactory) | [docs/setup.md](docs/setup.md) |
| Skills & Workflow-Übersicht | [docs/skills.md](docs/skills.md) |
| MCP-Datenzugriff (PostgreSQL, RabbitMQ) | [docs/mcp.md](docs/mcp.md) |
| Lokale Modelle (Ollama / LM Studio) | [docs/local-models.md](docs/local-models.md) |
| Template-Updates einspielen (Upstream-Sync) | [docs/template-updates.md](docs/template-updates.md) |
