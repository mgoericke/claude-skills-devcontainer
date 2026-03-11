# Local Models & Data Sovereignty

> **Privacy Notice:** When using the Anthropic Cloud API, prompts,
> context, and **source code** are sent to and processed on external servers.
> For sensitive projects, internal architectures, or regulated environments,
> we recommend using local models – the code then never leaves the machine.

Claude Code supports local models as a complete replacement for the Cloud API.
Configuration is done via two environment variables – no code changes needed.

---

## Quick Start

**Step 1 – Start a model server on the host** (Ollama or LM Studio, see below)

**Step 2 – Set environment variables on the host** (`~/.zshrc` or `~/.bashrc`):

```bash
# Ollama
export ANTHROPIC_BASE_URL="http://host.docker.internal:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
unset ANTHROPIC_API_KEY   # Disable Cloud API

# – or – LM Studio
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

**Step 3 – Rebuild the DevContainer:**
`Cmd+Shift+P` → `Dev Containers: Rebuild Container`

**Step 4 – Specify the model at startup:**
```bash
claude --model qwen3-coder       # Ollama
claude --model openai/qwen3-coder  # LM Studio
```

> **`host.docker.internal` instead of `localhost`:** In the DevContainer, `localhost`
> points to the container itself – not to the host. `host.docker.internal` is the
> correct address for services running on the host (works automatically
> under Docker Desktop on macOS and Windows; on Linux use `172.17.0.1` if needed).

> **Model server on the LAN?** `host.docker.internal` can be replaced by any
> reachable address – including a LAN IP like `http://192.168.1.100:11434`.

---

## Option A – Ollama

[Ollama](https://ollama.com) runs as a local server and manages models automatically.

**Installation & Start:**
```bash
# macOS
brew install ollama
ollama serve                      # Start server (runs on port 11434)

# Download and start a model
ollama pull qwen3-coder           # ~8 GB, recommended for code tasks
```

**Recommended models for Claude Code:**

| Model | Size | Strength |
|-------|------|----------|
| `qwen3-coder` | ~8 GB | Code generation, reasoning |
| `glm-4.7` | ~5 GB | Compact, fast |
| `gpt-oss:20b` | ~12 GB | Generalist model |
| `gpt-oss:120b` | ~70 GB | Maximum quality (powerful hardware) |

> **Context window:** Claude Code requires at least 64k token context.
> Ollama configures this automatically for recommended models.

**Quick command (without DevContainer, directly in the terminal):**
```bash
ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 \
  ANTHROPIC_API_KEY="" claude --model qwen3-coder
```

---

## Option B – LM Studio

[LM Studio](https://lmstudio.ai) offers a graphical interface for model management
and an OpenAI-compatible API server.

**Installation & Start:**
```bash
# Start server (port 1234)
lms server start --port 1234
```

Or via the LM Studio GUI: **Local Server** → **Start Server**

**Choose a model:** In LM Studio, load a model with at least 25k token context.
Recommendation: Qwen3-Coder, DeepSeek-Coder, or similar code-optimized models.

**Start Claude Code:**
```bash
claude --model openai/qwen3-coder
```

> **Context window:** At least 25k tokens – the more, the better for
> extensive codebase analyses.

---

## Switch Back to the Cloud API

```bash
# Remove variables and set API key again
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_AUTH_TOKEN
export ANTHROPIC_API_KEY="sk-ant-..."
# Rebuild DevContainer
```

---

## Comparison: Cloud vs. Local

| | Cloud API (Anthropic) | Local (Ollama / LM Studio) |
|-|----------------------|---------------------------|
| **Privacy** | Code is processed externally | Code stays on the machine |
| **Model quality** | Claude Sonnet / Opus | Depends on hardware |
| **Speed** | Fast (server infrastructure) | Depends on local GPU/CPU |
| **Cost** | Pay-per-use | One-time (hardware) |
| **Offline** | No | Yes |
| **Recommendation** | General development | Sensitive projects, regulation |
