---
name: review-skill
description: Prueft geaenderten oder bestehenden Code gegen Projekt-Konventionen, Architektur-Regeln (BCE) und Best Practices. Erfasst automatisch staged/unstaged Changes oder Branch-Diffs. Verwende diesen Skill bei "review code", "pruefe den Code", "code review", "schau dir den Code an", "Qualitaetspruefung" oder wenn Code vor einem Commit oder Merge geprueft werden soll.
argument-hint: "[dateien-oder-verzeichnis]"
---

# Review Skill

Systematisches Code-Review gegen Projekt-Konventionen, Architektur-Regeln und Best Practices.

> **Philosophie:** Ein guter Review findet nicht nur Fehler – er stellt sicher, dass der Code
> den Konventionen des Projekts folgt und langfristig wartbar bleibt.

---

## What This Skill Does

1. **Erfasst Änderungen** – Staged/Unstaged Changes, Branch-Diff oder vom User benannte Dateien
2. **Prüft gegen Regeln** – BCE-Architektur, Lessons-Learned, Sicherheit, Code-Qualität, Konfiguration, Tests
3. **Erstellt Report** – Strukturierte Ausgabe mit Findings (Kritisch / Warnung / Hinweis) und positivem Feedback
4. **Bietet Fixes an** – Nach Bestätigung können Findings direkt korrigiert werden

## How to Use

```
Prüfe den Code den ich geändert habe
```

```
Review die Änderungen auf dem aktuellen Branch
```

```
Mach ein Code Review für src/main/java/com/example/
```

---

## Instructions

> **Vor jedem Review**:
> 1. `.claude/lessons-learned.md` lesen
> 2. [references/review-checklist.md](references/review-checklist.md) als Prüfkatalog verwenden

## Dynamischer Kontext (automatisch vorgeladen)

Folgende Git-Informationen werden beim Aufruf automatisch injiziert:

- Staged changes: !`git diff --cached --name-only 2>/dev/null`
- Unstaged changes: !`git diff --name-only 2>/dev/null`
- Untracked files: !`git ls-files --others --exclude-standard 2>/dev/null`
- Current branch: !`git branch --show-current 2>/dev/null`

### Schritt 1 – Änderungen erfassen

Wenn `$ARGUMENTS` übergeben wurde (z.B. `/review-skill src/main/java/`), diese Dateien/Verzeichnisse reviewen.

Andernfalls den **dynamischen Kontext** oben auswerten – in dieser Reihenfolge:

| Priorität | Quelle |
|-----------|--------|
| 1 | `$ARGUMENTS` (explizit übergebene Dateien/Verzeichnisse) |
| 2 | Staged Changes (aus dynamischem Kontext) |
| 3 | Unstaged Changes (aus dynamischem Kontext) |
| 4 | Branch-Diff gegen main: `git diff main...HEAD --name-only` |

**Regeln:**
- Wenn staged oder unstaged Changes vorhanden → diese reviewen
- Wenn keine lokalen Änderungen, aber Branch ≠ main → Branch-Diff reviewen
- Wenn gar keine Änderungen vorhanden → User fragen: welche Dateien oder Verzeichnisse sollen geprüft werden?
- Nur relevante Dateien reviewen (Java, Properties, YAML, SQL, Dockerfile, docker-compose) – generierte Dateien (target/, .class) ignorieren

**Dateien lesen:** Alle geänderten Dateien vollständig lesen, nicht nur das Diff. Der Kontext ist wichtig für die Bewertung.

### Schritt 2 – Review durchführen

Jede geänderte Datei gegen den Prüfkatalog (`references/review-checklist.md`) prüfen.

**Prüfkategorien (Kurzfassung):**

#### 2.1 Architektur (BCE)

- Klassen in der richtigen Schicht? (`boundary/rest/`, `boundary/messaging/`, `control/`, `entity/`)
- Keine direkten Repository-Aufrufe aus der Boundary-Schicht
- Keine REST-/Messaging-Logik in der Entity-Schicht
- Controller/Resource delegiert an Service (Control), nicht an Repository (Entity)

#### 2.2 Lessons-Learned Abgleich

`.claude/lessons-learned.md` gegen den geänderten Code prüfen:

