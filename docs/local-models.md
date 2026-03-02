# Lokale Modelle & Datensouveränität

> **Datenschutz-Hinweis:** Bei der Nutzung der Anthropic Cloud API werden Prompts,
> Kontext und **Quellcode** an externe Server gesendet und dort verarbeitet.
> Für sensible Projekte, interne Architekturen oder regulierte Umgebungen empfehlen
> wir die Verwendung lokaler Modelle – der Code verlässt dann nie den Rechner.

Claude Code unterstützt lokale Modelle als vollständigen Ersatz für die Cloud API.
Die Konfiguration erfolgt über zwei Umgebungsvariablen – kein Code-Umbau nötig.

---

## Schnellstart

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

## Option A – Ollama

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

## Option B – LM Studio

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

## Zurück zur Cloud API

```bash
# Variablen entfernen und API Key wieder setzen
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_AUTH_TOKEN
export ANTHROPIC_API_KEY="sk-ant-..."
# DevContainer neu bauen
```

---

## Vergleich: Cloud vs. Lokal

| | Cloud API (Anthropic) | Lokal (Ollama / LM Studio) |
|-|----------------------|---------------------------|
| **Datenschutz** | Code wird extern verarbeitet | Code bleibt auf dem Rechner |
| **Modellqualität** | Claude Sonnet / Opus | Je nach Hardware |
| **Geschwindigkeit** | Schnell (Serverinfrastruktur) | Abhängig von lokaler GPU/CPU |
| **Kosten** | Pay-per-use | Einmalig (Hardware) |
| **Offline** | Nein | Ja |
| **Empfehlung** | Allgemeine Entwicklung | Sensible Projekte, Regulierung |
