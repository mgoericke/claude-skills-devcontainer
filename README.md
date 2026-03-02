# KI-gestütztes Projekt-Scaffolding

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
- **OpenAPI → Java** – `openapi-skill` liest eine OpenAPI 3.x Spec und generiert REST-Endpunkte + DTOs im BCE-Pattern (optional)
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
```
Generiere Code aus der OpenAPI Spec api/openapi.yaml
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

## Lokale Modelle & Datensouveränität

> **Datenschutz-Hinweis:** Bei der Nutzung der Anthropic Cloud API werden Prompts,
> Kontext und **Quellcode** an externe Server gesendet und dort verarbeitet.
> Für sensible Projekte, interne Architekturen oder regulierte Umgebungen empfehlen
> wir die Verwendung lokaler Modelle – der Code verlässt dann nie den Rechner.

Claude Code unterstützt lokale Modelle als vollständigen Ersatz für die Cloud API.
Die Konfiguration erfolgt über zwei Umgebungsvariablen – kein Code-Umbau nötig.

### Schnellstart

**Schritt 1 – Modell-Server auf dem Host starten** (Ollama oder LM Studio, s. u.)

**Schritt 2 – Umgebungsvariablen auf dem Host setzen** (`~/.zshrc` oder `~/.bashrc`):

```bash
# Ollama
export ANTHROPIC_BASE_URL="http://host.docker.internal:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
unset ANTHROPIC_API_KEY   # Cloud API deaktivieren

# – oder – LM Studio
export ANTHROPIC_BASE_URL="http://host.docker.internal:1234"
export ANTHROPIC_AUTH_TOKEN="lmstudio"
unset ANTHROPIC_API_KEY
```

```powershell
# Windows (PowerShell) – Ollama
$env:ANTHROPIC_BASE_URL   = "http://host.docker.internal:11434"
$env:ANTHROPIC_AUTH_TOKEN = "ollama"
Remove-Item Env:ANTHROPIC_API_KEY -ErrorAction SilentlyContinue
```

**Schritt 3 – DevContainer neu bauen:**
`Cmd+Shift+P` → `Dev Containers: Rebuild Container`

**Schritt 4 – Modell beim Start angeben:**
```bash
claude --model qwen3-coder       # Ollama
claude --model openai/qwen3-coder  # LM Studio
```

> **`host.docker.internal` statt `localhost`:** Im DevContainer zeigt `localhost`
> auf den Container selbst – nicht auf den Host. `host.docker.internal` ist die
> korrekte Adresse für Dienste, die auf dem Host laufen (funktioniert automatisch
> unter Docker Desktop auf macOS und Windows; unter Linux ggf. `172.17.0.1`).

> **Modell-Server im LAN?** `host.docker.internal` lässt sich durch eine beliebige
> erreichbare Adresse ersetzen – auch eine LAN-IP wie `http://192.168.1.100:11434`.

---

### Option A – Ollama

