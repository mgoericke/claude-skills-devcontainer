---
name: blog-post-skill
description: Erstellt technische Blog Posts im Stil von the-main-thread.com mit strukturiertem Interview und Zielgruppen-Anpassung (Developer, Business Analysts, Projekt Manager). Verwende diesen Skill immer wenn ein Blog Post, Artikel, Tutorial, Anleitung, Erfahrungsbericht oder Fachbeitrag erstellt werden soll – auch bei informellen Anfragen wie "schreib was ueber X", "ich moechte ueber X bloggen" oder "mach einen Artikel draus". Auch verwenden wenn ein bestehender Entwurf in Blog-Post-Format gebracht werden soll.
argument-hint: "[thema]"
---

# Blog Post Skill

Erstellt technische Blog Posts als Markdown-Datei in `docs/` – basierend auf einem
strukturierten Interview und einem bewährten Template aus erfolgreichen Fachartikeln.

> **Philosophie:** Ein guter technischer Blog Post erzählt eine Geschichte.
> Er beginnt mit einem Problem, das der Leser kennt, und endet mit einer Erkenntnis,
> die über den Code hinausgeht.

---

## What This Skill Does

1. **Fragt Sprache und Zielgruppe ab** – Deutsch/Englisch, Developer/BA/PM
2. **Führt strukturiertes Interview** – Thema, Kernbotschaft, Gliederung, Code-Beispiele
3. **Generiert Blog Post** – Aus Template mit zielgruppengerechter Sprache und Tiefe
4. **Erstellt Hero Image** (optional) – Per Hugging Face API (FLUX) als Titelbild

## How to Use

```
Schreib einen Blog Post über Quarkus und LangChain4j
```

```
Erstelle einen Artikel über unser DevContainer-Template
```

```
Write a blog post about Java FFM and native AI inference
```

---

## Instructions

> **Vor jeder Ausführung**:
> 1. `.claude/lessons-learned.md` prüfen
> 2. Template `templates/blog-post.md.template` laden

### Schritt 1 – Sprache und Zielgruppe abfragen

Sprache und Zielgruppe bestimmen den gesamten Ton, die Tiefe und die Menge an Code-Beispielen im Post. Ohne diese Information wird der Post nicht zielgruppengerecht – daher immer zuerst mit `AskUserQuestion` abfragen.

#### Frage 1 – Sprache

```
In welcher Sprache soll der Blog Post geschrieben werden?
```

Optionen:
- **Deutsch** (Empfohlen) – Fachbegriffe bleiben Englisch, Prosa auf Deutsch
- **Englisch** – Gesamter Text auf Englisch

#### Frage 2 – Zielgruppe

```
Wer ist die primäre Zielgruppe?
```

Optionen:
- **Developer** – Technisch tiefgehend, viele Code-Beispiele, Architektur-Entscheidungen erklärt, CLI-Befehle, vollständig kompilierbare Snippets
- **Business Analysts** – Fachlicher Fokus, Code nur illustrativ, Nutzen und Prozesse im Vordergrund, Diagramme statt Implementierungsdetails
- **Projekt Manager** – Strategischer Blick, Entscheidungshilfen, Risiken/Chancen, Aufwandseinschätzungen, wenig Code

### Schritt 2 – Themen-Interview

Das Interview liefert die inhaltliche Grundlage fuer den gesamten Post. Fragen sequenziell stellen – eine Gruppe nach der anderen, damit der Nutzer nicht ueberfordert wird.

#### Gruppe 1 – Kern

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **Was ist das Thema?** | Kurzer Arbeitstitel |
| 2 | **Welches Problem löst der Artikel?** | Das "Warum" – warum sollte jemand weiterlesen? |
| 3 | **Was ist die zentrale Erkenntnis / These?** | Der eine Satz, den der Leser mitnehmen soll |

#### Gruppe 2 – Inhalt

| # | Frage | Hinweis |
|---|-------|---------|
| 4 | **Welche Hauptabschnitte soll der Post haben?** | 3–6 Abschnitte, grobe Stichworte reichen |
| 5 | **Gibt es Code-Beispiele?** | Sprache, Framework, Umfang – oder "keine" |
| 6 | **Gibt es ein konkretes Projekt / Repo als Grundlage?** | Link oder lokaler Pfad – dann Code auslesen |

#### Gruppe 3 – Kontext

| # | Frage | Hinweis |
|---|-------|---------|
| 7 | **Gibt es einen persönlichen Aufhänger / eine Anekdote?** | Einstieg mit Erfahrung wirkt authentisch |
| 8 | **Soll der Post auf eine bestimmte Plattform?** | Substack, Dev.to, Medium, firmeninternes Blog |
| 9 | **Gewünschte Länge?** | Kurz (~1.000 Wörter), Mittel (~2.500), Lang (~4.500) |

### Schritt 3 – Gliederung erstellen und bestätigen

Vor dem Schreiben eine **kompakte Gliederung** präsentieren:

```
## Gliederung: [Arbeitstitel]

1. Hook – [Einstieg in 1 Satz]
2. Problemstellung – [Was ist das Problem?]
3. [Abschnitt 1] – [Kernpunkt]
4. [Abschnitt 2] – [Kernpunkt]
5. [Abschnitt 3] – [Kernpunkt]
6. Fazit – [Zentrale Erkenntnis]
```

**Erst nach Bestätigung** weiterschreiben.

### Schritt 4 – Blog Post generieren

Template `templates/blog-post.md.template` laden und befüllen.

#### Stilregeln nach Zielgruppe

