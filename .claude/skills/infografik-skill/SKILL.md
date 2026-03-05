---
name: infografik-skill
description: Erstellt professionelle Infografiken als PNG ueber die Hugging Face Inference API (FLUX.1-schnell). Unterstuetzt technische Dashboards, Architekturuebersichten, Prozessflows, Vergleiche, Timelines und kreative Poster. Verwende diesen Skill bei Infografiken, Visualisierungen, illustrierten Statistiken oder Roadmaps – auch bei "visualisiere das", "mach das uebersichtlich", "zeig das als Bild", "erstelle ein Diagramm" oder "erstelle eine Infografik".
argument-hint: "[thema-oder-beschreibung]"
---

# Infografik-Skill

Erstellt professionelle Infografiken als PNG-Datei über die **Hugging Face Inference API** (kostenlos, kein Billing erforderlich).

> **Philosophie:** Daten werden erst dann verständlich, wenn sie visuell erzählt werden.
> Eine gute Infografik reduziert Komplexität – sie fügt keine hinzu.

---

## What This Skill Does

1. **Fragt Stil und Typ ab** – Technisch/Professional oder Kreativ/Visuell per `AskUserQuestion`
2. **Klärt Thema und Daten** – Nutzer-Daten oder Beispieldaten aus `references/beispieldaten.md`
3. **Wählt Farbpalette** – Aus `references/farbpaletten.md` passend zum Stil
4. **Formuliert Image-Prompt** – Detaillierten englischen Prompt aus Daten, Stil und Palette
5. **Ruft Hugging Face API auf** – Generiert PNG via FLUX.1-schnell oder Fallback-Modell
6. **Speichert und präsentiert** – PNG mit Zeitstempel im Projekt-Root

## How to Use

```
Erstelle eine Infografik mit den aktuellen KPIs
```

```
Visualisiere die Architektur meines Projekts als Poster
```

```
Mach eine Übersicht der Sprint-Ergebnisse als Bild
```

### Voraussetzungen

Der Nutzer benötigt ein **kostenloses Hugging Face-Konto** und ein Access Token:
- Token erstellen: https://huggingface.co/settings/tokens (Read-Zugriff reicht)
- Token als Umgebungsvariable setzen: `export HF_TOKEN=hf_...`

---

## Instructions

### Schritt 1 – Stil-Abfrage

Der Grafikstil bestimmt Layout, Farbpalette und Detailgrad des Image-Prompts. Ohne diese Entscheidung wuerde der Prompt zu generisch ausfallen – daher immer zuerst mit `AskUserQuestion` abfragen.

#### Frage 1 – Grafikstil (Zielgruppe)

```
Welchen Grafikstil möchtest du?
```

Optionen:
- **Technisch / Professional** – Für Entwickler, Architekten, Business Analysten. Präzise Kacheln, Metriken, Tabellen, strukturierte Layouts. Beispiel: KPI-Dashboard, Architekturübersicht, API-Dokumentation.
- **Kreativ / Visuell** – Für Nicht-Techniker, Management, Stakeholder, Marketing. Große Illustrationen, bunte Grafiken, Storytelling-Layouts. Beispiel: Roadmap-Poster, Prozessflow mit Symbolen, Team-Überblick.

#### Frage 2 – Infografik-Typ

**Bei Technisch / Professional:**

| Typ | Beschreibung |
|-----|-------------|
| Dashboard / KPI | Hero Numbers, Metriken, Fortschrittsbalken |
| Architektur | Layer-Diagramme, Komponenten, BCE/MVC-Strukturen |
| Prozess / Workflow | Schritte mit Pfeilen, nummeriert, horizontal oder vertikal |
| Vergleich | A vs B, Pro/Contra, Tabellen mit Farbcodierung |
| Timeline | Versionsverlauf, Sprint-Planung, Roadmap mit Meilensteinen |

**Bei Kreativ / Visuell:**

| Typ | Beschreibung |
|-----|-------------|
| Storytelling / Poster | Narrative Struktur, große Illustrationen, lebendige Farben |
| Kreisdiagramm-Fokus | Zentrale Botschaft, radiale Anordnung, starke Akzente |
| Schritt-für-Schritt | Groß nummerierte Schritte, Icons, viel Weißraum |
| Statistik / Fakten | Große Zahlen mit Illustrationen, Piktogramme |
| Roadmap | Zeitlinie mit Illustrationen, Meilenstein-Symbole, Phasenfarben |

### Schritt 2 – Thema und Daten klären

Nutzer-Daten verwenden oder Beispieldaten aus `references/beispieldaten.md`.

### Schritt 3 – Farbpalette wählen

`references/farbpaletten.md` laden; Farbbeschreibung für den Prompt nutzen.

### Schritt 4 – Image-Prompt formulieren

Der Prompt muss **auf Englisch** und sehr detailliert sein. Struktur:

