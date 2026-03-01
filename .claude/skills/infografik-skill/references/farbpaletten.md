# Farbpaletten für Infografiken

Lade diese Datei wenn der Nutzer ein bestimmtes Theme wählt oder du Farben für eine Infografik brauchst.

**Grundregel:** Kein dunkles Design. Alle Paletten sind hell, kontrastreich und für professionelle Zielgruppen (Developer, Architekten, Business Analysten, Projektmanager) optimiert.

---

## 💼 Corporate Blue (Standard)
Klassisch, vertrauenswürdig – optimal für Business Analysten und Projektmanager.
Inspiriert von führenden Enterprise-Dashboards und Consulting-Reports.
```python
PALETTE = {
    'bg':      '#FFFFFF',  # Reines Weiß
    'card':    '#F0F4FF',  # Hellblau-Weiß
    'accent1': '#1A56DB',  # Cobalt-Blau (Primär)
    'accent2': '#0E9F6E',  # Smaragdgrün (Erfolg/KPI)
    'accent3': '#E3A008',  # Amber (Warnung/Highlight)
    'accent4': '#6C2BD9',  # Violett (Sekundär)
    'text':    '#111928',  # Fast Schwarz
    'muted':   '#6B7280',  # Mittelgrau
    'border':  '#D1D5DB',  # Hellgrau für Rahmen
}
```

---

## 🖥️ Tech Professional
Modern, präzise – ideal für Entwickler und Software-Architekten.
Klare Struktur, technischer Look mit Neon-Akzenten auf hellem Grund.
```python
PALETTE = {
    'bg':      '#F8FAFC',  # Kühles Off-White
    'card':    '#FFFFFF',  # Weiß
    'accent1': '#0284C7',  # Sky-Blau (Primär)
    'accent2': '#059669',  # Emerald (Tech-Grün)
    'accent3': '#7C3AED',  # Indigo (Code/Architektur)
    'accent4': '#DC2626',  # Rot (Alerts/Errors)
    'text':    '#0F172A',  # Slate-Schwarz
    'muted':   '#64748B',  # Slate-Grau
    'border':  '#E2E8F0',  # Sehr helles Grau
}
```

---

## 📊 Analytics & Data
Datengetrieben, strukturiert – für Data Analysten und BI-Experten.
Teal-Akzente signalisieren Präzision und Verlässlichkeit.
```python
PALETTE = {
    'bg':      '#F9FAFB',  # Warm Off-White
    'card':    '#FFFFFF',  # Weiß
    'accent1': '#0694A2',  # Teal (Primär)
    'accent2': '#3F83F8',  # Hellblau (Sekundär)
    'accent3': '#FF5A1F',  # Orange (Hervorhebung)
    'accent4': '#1C64F2',  # Dunkelblau (Trend)
    'text':    '#1F2937',  # Dunkelgrau
    'muted':   '#9CA3AF',  # Mittelgrau
    'border':  '#E5E7EB',  # Rahmenlinie
}
```

---

## 🏢 Enterprise Slate
Neutral, seriös, universell – für Mixed Audiences und Executive Präsentationen.
Funktioniert sowohl gedruckt als auch digital.
```python
PALETTE = {
    'bg':      '#FFFFFF',  # Weiß
    'card':    '#F1F5F9',  # Slate-100
    'accent1': '#334155',  # Slate-700 (Primär)
    'accent2': '#0EA5E9',  # Light-Blue (Akzent)
    'accent3': '#10B981',  # Grün (Positiv)
    'accent4': '#F59E0B',  # Gelb-Orange (KPI)
    'text':    '#0F172A',  # Slate-900
    'muted':   '#94A3B8',  # Slate-400
    'border':  '#CBD5E1',  # Slate-300
}
```

---

## 🚀 Agile & Modern
Frisch, dynamisch – für agile Teams, Scrum Master und moderne PM-Kontexte.
Mint und Indigo vermitteln Innovation und Energie.
```python
PALETTE = {
    'bg':      '#FAFFFE',  # Mint-Weiß
    'card':    '#F0FDF9',  # Grün-Weiß
    'accent1': '#0D9488',  # Teal-600 (Primär)
    'accent2': '#4F46E5',  # Indigo (Sprint/Feature)
    'accent3': '#F97316',  # Orange (Blocker/Action)
    'accent4': '#0EA5E9',  # Sky-Blau (Info)
    'text':    '#134E4A',  # Teal-Dunkel
    'muted':   '#6B7280',  # Grau
    'border':  '#CCFBF1',  # Mintgrün-Hell
}
```

---

## Verwendung im Code
```python
# Palette laden und verwenden:
fig = plt.figure(figsize=(11, 15), facecolor=PALETTE['bg'])
ax.set_facecolor(PALETTE['card'])
ax.text(0.5, 0.9, 'Titel', color=PALETTE['text'], ...)
ax.barh(y, width, color=PALETTE['accent1'], ...)

# Rahmen/Borders:
rect = FancyBboxPatch(..., edgecolor=PALETTE['border'], facecolor=PALETTE['card'])

# Dunklen Text immer auf hellem Hintergrund:
# PALETTE['text'] auf PALETTE['bg'] oder PALETTE['card']
# Nie: heller Text auf hellem Grund
```

## Zielgruppen-Empfehlung

| Zielgruppe             | Empfohlene Palette   |
|------------------------|----------------------|
| Projektmanager / PMO   | Corporate Blue       |
| Software-Entwickler    | Tech Professional    |
| Business Analysten     | Analytics & Data     |
| C-Level / Executive    | Enterprise Slate     |
| Agile Teams / Scrum    | Agile & Modern       |
| Gemischtes Publikum    | Enterprise Slate     |
