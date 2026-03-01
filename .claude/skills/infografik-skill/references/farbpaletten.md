# Farbpaletten für Infografiken

Lade diese Datei wenn der Nutzer ein bestimmtes Theme wählt oder du Farben für eine Infografik brauchst.

---

## 🌑 Dark Tech (Standard)
Professionell, modern – gut für KI, Software, Statistik-Themen.
```python
PALETTE = {
    'bg':      '#0F172A',  # Hintergrund
    'card':    '#1E293B',  # Karten
    'accent1': '#38BDF8',  # Hellblau (Primär)
    'accent2': '#818CF8',  # Indigo
    'accent3': '#34D399',  # Grün
    'accent4': '#FB923C',  # Orange
    'text':    '#F1F5F9',  # Weiß
    'muted':   '#94A3B8',  # Grau
}
```

---

## ☀️ Light Clean
Sauber, lesefreundlich – gut für Reports, Behörden, Gesundheit.
```python
PALETTE = {
    'bg':      '#FFFFFF',
    'card':    '#F8FAFC',
    'accent1': '#2563EB',  # Blau
    'accent2': '#7C3AED',  # Violett
    'accent3': '#059669',  # Grün
    'accent4': '#D97706',  # Amber
    'text':    '#0F172A',
    'muted':   '#64748B',
}
```

---

## 🇩🇪 Behörden / Public Sector
Seriös, zugänglich – gut für Bürgerservices, Verwaltung, Dokumentation.
```python
PALETTE = {
    'bg':      '#F5F5F5',
    'card':    '#FFFFFF',
    'accent1': '#003399',  # EU-Blau
    'accent2': '#CC0000',  # Akzent-Rot
    'accent3': '#006600',  # Grün
    'accent4': '#FF8800',  # Orange
    'text':    '#1A1A1A',
    'muted':   '#666666',
}
```

---

## 🌿 Nature & Nachhaltigkeit
Organisch, warm – gut für Umwelt, ESG, Landwirtschaft.
```python
PALETTE = {
    'bg':      '#FAFAF7',
    'card':    '#F0F4EC',
    'accent1': '#2D6A4F',  # Dunkelgrün
    'accent2': '#74C69D',  # Mintgrün
    'accent3': '#B7E4C7',  # Hellgrün
    'accent4': '#D4A017',  # Ocker
    'text':    '#1B2617',
    'muted':   '#6B7F64',
}
```

---

## 🔥 High Impact
Mutig, auffällig – gut für Marketing, Präsentationen, Events.
```python
PALETTE = {
    'bg':      '#0A0A0A',
    'card':    '#1A1A1A',
    'accent1': '#FF2D55',  # Hot Pink
    'accent2': '#FF9500',  # Orange
    'accent3': '#00E5FF',  # Cyan
    'accent4': '#A8FF3E',  # Neon Grün
    'text':    '#FFFFFF',
    'muted':   '#888888',
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
```
