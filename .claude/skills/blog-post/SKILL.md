---
name: blog-post
description: Creates technical blog posts in the style of the-main-thread.com with structured interviews and audience adaptation (Developer, Business Analysts, Project Managers). Use this skill whenever a blog post, article, tutorial, guide, experience report, or technical contribution needs to be created – also for informal requests like "write something about X", "I want to blog about X", or "make an article out of this". Also use when an existing draft should be turned into blog post format.
argument-hint: "[topic]"
---

# Blog Post Skill

Creates technical blog posts as Markdown files in `docs/` – based on a
structured interview and a proven template from successful technical articles.

> **Philosophy:** A good technical blog post tells a story.
> It starts with a problem the reader knows and ends with an insight
> that goes beyond the code.

---

## What This Skill Does

1. **Asks for language and audience** – German/English, Developer/BA/PM
2. **Conducts structured interview** – Topic, key message, outline, code examples
3. **Generates blog post** – From template with audience-appropriate language and depth
4. **Creates hero image** (optional) – Via Hugging Face API (FLUX) as title image

## How to Use

```
Write a blog post about Quarkus and LangChain4j
```

```
Create an article about our DevContainer template
```

```
Write a blog post about Java FFM and native AI inference
```

---

## Instructions

> **Before every execution**:
> 1. Check `.claude/lessons-learned.md`
> 2. Load template `templates/blog-post.md.template`

### Step 1 – Ask for language and audience

Language and audience determine the entire tone, depth, and amount of code examples in the post. Without this information, the post won't be audience-appropriate – therefore always ask first with `AskUserQuestion`.

#### Question 1 – Language

```
What language should the blog post be written in?
```

Options:
- **German** (Recommended) – Technical terms remain English, prose in German
- **English** – Entire text in English

#### Question 2 – Audience

```
Who is the primary audience?
```

Options:
- **Developer** – Technically deep, many code examples, architecture decisions explained, CLI commands, fully compilable snippets
- **Business Analysts** – Business focus, code only illustrative, benefits and processes in the foreground, diagrams instead of implementation details
- **Project Managers** – Strategic perspective, decision aids, risks/opportunities, effort estimates, little code

### Step 2 – Topic interview

The interview provides the content foundation for the entire post. Ask questions sequentially – one group at a time, so the user is not overwhelmed.

#### Group 1 – Core

| # | Question | Hint |
|---|----------|------|
| 1 | **What is the topic?** | Short working title |
| 2 | **What problem does the article solve?** | The "why" – why should someone keep reading? |
| 3 | **What is the central insight / thesis?** | The one sentence the reader should take away |

#### Group 2 – Content

| # | Question | Hint |
|---|----------|------|
| 4 | **What main sections should the post have?** | 3–6 sections, rough keywords are enough |
| 5 | **Are there code examples?** | Language, framework, scope – or "none" |
| 6 | **Is there a specific project / repo as a basis?** | Link or local path – then read code from it |

#### Group 3 – Context

| # | Question | Hint |
|---|----------|------|
| 7 | **Is there a personal hook / anecdote?** | Starting with experience feels authentic |
| 8 | **Should the post be for a specific platform?** | Substack, Dev.to, Medium, company blog |
| 9 | **Desired length?** | Short (~1,000 words), Medium (~2,500), Long (~4,500) |

### Step 3 – Create and confirm outline

Before writing, present a **compact outline**:

```
## Outline: [Working Title]

1. Hook – [Opening in 1 sentence]
2. Problem statement – [What is the problem?]
3. [Section 1] – [Key point]
4. [Section 2] – [Key point]
5. [Section 3] – [Key point]
6. Conclusion – [Central insight]
```

**Only continue writing after confirmation.**

### Step 4 – Generate blog post

Load and fill template `templates/blog-post.md.template`.

#### Style rules by audience

**Developer:**
- Problem-first opening with personal experience or concrete scenario
- Code examples complete and compilable (with imports, package declaration)
- "Why" sections for architecture decisions ("Why FFM requires a shared library")
- Verification section with curl commands or test output
- Conclusion highlights strategic insight, not just a summary
- Inline code for technical terms (`ProcessBuilder`, `@Blocking`)
- **Bold** for key concepts
- Tables for comparisons and configurations
- ~15–20 code blocks for tutorial posts

