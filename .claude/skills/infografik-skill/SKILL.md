---
name: infografik-skill
description: Erstellt professionelle, datengetriebene Infografiken als PNG- oder PDF-Dateien mit Python (matplotlib, PIL). Verwende diesen Skill immer wenn der Nutzer eine Infografik, visuelle Zusammenfassung, Datendarstellung, Chart-Übersicht oder illustrierte Statistik erstellen möchte – auch wenn er nur "visualisiere das" oder "mach das übersichtlich" sagt. Der Skill kombiniert Datenvisualisierung mit ansprechendem Design und liefert eine fertige, herunterladbare Datei.
---

# Infografik-Skill

Erstelle professionelle, visuell ansprechende Infografiken als PNG- oder PDF-Datei mit Python.

## Workflow

1. **Stil & Zielgruppe abfragen** – Nutze `AskUserQuestion` mit zwei Fragen (Stil + Zielgruppe) bevor du beginnst
2. **Thema & Daten klären** – Verstehe was visualisiert werden soll. Eigene Daten oder Beispieldaten?
3. **Layout planen** – Wähle einen passenden Infografik-Typ (siehe unten)
4. **Code schreiben & ausführen** – Python mit matplotlib/PIL
5. **Ausgabe sichern** – Datei nach `/mnt/user-data/outputs/` speichern UND ins aktuelle Arbeitsverzeichnis kopieren (niemals überschreiben)
6. **Ergebnis präsentieren** – Mit `present_files` teilen

---

## Schritt 1: Stil & Zielgruppe abfragen (PFLICHT)

Rufe immer zuerst `AskUserQuestion` auf mit diesen beiden Fragen:

```
Frage 1 – Stil:
  header: "Stil"
  question: "Welchen visuellen Stil soll die Infografik haben?"
  options:
    - label: "Modern Flat"
      description: "Geometrisch, klare Formen, flache Icons, helle Farben – zeitgemäß und leserfreundlich"
    - label: "Bold & Graphic"
      description: "Große Kontraste, kräftige Farben, auffällige Typografie – ideal für Marketing und Präsentationen"
    - label: "Dark Tech"
      description: "Dunkler Hintergrund, leuchtende Akzente – für Tech-, KI- und Digitalthemen"
    - label: "Corporate Minimal"
      description: "Sauber, professionell, viel Weißraum – für Reports, Behörden, Geschäftsberichte"

Frage 2 – Zielgruppe:
  header: "Zielgruppe"
  question: "Für wen ist diese Infografik gedacht?"
  options:
    - label: "Management / Entscheider"
      description: "Kurzgefasst, KPIs im Fokus, Executive Summary"
    - label: "Fachpublikum / Experten"
      description: "Detailliert, datenreich, technische Tiefe"
    - label: "Allgemeinpublikum"
      description: "Verständlich, ansprechend, ohne Vorwissen"
    - label: "Social Media"
      description: "Hochformat, schnell konsumierbar, starke Bildsprache"
```

Passe Design, Detailgrad und Typografie danach an.

---

## Infografik-Typen (Freepik-Stil)

### Statistik-Infografik (Hero Numbers)
Große Kennzahlen im Vordergrund, ergänzt durch Mini-Charts und Icons.
- Stil-Tipp: Bold & Graphic oder Dark Tech
- Layout: 3–4 große Zahlen oben, Balken-/Kreisdiagramm unten

### Prozess-Infografik
Schritt-für-Schritt-Ablauf mit Pfeilen oder verbundenen Schritten.
- Stil-Tipp: Modern Flat oder Corporate Minimal
- Layout: Vertikal mit nummerierten Kreisen + Verbindungslinien

### Timeline-Infografik
Horizontale oder vertikale Zeitlinie mit Ereignissen und Jahreszahlen.
- Stil-Tipp: Modern Flat, Dark Tech
- Layout: Linie mittig, Ereignisse alternierend links/rechts

### Vergleichs-Infografik (A vs B)
Zwei oder mehr Optionen nebeneinander mit Pro/Contra oder Kennzahlen.
- Stil-Tipp: Corporate Minimal oder Bold & Graphic
- Layout: Geteilte Spalten mit farbiger Trennlinie

### Liste / Aufzählung (Icon-Liste)
Nummerierte oder ungeordnete Liste mit großen Icons pro Eintrag.
- Stil-Tipp: Modern Flat oder Corporate Minimal
- Layout: Vertikal, Icon links – Text rechts

### Kreisförmiges / Bubble-Layout
Zentrales Thema mit radialen Ästen oder Blasen für Unterpunkte.
- Stil-Tipp: Dark Tech oder Bold & Graphic
- Layout: Hub-and-Spoke mit Kreis-Icons

### Dashboard / KPI-Übersicht
Kombinierte Metriken: Balken, Kreise, Zahlen in Kachel-Layout.
- Stil-Tipp: Dark Tech oder Corporate Minimal
- Layout: Raster aus Kacheln (2×2 oder 3×2)

---

## Stil → Palette Mapping

| Stil | Farbpalette (aus farbpaletten.md) | Besonderheiten |
|---|---|---|
| Modern Flat | Light Clean | Runde Ecken (radius 8–12pt), flache Schatten |
| Bold & Graphic | High Impact | Starke Kontraste, große Typografie (Titel 40+pt) |
| Dark Tech | Dark Tech | Leuchtende Akzente, dünne Linien als Strukturelemente |
| Corporate Minimal | Light Clean / Behörden | Viel Weißraum, dezente Akzente, max. 2 Farben |

