# Java DevContainer Template

DevContainer-Template für Java-Projekte mit Spring Boot oder Quarkus.

## Voraussetzungen

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Neues Projekt anlegen (Fork-Workflow)

Neue Projekte werden als **Fork** dieses Repositories angelegt. Dadurch können
Template-Updates (neue Skills, DevContainer-Verbesserungen, neue Coding-Standards)
jederzeit per `git` eingespielt werden.

### Schritt 1 – Fork erstellen

GitHub: Schaltfläche **"Fork"** oben rechts auf der Repository-Seite.
Dadurch entsteht `github.com/<deine-org>/<dein-repo>` als eigene Kopie.

### Schritt 2 – Upstream einrichten

#### Option A – Fork auf GitHub geklont (empfohlen)

```bash
# Fork klonen (Dateien sind bereits vorhanden)
git clone git@github.com:<deine-org>/<dein-repo>.git
cd <dein-repo>

# Dieses Template als "upstream" Remote hinzufügen
git remote add upstream git@github.com:<template-org>/claude-skills-devcontainer.git

# Upstream initial fetchen (einmalig – lädt alle Branches und Tags)
git fetch upstream

# Remotes prüfen
git remote -v
# origin    git@github.com:<deine-org>/<dein-repo>.git  (fetch/push)
# upstream  git@github.com:<template-org>/claude-skills-devcontainer.git  (fetch/push)
```

#### Option B – Leeres Repo mit `git init`

Falls du ein leeres Repo angelegt hast (z.B. auf GitHub ohne Inhalt, dann `git init` lokal):

```bash
cd <dein-repo>

# Upstream hinzufügen und fetchen
git remote add upstream git@github.com:<template-org>/claude-skills-devcontainer.git
git fetch upstream

# Template-Inhalt in lokalen main-Branch auschecken
git checkout -b main upstream/main

# Eigenes Remote setzen und pushen
git remote add origin git@github.com:<deine-org>/<dein-repo>.git
git push -u origin main
```

### Schritt 3 – VS Code öffnen

```bash
code .
# → "Reopen in Container" wählen
```

Beim ersten Start ~3–5 Min. Alle Tools werden automatisch installiert.

---

## Updates aus dem Template einspielen (Upstream-Sync)

Wenn das Template verbessert wird (neue Skills, DevContainer-Updates, neue Regeln),
können diese Änderungen in den Fork übernommen werden.

> **Regel:** Upstream-Sync **niemals** direkt auf `main` – immer über einen
> separaten Branch und Pull Request. So bleiben Konflikte kontrollierbar.

### Ablauf

```bash
# 1. Neue Commits vom Template herunterladen (kein Merge, kein Push)
#    "fetch" statt "pull upstream main" – nur holen, nicht automatisch mergen
git fetch upstream

# 2. Prüfen ob überhaupt etwas Neues vorliegt
git log HEAD..upstream/main --oneline

# 3. Branch für den Sync anlegen (Pflicht – niemals direkt auf main!)
git checkout -b chore/upstream-sync

# 4. Upstream-main in den Branch mergen
git merge upstream/main

# 5. Konflikte lösen (falls vorhanden)
#    Eigene Anpassungen (z.B. CLAUDE.md, devcontainer.json) prüfen –
#    Upstream-Änderungen gezielt übernehmen oder ablehnen.
git status
# → Konflikte in Editor öffnen, lösen, dann:
git add .
git commit -m "chore: sync upstream template changes"

# 6. Branch pushen und Pull Request auf GitHub erstellen
git push origin chore/upstream-sync
# → GitHub: Pull Request von chore/upstream-sync → main öffnen und mergen
```

### Was kann zu Konflikten führen?

| Datei | Konfliktrisiko | Empfehlung |
|-------|----------------|-----------|
| `.devcontainer/devcontainer.json` | Mittel | Eigene `containerEnv`-Einträge behalten, neue Features aus Upstream übernehmen |
| `CLAUDE.md` | Niedrig | Upstream-Regeln übernehmen, eigene Erweiterungen darunter behalten |
| `.claude/skills/` | Niedrig | Neue Skills aus Upstream sind reine Ergänzungen |
| `docker-compose.yml` | Hoch | Eigene Services (z.B. andere DB-Namen) sorgfältig prüfen |

