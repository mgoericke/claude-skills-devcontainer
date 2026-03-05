# Setup

## Voraussetzungen (Host-System)

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

---

## 1 – Fork erstellen

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

---

## 2 – Umgebungsvariablen setzen

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

### Claude Code authentifizieren

**Option A – API Key** (empfohlen, s. o.): Variable `ANTHROPIC_API_KEY` auf dem Host setzen.

**Option B – Login im Container:**
```bash
claude login
```

### Hugging Face Token (`HF_TOKEN`)

Benötigt für den **Infografik-Skill**. Einmalige Einrichtung:

1. Token erstellen unter https://huggingface.co/settings/tokens (**Token type:** `Read`)
2. Als `HF_TOKEN` auf dem Host setzen (s. o.)
3. DevContainer neu bauen

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

## 3 – Container starten

```bash
code .
# → "Reopen in Container" wählen
```

Beim ersten Start ~3–5 Min. Alle Tools (Java 25, Maven, Docker-in-Docker, Claude Code)
werden automatisch installiert.
