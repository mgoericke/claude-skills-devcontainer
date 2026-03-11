---
name: html-skill
description: Creates simple HTML pages with Tailwind CSS (CDN). Use for "create an HTML page", "simple website", "landing page", or "static page".
argument-hint: "[description]"
---

# HTML Skill

Creates simple, responsive HTML pages with **Tailwind CSS** via CDN link.
No build tool, no npm, no Node – just an HTML file.

> **Philosophy:** Not every interface needs a framework.
> Sometimes a well-designed HTML page is enough.

---

## When to Use This Skill

- A simple HTML page should be created (landing page, admin UI, dashboard, form)
- A static page without JavaScript framework is needed
- Phrases like "create an HTML page", "simple website", "landing page", "build me a form", "static page"
- **Do not use** for single page applications (SPAs) or complex frontend applications

## What This Skill Does

1. **Asks for page purpose** – What should the page show? (Landing page, form, dashboard, etc.)
2. **Generates HTML** – Responsive, semantically correct, styled with Tailwind CSS
3. **Saves the file** – In the project or at a desired path

## How to Use

```
Create a simple landing page for my project
```

```
/html-skill Contact form with name, email, and message
```

```
Build me a dashboard with KPI tiles
```

---

## Instructions

### Step 1 – Clarify purpose and content

| # | Question | Hint |
|---|----------|------|
| 1 | **What should the page show?** | Landing page, form, dashboard, table, etc. |
| 2 | **What content?** | Texts, fields, table data, KPIs |
| 3 | **Where to save?** | Default: project root. Alternative: `src/main/resources/static/` for Spring Boot, `src/main/resources/META-INF/resources/` for Quarkus |

If `$ARGUMENTS` was provided, derive purpose and content from it and only ask follow-up questions if necessary.

### Step 2 – Generate HTML

Every generated HTML page follows this skeleton:

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
    <!-- Content here -->
</body>
</html>
```

**Style rules:**

- **Tailwind CSS via CDN** – no local build, no npm
- **Responsive** – Mobile-first with `sm:`, `md:`, `lg:` breakpoints
- **Semantic HTML** – `<header>`, `<main>`, `<footer>`, `<nav>`, `<section>`
- **Accessibility** – `alt` attributes, `aria-label` where meaningful, sufficient contrast
- **No JavaScript** except Tailwind CDN – unless the user explicitly asks for it
- **Dark Mode** – Optional via `class="dark"` and `dark:` prefix (only on request)

**Tailwind class guidelines:**

- Container: `max-w-4xl mx-auto px-4 py-8`
- Cards: `bg-white rounded-lg shadow-md p-6`
- Buttons: `bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg`
- Forms: `border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent`
- Tables: `w-full border-collapse` with `divide-y divide-gray-200`
- Typography: `text-3xl font-bold` for H1, `text-xl font-semibold` for H2

### Step 3 – Save

Derive filename from the page purpose (kebab-case):

```
landing-page.html
contact-form.html
dashboard.html
```

Storage location depending on context:
- **Standalone**: Project root
- **Spring Boot**: `src/main/resources/static/`
- **Quarkus**: `src/main/resources/META-INF/resources/`

---

## Additional resources

- Tailwind CSS documentation: https://tailwindcss.com/docs
- Tailwind CDN: https://cdn.tailwindcss.com (Play CDN – for prototypes and simple pages)

---

## Conventions

- **HTML language**: `lang="en"` (default) or `lang="de"` depending on context
- **Styling**: Exclusively Tailwind CSS utility classes – no custom CSS
- **JavaScript**: Only if explicitly requested – default is pure HTML
- **Images**: Placeholders with `https://placehold.co/` or SVG icons
- **Co-Author**: `<!-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via html-skill -->`
