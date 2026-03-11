# Website Patterns (Tailwind CSS)

Reference patterns for the website mode of the frontend-skill.
Based on Tailwind CSS Showcase: https://tailwindcss.com/showcase

---

## Section Patterns

### Hero Section

**Variant 1: Centered with CTA**

```html
<header class="relative overflow-hidden">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24 sm:py-32 text-center">
        <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tight text-gray-900">
            Your Product.<br>
            <span class="text-blue-600">Simply better.</span>
        </h1>
        <p class="mt-6 max-w-2xl mx-auto text-lg text-gray-600">
            A short, compelling description of the product or service.
        </p>
        <div class="mt-10 flex flex-col sm:flex-row gap-4 justify-center">
            <a href="#" class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition">
                Get Started
            </a>
            <a href="#" class="rounded-lg border border-gray-300 px-6 py-3 text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                Learn More
            </a>
        </div>
    </div>
</header>
```

**Variant 2: Split with Image**

```html
<header class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <div class="grid lg:grid-cols-2 gap-12 items-center">
        <div>
            <h1 class="text-4xl sm:text-5xl font-bold tracking-tight text-gray-900">
                The modern solution for your business
            </h1>
            <p class="mt-6 text-lg text-gray-600">
                Description of the value proposition in 2-3 sentences.
            </p>
            <div class="mt-8 flex gap-4">
                <a href="#" class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition">
                    Try for Free
                </a>
            </div>
        </div>
        <div class="relative">
            <img src="https://placehold.co/600x400" alt="Product image" class="rounded-2xl shadow-2xl">
        </div>
    </div>
</header>
```

### Features Grid

**3 Columns with Icons**

```html
<section id="features" class="py-20 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
            <h2 class="text-3xl font-bold text-gray-900">Everything you need</h2>
            <p class="mt-4 text-lg text-gray-600 max-w-2xl mx-auto">
                Our features at a glance
            </p>
        </div>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Feature Card -->
            <div class="bg-white rounded-xl p-8 shadow-sm hover:shadow-md transition">
                <div class="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100 text-blue-600">
                    <!-- SVG Icon -->
                </div>
                <h3 class="mt-6 text-lg font-semibold text-gray-900">Feature Name</h3>
                <p class="mt-2 text-gray-600">
                    Short description of the feature and its benefit.
                </p>
            </div>
            <!-- More Feature Cards -->
        </div>
    </div>
</section>
```

### Testimonials

**Card-based**

```html
<section class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-center text-gray-900 mb-16">What our customers say</h2>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Testimonial Card -->
            <div class="bg-white rounded-xl p-8 shadow-sm border">
                <div class="flex gap-1 text-yellow-400 mb-4">
                    ★★★★★
                </div>
                <p class="text-gray-600 italic">
                    "Customer quote about their positive experience with the product or service."
                </p>
                <div class="mt-6 flex items-center gap-3">
                    <img src="https://placehold.co/40x40" alt="Avatar" class="h-10 w-10 rounded-full">
                    <div>
                        <p class="text-sm font-semibold text-gray-900">Jane Smith</p>
                        <p class="text-sm text-gray-500">CEO, Company Inc.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
```

### Pricing

**3 Columns with Highlight**

```html
<section id="pricing" class="py-20 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
            <h2 class="text-3xl font-bold text-gray-900">Simple, transparent pricing</h2>
            <p class="mt-4 text-lg text-gray-600">Choose the plan that fits you</p>
        </div>
        <div class="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            <!-- Basic -->
            <div class="bg-white rounded-xl p-8 shadow-sm border">
                <h3 class="text-lg font-semibold text-gray-900">Basic</h3>
                <p class="mt-2 text-sm text-gray-500">For individuals</p>
                <div class="mt-6">
                    <span class="text-4xl font-bold">$9</span>
                    <span class="text-gray-500">/month</span>
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
                    Select
                </a>
            </div>

            <!-- Pro (Highlighted) -->
            <div class="bg-blue-600 rounded-xl p-8 shadow-lg text-white relative">
                <span class="absolute -top-3 left-1/2 -translate-x-1/2 rounded-full bg-yellow-400 px-3 py-0.5 text-xs font-semibold text-gray-900">
                    Popular
                </span>
                <h3 class="text-lg font-semibold">Pro</h3>
                <p class="mt-2 text-sm text-blue-200">For teams</p>
                <div class="mt-6">
                    <span class="text-4xl font-bold">$29</span>
                    <span class="text-blue-200">/month</span>
                </div>
                <ul class="mt-8 space-y-3">
                    <li class="flex items-center gap-2 text-sm">
                        <svg class="h-5 w-5 text-blue-200">...</svg> Everything in Basic
                    </li>
                    <li class="flex items-center gap-2 text-sm">
                        <svg class="h-5 w-5 text-blue-200">...</svg> Feature 3
                    </li>
                </ul>
                <a href="#" class="mt-8 block rounded-lg bg-white py-2.5 text-center text-sm font-medium text-blue-600 hover:bg-blue-50 transition">
                    Select
                </a>
            </div>

            <!-- Enterprise -->
            <div class="bg-white rounded-xl p-8 shadow-sm border">
                <h3 class="text-lg font-semibold text-gray-900">Enterprise</h3>
                <p class="mt-2 text-sm text-gray-500">For organizations</p>
                <div class="mt-6">
                    <span class="text-4xl font-bold">$99</span>
                    <span class="text-gray-500">/month</span>
                </div>
                <ul class="mt-8 space-y-3">
                    <li class="flex items-center gap-2 text-sm text-gray-600">
                        <svg class="h-5 w-5 text-green-500">...</svg> Everything in Pro
                    </li>
                    <li class="flex items-center gap-2 text-sm text-gray-600">
                        <svg class="h-5 w-5 text-green-500">...</svg> Feature 4
                    </li>
                </ul>
                <a href="#" class="mt-8 block rounded-lg border border-gray-300 py-2.5 text-center text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                    Contact Us
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
            <h2 class="text-3xl font-bold">Ready to get started?</h2>
            <p class="mt-4 text-lg text-blue-100 max-w-xl mx-auto">
                Start today and see for yourself.
            </p>
            <a href="#" class="mt-8 inline-block rounded-lg bg-white px-8 py-3 text-sm font-medium text-blue-600 hover:bg-blue-50 transition">
                Try for Free
            </a>
        </div>
    </div>
</section>
```

