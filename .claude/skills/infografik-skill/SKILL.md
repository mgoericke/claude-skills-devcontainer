---
name: infografik-skill
description: Erstellt professionelle, datengetriebene Infografiken als PNG-Dateien über die Hugging Face Inference API (kostenlos). Verwende diesen Skill immer wenn der Nutzer eine Infografik, visuelle Zusammenfassung, Datendarstellung, Chart-Übersicht oder illustrierte Statistik erstellen möchte – auch wenn er nur "visualisiere das" oder "mach das übersichtlich" sagt. Der Skill generiert das Bild per KI-Prompt über die Hugging Face API.
---

# Infografik-Skill

Erstelle professionelle Infografiken als PNG-Datei über die **Hugging Face Inference API** (kostenlos, kein Billing erforderlich).

## Voraussetzungen

Der Nutzer benötigt ein **kostenloses Hugging Face-Konto** und ein Access Token:
- Token erstellen: https://huggingface.co/settings/tokens (Read-Zugriff reicht)
- Token als Umgebungsvariable setzen: `export HF_TOKEN=hf_...`

---

## PFLICHT: Stil-Abfrage vor jeder Erstellung

**Bevor der Prompt generiert wird, MUSS der Nutzer mit `AskUserQuestion` nach Stil und Typ gefragt werden.**

### Frage 1 – Grafikstil (Zielgruppe)

```
Welchen Grafikstil möchtest du?
```

Optionen:
- **Technisch / Professional** – Für Entwickler, Architekten, Business Analysten. Präzise Kacheln, Metriken, Tabellen, strukturierte Layouts. Beispiel: KPI-Dashboard, Architekturübersicht, API-Dokumentation.
- **Kreativ / Visuell** – Für Nicht-Techniker, Management, Stakeholder, Marketing. Große Illustrationen, bunte Grafiken, Storytelling-Layouts. Beispiel: Roadmap-Poster, Prozessflow mit Symbolen, Team-Überblick.

### Frage 2 – Infografik-Typ

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

---

## Workflow (nach Stil-Abfrage)

1. **Stil & Typ abfragen** – `AskUserQuestion` (PFLICHT, vor allem anderen)
2. **Thema & Daten klären** – Nutzer-Daten verwenden oder Beispieldaten aus `references/beispieldaten.md`
3. **Farbpalette wählen** – `references/farbpaletten.md` laden; Farbbeschreibung für den Prompt nutzen
4. **Image-Prompt formulieren** – Detaillierten englischen Prompt aus Daten, Stil und Palette erstellen (siehe unten)
5. **API aufrufen** – Hugging Face Inference API via `curl` (siehe unten)
6. **Ausgabe speichern** – PNG ins Projekt-Root speichern
7. **Ausgabe präsentieren** – mit `present_files` teilen

---

## Prompt-Formulierung

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

### Beispiel-Prompt (Technisch / KPI-Dashboard):

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

### Beispiel-Prompt (Kreativ / Storytelling-Poster):

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

---

## API-Aufruf (Hugging Face)

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

### Fehlerbehandlung

- **503 / Model loading**: Modell startet noch – 20 Sekunden warten, dann erneut versuchen
- **401 Unauthorized**: `HF_TOKEN` fehlt oder ungültig
- **Leere/korrupte PNG**: Antwort war JSON-Fehler – `cat infografik.png` zur Diagnose
- **Text im Bild unleserlich**: Bekannte FLUX-Limitation – Beschriftungen im Prompt kürzer halten, nur Schlüsselwörter verwenden

---

## Qualitätscheckliste

Vor dem Präsentieren prüfen:
- [ ] Stil-Abfrage wurde durchgeführt (AskUserQuestion)
- [ ] Prompt ist auf Englisch und enthält alle relevanten Daten
- [ ] Farbpalette ist im Prompt beschrieben
- [ ] PNG-Datei wurde erfolgreich gespeichert (Dateigröße > 10 KB)
- [ ] Datei liegt im Projekt-Root

---

## Ausgabe

PNG-Datei im aktuellen Verzeichnis speichern:

```bash
# API-Aufruf speichert direkt als infografik.png
# Dann present_files mit dem Pfad aufrufen
```

Dateiname: **niemals** eine bestehende Infografik überschreiben. Immer mit Zeitstempel oder beschreibendem Namen speichern:

```bash
# Dateiname mit Zeitstempel
infografik_$(date +%Y%m%d_%H%M%S).png

# Oder beschreibender Name
infografik_spring-architektur.png
infografik_kpi-dashboard.png
```

Vor dem Speichern prüfen ob eine Datei mit dem geplanten Namen bereits existiert.

---

## Referenz-Dateien

Lade bei Bedarf:
- `references/farbpaletten.md` – 5 Themes mit Farbbeschreibungen für den Prompt
- `references/beispieldaten.md` – Demo-Datensätze als Textbeschreibung für den Prompt

Wann laden:
- Farbpaletten → immer laden, Farben präzise im Prompt beschreiben
- Beispieldaten → wenn kein eigener Datensatz vorhanden ist