### Upstream-Updates regelmäßig einspielen

Empfehlung: **bei jedem neuen Feature-Branch** kurz prüfen ob neue Upstream-Commits vorliegen –
die beiden Befehle aus Schritt 1 und 2 des Ablaufs reichen dafür aus.

---

## Claude Code

Zwei Möglichkeiten zur Authentifizierung:

**Option A – API Key (Umgebungsvariable auf dem Host):**

```bash
# macOS/Linux (~/.zshrc oder ~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Option B – Login nach Container-Start:**

```bash
claude login
```

---

## Umgebungsvariablen

Alle Variablen sind optional. Nur setzen wenn benötigt.

```bash
# macOS/Linux (~/.zshrc oder ~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."        # oder: claude login im Container

export HF_TOKEN="hf_..."                     # Hugging Face – für Infografik-Skill (kostenlos)

export ARTIFACTORY_URL="https://company.jfrog.io/artifactory"
export ARTIFACTORY_USER="your.name@example.com"
export ARTIFACTORY_TOKEN="your-token"

export GIT_TOKEN="..."                        # GitHub Packages, GitLab, Gitea, Bitbucket
export NPM_TOKEN="npm_..."                    # Private NPM Registry
```

```powershell
# Windows (PowerShell)
$env:ANTHROPIC_API_KEY = "sk-ant-..."
$env:HF_TOKEN = "hf_..."
$env:GIT_TOKEN = "..."
```

### Hugging Face Token (`HF_TOKEN`)

Benötigt für den **Infografik-Skill** (KI-Bildgenerierung via FLUX.1).

**Einmalige Einrichtung (3 Schritte):**

1. Token erstellen unter https://huggingface.co/settings/tokens
   - **Token type:** `Read` (reicht aus – schreibt nichts)
   - **Name:** z.B. `claude-infografik`

2. Token auf dem **Host-Rechner** setzen (nicht im Container):
   ```bash
   # macOS/Linux: in ~/.zshrc oder ~/.bashrc eintragen
   export HF_TOKEN="hf_..."
   source ~/.zshrc   # oder: neues Terminal öffnen
   ```

3. **DevContainer neu starten** – wichtig, damit der Token übernommen wird:
   - VS Code: `Cmd+Shift+P` → `Dev Containers: Rebuild Container`

> **Warum Rebuild?** Umgebungsvariablen vom Host werden beim Container-Start
> einmalig eingelesen (`devcontainer.json` → `containerEnv`). Ein laufender
> Container bekommt nachträglich gesetzte Variablen nicht mit.

Ein Token pro Use-Case ist Best Practice (HF-Empfehlung), damit einzelne Tokens
widerrufen werden können ohne andere Anwendungen zu beeinflussen.

### Maven – Artifactory (`~/.m2/settings.xml` im Container)

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

---

## Stack

|                   |                                          |
| ----------------- | ---------------------------------------- |
| Java              | 25 (Microsoft OpenJDK)                   |
| Frameworks        | Spring Boot 3.x oder Quarkus 3.x         |
| Datenbank         | PostgreSQL 17                            |
| Messaging         | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build             | Maven 3.9                                |
| Architektur-Tests | Taikai (ArchUnit)                        |
| KI                | Claude Code                              |

---

## Lokale Infrastruktur

```bash
docker compose up -d
```

- PostgreSQL: `localhost:5432`
- RabbitMQ Management: http://localhost:15672 (`app`/`app`)
- Anwendung Health: http://localhost:8080/actuator/health _(Spring)_
- Anwendung Health: http://localhost:8080/q/health _(Quarkus)_

---

## Neues Projekt scaffolden

```
Erstelle ein neues Quarkus-Projekt
```

Claude fragt nach `groupId`, `artifactId` und Framework – dann wird alles generiert.

---

## Architektur (BCE-Pattern)

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

## Dockerfile-Konventionen

| Framework   | Speicherort                      |
| ----------- | -------------------------------- |
| Spring Boot | `./Dockerfile` (Projekt-Root)    |
| Quarkus     | `src/main/docker/Dockerfile.jvm` |
