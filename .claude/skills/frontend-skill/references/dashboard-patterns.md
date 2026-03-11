# Dashboard Patterns (TailAdmin)

Reference patterns for the dashboard mode of the frontend-skill.
Based on TailAdmin (MIT License): https://demo.tailadmin.com/

---

## Layout Structure

### Standard Layout

```
┌──────────────────────────────────────────────┐
│  Sidebar (w-64)  │  Header (h-16)           │
│                  │───────────────────────────│
│  - Logo          │  KPI Cards Row           │
│  - Navigation    │                           │
│  - Submenus      │  Charts (2-col Grid)     │
│                  │                           │
│                  │  Data Table               │
│                  │                           │
│                  │  Footer                   │
└──────────────────────────────────────────────┘
```

### Sidebar

```html
<aside class="fixed left-0 top-0 z-50 flex h-screen w-64 flex-col overflow-y-auto bg-white shadow-lg"
       :class="sidebarOpen ? 'translate-x-0' : '-translate-x-full'"
       x-transition>
    <!-- Logo -->
    <div class="flex items-center gap-2 px-6 py-5 border-b">
        <span class="text-xl font-bold text-blue-600">AppName</span>
    </div>

    <!-- Navigation -->
    <nav class="mt-4 px-4 space-y-1">
        <a href="#" class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-white bg-blue-600">
            <!-- Icon SVG --> Dashboard
        </a>
        <a href="#" class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-gray-600 hover:bg-gray-100">
            <!-- Icon SVG --> Orders
        </a>

        <!-- Submenu with Alpine.js -->
        <div x-data="{ open: false }">
            <button @click="open = !open" class="flex w-full items-center justify-between rounded-lg px-3 py-2.5 text-sm font-medium text-gray-600 hover:bg-gray-100">
                Settings
                <svg :class="open ? 'rotate-180' : ''" class="h-4 w-4 transition-transform">...</svg>
            </button>
            <div x-show="open" x-collapse class="ml-4 mt-1 space-y-1">
                <a href="#" class="block rounded-lg px-3 py-2 text-sm text-gray-500 hover:text-gray-700">Profile</a>
                <a href="#" class="block rounded-lg px-3 py-2 text-sm text-gray-500 hover:text-gray-700">Security</a>
            </div>
        </div>
    </nav>
</aside>
```

### Header

```html
<header class="sticky top-0 z-40 flex h-16 items-center justify-between border-b bg-white px-6">
    <!-- Sidebar Toggle (Mobile) -->
    <button @click="sidebarOpen = !sidebarOpen" class="lg:hidden">
        <svg class="h-6 w-6">...</svg>
    </button>

    <!-- Search -->
    <div class="relative">
        <input type="text" placeholder="Search..." class="rounded-lg border border-gray-300 pl-10 pr-4 py-2 text-sm focus:ring-2 focus:ring-blue-500">
    </div>

    <!-- Right: Notifications + Profile -->
    <div class="flex items-center gap-4">
        <button class="relative">
            <svg class="h-6 w-6 text-gray-500">...</svg>
            <span class="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-red-500 text-[10px] text-white flex items-center justify-center">3</span>
        </button>
        <div x-data="{ open: false }" class="relative">
            <button @click="open = !open" class="flex items-center gap-2">
                <img src="https://placehold.co/32x32" class="h-8 w-8 rounded-full" alt="Avatar">
            </button>
            <div x-show="open" @click.away="open = false" class="absolute right-0 mt-2 w-48 rounded-lg bg-white shadow-lg border py-1">
                <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profile</a>
                <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sign Out</a>
            </div>
        </div>
    </div>
</header>
```

---

## Components

### KPI Cards

```html
<div class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
    <!-- KPI Card -->
    <div class="rounded-xl bg-white p-6 shadow-sm">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-sm font-medium text-gray-500">Revenue</p>
                <h3 class="mt-1 text-2xl font-bold text-gray-900">$45,231</h3>
            </div>
            <div class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-50">
                <!-- Icon SVG -->
            </div>
        </div>
        <div class="mt-4 flex items-center gap-1">
            <span class="text-sm font-medium text-green-600">↑ 12.5%</span>
            <span class="text-sm text-gray-500">vs. last month</span>
        </div>
    </div>
</div>
```

### Charts (ApexCharts)

```html
<div class="rounded-xl bg-white p-6 shadow-sm">
    <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-semibold">Revenue Trend</h3>
        <select class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm">
            <option>Last 7 days</option>
            <option>Last month</option>
            <option>Last year</option>
        </select>
    </div>
    <div id="revenue-chart"></div>
</div>

<script>
new ApexCharts(document.querySelector('#revenue-chart'), {
    chart: { type: 'area', height: 350, toolbar: { show: false } },
    series: [{ name: 'Revenue', data: [31, 40, 28, 51, 42, 109, 100] }],
    xaxis: { categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] },
    colors: ['#3b82f6'],
    fill: { type: 'gradient', gradient: { opacityFrom: 0.4, opacityTo: 0.1 } },
    stroke: { curve: 'smooth', width: 2 },
    dataLabels: { enabled: false },
    grid: { borderColor: '#f3f4f6' }
}).render();
</script>
```

**Chart Types:**

| Type | Use Case | `chart.type` |
|------|----------|-------------|
| Area | Trends, time series | `area` |
| Bar | Comparisons, categories | `bar` |
| Line | Developments | `line` |
| Donut | Proportions, distributions | `donut` |
| Radial | Progress, goals | `radialBar` |