---

## Zielgruppe → Design-Anpassungen

| Zielgruppe | Detailgrad | Schriftgröße | Besonderheiten |
|---|---|---|---|
| Management | Niedrig – nur KPIs | Groß (Body ≥ 14pt) | Max. 5 Kernaussagen, Executive Summary oben |
| Fachpublikum | Hoch – Rohdaten + Quellen | Normal (Body 11–13pt) | Fußzeile mit Datenquellen |
| Allgemeinpublikum | Mittel – erklärt | Groß, vereinfacht | Erklärungstexte, Icons zur Orientierung |
| Social Media | Sehr niedrig – 1 Kernbotschaft | Sehr groß | Hochformat (8×14 inch), starke Farben |

---

## Technischer Setup

```python
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch
import matplotlib.gridspec as gridspec
import numpy as np
import os, shutil
from datetime import datetime

# Basis-Setup (Größe je nach Zielgruppe)
fig = plt.figure(figsize=(11, 15), facecolor=PALETTE['bg'])  # Standard
# Social Media: figsize=(8, 14)
# Dashboard: figsize=(14, 10)

# DPI für qualitativ hochwertige Ausgabe
plt.savefig(output_path, dpi=150, bbox_inches='tight',
            facecolor=fig.get_facecolor(), edgecolor='none')
```

---

## Ausgabe & Datei-Verwaltung (WICHTIG)

### Regeln:
1. **Niemals überschreiben** – Prüfe ob die Zieldatei existiert, füge ggf. einen Zeitstempel oder Zähler an
2. **Immer ins aktuelle Verzeichnis kopieren** – Neben `/mnt/user-data/outputs/` immer auch ins CWD kopieren

```python
import os, shutil
from datetime import datetime

def save_infografik(fig, base_name: str, output_dir: str, cwd: str) -> str:
    """Speichert Infografik ohne Überschreiben, kopiert ins CWD."""
    os.makedirs(output_dir, exist_ok=True)

    # Eindeutigen Dateinamen erzeugen (nie überschreiben)
    def unique_path(directory, name):
        candidate = os.path.join(directory, name)
        if not os.path.exists(candidate):
            return candidate
        stem, ext = os.path.splitext(name)
        ts = datetime.now().strftime('%Y%m%d_%H%M%S')
        return os.path.join(directory, f"{stem}_{ts}{ext}")

    out_path = unique_path(output_dir, base_name)
    fig.savefig(out_path, dpi=150, bbox_inches='tight',
                facecolor=fig.get_facecolor(), edgecolor='none')

    # Ins aktuelle Arbeitsverzeichnis kopieren (niemals überschreiben)
    cwd_path = unique_path(cwd, base_name)
    shutil.copy2(out_path, cwd_path)

    return out_path, cwd_path

# Verwendung:
out_path, cwd_path = save_infografik(
    fig,
    base_name='infografik.png',
    output_dir='/mnt/user-data/outputs/',
    cwd=os.getcwd()
)
print(f"Gespeichert: {out_path}")
print(f"Kopiert nach: {cwd_path}")
```

---

## Design-Prinzipien

- **Farbpalette**: Maximal 3–4 Farben + Akzentfarbe (aus farbpaletten.md laden)
- **Typografie**: Klare Hierarchie: Titel (32–42pt) → Subtitel (18–22pt) → Body (12–14pt)
- **Weißraum**: Großzügig – Elemente atmen lassen (mind. 5% Rand)
- **Konsistenz**: Einheitliche Abstände, Radien, Icon-Stil
- **Freepik-Prinzip**: Jede Sektion klar abgegrenzt, visuelle Anker (Icons, Farbe) für schnelle Orientierung

## Qualitätscheckliste

Vor dem Speichern prüfen:
- [ ] Stil und Zielgruppe wurden abgefragt (AskUserQuestion)
- [ ] Keine Textüberschneidungen
- [ ] Alle Elemente innerhalb der Canvas-Grenzen
- [ ] Konsistente Abstände (Raster einhalten)
- [ ] Lesbare Schriftgrößen (min. 10pt)
- [ ] Ausreichend Kontrast (WCAG-konform)
- [ ] Titel erklärt das Thema auf einen Blick
- [ ] Datei ins CWD kopiert (nicht überschrieben)

---

## Referenz-Dateien

Lade bei Bedarf:
- `references/farbpaletten.md` – 5 vorgefertigte Themes (Dark Tech, Light Clean, Behörden, Nature, High Impact)
- `references/beispieldaten.md` – Demo-Datensätze für Markt, Zeitreihen, Branchen, Demografie, KI/Behörden

Wann laden:
- Farbpaletten → immer, basierend auf gewähltem Stil
- Beispieldaten → wenn kein eigener Datensatz vorhanden ist

---

## Hinweis zu Fonts

```python
from matplotlib import font_manager
# Prüfe verfügbare Fonts:
# [f.name for f in font_manager.fontManager.ttflist]
# Standard: DejaVu Sans (matplotlib Standard) – reicht für die meisten Fälle
```
