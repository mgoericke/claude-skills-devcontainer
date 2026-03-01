# Claude Code + Skills – DevContainer

DevContainer für Claude Code mit Skills, Java 21, Maven, Python 3.12 und Node.js 22.  
Läuft auf **Windows** (Docker Desktop + WSL2) und **macOS** (Docker Desktop / OrbStack).

## Enthaltene Tools

| Tool | Version | Zweck |
|------|---------|-------|
| Claude Code | latest | KI-Coding-Assistent |
| Java (MS OpenJDK) | 21 LTS | Quarkus / Enterprise Java |
| Maven | 3.9.9 | Build-Tool, `~/.m2` wird persistiert |
| Python | 3.12 | Skripte, infografik-skill (matplotlib) |
| Node.js + nvm | 22 LTS | Frontend-Tooling, Claude Code Runtime |

## Voraussetzungen

| Tool | Windows | macOS |
|------|---------|-------|
| Docker Desktop | [docker.com/desktop](https://docker.com/desktop) | [docker.com/desktop](https://docker.com/desktop) |
| VS Code | [code.visualstudio.com](https://code.visualstudio.com) | gleich |
| Dev Containers Extension | `ms-vscode-remote.remote-containers` | gleich |

## Start

```bash
# 1. Projektordner in VS Code öffnen
code .

# 2. VS Code fragt automatisch → "Reopen in Container" klicken
#    oder: Cmd/Ctrl+Shift+P → "Dev Containers: Reopen in Container"

# 3. Beim ersten Start: API-Key eingeben
claude
```

## Projektstruktur

```
.
├── .devcontainer/
│   └── devcontainer.json       # Container-Konfiguration (einzige Datei nötig)
└── .claude/
    └── skills/
        └── infografik-skill/   # Automatisch von Claude Code erkannt
            ├── SKILL.md
            └── references/
```

## Persistierte Volumes

| Volume | Inhalt | Warum |
|--------|--------|-------|
| `claude-code-config-*` | `~/.claude` | API-Key + Claude-Settings |
| `claude-code-m2-*` | `~/.m2` | Maven Local Repository (spart Downloads) |

## API-Key als Umgebungsvariable (empfohlen für Teams)

```jsonc
// .devcontainer/devcontainer.json ergänzen:
"containerEnv": {
  "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
}
```

Auf dem Host setzen:
```bash
# macOS/Linux (.zshrc / .bashrc):
export ANTHROPIC_API_KEY="sk-ant-..."

# Windows PowerShell:
$env:ANTHROPIC_API_KEY = "sk-ant-..."
```

## Node.js Version wechseln

nvm ist im Container enthalten:
```bash
nvm install 20    # z.B. für ältere Projekte
nvm use 20
```
