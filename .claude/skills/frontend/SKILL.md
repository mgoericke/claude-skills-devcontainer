---
name: frontend
description: Creates modern web UIs with Tailwind CSS. Three modes – Simple HTML pages (no JS), Dashboards/Admin Panels with TailAdmin (Alpine.js + ApexCharts), and Websites/Landing Pages with Tailwind CSS CDN. Use this skill for "create a dashboard", "landing page", "admin UI", "frontend", "website", "build a UI", "portfolio page", "create an HTML page", "simple website", "static page", "build me a form" or when a responsive HTML page with Tailwind CSS is needed. Do not use for complex SPAs with React/Vue/Angular.
argument-hint: "[description]"
---

# Frontend Skill

Creates modern, responsive web UIs with **Tailwind CSS**.

> **Philosophy:** Three modes for different requirements:
> **Simple** → Pure HTML + Tailwind CSS CDN (no JavaScript, no build tool)
> **Dashboard** → TailAdmin (HTML + Tailwind CSS + Alpine.js)
> **Website** → Tailwind CSS CDN (no build tool, optional JS)

---

## What This Skill Does

1. **Asks for the mode** – Simple HTML, Dashboard/Admin UI, or Website/Landing Page
2. **Generates HTML** – Responsive, semantically correct, styled with Tailwind CSS
3. **Adds interactivity** – Alpine.js for dashboards, optional for websites, none for simple
4. **Saves the files** – In the project or at a desired path

## How to Use

```
Create a simple contact form
```

```
Create a dashboard for order overview
```

```
/frontend Admin panel with KPI cards and table
```

```
Create a landing page for my SaaS product
```

```
Build me a portfolio page
```

---

## Instructions

### Step 1 – Ask for mode

The three modes use different technology stacks and layouts. Clarify the mode beforehand to use the right stack:

| Mode | When to use | Technology |
|------|-------------|------------|
| **Simple** | Simple HTML pages, forms, static content, quick prototypes | HTML + Tailwind CSS CDN (no JavaScript) |
| **Dashboard** | Admin panels, dashboards, data-rich UIs, tables, charts | TailAdmin + Alpine.js + ApexCharts |
| **Website** | Landing pages, marketing pages, portfolios, SaaS pages | Tailwind CSS CDN (optional JS) |

If `$ARGUMENTS` clearly indicate the mode (e.g. "Dashboard", "Admin", "simple form", "landing page"), start directly.
Otherwise ask.

---

## Simple Mode (Pure HTML)

For simple, static pages without JavaScript. Perfect for forms, simple dashboards, admin UIs, and quick prototypes.

> **Philosophy:** Not every interface needs a framework.
> Sometimes a well-designed HTML page is enough.

### Simple Skeleton

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-900">
    <!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via frontend -->
    <!-- Content here -->
</body>
</html>
```

### Simple Style Rules

- **Tailwind CSS via CDN** – no local build, no npm
- **No JavaScript** – unless the user explicitly asks for it
- **Semantic HTML** – `<header>`, `<main>`, `<footer>`, `<nav>`, `<section>`
- **Responsive** – Mobile-first with `sm:`, `md:`, `lg:` breakpoints
- **Accessibility** – `alt` attributes, `aria-label` where meaningful, sufficient contrast

### Simple Tailwind Class Guidelines

| Element | Classes |
|---------|---------|
| Container | `max-w-4xl mx-auto px-4 py-8` |
| Cards | `bg-white rounded-lg shadow-md p-6` |
| Buttons | `bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg` |
| Forms | `border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent` |
| Tables | `w-full border-collapse` with `divide-y divide-gray-200` |
| H1 | `text-3xl font-bold` |
| H2 | `text-xl font-semibold` |

---

## Dashboard Mode (TailAdmin)

### Reference

- **Demo:** https://demo.tailadmin.com/
- **License:** MIT (Open Source, Free Edition)
- **Technology:** HTML + Tailwind CSS + Alpine.js + ApexCharts

### Available Dashboard Variants

| Variant | URL | Use Case |
|---------|-----|----------|
| eCommerce | https://demo.tailadmin.com/ | Shop overview, revenue, orders |
| Analytics | https://demo.tailadmin.com/analytics | Traffic, conversions, metrics |
| Marketing | https://demo.tailadmin.com/marketing | Campaigns, reach, ROI |
| CRM | https://demo.tailadmin.com/crm | Contacts, deals, pipeline |
| Stocks | https://demo.tailadmin.com/stocks | Financial data, prices, portfolio |

### Dashboard Skeleton

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
</head>
<body class="bg-gray-100 text-gray-900" x-data="dashboardData()">
    <!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via frontend -->

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

### Dashboard Components

Detailed patterns → [references/dashboard-patterns.md](references/dashboard-patterns.md)

| Component | Description |
|-----------|-------------|
| **KPI Cards** | Metric + trend indicator (↑/↓) + sparkline |
| **Charts** | Line, Bar, Area, Donut via ApexCharts |
| **Sidebar** | Fixed navigation on left, collapsible, with icons |
| **Tables** | Sortable, with pagination and search field |
| **Forms** | Input groups, selects, toggles, date picker |
| **Modals** | Overlay dialogs for details/editing |
| **Alerts** | Toast notifications, status banners |

### Alpine.js Interactions

Alpine.js is used for all interactive elements:

```html
<!-- Toggle Sidebar -->
<button @click="sidebarOpen = !sidebarOpen">Menu</button>