[Ollama](https://ollama.com) läuft als lokaler Server und verwaltet Modelle automatisch.

**Installation & Start:**
```bash
# macOS
brew install ollama
ollama serve                      # Server starten (läuft auf Port 11434)

# Modell herunterladen und starten
ollama pull qwen3-coder           # ~8 GB, empfohlen für Code-Aufgaben
```

**Empfohlene Modelle für Claude Code:**

| Modell | Größe | Stärke |
|--------|-------|--------|
| `qwen3-coder` | ~8 GB | Code-Generierung, Reasoning |
| `glm-4.7` | ~5 GB | Kompakt, schnell |
| `gpt-oss:20b` | ~12 GB | Generalisten-Modell |
| `gpt-oss:120b` | ~70 GB | Maximale Qualität (leistungsstarke Hardware) |

> **Kontextfenster:** Claude Code benötigt mindestens 64k Token Kontext.
> Ollama konfiguriert dies automatisch für empfohlene Modelle.

**Kurzbefehl (ohne DevContainer, direkt im Terminal):**
```bash
ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 \
  ANTHROPIC_API_KEY="" claude --model qwen3-coder
```

---

### Option B – LM Studio

[LM Studio](https://lmstudio.ai) bietet eine grafische Oberfläche zur Modellverwaltung
und einen OpenAI-kompatiblen API-Server.

**Installation & Start:**
```bash
# Server starten (Port 1234)
lms server start --port 1234
```

Oder über die LM Studio GUI: **Local Server** → **Start Server**

**Modell wählen:** In LM Studio ein Modell mit mindestens 25k Token Kontext laden.
Empfehlung: Qwen3-Coder, DeepSeek-Coder oder ähnliche Code-optimierte Modelle.

**Claude Code starten:**
```bash
claude --model openai/qwen3-coder
```

> **Kontextfenster:** Mindestens 25k Token – je mehr, desto besser für
> umfangreiche Codebase-Analysen.

---

### Zurück zur Cloud API

```bash
# Variablen entfernen und API Key wieder setzen
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_AUTH_TOKEN
export ANTHROPIC_API_KEY="sk-ant-..."
# DevContainer neu bauen
```

---

### Vergleich: Cloud vs. Lokal

| | Cloud API (Anthropic) | Lokal (Ollama / LM Studio) |
|-|----------------------|---------------------------|
| **Datenschutz** | Code wird extern verarbeitet | Code bleibt auf dem Rechner |
| **Modellqualität** | Claude Sonnet / Opus | Je nach Hardware |
| **Geschwindigkeit** | Schnell (Serverinfrastruktur) | Abhängig von lokaler GPU/CPU |
| **Kosten** | Pay-per-use | Einmalig (Hardware) |
| **Offline** | Nein | Ja |
| **Empfehlung** | Allgemeine Entwicklung | Sensible Projekte, Regulierung |

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

---

## Skills

Alle Skills liegen in `.claude/skills/` und werden von Claude Code automatisch geladen.
Sie steuern, wie Claude bei typischen Aufgaben vorgeht – als eingebettete Anweisungen,
nicht als externe Tools.

### Workflow-Übersicht

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Projekt-Workflow                             │
└─────────────────────────────────────────────────────────────────────┘

  Idee / Anforderung
        │
        ▼
┌───────────────────┐
│ spec-feature-skill│  "Ich möchte ein neues Feature spezifizieren"
│                   │  → Interview → specs/<feature>.md
└────────┬──────────┘
         │
         ▼ (optional – wenn OpenAPI Spec vorhanden)
┌───────────────────┐
│  openapi-skill    │  "Generiere Code aus api/openapi.yaml"
│                   │  → boundary/rest/ + entity/dto/ + control/ (Stubs)
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│java-scaffold-skill│  "Erstelle ein neues Quarkus-Projekt"
│                   │  → pom.xml, docker-compose, Flyway, Dockerfile,
└────────┬──────────┘    ArchitekturTest, renovate.json
         │               (REST/DTOs nur wenn openapi-skill NICHT gelaufen)
         ▼
┌───────────────────┐
│    doc-skill      │  "Dokumentiere das Projekt"
│                   │  → docs/<artifactId>.md (erstellen oder aktualisieren)
└───────────────────┘

  Jederzeit parallel nutzbar:
┌───────────────────┐
│ infografik-skill  │  "Erstelle eine Infografik zu ..."
│                   │  → PNG via Hugging Face FLUX.1
└───────────────────┘
```

---

### spec-feature-skill

**Zweck:** Strukturiertes Feature-Interview vor der Implementierung – erzeugt eine
Spec-Datei als gemeinsame Sprache zwischen Fachlichkeit und Code.

**Trigger:** `Ich möchte ein neues Feature spezifizieren`

**Ablauf:**
1. Interview in 4 Gruppen: Kontext → Verhalten → Technische Hinweise → Qualität
2. Zusammenfassung und Bestätigung
3. Ausgabe: `specs/<feature-name>.md`

**Output-Pfad:** `specs/<feature-name-kebab-case>.md`

---

### openapi-skill _(optional)_

**Zweck:** Liest eine OpenAPI 3.x Spezifikation (YAML oder JSON) und generiert daraus
typsichere REST-Endpunkte und DTOs im BCE-Pattern – ohne Abweichung vom API-Vertrag.

**Trigger:** `Generiere Code aus der OpenAPI Spec api/openapi.yaml`

**Generiert:**
| Artefakt | Pfad | Beschreibung |
|----------|------|-------------|
| Controller / Resource | `boundary/rest/` | Ein File pro OpenAPI-Tag |
| DTOs | `entity/dto/` | Java Records mit Validation-Annotationen aus der Spec |
| Service-Stubs | `control/` | Leere Serviceklassen mit korrekten Methodensignaturen |

**Unterstützte Features:** Path/Query/Header-Parameter, Request Body, Response Body,
`$ref`-Auflösung, Enum-Typen, Security-Annotationen, OpenAPI 3.0.x + 3.1.x

**Hinweis:** Wenn dieser Skill ausgeführt wurde, generiert `java-scaffold-skill`
`boundary/rest/` und `entity/dto/` **nicht** nochmal.

---

### java-scaffold-skill

**Zweck:** Erstellt den vollständigen Projekt-Rahmen für eine neue Java-Anwendung –
inklusive Build-Konfiguration, Infrastruktur und Architekturtests.

**Trigger:** `Erstelle ein neues Quarkus-Projekt`

**Pflichtabfragen:** groupId · artifactId · Framework · benötigte Dienste (DB / Messaging / Keycloak)

**Generiert:**
| Artefakt | Beschreibung |
|----------|-------------|
| `pom.xml` | Mit aktuellen Versionen (immer aus dem Internet abgefragt) |
| `docker-compose.yml` | Nur mit bestätigten Diensten |
| `application.properties` | Framework-spezifisch vorkonfiguriert |
| `Dockerfile` | Spring: Projekt-Root · Quarkus: `src/main/docker/` |
| `ArchitectureTest.java` | Taikai-basierte BCE-Regel-Prüfung |
| `renovate.json` | Automatische Dependency-Update-PRs |

**Versions-Pflicht:** Vor jeder Generierung werden aktuelle Versionen im Internet
abgefragt – niemals aus dem Gedächtnis.

---

### doc-skill

**Zweck:** Erstellt oder aktualisiert `docs/<artifactId>.md` auf Basis des bestehenden
Projekts – liest Quellcode und Konfiguration automatisch aus, bevor Fragen gestellt werden.

**Trigger:** `Dokumentiere das Projekt` · `Aktualisiere die Projektdokumentation`

**Automatisch analysiert:** `pom.xml` · `application.properties` · `docker-compose.yml` ·
REST-Endpunkte · Entities · Flyway-Migrationen · vorhandene Specs

**Verhalten bei vorhandener Datei:** Nur leere oder veraltete Abschnitte werden
aktualisiert – manuelle Ergänzungen bleiben erhalten.

**Adaptive Abschnitte:** API-Referenz, Messaging, Keycloak/Auth erscheinen nur,
wenn die jeweiligen Dependencies in der `pom.xml` aktiv sind.

---

### infografik-skill

**Zweck:** Generiert professionelle Infografiken als PNG-Datei über die
Hugging Face Inference API (FLUX.1, kostenlos mit `HF_TOKEN`).

**Trigger:** `Erstelle eine Infografik zu ...` · `Visualisiere das` · `Mach das übersichtlich`

**Voraussetzung:** `HF_TOKEN` als Umgebungsvariable auf dem Host gesetzt
(einmalige Einrichtung unter https://huggingface.co/settings/tokens)
