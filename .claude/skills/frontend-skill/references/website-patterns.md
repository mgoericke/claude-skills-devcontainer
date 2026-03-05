# Website Patterns (Tailwind CSS)

Referenz-Patterns für den Website-Modus des frontend-skill.
Basiert auf Tailwind CSS Showcase: https://tailwindcss.com/showcase

---

## Sektions-Patterns

### Hero Section

**Variante 1: Zentriert mit CTA**

```html
<header class="relative overflow-hidden">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24 sm:py-32 text-center">
        <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tight text-gray-900">
            Dein Produkt.<br>
            <span class="text-blue-600">Einfach besser.</span>
        </h1>
        <p class="mt-6 max-w-2xl mx-auto text-lg text-gray-600">
            Eine kurze, überzeugende Beschreibung des Produkts oder der Dienstleistung.
        </p>
        <div class="mt-10 flex flex-col sm:flex-row gap-4 justify-center">
            <a href="#" class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition">
                Jetzt starten
            </a>
            <a href="#" class="rounded-lg border border-gray-300 px-6 py-3 text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                Mehr erfahren
            </a>
        </div>
    </div>
</header>
```

**Variante 2: Split mit Bild**

```html
<header class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <div class="grid lg:grid-cols-2 gap-12 items-center">
        <div>
            <h1 class="text-4xl sm:text-5xl font-bold tracking-tight text-gray-900">
                Die moderne Lösung für dein Business
            </h1>
            <p class="mt-6 text-lg text-gray-600">
                Beschreibung des Wertangebots in 2-3 Sätzen.
            </p>
            <div class="mt-8 flex gap-4">
                <a href="#" class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition">
                    Kostenlos testen
                </a>
            </div>
        </div>
        <div class="relative">
            <img src="https://placehold.co/600x400" alt="Produktbild" class="rounded-2xl shadow-2xl">
        </div>
    </div>
</header>
```

### Features Grid

**3-Spalten mit Icons**

```html
<section id="features" class="py-20 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
            <h2 class="text-3xl font-bold text-gray-900">Alles was du brauchst</h2>
            <p class="mt-4 text-lg text-gray-600 max-w-2xl mx-auto">
                Unsere Features im Überblick
            </p>
        </div>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Feature Card -->
            <div class="bg-white rounded-xl p-8 shadow-sm hover:shadow-md transition">
                <div class="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100 text-blue-600">
                    <!-- SVG Icon -->
                </div>
                <h3 class="mt-6 text-lg font-semibold text-gray-900">Feature-Name</h3>
                <p class="mt-2 text-gray-600">
                    Kurze Beschreibung des Features und seines Nutzens.
                </p>
            </div>
            <!-- Weitere Feature Cards -->
        </div>
    </div>
</section>
```

### Testimonials

**Kartenbasiert**

```html
<section class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-center text-gray-900 mb-16">Was unsere Kunden sagen</h2>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Testimonial Card -->
            <div class="bg-white rounded-xl p-8 shadow-sm border">
                <div class="flex gap-1 text-yellow-400 mb-4">
                    ★★★★★
                </div>
                <p class="text-gray-600 italic">
                    "Zitat des Kunden über die positive Erfahrung mit dem Produkt oder der Dienstleistung."
                </p>
                <div class="mt-6 flex items-center gap-3">
                    <img src="https://placehold.co/40x40" alt="Avatar" class="h-10 w-10 rounded-full">
                    <div>
                        <p class="text-sm font-semibold text-gray-900">Anna Schmidt</p>
                        <p class="text-sm text-gray-500">CEO, Firma GmbH</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
```

### Pricing

**3-Spalten mit Highlight**

