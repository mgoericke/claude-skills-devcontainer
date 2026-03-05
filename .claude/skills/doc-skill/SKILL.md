---
name: doc-skill
description: Erstellt oder aktualisiert eine Projektdokumentation als Markdown-Seite in docs/. Verwende bei "dokumentiere das Projekt", "schreib eine Doku" oder "aktualisiere die docs".
argument-hint: "[artifactId]"
---

# Doc Skill

Erstellt oder aktualisiert `docs/<artifactId>.md` auf Basis des bestehenden Projekts
und eines strukturierten Interviews.

> **Philosophie:** Dokumentation ist kein Anhang – sie ist Teil des Produkts.
> Gute Doku entsteht aus dem Quellcode, nicht neben ihm.

---

## When to Use This Skill

- Eine Projektdokumentation soll erstellt oder aktualisiert werden
- Ein neues Projekt wurde angelegt und braucht eine technische Dokumentation
- Bestehende Dokumentation soll mit neuen Features ergänzt werden
- Formulierungen wie "dokumentiere das Projekt", "schreib eine Doku", "aktualisiere die docs", "erstelle eine README für das Projekt"

## What This Skill Does

1. **Analysiert das Projekt** – pom.xml, Properties, docker-compose, Quellcode automatisch auswerten
2. **Schließt Lücken per Interview** – Nur fragen, was aus dem Code nicht hervorgeht
3. **Erstellt oder aktualisiert** – `docs/<artifactId>.md` aus Template oder gezielt ergänzen

## How to Use

```
Dokumentiere das Projekt
```

```
Erstelle eine Doku für mein Spring Boot Projekt
```

```
Aktualisiere die docs mit dem neuen Messaging-Feature
```

---

## Instructions

### Schritt 1 – Projekt analysieren (automatisch)

Vor dem Interview vorhandene Projektartefakte lesen und auswerten:

| Datei | Extrahierte Information |
|-------|------------------------|
| `pom.xml` | groupId, artifactId, Framework, aktive Dependencies (DB, Messaging, Keycloak) |
| `src/main/resources/application.properties` | Konfigurierte Ports, Datenbankname, Realm |
| `docker-compose.yml` | Services, Ports, Credentials |
| `specs/*.md` | Vorhandene Feature-Specs als Grundlage für API-Dokumentation |
| `src/main/java/**/boundary/rest/` | REST-Endpunkte (Pfade, Methoden) |
| `src/main/java/**/boundary/messaging/` | Messaging-Consumer (Channels) |
| `src/main/java/**/entity/` | Entities / Datenmodell |
| `src/main/resources/db/migration/` | Flyway-Migrationen → Datenbankschema |

Bereits ermittelte Informationen **nicht erneut abfragen**.

### Schritt 2 – Interview (nur Lücken schließen)

Nur fragen, was aus dem Quellcode nicht eindeutig hervorgeht:

| # | Frage | Nur fragen wenn |
|---|-------|----------------|
| 1 | **Kurzbeschreibung des Projekts** (1–2 Sätze: was tut es?) | Kein `README.md` vorhanden |
| 2 | **Zielgruppe / Nutzer** (interne API, öffentlich, anderes Team?) | Unklar aus dem Code |
| 3 | **Besondere Konfigurationshinweise** (Secrets, externe Systeme) | Nicht in `application.properties` |
| 4 | **Bekannte Einschränkungen / offene TODOs** | Immer fragen |
| 5 | **Sollen alle Abschnitte des Templates befüllt werden?** | Immer fragen – ggf. Abschnitte weglassen |

### Schritt 3 – Erstellen oder Aktualisieren

**Erstellen:** `docs/<artifactId>.md` existiert nicht
→ Datei aus Template `templates/project-doc.md.template` erzeugen, alle Platzhalter befüllen.

**Aktualisieren:** `docs/<artifactId>.md` existiert bereits
→ Datei lesen, geänderte/neue Inhalte gezielt ersetzen oder ergänzen.
→ Bestehende manuelle Ergänzungen des Nutzers **nicht überschreiben** – nur leere oder
  veraltete Abschnitte aktualisieren.
→ Am Ende der Datei einen Änderungshinweis ergänzen:
  `_Zuletzt aktualisiert: {{DATE}} (doc-skill)_`

### Abschnitte des Templates

| Abschnitt | Pflicht | Quelle |
|-----------|---------|--------|
| Projektübersicht | Ja | Interview + pom.xml |
| Stack & Versionen | Ja | pom.xml |
| Lokale Entwicklung | Ja | docker-compose.yml, application.properties |
| Architektur (BCE) | Ja | Paketstruktur |
| API-Referenz | Wenn REST vorhanden | boundary/rest/** |
| Messaging | Wenn RabbitMQ aktiv | boundary/messaging/**, application.properties |
| Auth / Keycloak | Wenn quarkus-oidc / oauth2-resource-server aktiv | application.properties |
| Konfigurationsreferenz | Ja | application.properties |
| Deployment | Ja | Dockerfile, docker-compose.yml |
| Bekannte Einschränkungen | Ja | Interview |

---

## References

| Datei | Beschreibung |
|-------|-------------|
| [templates/project-doc.md.template](templates/project-doc.md.template) | Template für die Projektdokumentation |

### Ausgabepfad

```
docs/<artifactId>.md
```

Das Verzeichnis `docs/` wird angelegt, falls es nicht existiert.

---

## Conventions

- **Sprache:** Deutsch (Prosa, Überschriften) · Englisch (Code-Blöcke, Pfade)
- **Dateiname:** `<artifactId>.md` in kebab-case
- Versionsnummern aus `pom.xml` übernehmen – keine Schätzungen
- Passwörter / Secrets nur als Platzhalter (`<your-secret>`) – nie echte Werte
- **Co-Author:** `<!-- Generiert via doc-skill · Co-Author: Claude (claude-sonnet-4-6, Anthropic) -->`

### Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[openapi-skill]           wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               ◀ Projektdokumentation
```