**Developer:**
- Problem-First-Einstieg mit persönlicher Erfahrung oder konkretem Szenario
- Code-Beispiele vollständig und kompilierbar (mit Imports, Package-Deklaration)
- "Warum"-Abschnitte für Architekturentscheidungen ("Why FFM requires a shared library")
- Verifizierungsabschnitt mit curl-Befehlen oder Testausgaben
- Fazit hebt strategische Erkenntnis hervor, nicht nur Zusammenfassung
- Inline-Code für technische Begriffe (`ProcessBuilder`, `@Blocking`)
- **Bold** für Schlüsselkonzepte
- Tabellen für Vergleiche und Konfigurationen
- ~15–20 Code-Blöcke bei Tutorial-Posts

**Business Analysts:**
- Einstieg mit fachlichem Problem oder Geschäftsszenario
- Code nur als Illustration (vereinfacht, Pseudocode erlaubt)
- Fokus auf Prozessflüsse, Nutzen, fachliche Auswirkungen
- Diagramme und Tabellen statt Implementierungsdetails
- Fazit mit Handlungsempfehlung und nächsten Schritten
- ~3–5 Code-Blöcke maximal

**Projekt Manager:**
- Einstieg mit strategischer Frage oder Marktbeobachtung
- Kein Code, außer zur Illustration ("so sieht das in 5 Zeilen aus")
- Fokus auf Entscheidungen, Risiken, Chancen, Team-Impact
- Vergleichstabellen für Technologie-Alternativen
- Fazit mit konkreter Empfehlung und Entscheidungsmatrix
- ~0–2 Code-Blöcke

#### Allgemeine Stilregeln (alle Zielgruppen)

Basierend auf dem Stil von [the-main-thread.com](https://www.the-main-thread.com):

- **Einstieg (Hook):** Erster Absatz erzählt eine Mini-Geschichte oder stellt eine überraschende Behauptung auf. Nie mit "In diesem Artikel…" beginnen.
- **Ton:** Professionell aber gesprächig. Direkt ohne belehrend zu wirken. Kurze Sätze für Rhythmus, längere für Erklärungen.
- **Absätze:** Kurz (2–4 Sätze). Einzelne Sätze als eigener Absatz sind erlaubt für Betonung.
- **Überschriften:** Klar und beschreibend. H2 für Hauptabschnitte, H3 für Unterabschnitte.
- **Listen:** Ungeordnet für Aufzählungen, nummeriert für Reihenfolgen. Nie mehr als 7 Einträge.
- **Metaphern:** Technische Konzepte durch alltägliche Vergleiche erklären ("wie ein Praktikant, dem man einarbeitet").
- **Fazit:** Keine reine Zusammenfassung. Stattdessen eine strategische Erkenntnis, die über den Artikel hinausweist. Gerne mit Antithese oder Wiederholung für Wirkung.
- **Horizontal Rules (`---`):** Zwischen Hauptabschnitten als visuelle Trenner.

### Schritt 5 – Hero Image (optional)

Nach dem Blog Post fragen:

```
Soll ein Hero Image für den Post generiert werden?
```

Falls ja, per Hugging Face API (wie im infografik-skill):

**Prompt-Schema für Blog Hero Images:**

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
  -d '{"inputs": "DEIN_PROMPT_HIER"}' \
  "https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell" \
  --output "docs/hero_$(date +%Y%m%d_%H%M%S).png"
```

### Qualitätscheckliste

Vor dem Präsentieren prüfen:
- [ ] Sprache und Zielgruppe wurden abgefragt
- [ ] Gliederung wurde bestätigt
- [ ] Hook im ersten Absatz (kein "In diesem Artikel…")
- [ ] Fazit enthält strategische Erkenntnis, nicht nur Zusammenfassung
- [ ] Code-Beispiele sind vollständig (bei Developer-Zielgruppe)
- [ ] Horizontal Rules zwischen Hauptabschnitten
- [ ] Keine Emojis (außer auf Wunsch)
- [ ] Co-Author-Hinweis am Ende
- [ ] Wortanzahl entspricht gewünschter Länge (±20%)

---

## References

| Datei | Beschreibung |
|-------|-------------|
| [blog-post.md.template](blog-post.md.template) | Markdown-Template für den Blog Post |
| `.claude/lessons-learned.md` | Erkenntnisse und Korrekturen |
| `references/farbpaletten.md` | Farbpaletten für Hero-Image-Generierung (aus infografik-skill) |

### Stilvorbilder

Die Stilregeln basieren auf der Analyse dieser Posts von [the-main-thread.com](https://www.the-main-thread.com):

| Post | Typ | Wörter |
|------|-----|--------|
| AI Coding Tools & Compounding Engineering | Meinungsartikel mit Tipps | ~1.000 |
| Local Image Generation (Quarkus, FFM, FLUX) | Tiefes Tutorial | ~4.500 |
| Multilingual Prompt Injection Guardrails | Tutorial mit Theorie | ~4.000 |
| Persistent LLM Memory (Quarkus, LangChain4j) | Hands-on Guide | ~4.500 |

---

## Conventions

- **Dateiname:** `docs/blog-<thema-kebab-case>.md`
- **Sprache Prosa:** Deutsch (default) oder Englisch – je nach Interview
- **Sprache Code:** Immer Englisch
- **Fachbegriffe:** Bleiben Englisch, auch in deutschen Posts
- **Co-Author:** Am Ende des Posts: `*Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via blog-post-skill*`
- **Hero Image:** `docs/hero_<thema-oder-zeitstempel>.png` – nie überschreiben

### Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[java-scaffold-skill]     Projekt aufsetzen
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               Projektdokumentation
        ↓
[blog-post-skill]         ◀ Blog Post über das Projekt / die Technologie
```