```html
<section id="pricing" class="py-20 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
            <h2 class="text-3xl font-bold text-gray-900">Einfache, transparente Preise</h2>
            <p class="mt-4 text-lg text-gray-600">Wähle den Plan, der zu dir passt</p>
        </div>
        <div class="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            <!-- Basic -->
            <div class="bg-white rounded-xl p-8 shadow-sm border">
                <h3 class="text-lg font-semibold text-gray-900">Basic</h3>
                <p class="mt-2 text-sm text-gray-500">Für Einzelpersonen</p>
                <div class="mt-6">
                    <span class="text-4xl font-bold">€9</span>
                    <span class="text-gray-500">/Monat</span>
                </div>
                <ul class="mt-8 space-y-3">
                    <li class="flex items-center gap-2 text-sm text-gray-600">
                        <svg class="h-5 w-5 text-green-500">...</svg> Feature 1
                    </li>
                    <li class="flex items-center gap-2 text-sm text-gray-600">
                        <svg class="h-5 w-5 text-green-500">...</svg> Feature 2
                    </li>
                </ul>
                <a href="#" class="mt-8 block rounded-lg border border-gray-300 py-2.5 text-center text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                    Auswählen
                </a>
            </div>

            <!-- Pro (Highlighted) -->
            <div class="bg-blue-600 rounded-xl p-8 shadow-lg text-white relative">
                <span class="absolute -top-3 left-1/2 -translate-x-1/2 rounded-full bg-yellow-400 px-3 py-0.5 text-xs font-semibold text-gray-900">
                    Beliebt
                </span>
                <h3 class="text-lg font-semibold">Pro</h3>
                <p class="mt-2 text-sm text-blue-200">Für Teams</p>
                <div class="mt-6">
                    <span class="text-4xl font-bold">€29</span>
                    <span class="text-blue-200">/Monat</span>
                </div>
                <ul class="mt-8 space-y-3">
                    <li class="flex items-center gap-2 text-sm">
                        <svg class="h-5 w-5 text-blue-200">...</svg> Alles aus Basic
                    </li>
                    <li class="flex items-center gap-2 text-sm">
                        <svg class="h-5 w-5 text-blue-200">...</svg> Feature 3
                    </li>
                </ul>
                <a href="#" class="mt-8 block rounded-lg bg-white py-2.5 text-center text-sm font-medium text-blue-600 hover:bg-blue-50 transition">
                    Auswählen
                </a>
            </div>

            <!-- Enterprise -->
            <div class="bg-white rounded-xl p-8 shadow-sm border">
                <h3 class="text-lg font-semibold text-gray-900">Enterprise</h3>
                <p class="mt-2 text-sm text-gray-500">Für Unternehmen</p>
                <div class="mt-6">
                    <span class="text-4xl font-bold">€99</span>
                    <span class="text-gray-500">/Monat</span>
                </div>
                <ul class="mt-8 space-y-3">
                    <li class="flex items-center gap-2 text-sm text-gray-600">
                        <svg class="h-5 w-5 text-green-500">...</svg> Alles aus Pro
                    </li>
                    <li class="flex items-center gap-2 text-sm text-gray-600">
                        <svg class="h-5 w-5 text-green-500">...</svg> Feature 4
                    </li>
                </ul>
                <a href="#" class="mt-8 block rounded-lg border border-gray-300 py-2.5 text-center text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                    Kontaktieren
                </a>
            </div>
        </div>
    </div>
</section>
```

### CTA Banner

```html
<section class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="rounded-2xl bg-blue-600 px-8 py-16 text-center text-white">
            <h2 class="text-3xl font-bold">Bereit loszulegen?</h2>
            <p class="mt-4 text-lg text-blue-100 max-w-xl mx-auto">
                Starte noch heute und überzeuge dich selbst.
            </p>
            <a href="#" class="mt-8 inline-block rounded-lg bg-white px-8 py-3 text-sm font-medium text-blue-600 hover:bg-blue-50 transition">
                Jetzt kostenlos testen
            </a>
        </div>
    </div>
</section>
```

### FAQ (Accordion)

```html
<section class="py-20 bg-gray-50">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-center text-gray-900 mb-12">Häufige Fragen</h2>
        <div class="space-y-4" x-data="{ active: null }">
            <!-- FAQ Item -->
            <div class="rounded-xl bg-white shadow-sm">
                <button @click="active = active === 1 ? null : 1"
                        class="flex w-full items-center justify-between px-6 py-4 text-left">
                    <span class="text-sm font-semibold text-gray-900">Wie funktioniert die kostenlose Testphase?</span>
                    <svg :class="active === 1 ? 'rotate-180' : ''" class="h-5 w-5 text-gray-400 transition-transform">...</svg>
                </button>
                <div x-show="active === 1" x-collapse class="px-6 pb-4">
                    <p class="text-sm text-gray-600">Antwort auf die Frage...</p>
                </div>
            </div>
        </div>
    </div>
</section>
```

**Hinweis:** FAQ mit Alpine.js benötigt `<script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>` im `<head>`.

### Stats

```html
<section class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-8 text-center">
            <div>
                <p class="text-4xl font-bold text-blue-600">10.000+</p>
                <p class="mt-2 text-sm text-gray-600">Zufriedene Kunden</p>
            </div>
            <div>
                <p class="text-4xl font-bold text-blue-600">99,9%</p>
                <p class="mt-2 text-sm text-gray-600">Uptime</p>
            </div>
            <div>
                <p class="text-4xl font-bold text-blue-600">50+</p>
                <p class="mt-2 text-sm text-gray-600">Integrationen</p>
            </div>
            <div>
                <p class="text-4xl font-bold text-blue-600">24/7</p>
                <p class="mt-2 text-sm text-gray-600">Support</p>
            </div>
        </div>
    </div>
</section>
```

### Team

