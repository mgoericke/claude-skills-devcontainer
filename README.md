# Java DevContainer – KI-gestütztes Projekt-Scaffolding

Dieses Template ermöglicht das schnelle Aufsetzen neuer Java-Projekte mit vollständiger
KI-Unterstützung durch Claude Code. Du beschreibst dein Vorhaben in natürlicher Sprache –
Claude übernimmt Scaffolding, Spezifikation, Architektur und Code-Generierung.

## Was dieses Template bietet

- **Spring Boot 4.x oder Quarkus 3.31+** – vollständig vorkonfiguriert, inklusive Health Checks
- **PostgreSQL + RabbitMQ + Keycloak** – lokale Infrastruktur per `docker compose up -d` startklar
- **Keycloak 26.x** – Identity & Access Management für OAuth2/OIDC; läuft im Dev-Modus auf Port 8180 (optional)
- **BCE-Architektur** (Boundary / Control / Entity) mit automatischen Architekturtests via Taikai
- **Spec Driven Development** – strukturiertes Feature-Interview erzeugt eine Spec-Datei, bevor Code entsteht
- **Flyway** für Datenbankmigrationen – kein unsicheres `ddl-auto=create`
- **Persistenter Maven-Cache** – kürzere Build-Zeiten nach dem ersten Start
- **Infografik-Skill** – KI-Bildgenerierung via Hugging Face FLUX.1 (optional)
- **Projekt-Dokumentation** – `doc-skill` liest Quellcode und Konfiguration und erstellt oder aktualisiert `docs/<projekt>.md`
- **Fork-Workflow** – Template-Updates lassen sich jederzeit per `git merge` einspielen

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
Erstelle eine Infografik zum Thema Microservice-Kommunikation
```
```
Dokumentiere das Projekt
```
```
Aktualisiere die Projektdokumentation
```

---

## Stack

| Schicht           | Technologie                              |
| ----------------- | ---------------------------------------- |
| Java              | 25 (Microsoft OpenJDK)                   |
| Frameworks        | Spring Boot 3.x oder Quarkus 3.x         |
| Datenbank         | PostgreSQL 17                            |
| Messaging         | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build             | Maven 3.9                                |
| Architektur-Tests | Taikai (ArchUnit)                        |
| Auth / IAM        | Keycloak 26.x                            |
| KI                | Claude Code                              |

---

## Setup

### Voraussetzungen (Host-System)

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### 1 – Fork erstellen

Neue Projekte werden als **Fork** dieses Repositories angelegt. Dadurch können
Template-Updates (neue Skills, DevContainer-Verbesserungen, neue Coding-Standards)
jederzeit per `git` eingespielt werden.

GitHub: Schaltfläche **"Fork"** oben rechts auf der Repository-Seite.
Dadurch entsteht `github.com/<deine-org>/<dein-repo>` als eigene Kopie.

```bash
# Fork klonen
git clone git@github.com:<deine-org>/<dein-repo>.git
cd <dein-repo>

# Template als "upstream" Remote einrichten
git remote add upstream git@github.com:<template-org>/claude-skills-devcontainer.git
git fetch upstream

# Remotes prüfen
git remote -v
# origin    git@github.com:<deine-org>/<dein-repo>.git  (fetch/push)
# upstream  git@github.com:<template-org>/claude-skills-devcontainer.git  (fetch/push)
```

### 2 – Umgebungsvariablen setzen

Alle Variablen werden auf dem **Host-System** gesetzt und beim Container-Start automatisch
übernommen. Tokens nie direkt in Konfigurationsdateien eintragen.

```bash
# macOS/Linux (~/.zshrc oder ~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."        # oder: claude login im Container
export HF_TOKEN="hf_..."                     # Hugging Face – für Infografik-Skill (kostenlos)

# Optional – nur bei Bedarf
export ARTIFACTORY_URL="https://company.jfrog.io/artifactory"
export ARTIFACTORY_USER="your.name@example.com"
export ARTIFACTORY_TOKEN="your-token"
export GIT_TOKEN="..."                        # GitHub Packages, GitLab, Gitea, Bitbucket
export NPM_TOKEN="npm_..."                    # Private NPM Registry
```

```powershell
# Windows (PowerShell)
$env:ANTHROPIC_API_KEY = "sk-ant-..."
$env:HF_TOKEN          = "hf_..."
$env:GIT_TOKEN         = "..."
```

> **Hinweis:** Nach dem Setzen einer neuen Variable muss der Container neu gebaut werden:
> `Cmd+Shift+P` → `Dev Containers: Rebuild Container`

#### Claude Code authentifizieren

**Option A – API Key** (empfohlen, s. o.): Variable `ANTHROPIC_API_KEY` auf dem Host setzen.

**Option B – Login im Container:**
```bash
claude login
```

#### Hugging Face Token (`HF_TOKEN`)

Benötigt für den **Infografik-Skill**. Einmalige Einrichtung:

1. Token erstellen unter https://huggingface.co/settings/tokens (**Token type:** `Read`)
2. Als `HF_TOKEN` auf dem Host setzen (s. o.)
3. DevContainer neu bauen

#### Maven – Artifactory (`~/.m2/settings.xml` im Container)

```xml
<settings>
  <servers>
    <server>
      <id>artifactory</id>
      <username>${env.ARTIFACTORY_USER}</username>
      <password>${env.ARTIFACTORY_TOKEN}</password>
    </server>
  </servers>
  <mirrors>
    <mirror>
      <id>artifactory</id>
      <url>${env.ARTIFACTORY_URL}/maven-public</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