**Business Analysts:**
- Opening with business problem or business scenario
- Code only as illustration (simplified, pseudocode allowed)
- Focus on process flows, benefits, business impact
- Diagrams and tables instead of implementation details
- Conclusion with recommendations and next steps
- ~3–5 code blocks maximum

**Project Managers:**
- Opening with strategic question or market observation
- No code, except for illustration ("this is what it looks like in 5 lines")
- Focus on decisions, risks, opportunities, team impact
- Comparison tables for technology alternatives
- Conclusion with concrete recommendation and decision matrix
- ~0–2 code blocks

#### General style rules (all audiences)

Based on the style of [the-main-thread.com](https://www.the-main-thread.com):

- **Opening (Hook):** First paragraph tells a mini-story or makes a surprising claim. Never start with "In this article…".
- **Tone:** Professional but conversational. Direct without being preachy. Short sentences for rhythm, longer ones for explanations.
- **Paragraphs:** Short (2–4 sentences). Single sentences as their own paragraph are allowed for emphasis.
- **Headings:** Clear and descriptive. H2 for main sections, H3 for subsections.
- **Lists:** Unordered for enumerations, numbered for sequences. Never more than 7 entries.
- **Metaphors:** Explain technical concepts through everyday comparisons ("like an intern you're onboarding").
- **Conclusion:** Not a mere summary. Instead, a strategic insight that points beyond the article. Antithesis or repetition for effect is welcome.
- **Horizontal Rules (`---`):** Between main sections as visual separators.

### Step 5 – Hero image (optional)

After the blog post, ask:

```
Should a hero image be generated for the post?
```

If yes, via Hugging Face API (as in infografik):

**Prompt schema for blog hero images:**

```
A modern, minimalist hero image for a technical blog post about [TOPIC].
Style: abstract, geometric shapes suggesting [CORE_CONCEPT].
Color scheme: dark background (#1a1a2e), accent colors [PRIMARY_COLOR] and [SECONDARY_COLOR].
No text, no letters, no words. Clean, editorial feel.
Format: landscape, 1200x630 pixels (Open Graph).
```

```bash
curl -s \
  -H "Authorization: Bearer $HF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"inputs": "YOUR_PROMPT_HERE"}' \
  "https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell" \
  --output "docs/hero_$(date +%Y%m%d_%H%M%S).png"
```

### Quality checklist

Check before presenting:
- [ ] Language and audience were asked
- [ ] Outline was confirmed
- [ ] Hook in first paragraph (no "In this article…")
- [ ] Conclusion contains strategic insight, not just a summary
- [ ] Code examples are complete (for developer audience)
- [ ] Horizontal rules between main sections
- [ ] No emojis (unless requested)
- [ ] Co-author note at the end
- [ ] Word count matches desired length (±20%)

---

## References

| File | Description |
|------|-------------|
| [blog-post.md.template](blog-post.md.template) | Markdown template for the blog post |
| `.claude/lessons-learned.md` | Findings and corrections |
| `references/farbpaletten.md` | Color palettes for hero image generation (from infografik) |

### Style references

The style rules are based on the analysis of these posts from [the-main-thread.com](https://www.the-main-thread.com):

| Post | Type | Words |
|------|------|-------|
| AI Coding Tools & Compounding Engineering | Opinion article with tips | ~1,000 |
| Local Image Generation (Quarkus, FFM, FLUX) | Deep tutorial | ~4,500 |
| Multilingual Prompt Injection Guardrails | Tutorial with theory | ~4,000 |
| Persistent LLM Memory (Quarkus, LangChain4j) | Hands-on guide | ~4,500 |

---

## Conventions

- **Filename:** `docs/blog-<topic-kebab-case>.md`
- **Prose language:** German (default) or English – depending on interview
- **Code language:** Always English
- **Technical terms:** Remain English, even in German posts
- **Co-Author:** At the end of the post: `*Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generated via blog-post*`
- **Hero Image:** `docs/hero_<topic-or-timestamp>.png` – never overwrite

### Position in Workflow

```
[spec-feature]      optional – business requirements
        |
[java-scaffold]     project setup
        |
[review]            code review
        |
[doc]               project documentation
        |
[blog-post]         < blog post about the project / technology
```
