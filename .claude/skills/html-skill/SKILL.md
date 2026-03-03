---
name: html-skill
description: Erstellt einfache HTML-Seiten mit Tailwind CSS (CDN). Verwende bei "erstelle eine HTML-Seite", "einfache Webseite", "Landing Page" oder "statische Seite".
argument-hint: "[beschreibung]"
---

# HTML Skill

Erstellt einfache, responsive HTML-Seiten mit **Tailwind CSS** via CDN-Link.
Kein Build-Tool, kein npm, kein Node – nur eine HTML-Datei.

> **Philosophie:** Nicht jede Oberfläche braucht ein Framework.
> Manchmal reicht eine gut gestaltete HTML-Seite.

---

## When to Use This Skill

- Eine einfache HTML-Seite soll erstellt werden (Landing Page, Admin-UI, Dashboard, Formular)
- Eine statische Seite ohne JavaScript-Framework wird benötigt
- Formulierungen wie "erstelle eine HTML-Seite", "einfache Webseite", "Landing Page", "baue mir ein Formular", "statische Seite"
- **Nicht verwenden** für Single Page Applications (SPAs) oder komplexe Frontend-Anwendungen

## What This Skill Does

1. **Fragt Seitenzweck ab** – Was soll die Seite zeigen? (Landing Page, Formular, Dashboard, etc.)
2. **Generiert HTML** – Responsive, semantisch korrekt, mit Tailwind CSS gestylt
3. **Speichert die Datei** – Im Projekt oder an einem gewünschten Pfad

## How to Use

```
Erstelle eine einfache Landing Page für mein Projekt
```

```
/html-skill Kontaktformular mit Name, E-Mail und Nachricht
```

```
Baue mir ein Dashboard mit KPI-Kacheln
```

---

## Instructions

### Schritt 1 – Zweck und Inhalt klären

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **Was soll die Seite zeigen?** | Landing Page, Formular, Dashboard, Tabelle, etc. |
| 2 | **Welche Inhalte?** | Texte, Felder, Tabellendaten, KPIs |
| 3 | **Wo speichern?** | Standard: Projekt-Root. Alternative: `src/main/resources/static/` für Spring Boot, `src/main/resources/META-INF/resources/` für Quarkus |

Wenn `$ARGUMENTS` übergeben wurde, daraus Zweck und Inhalt ableiten und nur Rückfragen stellen wenn nötig.

### Schritt 2 – HTML generieren

Jede generierte HTML-Seite folgt diesem Grundgerüst:

```html
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-900">
    <!-- Inhalt hier -->
</body>
</html>
```

**Stilregeln:**

- **Tailwind CSS via CDN** – kein lokales Build, kein npm
- **Responsive** – Mobile-first mit `sm:`, `md:`, `lg:` Breakpoints
- **Semantisches HTML** – `<header>`, `<main>`, `<footer>`, `<nav>`, `<section>`
- **Barrierefreiheit** – `alt`-Attribute, `aria-label` wo sinnvoll, ausreichender Kontrast
- **Kein JavaScript** außer Tailwind CDN – es sei denn der User fragt explizit danach
- **Dark Mode** – Optional via `class="dark"` und `dark:` Prefix (nur auf Wunsch)

**Tailwind-Klassen-Richtlinien:**

- Container: `max-w-4xl mx-auto px-4 py-8`
- Karten: `bg-white rounded-lg shadow-md p-6`
- Buttons: `bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg`
- Formulare: `border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent`
- Tabellen: `w-full border-collapse` mit `divide-y divide-gray-200`
- Typografie: `text-3xl font-bold` für H1, `text-xl font-semibold` für H2

### Schritt 3 – Speichern

Dateiname aus dem Seitenzweck ableiten (kebab-case):

```
landing-page.html
kontakt-formular.html
dashboard.html
```

Speicherort je nach Kontext:
- **Standalone**: Projekt-Root
- **Spring Boot**: `src/main/resources/static/`
- **Quarkus**: `src/main/resources/META-INF/resources/`

---

## Additional resources

- Tailwind CSS Dokumentation: https://tailwindcss.com/docs
- Tailwind CDN: https://cdn.tailwindcss.com (Play CDN – für Prototypen und einfache Seiten)

---

## Conventions

- **Sprache HTML**: `lang="de"` (default) oder `lang="en"` je nach Kontext
- **Styling**: Ausschließlich Tailwind CSS Utility-Klassen – kein eigenes CSS
- **JavaScript**: Nur wenn explizit gewünscht – Standard ist reines HTML
- **Bilder**: Platzhalter mit `https://placehold.co/` oder SVG-Icons
- **Co-Author**: `<!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via html-skill -->`
