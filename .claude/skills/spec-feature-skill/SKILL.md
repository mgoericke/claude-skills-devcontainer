---
name: spec-feature-skill
description: Spec Driven Development – erfragt fachliche Features per strukturierter Interview-Sequenz und erstellt daraus eine Spezifikationsdatei in specs/. Verwende bei "Feature spezifizieren", "erstelle eine Spec" oder "beschreibe das Feature".
argument-hint: "[feature-name]"
---

# Spec Feature Skill

Strukturiertes Interview zur Erfassung fachlicher Anforderungen.
Das Ergebnis ist eine Spec-Datei in `specs/`, die als Grundlage für Implementierung,
Tests und Dokumentation dient.

> **Philosophie:** Erst verstehen, dann bauen. Die Spec ist die gemeinsame Sprache
> zwischen Fachlichkeit und Code.

---

## When to Use This Skill

- Ein neues fachliches Feature soll beschrieben werden, bevor Code geschrieben wird
- Anforderungen sollen strukturiert erfasst und dokumentiert werden
- Eine Grundlage für Implementierung, Tests und Dokumentation wird benötigt
- Formulierungen wie "spezifiziere ein Feature", "beschreibe das Feature", "erstelle eine Spec", "was soll das System tun?"

## What This Skill Does

1. **Führt strukturiertes Interview** – 4 Fragegruppen (Kontext, Verhalten, Technik, Qualität) sequenziell abfragen
2. **Fasst Antworten zusammen** – Kompakte Zusammenfassung zur Bestätigung
3. **Erstellt Spec-Datei** – `specs/<feature-name-kebab-case>.md` aus Template

## How to Use

```
Ich möchte ein neues Feature spezifizieren
```

```
Erstelle eine Spec für die Auftragserfassung
```

```
Beschreibe das Feature Benutzerregistrierung bevor wir implementieren
```

---

## Instructions

### Schritt 1 – Interview (Pflicht)

Fragen **sequenziell** stellen – eine Gruppe nach der anderen, nicht alle auf einmal.
Antworten sammeln und am Ende der Phase zusammenfassen.

#### Gruppe 1 – Kontext

1. **Wie heißt das Feature?** _(kurzer, fachlicher Name – wird Dateiname)_
2. **Was ist das Ziel?** _(1–3 Sätze: welches Problem wird gelöst?)_
3. **Wer nutzt es?** _(Rolle / Akteur, z.B. "Sachbearbeiter", "externer API-Client")_

#### Gruppe 2 – Verhalten

4. **Was soll das System tun?** _(Hauptablauf in einfachen Sätzen)_
5. **Welche Varianten / Sonderfälle gibt es?** _(alternative Abläufe, Fehlerfälle)_
6. **Was soll das System explizit NICHT tun?** _(Abgrenzung – verhindert Scope-Creep)_

#### Gruppe 3 – Technische Hinweise

7. **Gibt es API-Endpunkte?** _(Methode + Pfad, z.B. `POST /orders`)_
8. **Welche Daten sind beteiligt?** _(Felder, Typen – grob reicht)_
9. **Gibt es Messaging-Events?** _(publiziert / konsumiert, Channel-Namen)_
10. **Gibt es Abhängigkeiten zu anderen Features / Services?**

#### Gruppe 4 – Qualität

11. **Welche Akzeptanzkriterien müssen erfüllt sein?** _(messbar, testbar)_
12. **Gibt es nicht-funktionale Anforderungen?** _(Performance, Sicherheit, Verfügbarkeit)_
13. **Welche offenen Fragen / Annahmen gibt es noch?**

### Schritt 2 – Zusammenfassung

Nach dem Interview: alle Antworten kompakt zusammenfassen und bestätigen lassen.
Erst nach Bestätigung die Spec-Datei schreiben.

### Schritt 3 – Spec-Datei erzeugen

Dateiname: `specs/<feature-name-kebab-case>.md`
Template: siehe `templates/feature-spec.md.template`

---

## References

| Datei | Beschreibung |
|-------|-------------|
| [templates/feature-spec.md.template](templates/feature-spec.md.template) | Template für die Spec-Datei |

---

## Conventions

- **Dateiname:** kebab-case, Englisch (`order-creation.md`)
- **Feature-Name (Heading):** Titel-Case, Deutsch (`Auftragserfassung`)
- **Gherkin-Szenarien:** Deutsch (`Gegeben`, `Wenn`, `Dann`)
- **Code-Artefakte im Vorschlag:** Englisch (`OrderService`, `createOrder`)

### Integration mit java-scaffold-skill

Nach der Spec-Erstellung kann der `java-scaffold-skill` die Spec als Input verwenden:

```
Implementiere das Feature gemäß specs/order-creation.md
```

Der Scaffold-Skill liest die Spec und leitet daraus ab:
- Boundary: REST-Endpunkte und/oder Messaging-Consumer
- Control: Service-Klassen für die Geschäftslogik
- Entity: JPA-Entities, Flyway-Migration, Repositories

### Position im Workflow

```
[spec-feature-skill]      ◀ fachliche Anforderungen erfassen
        ↓
[openapi-skill]           wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               Projektdokumentation
```
