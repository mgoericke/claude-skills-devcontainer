---
name: infografik-skill
description: Erstellt professionelle, datengetriebene Infografiken als PNG- oder PDF-Dateien mit Python (matplotlib, PIL). Verwende diesen Skill immer wenn der Nutzer eine Infografik, visuelle Zusammenfassung, Datendarstellung, Chart-Übersicht oder illustrierte Statistik erstellen möchte – auch wenn er nur "visualisiere das" oder "mach das übersichtlich" sagt. Der Skill kombiniert Datenvisualisierung mit ansprechendem Design und liefert eine fertige, herunterladbare Datei.
---

# Infografik-Skill

Erstelle professionelle, visuell ansprechende Infografiken als PNG- oder PDF-Datei mit Python.

## Workflow

1. **Thema & Daten klären** – Verstehe was visualisiert werden soll. Hast du Daten vom Nutzer oder musst du sinnvolle Beispieldaten verwenden?
2. **Layout planen** – Wähle einen Infografik-Typ (siehe unten)
3. **Code schreiben & ausführen** – Python mit matplotlib/PIL
4. **Ausgabe präsentieren** – Datei nach `/mnt/user-data/outputs/` kopieren und mit `present_files` teilen

## Infografik-Typen

### Statistik-Infografik
Kennzahlen groß hervorgehoben, mit Icons und Vergleichsbalken.
```python
# Große Zahlen = "Hero Numbers", daneben erklärende Mikro-Charts
```

### Prozess-Infografik
Schritt-für-Schritt-Ablauf mit Pfeilen und numerierten Schritten.

### Vergleichs-Infografik
Nebeneinander-Darstellung von Optionen (Pro/Contra, A vs B).

### Timeline-Infografik
Horizontale oder vertikale Zeitlinie mit Ereignissen.

### Datentabelle als Grafik
Tabelle mit Farbcodierung, Icons und visueller Hierarchie.

## Design-Prinzipien

- **Farbpalette**: Maximal 3–4 Farben + Akzentfarbe
- **Typografie**: Klare Hierarchie: Titel (28–36px) → Subtitel (18–22px) → Body (12–14px)
- **Weißraum**: Großzügig – Elemente atmen lassen
- **Konsistenz**: Einheitliche Abstände, Radien, Icon-Stil

## Technischer Setup

```python
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch
import matplotlib.gridspec as gridspec
import numpy as np

# Basis-Setup
fig = plt.figure(figsize=(10, 14), facecolor='#F8F9FA')
fig.patch.set_facecolor('#F8F9FA')

# DPI für qualitativ hochwertige Ausgabe
plt.savefig('output.png', dpi=150, bbox_inches='tight',
            facecolor=fig.get_facecolor())
```

## Qualitätscheckliste

Vor dem Speichern prüfen:
- [ ] Keine Textüberschneidungen
- [ ] Alle Elemente innerhalb der Canvas-Grenzen
- [ ] Konsistente Abstände (verwende ein Raster)
- [ ] Lesbare Schriftgrößen (min. 10pt)
- [ ] Ausreichend Kontrast (Dunkel auf Hell oder umgekehrt)
- [ ] Titel erklärt das Thema auf einen Blick

## Ausgabe

Immer als PNG (bevorzugt, dpi=150) oder PDF speichern:
```python
output_path = '/mnt/user-data/outputs/infografik.png'
plt.savefig(output_path, dpi=150, bbox_inches='tight',
            facecolor=fig.get_facecolor(), edgecolor='none')
```

Dann `present_files` mit dem Pfad aufrufen.

## Referenz-Dateien

Lade bei Bedarf:
- `references/farbpaletten.md` – 5 vorgefertigte Themes (Dark Tech, Light Clean, Behörden, Nature, High Impact)
- `references/beispieldaten.md` – Demo-Datensätze für Markt, Zeitreihen, Branchen, Demografie, KI/Behörden

Wann laden:
- Farbpaletten → wenn Nutzer kein Theme nennt oder nach bestimmtem Stil fragt
- Beispieldaten → wenn kein eigener Datensatz vorhanden ist

## Hinweis zu Fonts

Für bessere Typografie kannst du prüfen ob `DejaVu Sans` (matplotlib Standard) reicht,
oder lade mit `matplotlib.font_manager` alternative Fonts:
```python
from matplotlib import font_manager
# Prüfe verfügbare Fonts:
# [f.name for f in font_manager.fontManager.ttflist]
```