```
A professional [style] infographic about [topic].
Layout: [describe layout - grid, flow, poster, etc.]
Content: [list the key data points, labels, values]
Color scheme: [describe colors from palette]
Typography: [clean, bold titles, readable labels]
Style: flat design, high contrast, white background, no gradients, crisp edges.
Format: portrait orientation, 1024x1536 pixels.
```

**Beispiel-Prompt (Technisch / KPI-Dashboard):**

```
A professional corporate KPI dashboard infographic. Clean grid layout with 6 metric tiles.
Content: Revenue 12.4M EUR (up 18%), Active Users 87.200, Error Rate 0.3%,
Uptime 99.9%, Sprint Velocity 42 points, NPS Score 72.
Color scheme: white background, cobalt blue (#1A56DB) headers,
emerald green (#0E9F6E) for positive KPIs, amber (#E3A008) for warnings.
Typography: bold sans-serif titles, monospace values.
Style: flat design, no shadows, card-based layout, horizontal dividers.
Format: portrait, 1024x1536.
```

**Beispiel-Prompt (Kreativ / Storytelling-Poster):**

```
A vibrant storytelling infographic poster about digital transformation.
Layout: top-to-bottom flow with 4 illustrated steps connected by arrows.
Content: Step 1 Analyse (magnifying glass icon), Step 2 Design (pencil icon),
Step 3 Build (gear icon), Step 4 Launch (rocket icon).
Color scheme: mint-white background (#FAFFFE), teal (#0D9488) primary,
indigo (#4F46E5) accent, orange (#F97316) highlights.
Typography: large bold step numbers, readable sans-serif descriptions.
Style: modern flat illustration, rounded icons, generous whitespace.
Format: portrait poster, 1024x1536.
```

### Schritt 5 – API aufrufen

Empfohlenes Modell: **`black-forest-labs/FLUX.1-schnell`** (kostenlos, schnell, hohe Qualität)

```bash
curl -s \
  -H "Authorization: Bearer $HF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"inputs": "DEIN_PROMPT_HIER"}' \
  "https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell" \
  --output "infografik_$(date +%Y%m%d_%H%M%S).png"
```

Fallback-Modell falls FLUX nicht verfügbar: **`stabilityai/stable-diffusion-xl-base-1.0`**

```bash
curl -s \
  -H "Authorization: Bearer $HF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"inputs": "DEIN_PROMPT_HIER"}' \
  "https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-xl-base-1.0" \
  --output "infografik_$(date +%Y%m%d_%H%M%S).png"
```

#### Fehlerbehandlung

- **503 / Model loading**: Modell startet noch – 20 Sekunden warten, dann erneut versuchen
- **401 Unauthorized**: `HF_TOKEN` fehlt oder ungültig
- **Leere/korrupte PNG**: Antwort war JSON-Fehler – `cat infografik.png` zur Diagnose
- **Text im Bild unleserlich**: Bekannte FLUX-Limitation – Beschriftungen im Prompt kürzer halten, nur Schlüsselwörter verwenden

### Schritt 6 – Ausgabe speichern und präsentieren

PNG ins Projekt-Root speichern, dann mit `present_files` teilen.

Dateiname: **Niemals** eine bestehende Infografik überschreiben. Immer mit Zeitstempel oder beschreibendem Namen speichern:

```bash
# Dateiname mit Zeitstempel
infografik_$(date +%Y%m%d_%H%M%S).png

# Oder beschreibender Name
infografik_spring-architektur.png
infografik_kpi-dashboard.png
```

Vor dem Speichern prüfen ob eine Datei mit dem geplanten Namen bereits existiert.

### Qualitätscheckliste

Vor dem Präsentieren prüfen:
- [ ] Stil-Abfrage wurde durchgeführt (AskUserQuestion)
- [ ] Prompt ist auf Englisch und enthält alle relevanten Daten
- [ ] Farbpalette ist im Prompt beschrieben
- [ ] PNG-Datei wurde erfolgreich gespeichert (Dateigröße > 10 KB)
- [ ] Datei liegt im Projekt-Root

---

## References

| Datei | Beschreibung |
|-------|-------------|
| [references/farbpaletten.md](references/farbpaletten.md) | 5 Themes mit Farbbeschreibungen für den Prompt – immer laden |
| [references/beispieldaten.md](references/beispieldaten.md) | Demo-Datensätze als Textbeschreibung – laden wenn kein eigener Datensatz vorhanden |

---

## Conventions

- **Prompt-Sprache:** Englisch (Hugging Face Modelle verstehen Englisch am besten)
- **Dateiformat:** PNG, Portrait 1024x1536
- **Dateiname:** `infografik_<beschreibung-oder-zeitstempel>.png` – nie überschreiben
- **Stil:** Flat Design, High Contrast, keine Schatten/Gradienten
- **Qualität:** Beschriftungen kurz halten – FLUX-Limitation bei langen Texten
