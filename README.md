# Java DevContainer Template

DevContainer-Template für Java-Projekte mit Spring Boot oder Quarkus.

## Voraussetzungen

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Schnellstart

```bash
# 1. Template verwenden (GitHub → "Use this template")
git clone git@github.com:your-org/your-repo.git && cd your-repo

# 2. VS Code öffnen → "Reopen in Container"
code .
```

Beim ersten Start ~3–5 Min. Alle Tools werden automatisch installiert.

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