```html
<section class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-center text-gray-900 mb-16">Unser Team</h2>
        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
            <div class="text-center">
                <img src="https://placehold.co/200x200" alt="Teamfoto" class="mx-auto h-32 w-32 rounded-full object-cover">
                <h3 class="mt-4 text-lg font-semibold text-gray-900">Anna Schmidt</h3>
                <p class="text-sm text-gray-500">CEO & Gründerin</p>
            </div>
        </div>
    </div>
</section>
```

### Footer

```html
<footer class="bg-gray-900 text-gray-400">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid md:grid-cols-4 gap-8">
            <!-- Brand -->
            <div>
                <span class="text-xl font-bold text-white">Logo</span>
                <p class="mt-4 text-sm">Kurze Beschreibung des Unternehmens oder Produkts.</p>
            </div>
            <!-- Links -->
            <div>
                <h4 class="text-sm font-semibold text-white uppercase tracking-wider">Produkt</h4>
                <ul class="mt-4 space-y-2">
                    <li><a href="#" class="text-sm hover:text-white transition">Features</a></li>
                    <li><a href="#" class="text-sm hover:text-white transition">Preise</a></li>
                </ul>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-white uppercase tracking-wider">Unternehmen</h4>
                <ul class="mt-4 space-y-2">
                    <li><a href="#" class="text-sm hover:text-white transition">Über uns</a></li>
                    <li><a href="#" class="text-sm hover:text-white transition">Kontakt</a></li>
                </ul>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-white uppercase tracking-wider">Rechtliches</h4>
                <ul class="mt-4 space-y-2">
                    <li><a href="#" class="text-sm hover:text-white transition">Impressum</a></li>
                    <li><a href="#" class="text-sm hover:text-white transition">Datenschutz</a></li>
                </ul>
            </div>
        </div>
        <div class="mt-12 border-t border-gray-800 pt-8 text-center text-sm">
            &copy; 2026 Firmenname. Alle Rechte vorbehalten.
        </div>
    </div>
</footer>
```

### Navigation (Fixed)

```html
<nav class="fixed top-0 w-full bg-white/80 backdrop-blur-md shadow-sm z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <a href="#" class="text-xl font-bold text-gray-900">Logo</a>

            <!-- Desktop Navigation -->
            <div class="hidden md:flex items-center space-x-8">
                <a href="#features" class="text-sm text-gray-600 hover:text-gray-900 transition">Features</a>
                <a href="#pricing" class="text-sm text-gray-600 hover:text-gray-900 transition">Preise</a>
                <a href="#contact" class="text-sm text-gray-600 hover:text-gray-900 transition">Kontakt</a>
                <a href="#" class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition">
                    Starten
                </a>
            </div>

            <!-- Mobile Menu Button -->
            <button class="md:hidden" x-data @click="$dispatch('toggle-menu')">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                </svg>
            </button>
        </div>
    </div>
</nav>
```

---

## Page-Pattern-Vorlagen

### SaaS Landing Page (inspiriert von Salient)

Sektionsreihenfolge:
1. Navigation (fixed, transparent → solid on scroll)
2. Hero (zentriert, großer Titel + CTA)
3. Logos/Trust-Bar (Kundenlogos)
4. Features Grid (3 Spalten)
5. Feature Highlight (Split: Text + Screenshot)
6. Stats
7. Testimonials
8. Pricing (3 Spalten)
9. CTA Banner
10. Footer

### Portfolio (inspiriert von Spotlight)

Sektionsreihenfolge:
1. Navigation (minimal)
2. Hero (Split: Foto + Intro-Text)
3. Über mich
4. Projekte-Grid (Karten mit Bild + Beschreibung)
5. Skills/Technologien
6. Kontakt-Formular
7. Footer (minimal)

### Event/Konferenz (inspiriert von Keynote)

Sektionsreihenfolge:
1. Navigation
2. Hero (Großes Hintergrundbild + Event-Name + Datum)
3. Speaker-Grid
4. Programm/Schedule (Timeline)
5. Venue/Location (Map-Platzhalter)
6. Sponsoren-Logos
7. Ticket-CTA
8. Footer

### Podcast/Media (inspiriert von Transmit)

Sektionsreihenfolge:
1. Navigation
2. Hero (Cover-Art + Titel + Abonnieren-Buttons)
3. Letzte Episoden (Liste)
4. Über den Podcast
5. Host-Vorstellung
6. Plattform-Links
7. Footer

### Mobile App Promo (inspiriert von Pocket)

Sektionsreihenfolge:
1. Navigation
2. Hero (Phone-Mockup + App-Beschreibung + Store-Badges)
3. Features (alternierend: Screenshot links/rechts + Text)
4. Stats/Social Proof
5. Download-CTA
6. Footer
