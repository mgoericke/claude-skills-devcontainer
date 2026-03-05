---
name: frontend-skill
description: Erstellt moderne Web-UIs mit Tailwind CSS. Dashboards mit TailAdmin, Landing Pages und SPAs mit Tailwind CSS CDN. Verwende bei "erstelle ein Dashboard", "Landing Page", "Admin-UI", "Frontend", "Webseite" oder "UI".
argument-hint: "[beschreibung]"
---

# Frontend Skill

Erstellt moderne, responsive Web-UIs mit **Tailwind CSS**.

> **Philosophie:** Zwei Modi für unterschiedliche Anforderungen:
> **Dashboard** → TailAdmin (HTML + Tailwind CSS + Alpine.js)
> **Website** → Tailwind CSS CDN (kein Build-Tool)

---

## When to Use This Skill

- Ein Dashboard, Admin-Panel oder datenreiche UI soll erstellt werden
- Eine Landing Page, SPA oder Marketing-Seite wird benötigt
- Formulierungen wie "erstelle ein Dashboard", "Admin-UI", "Landing Page", "Frontend", "Webseite", "UI bauen"
- **Nicht verwenden** für komplexe SPAs mit React/Vue/Angular – dafür eigenes Framework nutzen

## What This Skill Does

1. **Fragt den Modus ab** – Dashboard/Admin-UI oder Website/Landing Page
2. **Generiert HTML** – Responsive, semantisch korrekt, mit Tailwind CSS gestylt
3. **Fügt Interaktivität hinzu** – Alpine.js für Dashboards, optional für Websites
4. **Speichert die Dateien** – Im Projekt oder an einem gewünschten Pfad

## How to Use

```
Erstelle ein Dashboard für Bestellungsübersicht
```

```
/frontend-skill Admin-Panel mit KPI-Karten und Tabelle
```

```
Erstelle eine Landing Page für mein SaaS-Produkt
```

```
Baue mir eine Portfolio-Seite
```

---

## Instructions

### Schritt 1 – Modus abfragen (PFLICHT)

Vor jeder Generierung den Modus klären:

| Modus | Wann verwenden | Technologie |
|-------|---------------|-------------|
| **Dashboard** | Admin-Panels, Dashboards, datenreiche UIs, Tabellen, Charts | TailAdmin + Alpine.js + ApexCharts |
| **Website** | Landing Pages, SPAs, Marketing-Seiten, Portfolios | Tailwind CSS CDN |

Wenn `$ARGUMENTS` den Modus eindeutig erkennen lassen (z.B. "Dashboard", "Admin"), direkt starten.
Sonst nachfragen.

---

## Dashboard-Modus (TailAdmin)

### Referenz

- **Demo:** https://demo.tailadmin.com/
- **Lizenz:** MIT (Open Source, Free Edition)
- **Technologie:** HTML + Tailwind CSS + Alpine.js + ApexCharts

### Verfügbare Dashboard-Varianten

| Variante | URL | Einsatz |
|----------|-----|---------|
| eCommerce | https://demo.tailadmin.com/ | Shop-Übersicht, Umsatz, Bestellungen |
| Analytics | https://demo.tailadmin.com/analytics | Traffic, Conversions, Metriken |
| Marketing | https://demo.tailadmin.com/marketing | Kampagnen, Reichweite, ROI |
| CRM | https://demo.tailadmin.com/crm | Kontakte, Deals, Pipeline |
| Stocks | https://demo.tailadmin.com/stocks | Finanzdaten, Kurse, Portfolio |

### Dashboard-Grundgerüst

```html
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
</head>
<body class="bg-gray-100 text-gray-900" x-data="dashboardData()">
    <!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill -->

    <!-- Sidebar -->
    <aside class="fixed left-0 top-0 z-50 flex h-screen w-64 flex-col bg-white shadow-lg">
        <!-- Navigation -->
    </aside>

    <!-- Main Content -->
    <main class="ml-64 p-6">
        <!-- Header -->
        <!-- KPI Cards -->
        <!-- Charts -->
        <!-- Tables -->
    </main>

    <script>
    function dashboardData() {
        return {
            sidebarOpen: true,
            // Dashboard state
        }
    }
    </script>
</body>
</html>
```

### Dashboard-Komponenten

Detaillierte Patterns → [references/dashboard-patterns.md](references/dashboard-patterns.md)

| Komponente | Beschreibung |
|-----------|-------------|
| **KPI-Karten** | Metrik + Trend-Indikator (↑/↓) + Sparkline |
| **Charts** | Line, Bar, Area, Donut via ApexCharts |
| **Sidebar** | Feste Navigation links, collapsible, mit Icons |
| **Tabellen** | Sortierbar, mit Pagination und Suchfeld |
| **Formulare** | Input-Gruppen, Selects, Toggles, Date Picker |
| **Modals** | Overlay-Dialoge für Details/Bearbeitung |
| **Alerts** | Toast-Benachrichtigungen, Status-Banner |

### Alpine.js Interaktionen

Alpine.js wird für alle interaktiven Elemente verwendet:

```html
<!-- Toggle Sidebar -->
<button @click="sidebarOpen = !sidebarOpen">Menu</button>

<!-- Tabs -->
<div x-data="{ activeTab: 'overview' }">
    <button @click="activeTab = 'overview'" :class="activeTab === 'overview' ? 'border-blue-500' : ''">Übersicht</button>
    <div x-show="activeTab === 'overview'">...</div>
</div>

<!-- Dropdown -->
<div x-data="{ open: false }">
    <button @click="open = !open">Optionen</button>
    <div x-show="open" @click.away="open = false">...</div>
</div>
```

---

## Website-Modus (Tailwind CSS)

### Referenz

- **Showcase:** https://tailwindcss.com/showcase
- **Technologie:** HTML + Tailwind CSS CDN (kein Build-Tool, kein npm)

### Bewährte Patterns (inspiriert von Tailwind Showcase)

| Pattern | Inspiriert von | Einsatz |
|---------|---------------|---------|
| **SaaS Landing Page** | Salient | Software-Produkte, B2B |
| **Portfolio** | Spotlight | Persönliche Seiten, Freelancer |
| **Konferenz/Event** | Keynote | Veranstaltungen, Meetups |
| **Podcast/Media** | Transmit | Audio, Video, Content |
| **Mobile App Promo** | Pocket | App-Download-Seiten |

### Website-Grundgerüst

```html
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-white text-gray-900">
    <!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill -->

    <!-- Navigation -->
    <nav class="fixed top-0 w-full bg-white/80 backdrop-blur-md shadow-sm z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
            <a href="#" class="text-xl font-bold">Logo</a>
            <div class="hidden md:flex space-x-8">
                <a href="#features" class="text-gray-600 hover:text-gray-900">Features</a>
                <a href="#pricing" class="text-gray-600 hover:text-gray-900">Preise</a>
                <a href="#contact" class="text-gray-600 hover:text-gray-900">Kontakt</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header>...</header>

    <!-- Features -->
    <section id="features">...</section>

    <!-- Pricing / CTA -->
    <section id="pricing">...</section>

    <!-- Footer -->
    <footer>...</footer>
</body>
</html>
```

### Verfügbare Sektionen

Detaillierte Patterns → [references/website-patterns.md](references/website-patterns.md)

| Sektion | Beschreibung |
|---------|-------------|
| **Hero** | Großer Titel + Subtitle + CTA-Button, optional mit Bild/Video |
| **Features-Grid** | 3-4 Spalten mit Icons und Beschreibungen |
| **Testimonials** | Kundenzitate mit Avatar und Name |
| **Pricing** | Preistabellen mit Highlight für empfohlenen Plan |
| **CTA** | Call-to-Action Banner mit Button |
| **FAQ** | Accordion mit häufigen Fragen |
| **Team** | Teamvorstellung mit Fotos und Rollen |
| **Stats** | Kennzahlen in großer Schrift (z.B. "10.000+ Kunden") |
| **Footer** | Links, Social Media, Copyright |

---

## Gemeinsame Konventionen

### Stilregeln

- **Responsive** – Mobile-first mit `sm:`, `md:`, `lg:` Breakpoints
- **Semantisches HTML** – `<header>`, `<main>`, `<footer>`, `<nav>`, `<section>`
- **Barrierefreiheit** – `alt`-Attribute, `aria-label` wo sinnvoll, ausreichender Kontrast
- **Dark Mode** – Optional via `class="dark"` und `dark:` Prefix (nur auf Wunsch)
- **Kein eigenes CSS** – Ausschließlich Tailwind Utility-Klassen

### Tailwind-Klassen-Richtlinien

| Element | Klassen |
|---------|---------|
| Container | `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8` |
| Karten | `bg-white rounded-xl shadow-md p-6` |
| Buttons (primary) | `bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-5 rounded-lg transition` |
| Buttons (secondary) | `border border-gray-300 text-gray-700 hover:bg-gray-50 font-medium py-2.5 px-5 rounded-lg transition` |
| Inputs | `border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent w-full` |
| Tabellen | `w-full border-collapse divide-y divide-gray-200` |
| H1 | `text-4xl sm:text-5xl font-bold tracking-tight` |
| H2 | `text-2xl sm:text-3xl font-semibold` |

### Speicherort

Dateiname aus dem Seitenzweck ableiten (kebab-case):

```
dashboard.html
landing-page.html
admin-panel.html
portfolio.html
```

Speicherort je nach Kontext:
- **Standalone**: Projekt-Root
- **Spring Boot**: `src/main/resources/static/`
- **Quarkus**: `src/main/resources/META-INF/resources/`

### Bilder

- Platzhalter mit `https://placehold.co/` oder inline SVG-Icons
- Für Icons: Heroicons als inline SVG (https://heroicons.com)

### Co-Author

```html
<!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill -->
```

---

## Additional Resources

- Tailwind CSS Docs: https://tailwindcss.com/docs
- Tailwind CDN: https://cdn.tailwindcss.com
- TailAdmin Demo: https://demo.tailadmin.com/
- Alpine.js Docs: https://alpinejs.dev/
- ApexCharts Docs: https://apexcharts.com/
- Heroicons: https://heroicons.com/