| Regel | Prüfung |
|-------|---------|
| `@Blocking` bei Quarkus-Consumer | `@Incoming` ohne `@Blocking` bei DB-Zugriff? |
| Flyway statt ddl-auto | `ddl-auto=create` oder `update` in Properties? |
| Health Checks | Actuator/SmallRye-Health Dependency vorhanden? |
| Dev Services deaktiviert | Quarkus Dev Services noch aktiv? |
| Dockerfile-Konvention | Spring Boot → Root, Quarkus → `src/main/docker/` |
| RabbitMQ Config | Falsche Property-Keys (`quarkus.rabbitmq.*` statt `rabbitmq-host`)? |

#### 2.3 Coding-Standards

- **Sprache:** Kommentare/Javadoc auf Deutsch, Code (Klassen, Methoden, Variablen) auf Englisch
- **Naming:** Java-Konventionen (CamelCase Klassen, camelCase Methoden, UPPER_SNAKE Konstanten)
- **Packages:** `{{groupId}}.boundary.rest`, `{{groupId}}.control`, `{{groupId}}.entity`
- **Fachliche Neutralität:** Keine domänenspezifischen Namen in Templates

#### 2.4 Sicherheit

- SQL-Injection: Keine String-Konkatenation in Queries (`"SELECT ... " + param`)
- Input-Validierung: `@Valid` an Controller/Resource-Methoden bei Request-Bodies
- Secrets: Keine hartcodierten Passwörter, Tokens oder Keys in Quellcode/Properties
- CORS: Nicht `allowedOrigins("*")` in Produktion
- Security-Config: Swagger-UI-Pfade freigegeben, aber nicht alles `permitAll()`

#### 2.5 Code-Qualität

- Unnötige Komplexität oder Over-Engineering
- Duplikation (gleiche Logik an mehreren Stellen)
- Fehlende oder falsche Exception-Behandlung
- Unused Imports, tote Code-Pfade
- Lombok sinnvoll eingesetzt (nicht überladen)

#### 2.6 Konfiguration

- `application.properties` vollständig (DB, Messaging, Health, Flyway)
- `docker-compose.yml`: Health Checks für alle Services
- Flyway-Migration vorhanden für jede neue Entity
- `versions-maven-plugin` in der POM
- `renovate.json` im Projekt-Root

#### 2.7 Tests

- Architekturtest (Taikai) vorhanden?
- Neue Geschäftslogik (Control-Schicht) hat Unit-Tests?
- Testklassen im richtigen Package?

### Schritt 3 – Report erstellen

Ergebnis als strukturierte Markdown-Ausgabe im Chat:

```
## Review-Ergebnis

### Zusammenfassung
- X Dateien geprüft
- X Findings (Y kritisch, Z Warnungen, W Hinweise)

### Kritisch 🔴
| # | Datei | Zeile | Problem | Lösung |
|---|-------|-------|---------|--------|
| 1 | ... | ... | ... | ... |

### Warnung 🟡
| # | Datei | Zeile | Problem | Lösung |
|---|-------|-------|---------|--------|

### Hinweis 🔵
| # | Datei | Zeile | Problem | Lösung |
|---|-------|-------|---------|--------|

### ✅ Positiv
- Was gut gelöst ist (nicht nur Fehler suchen!)
```

**Kategorisierung:**

| Kategorie | Kriterium |
|-----------|-----------|
| **Kritisch** 🔴 | Sicherheitslücke, Datenverlust möglich, Architektur-Verletzung, `ddl-auto=create` |
| **Warnung** 🟡 | Konventions-Verletzung, fehlender Test, fehlende Validierung |
| **Hinweis** 🔵 | Verbesserungsvorschlag, Stil, Lesbarkeit |

**Nach dem Report:** Fragen ob Findings direkt gefixt werden sollen.
Nur fixen nach expliziter Bestätigung – nie automatisch.

---

## References

| Datei | Beschreibung |
|-------|-------------|
| `.claude/lessons-learned.md` | Erkenntnisse und Korrekturen – vor jedem Review lesen |
| [references/review-checklist.md](references/review-checklist.md) | Detaillierter Prüfkatalog mit Regeln pro Kategorie |

---

## Conventions

- Der Review-Skill **ändert keinen Code** ohne Bestätigung
- Positives Feedback geben – nicht nur Fehler auflisten
- Bei Unsicherheit lieber als Hinweis statt als Kritisch einstufen
- Keine Findings für generierten Code (target/, build/)
- Framework erkennen (Spring Boot vs. Quarkus) und passende Regeln anwenden

### Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[openapi-skill]           wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra
        ↓
[review-skill]            ◀ Code-Review
        ↓
[doc-skill]               Projektdokumentation
```
