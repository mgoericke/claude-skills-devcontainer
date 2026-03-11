---
name: infografik-skill
description: Creates professional infographics as PNG via the Hugging Face Inference API (FLUX.1-schnell). Supports technical dashboards, architecture overviews, process flows, comparisons, timelines, and creative posters. Use this skill for infographics, visualizations, illustrated statistics, or roadmaps – also for "visualize this", "make this clear", "show this as an image", "create a diagram", or "create an infographic".
argument-hint: "[topic-or-description]"
---

# Infographic Skill

Creates professional infographics as PNG files via the **Hugging Face Inference API** (free, no billing required).

> **Philosophy:** Data only becomes understandable when told visually.
> A good infographic reduces complexity – it doesn't add to it.

---

## What This Skill Does

1. **Asks for style and type** – Technical/Professional or Creative/Visual via `AskUserQuestion`
2. **Clarifies topic and data** – User data or example data from `references/beispieldaten.md`
3. **Selects color palette** – From `references/farbpaletten.md` matching the style
4. **Formulates image prompt** – Detailed English prompt from data, style, and palette
5. **Calls Hugging Face API** – Generates PNG via FLUX.1-schnell or fallback model
6. **Saves and presents** – PNG with timestamp in project root

## How to Use

```
Create an infographic with the current KPIs
```

```
Visualize the architecture of my project as a poster
```

```
Make an overview of the sprint results as an image
```

### Prerequisites

The user needs a **free Hugging Face account** and an access token:
- Create token: https://huggingface.co/settings/tokens (Read access is sufficient)
- Set token as environment variable: `export HF_TOKEN=hf_...`

---

## Instructions

### Step 1 – Style query

The graphic style determines layout, color palette, and detail level of the image prompt. Without this decision, the prompt would be too generic – therefore always ask first with `AskUserQuestion`.

#### Question 1 – Graphic style (audience)

```
What graphic style do you want?
```

Options:
- **Technical / Professional** – For developers, architects, business analysts. Precise tiles, metrics, tables, structured layouts. Example: KPI dashboard, architecture overview, API documentation.
- **Creative / Visual** – For non-technical people, management, stakeholders, marketing. Large illustrations, colorful graphics, storytelling layouts. Example: Roadmap poster, process flow with symbols, team overview.

#### Question 2 – Infographic type

**For Technical / Professional:**

| Type | Description |
|------|-------------|
| Dashboard / KPI | Hero numbers, metrics, progress bars |
| Architecture | Layer diagrams, components, BCE/MVC structures |
| Process / Workflow | Steps with arrows, numbered, horizontal or vertical |
| Comparison | A vs B, pros/cons, tables with color coding |
| Timeline | Version history, sprint planning, roadmap with milestones |

**For Creative / Visual:**

| Type | Description |
|------|-------------|
| Storytelling / Poster | Narrative structure, large illustrations, vivid colors |
| Pie chart focus | Central message, radial arrangement, strong accents |
| Step-by-step | Large numbered steps, icons, generous whitespace |
| Statistics / Facts | Large numbers with illustrations, pictograms |
| Roadmap | Timeline with illustrations, milestone symbols, phase colors |

### Step 2 – Clarify topic and data

Use user data or example data from `references/beispieldaten.md`.

### Step 3 – Select color palette

Load `references/farbpaletten.md`; use color description for the prompt.

### Step 4 – Formulate image prompt

The prompt must be **in English** and very detailed. Structure:

```
A professional [style] infographic about [topic].
Layout: [describe layout - grid, flow, poster, etc.]
Content: [list the key data points, labels, values]
Color scheme: [describe colors from palette]
Typography: [clean, bold titles, readable labels]
Style: flat design, high contrast, white background, no gradients, crisp edges.
Format: portrait orientation, 1024x1536 pixels.
```

**Example prompt (Technical / KPI Dashboard):**

```
A professional corporate KPI dashboard infographic. Clean grid layout with 6 metric tiles.
Content: Revenue 12.4M EUR (up 18%), Active Users 87,200, Error Rate 0.3%,
Uptime 99.9%, Sprint Velocity 42 points, NPS Score 72.
Color scheme: white background, cobalt blue (#1A56DB) headers,
emerald green (#0E9F6E) for positive KPIs, amber (#E3A008) for warnings.
Typography: bold sans-serif titles, monospace values.
Style: flat design, no shadows, card-based layout, horizontal dividers.
Format: portrait, 1024x1536.
```

**Example prompt (Creative / Storytelling Poster):**

```
A vibrant storytelling infographic poster about digital transformation.
Layout: top-to-bottom flow with 4 illustrated steps connected by arrows.
Content: Step 1 Analysis (magnifying glass icon), Step 2 Design (pencil icon),
Step 3 Build (gear icon), Step 4 Launch (rocket icon).
Color scheme: mint-white background (#FAFFFE), teal (#0D9488) primary,
indigo (#4F46E5) accent, orange (#F97316) highlights.
Typography: large bold step numbers, readable sans-serif descriptions.
Style: modern flat illustration, rounded icons, generous whitespace.
Format: portrait poster, 1024x1536.
```

### Step 5 – Call API

Recommended model: **`black-forest-labs/FLUX.1-schnell`** (free, fast, high quality)

```bash
curl -s \
  -H "Authorization: Bearer $HF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"inputs": "YOUR_PROMPT_HERE"}' \
  "https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell" \
  --output "infographic_$(date +%Y%m%d_%H%M%S).png"
```

Fallback model if FLUX is unavailable: **`stabilityai/stable-diffusion-xl-base-1.0`**

```bash
curl -s \
  -H "Authorization: Bearer $HF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"inputs": "YOUR_PROMPT_HERE"}' \
  "https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-xl-base-1.0" \
  --output "infographic_$(date +%Y%m%d_%H%M%S).png"
```

#### Error handling

- **503 / Model loading**: Model is still starting – wait 20 seconds, then retry
- **401 Unauthorized**: `HF_TOKEN` missing or invalid
- **Empty/corrupt PNG**: Response was JSON error – `cat infographic.png` to diagnose
- **Text in image unreadable**: Known FLUX limitation – keep labels in prompt shorter, use only keywords

### Step 6 – Save output and present

Save PNG to project root, then share with `present_files`.

Filename: **Never** overwrite an existing infographic. Always save with timestamp or descriptive name:

```bash
# Filename with timestamp
infographic_$(date +%Y%m%d_%H%M%S).png

# Or descriptive name
infographic_spring-architecture.png
infographic_kpi-dashboard.png
```

Check before saving whether a file with the planned name already exists.

### Quality checklist

Check before presenting:
- [ ] Style query was performed (AskUserQuestion)
- [ ] Prompt is in English and contains all relevant data
- [ ] Color palette is described in the prompt
- [ ] PNG file was saved successfully (file size > 10 KB)
- [ ] File is in project root

---

## References

| File | Description |
|------|-------------|
| [references/farbpaletten.md](references/farbpaletten.md) | 5 themes with color descriptions for the prompt – always load |
| [references/beispieldaten.md](references/beispieldaten.md) | Demo datasets as text description – load when no custom dataset is available |

---

## Conventions

- **Prompt language:** English (Hugging Face models understand English best)
- **File format:** PNG, Portrait 1024x1536
- **Filename:** `infographic_<description-or-timestamp>.png` – never overwrite
- **Style:** Flat design, high contrast, no shadows/gradients
- **Quality:** Keep labels short – FLUX limitation with long texts