```

### 3 – Container starten

```bash
code .
# → "Reopen in Container" wählen
```

Beim ersten Start ~3–5 Min. Alle Tools (Java 25, Maven, Docker-in-Docker, Claude Code)
werden automatisch installiert.

---

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

---

## Arbeiten mit dem Template

### Spec Driven Development

Vor der Implementierung steht die Spezifikation. Der `spec-feature-skill` führt ein
strukturiertes Interview durch und erzeugt eine Spec-Datei in `specs/`.

```
Ich möchte ein neues Feature spezifizieren
```

Claude stellt gezielte Fragen zu Kontext, Verhalten, API, Datenmodell und Akzeptanzkriterien
und erstellt danach `specs/<feature-name>.md`.

Die fertige Spec dient als Input für den Scaffold-Skill:

```
Implementiere das Feature gemäß specs/order-creation.md
```

### Neues Projekt scaffolden

```
Erstelle ein neues Quarkus-Projekt
```

Claude fragt nach `groupId`, `artifactId`, Framework und welche Dienste (Datenbank,
Messaging, Keycloak) benötigt werden – dann wird alles generiert:
Projektstruktur, Konfiguration, Dockerfile, docker-compose.yml und Architekturtests.

### Projektdokumentation erstellen oder aktualisieren

```
Dokumentiere das Projekt
```

Der `doc-skill` liest automatisch `pom.xml`, `application.properties`, `docker-compose.yml`
und den Quellcode aus, stellt gezielte Rückfragen zu Lücken und erzeugt
`docs/<artifactId>.md`. Bei einer vorhandenen Datei werden nur veraltete Abschnitte
aktualisiert – manuelle Ergänzungen bleiben erhalten.

### Architektur (BCE-Pattern)

```
src/main/java/com/example/orders/
├── boundary/
│   ├── rest/          # REST-Endpunkte (*Resource.java, *Controller.java)
│   └── messaging/     # Consumer (*Consumer.java, *Listener.java)
├── control/           # Business-Logik (*Service.java)
└── entity/            # JPA Entities, Repositories, DTOs
```

Regeln werden durch Taikai zur Build-Zeit geprüft:

```bash
./mvnw test -Dtest=ArchitectureTest
```

### Dockerfile-Konventionen

| Framework   | Speicherort                      |
| ----------- | -------------------------------- |
| Spring Boot | `./Dockerfile` (Projekt-Root)    |
| Quarkus     | `src/main/docker/Dockerfile.jvm` |

---

## Template-Updates einspielen (Upstream-Sync)

Wenn das Template verbessert wird (neue Skills, DevContainer-Updates, neue Regeln),
können diese Änderungen in den Fork übernommen werden.

> **Regel:** Upstream-Sync **niemals** direkt auf `main` – immer über einen
> separaten Branch und Pull Request.

```bash
# 1. Neue Commits holen (kein Merge)
git fetch upstream

# 2. Prüfen ob etwas Neues vorliegt
git log HEAD..upstream/main --oneline

# 3. Sync-Branch anlegen
git checkout -b chore/upstream-sync

# 4. Upstream-main mergen
git merge upstream/main

# 5. Konflikte lösen (falls vorhanden), dann committen
git add .
git commit -m "chore: sync upstream template changes"

# 6. Branch pushen und Pull Request öffnen
git push origin chore/upstream-sync
```

### Konflikt-Übersicht

| Datei | Konfliktrisiko | Empfehlung |
|-------|----------------|-----------|
| `.devcontainer/devcontainer.json` | Mittel | Eigene `containerEnv`-Einträge behalten, neue Features übernehmen |
| `CLAUDE.md` | Niedrig | Upstream-Regeln übernehmen, eigene Erweiterungen darunter behalten |
| `.claude/skills/` | Niedrig | Neue Skills sind reine Ergänzungen |
| `docker-compose.yml` | Hoch | Eigene Services sorgfältig prüfen |

**Empfehlung:** Bei jedem neuen Feature-Branch kurz `git fetch upstream` und
`git log HEAD..upstream/main --oneline` ausführen, um frühzeitig Updates zu erkennen.
