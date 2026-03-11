# Setup

## Prerequisites (Host System)

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

---

## 1 – Clone the Repository

```bash
git clone <repository-url>
cd <your-repo>
```

---

## 2 – Set Environment Variables

All variables are set on the **host system** and automatically passed through on container start.
Never enter tokens directly in configuration files.

```bash
# macOS/Linux (~/.zshrc or ~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."        # or: claude login in the container
export HF_TOKEN="hf_..."                     # Hugging Face – for infografik (free)

# Optional – only when needed
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

> **Note:** After setting a new variable, the container must be rebuilt:
> `Cmd+Shift+P` → `Dev Containers: Rebuild Container`

### Authenticate Claude Code

**Option A – API Key** (recommended, see above): Set the `ANTHROPIC_API_KEY` variable on the host.

**Option B – Login in the container:**
```bash
claude login
```

### Hugging Face Token (`HF_TOKEN`)

Required for the **infografik**. One-time setup:

1. Create a token at https://huggingface.co/settings/tokens (**Token type:** `Read`)
2. Set as `HF_TOKEN` on the host (see above)
3. Rebuild the DevContainer

### Maven – Artifactory (`~/.m2/settings.xml` in the container)

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

## 3 – Start the Container

```bash
code .
# → Choose "Reopen in Container"
```

On first start ~3–5 min. All tools (Java 25, Maven, Docker-in-Docker, Claude Code)
are installed automatically.