### FAQ (Accordion)

```html
<section class="py-20 bg-gray-50">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-center text-gray-900 mb-12">Frequently Asked Questions</h2>
        <div class="space-y-4" x-data="{ active: null }">
            <!-- FAQ Item -->
            <div class="rounded-xl bg-white shadow-sm">
                <button @click="active = active === 1 ? null : 1"
                        class="flex w-full items-center justify-between px-6 py-4 text-left">
                    <span class="text-sm font-semibold text-gray-900">How does the free trial work?</span>
                    <svg :class="active === 1 ? 'rotate-180' : ''" class="h-5 w-5 text-gray-400 transition-transform">...</svg>
                </button>
                <div x-show="active === 1" x-collapse class="px-6 pb-4">
                    <p class="text-sm text-gray-600">Answer to the question...</p>
                </div>
            </div>
        </div>
    </div>
</section>
```

**Note:** FAQ with Alpine.js requires `<script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>` in the `<head>`.

### Stats

```html
<section class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-8 text-center">
            <div>
                <p class="text-4xl font-bold text-blue-600">10,000+</p>
                <p class="mt-2 text-sm text-gray-600">Happy Customers</p>
            </div>
            <div>
                <p class="text-4xl font-bold text-blue-600">99.9%</p>
                <p class="mt-2 text-sm text-gray-600">Uptime</p>
            </div>
            <div>
                <p class="text-4xl font-bold text-blue-600">50+</p>
                <p class="mt-2 text-sm text-gray-600">Integrations</p>
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
        <h2 class="text-3xl font-bold text-center text-gray-900 mb-16">Our Team</h2>
        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
            <div class="text-center">
                <img src="https://placehold.co/200x200" alt="Team photo" class="mx-auto h-32 w-32 rounded-full object-cover">
                <h3 class="mt-4 text-lg font-semibold text-gray-900">Jane Smith</h3>
                <p class="text-sm text-gray-500">CEO & Founder</p>
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
                <p class="mt-4 text-sm">Short description of the company or product.</p>
            </div>
            <!-- Links -->
            <div>
                <h4 class="text-sm font-semibold text-white uppercase tracking-wider">Product</h4>
                <ul class="mt-4 space-y-2">
                    <li><a href="#" class="text-sm hover:text-white transition">Features</a></li>
                    <li><a href="#" class="text-sm hover:text-white transition">Pricing</a></li>
                </ul>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-white uppercase tracking-wider">Company</h4>
                <ul class="mt-4 space-y-2">
                    <li><a href="#" class="text-sm hover:text-white transition">About Us</a></li>
                    <li><a href="#" class="text-sm hover:text-white transition">Contact</a></li>
                </ul>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-white uppercase tracking-wider">Legal</h4>
                <ul class="mt-4 space-y-2">
                    <li><a href="#" class="text-sm hover:text-white transition">Imprint</a></li>
                    <li><a href="#" class="text-sm hover:text-white transition">Privacy Policy</a></li>
                </ul>
            </div>
        </div>
        <div class="mt-12 border-t border-gray-800 pt-8 text-center text-sm">
            &copy; 2026 Company Name. All rights reserved.
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
                <a href="#pricing" class="text-sm text-gray-600 hover:text-gray-900 transition">Pricing</a>
                <a href="#contact" class="text-sm text-gray-600 hover:text-gray-900 transition">Contact</a>
                <a href="#" class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition">
                    Get Started
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

## Page Pattern Templates

### SaaS Landing Page (inspired by Salient)

Section order:
1. Navigation (fixed, transparent → solid on scroll)
2. Hero (centered, large title + CTA)
3. Logos/Trust Bar (customer logos)
4. Features Grid (3 columns)
5. Feature Highlight (split: text + screenshot)
6. Stats
7. Testimonials
8. Pricing (3 columns)
9. CTA Banner
10. Footer

### Portfolio (inspired by Spotlight)

Section order:
1. Navigation (minimal)
2. Hero (split: photo + intro text)
3. About Me
4. Projects Grid (cards with image + description)
5. Skills/Technologies
6. Contact Form
7. Footer (minimal)

### Event/Conference (inspired by Keynote)

Section order:
1. Navigation
2. Hero (large background image + event name + date)
3. Speaker Grid
4. Program/Schedule (timeline)
5. Venue/Location (map placeholder)
6. Sponsor Logos
7. Ticket CTA
8. Footer

### Podcast/Media (inspired by Transmit)

Section order:
1. Navigation
2. Hero (cover art + title + subscribe buttons)
3. Latest Episodes (list)
4. About the Podcast
5. Host Introduction
6. Platform Links
7. Footer

### Mobile App Promo (inspired by Pocket)

Section order:
1. Navigation
2. Hero (phone mockup + app description + store badges)
3. Features (alternating: screenshot left/right + text)
4. Stats/Social Proof
5. Download CTA
6. Footer