<!-- Tabs -->
<div x-data="{ activeTab: 'overview' }">
    <button @click="activeTab = 'overview'" :class="activeTab === 'overview' ? 'border-blue-500' : ''">Overview</button>
    <div x-show="activeTab === 'overview'">...</div>
</div>

<!-- Dropdown -->
<div x-data="{ open: false }">
    <button @click="open = !open">Options</button>
    <div x-show="open" @click.away="open = false">...</div>
</div>
```

---

## Website Mode (Tailwind CSS)

### Reference

- **Showcase:** https://tailwindcss.com/showcase
- **Technology:** HTML + Tailwind CSS CDN (no build tool, no npm)

### Proven Patterns (inspired by Tailwind Showcase)

| Pattern | Inspired by | Use Case |
|---------|-------------|----------|
| **SaaS Landing Page** | Salient | Software products, B2B |
| **Portfolio** | Spotlight | Personal pages, freelancers |
| **Conference/Event** | Keynote | Events, meetups |
| **Podcast/Media** | Transmit | Audio, video, content |
| **Mobile App Promo** | Pocket | App download pages |

### Website Skeleton

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-white text-gray-900">
    <!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via frontend -->

    <!-- Navigation -->
    <nav class="fixed top-0 w-full bg-white/80 backdrop-blur-md shadow-sm z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
            <a href="#" class="text-xl font-bold">Logo</a>
            <div class="hidden md:flex space-x-8">
                <a href="#features" class="text-gray-600 hover:text-gray-900">Features</a>
                <a href="#pricing" class="text-gray-600 hover:text-gray-900">Pricing</a>
                <a href="#contact" class="text-gray-600 hover:text-gray-900">Contact</a>
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

### Available Sections

Detailed patterns → [references/website-patterns.md](references/website-patterns.md)

| Section | Description |
|---------|-------------|
| **Hero** | Large title + subtitle + CTA button, optionally with image/video |
| **Features Grid** | 3-4 columns with icons and descriptions |
| **Testimonials** | Customer quotes with avatar and name |
| **Pricing** | Pricing tables with highlight for recommended plan |
| **CTA** | Call-to-action banner with button |
| **FAQ** | Accordion with frequently asked questions |
| **Team** | Team introduction with photos and roles |
| **Stats** | Key figures in large font (e.g. "10,000+ Customers") |
| **Footer** | Links, social media, copyright |

---

## Common Conventions

### Style Rules

- **Responsive** – Mobile-first with `sm:`, `md:`, `lg:` breakpoints
- **Semantic HTML** – `<header>`, `<main>`, `<footer>`, `<nav>`, `<section>`
- **Accessibility** – `alt` attributes, `aria-label` where meaningful, sufficient contrast
- **Dark Mode** – Optional via `class="dark"` and `dark:` prefix (only on request)
- **No custom CSS** – Exclusively Tailwind utility classes

### Tailwind Class Guidelines

| Element | Classes |
|---------|---------|
| Container | `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8` |
| Cards | `bg-white rounded-xl shadow-md p-6` |
| Buttons (primary) | `bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-5 rounded-lg transition` |
| Buttons (secondary) | `border border-gray-300 text-gray-700 hover:bg-gray-50 font-medium py-2.5 px-5 rounded-lg transition` |
| Inputs | `border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent w-full` |
| Tables | `w-full border-collapse divide-y divide-gray-200` |
| H1 | `text-4xl sm:text-5xl font-bold tracking-tight` |
| H2 | `text-2xl sm:text-3xl font-semibold` |

### Storage Location

Derive filename from the page purpose (kebab-case):

```
dashboard.html
landing-page.html
admin-panel.html
portfolio.html
```

Storage location depending on context:
- **Standalone**: Project root
- **Spring Boot**: `src/main/resources/static/`
- **Quarkus**: `src/main/resources/META-INF/resources/`

### Images

- Placeholders with `https://placehold.co/` or inline SVG icons
- For icons: Heroicons as inline SVG (https://heroicons.com)

### Co-Author

```html
<!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via frontend -->
```

---

## Additional Resources

- Tailwind CSS Docs: https://tailwindcss.com/docs
- Tailwind CDN: https://cdn.tailwindcss.com
- TailAdmin Demo: https://demo.tailadmin.com/
- Alpine.js Docs: https://alpinejs.dev/
- ApexCharts Docs: https://apexcharts.com/
- Heroicons: https://heroicons.com/