### Data Table

```html
<div class="rounded-xl bg-white shadow-sm">
    <!-- Table Header -->
    <div class="flex items-center justify-between border-b px-6 py-4">
        <h3 class="text-lg font-semibold">Orders</h3>
        <input type="text" placeholder="Search..."
               class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:ring-2 focus:ring-blue-500">
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b bg-gray-50">
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase text-gray-500">ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase text-gray-500">Customer</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase text-gray-500">Status</th>
                    <th class="px-6 py-3 text-right text-xs font-medium uppercase text-gray-500">Amount</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 text-sm font-medium text-gray-900">#1234</td>
                    <td class="px-6 py-4 text-sm text-gray-600">John Doe</td>
                    <td class="px-6 py-4">
                        <span class="inline-flex rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-800">Paid</span>
                    </td>
                    <td class="px-6 py-4 text-sm text-right font-medium text-gray-900">$129.00</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="flex items-center justify-between border-t px-6 py-3">
        <span class="text-sm text-gray-500">1–10 of 42 entries</span>
        <div class="flex gap-1">
            <button class="rounded-lg border px-3 py-1.5 text-sm hover:bg-gray-50">Previous</button>
            <button class="rounded-lg bg-blue-600 px-3 py-1.5 text-sm text-white">1</button>
            <button class="rounded-lg border px-3 py-1.5 text-sm hover:bg-gray-50">2</button>
            <button class="rounded-lg border px-3 py-1.5 text-sm hover:bg-gray-50">Next</button>
        </div>
    </div>
</div>
```

### Status Badges

```html
<!-- Variants -->
<span class="inline-flex rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-800">Active</span>
<span class="inline-flex rounded-full bg-yellow-100 px-2.5 py-0.5 text-xs font-medium text-yellow-800">Pending</span>
<span class="inline-flex rounded-full bg-red-100 px-2.5 py-0.5 text-xs font-medium text-red-800">Rejected</span>
<span class="inline-flex rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-medium text-blue-800">In Progress</span>
<span class="inline-flex rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-800">Draft</span>
```

### Modal

```html
<div x-data="{ modalOpen: false }">
    <button @click="modalOpen = true" class="rounded-lg bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700">
        View Details
    </button>

    <!-- Backdrop -->
    <div x-show="modalOpen" x-transition:enter="transition ease-out duration-200" x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100" x-transition:leave="transition ease-in duration-150"
         x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0"
         class="fixed inset-0 z-50 bg-black/50" @click="modalOpen = false">
    </div>

    <!-- Modal Content -->
    <div x-show="modalOpen" x-transition
         class="fixed left-1/2 top-1/2 z-50 w-full max-w-lg -translate-x-1/2 -translate-y-1/2 rounded-xl bg-white p-6 shadow-xl">
        <div class="flex items-center justify-between border-b pb-4">
            <h3 class="text-lg font-semibold">Title</h3>
            <button @click="modalOpen = false" class="text-gray-400 hover:text-gray-600">&times;</button>
        </div>
        <div class="mt-4">
            <!-- Modal Body -->
        </div>
        <div class="mt-6 flex justify-end gap-3">
            <button @click="modalOpen = false" class="rounded-lg border px-4 py-2 text-sm hover:bg-gray-50">Cancel</button>
            <button class="rounded-lg bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700">Save</button>
        </div>
    </div>
</div>
```

### Forms

```html
<form class="space-y-6">
    <!-- Text Input -->
    <div>
        <label class="mb-1.5 block text-sm font-medium text-gray-700">Name</label>
        <input type="text" class="w-full rounded-lg border border-gray-300 px-3 py-2.5 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
               placeholder="John Doe">
    </div>

    <!-- Select -->
    <div>
        <label class="mb-1.5 block text-sm font-medium text-gray-700">Category</label>
        <select class="w-full rounded-lg border border-gray-300 px-3 py-2.5 text-sm focus:ring-2 focus:ring-blue-500">
            <option>Please select</option>
            <option>Electronics</option>
            <option>Clothing</option>
        </select>
    </div>

    <!-- Toggle -->
    <div class="flex items-center justify-between" x-data="{ enabled: false }">
        <span class="text-sm font-medium text-gray-700">Notifications</span>
        <button @click="enabled = !enabled" type="button"
                :class="enabled ? 'bg-blue-600' : 'bg-gray-200'"
                class="relative inline-flex h-6 w-11 items-center rounded-full transition-colors">
            <span :class="enabled ? 'translate-x-6' : 'translate-x-1'"
                  class="inline-block h-4 w-4 rounded-full bg-white transition-transform"></span>
        </button>
    </div>

    <button type="submit" class="w-full rounded-lg bg-blue-600 py-2.5 text-sm font-medium text-white hover:bg-blue-700">
        Save
    </button>
</form>
```

---

## Color Palette

| Purpose | Class | Hex |
|---------|-------|-----|
| Primary | `blue-600` | #2563eb |
| Success | `green-600` | #16a34a |
| Warning | `yellow-500` | #eab308 |
| Danger | `red-600` | #dc2626 |
| Info | `cyan-500` | #06b6d4 |
| Background | `gray-100` | #f3f4f6 |
| Card | `white` | #ffffff |
| Text Primary | `gray-900` | #111827 |
| Text Secondary | `gray-500` | #6b7280 |
