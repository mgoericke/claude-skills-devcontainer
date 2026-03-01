---
name: infografik-skill
description: Erstellt professionelle, datengetriebene Infografiken als PNG- oder PDF-Dateien mit Python (matplotlib, PIL). Verwende diesen Skill immer wenn der Nutzer eine Infografik, visuelle Zusammenfassung, Datendarstellung, Chart-Übersicht oder illustrierte Statistik erstellen möchte – auch wenn er nur "visualisiere das" oder "mach das übersichtlich" sagt. Der Skill kombiniert Datenvisualisierung mit ansprechendem Design und liefert eine fertige, herunterladbare Datei.
---

# Infografik-Skill

Erstelle professionelle, visuell ansprechende Infografiken als PNG- oder PDF-Datei mit Python.

## PFLICHT: Stil-Abfrage vor jeder Erstellung

**Bevor Code geschrieben wird, MUSS der Nutzer mit `AskUserQuestion` nach Stil und Typ gefragt werden.**

Verwende folgende zwei Fragen:

### Frage 1 – Grafikstil (Zielgruppe)

```
Welchen Grafikstil möchtest du?
```

Optionen:
- **Technisch / Professional** – Für Entwickler, Architekten, Business Analysten. Präzise Kacheln, Metriken, Tabellen, Code-Badges, strukturierte Layouts. Beispiel: KPI-Dashboard, Architekturübersicht, API-Dokumentation.
- **Kreativ / Visuell** – Für Nicht-Techniker, Management, Stakeholder, Marketing. Große Illustrationen, bunte Icons, Storytelling-Layouts, Fließtexte mit Bildelementen. Beispiel: Roadmap-Poster, Prozessflow mit Symbolen, Team-Überblick.

### Frage 2 – Infografik-Typ

Je nach gewähltem Stil werden unterschiedliche Typen angeboten:

**Bei Technisch / Professional:**
| Typ | Beschreibung |
|-----|-------------|
| Dashboard / KPI | Hero Numbers, Metriken, Fortschrittsbalken, Mini-Charts |
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

1. **Stil & Typ abfragen** – `AskUserQuestion` mit den zwei Fragen oben (PFLICHT, vor allem anderen)
2. **Thema & Daten klären** – Nutzer-Daten verwenden oder sinnvolle Beispieldaten einsetzen
3. **Farbpalette wählen** – `references/farbpaletten.md` laden; für Kreativ-Stil mutige Paletten bevorzugen
4. **Code schreiben & ausführen** – Python mit matplotlib/PIL, Stil-spezifische Designregeln beachten (siehe unten)
5. **Ausgabe speichern** – Datei nach `/mnt/user-data/outputs/` speichern **und** ins Root-Verzeichnis des Projekts (`/workspaces/<projektname>/`) kopieren
6. **Ausgabe präsentieren** – mit `present_files` teilen

---

## Designregeln nach Stil

### Technisch / Professional
- Heller Hintergrund (`#F8FAFC`, `#FFFFFF`)
- Kachel-basiertes Grid-Layout mit `FancyBboxPatch`
- Schmale Farbstreifen als Akzent (links oder oben an Kacheln)
- Monospace-Font für Code, Endpunkte, Schlüssel
- Maximal 4 Akzentfarben, viel Grau für Nebeninformationen
- Abschnitte klar mit Trennlinien und Labels strukturieren
- Palette: Corporate Blue, Tech Professional oder Enterprise Slate

### Kreativ / Visuell
- Farbige oder gradient-ähnliche Hintergründe
- Große Formen: Kreise, Sechsecke, geschwungene Bänder
- Text-Icons mit `matplotlib` (Zahlen in Kreisen, Pfeile, Symbole)
- Große Schrift für Hauptbotschaften (min. 24pt für Kernaussagen)
- Weniger Elemente, mehr visuelle Wirkung – „weniger ist mehr"
- Storytelling-Fluss: Top → Bottom, oder radial
- Palette: Agile & Modern, Analytics & Data – oder eigene bunte Kombination
- Matplotlib-Tricks für kreative Elemente:

```python
# Kreis mit Text (Icon-Ersatz)
circle = plt.Circle((cx, cy), radius, color=col, zorder=5)
ax.add_patch(circle)
ax.text(cx, cy, '1', ha='center', va='center', fontsize=20,
        fontweight='bold', color='white', zorder=6)

# Geschwungenes Band (Hintergrundform)
from matplotlib.patches import Arc, Wedge
wedge = Wedge((0.5, 0.5), 0.4, 0, 180, width=0.1,
              facecolor='#0284C7', alpha=0.2,
              transform=ax.transAxes)
ax.add_patch(wedge)

# Große dekorative Zahl
ax.text(0.5, 0.5, '87%', ha='center', va='center',
        fontsize=72, fontweight='bold', color=col,
        alpha=0.15, transform=ax.transAxes)  # als Hintergrund-Wasserzeichen
```

---

## Technischer Setup

```python
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, Circle, Wedge
import matplotlib.gridspec as gridspec
import numpy as np
import shutil, os

# Basis-Setup
fig = plt.figure(figsize=(11, 15), facecolor='#F8FAFC')
fig.patch.set_facecolor('#F8FAFC')
```

## Qualitätscheckliste

Vor dem Speichern prüfen:
- [ ] Stil-Abfrage wurde durchgeführt (AskUserQuestion)
- [ ] Keine Textüberschneidungen
- [ ] Alle Elemente innerhalb der Canvas-Grenzen
- [ ] Konsistente Abstände (verwende ein Raster)
- [ ] Lesbare Schriftgrößen (min. 10pt)
- [ ] Ausreichend Kontrast (Dunkel auf Hell oder umgekehrt)
- [ ] Titel erklärt das Thema auf einen Blick
- [ ] Kreativ-Stil: Mindestens ein großes visuelles Ankerelement vorhanden

## Ausgabe

Immer als PNG (bevorzugt, dpi=150) oder PDF speichern **und** ins Root-Verzeichnis kopieren:
```python
import shutil, os

output_path = '/mnt/user-data/outputs/infografik.png'
os.makedirs('/mnt/user-data/outputs', exist_ok=True)
plt.savefig(output_path, dpi=150, bbox_inches='tight',
            facecolor=fig.get_facecolor(), edgecolor='none')

# Pflicht: Kopie ins Projekt-Root
root_path = os.path.join(os.getcwd(), 'infografik.png')
shutil.copy2(output_path, root_path)
print(f"Infografik gespeichert: {output_path}")
print(f"Kopie im Projekt-Root: {root_path}")
```

Dann `present_files` mit dem Pfad aufrufen.

## Referenz-Dateien

Lade bei Bedarf:
- `references/farbpaletten.md` – 5 Themes: Corporate Blue, Tech Professional, Analytics & Data, Enterprise Slate, Agile & Modern
- `references/beispieldaten.md` – Demo-Datensätze für Markt, Zeitreihen, Branchen, Demografie, KI/Behörden

Wann laden:
- Farbpaletten → immer laden, da alle Paletten hell und zielgruppenspezifisch sind
- Beispieldaten → wenn kein eigener Datensatz vorhanden ist

## Hinweis zu Fonts

```python
from matplotlib import font_manager
# Prüfe verfügbare Fonts:
# [f.name for f in font_manager.fontManager.ttflist]
# Standard: DejaVu Sans – reicht für professionelle Ergebnisse
```
