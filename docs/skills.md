# Skills

Alle Skills liegen in `.claude/skills/` und werden von Claude Code automatisch geladen.
Sie steuern, wie Claude bei typischen Aufgaben vorgeht – als eingebettete Anweisungen,
nicht als externe Tools.

---

## Workflow-Übersicht

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Projekt-Workflow                             │
└─────────────────────────────────────────────────────────────────────┘

  Idee / Anforderung
        │
        ▼
┌───────────────────┐
│ spec-feature-skill│  "Ich möchte ein neues Feature spezifizieren"
│                   │  → Interview → specs/<feature>.md
└────────┬──────────┘
         │
         ▼ (optional – wenn OpenAPI Spec vorhanden)
┌───────────────────┐
│  openapi-skill    │  "Generiere Code aus api/openapi.yaml"
│                   │  → boundary/rest/ + entity/dto/ + control/ (Stubs)
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│java-scaffold-skill│  "Erstelle ein neues Quarkus-Projekt"
│                   │  → pom.xml, docker-compose, Flyway, Dockerfile,
└────────┬──────────┘    ArchitekturTest, renovate.json
         │               (REST/DTOs nur wenn openapi-skill NICHT gelaufen)
         ▼
┌───────────────────┐
│    doc-skill      │  "Dokumentiere das Projekt"
│                   │  → docs/<artifactId>.md (erstellen oder aktualisieren)
└───────────────────┘

  Jederzeit parallel nutzbar:
┌───────────────────┐
│ infografik-skill  │  "Erstelle eine Infografik zu ..."
│                   │  → PNG via Hugging Face FLUX.1
└───────────────────┘
```

---

## spec-feature-skill

**Zweck:** Strukturiertes Feature-Interview vor der Implementierung – erzeugt eine
Spec-Datei als gemeinsame Sprache zwischen Fachlichkeit und Code.

**Trigger:** `Ich möchte ein neues Feature spezifizieren`

**Ablauf:**
1. Interview in 4 Gruppen: Kontext → Verhalten → Technische Hinweise → Qualität
2. Zusammenfassung und Bestätigung
3. Ausgabe: `specs/<feature-name>.md`

**Output-Pfad:** `specs/<feature-name-kebab-case>.md`

---

## openapi-skill _(optional)_

**Zweck:** Liest eine OpenAPI 3.x Spezifikation (YAML oder JSON) und generiert daraus
typsichere REST-Endpunkte und DTOs im BCE-Pattern – ohne Abweichung vom API-Vertrag.

**Trigger:** `Generiere Code aus der OpenAPI Spec api/openapi.yaml`

**Generiert:**
| Artefakt | Pfad | Beschreibung |
|----------|------|-------------|
| Controller / Resource | `boundary/rest/` | Ein File pro OpenAPI-Tag |
| DTOs | `entity/dto/` | Java Records mit Validation-Annotationen aus der Spec |
| Service-Stubs | `control/` | Leere Serviceklassen mit korrekten Methodensignaturen |

**Unterstützte Features:** Path/Query/Header-Parameter, Request Body, Response Body,
`$ref`-Auflösung, Enum-Typen, Security-Annotationen, OpenAPI 3.0.x + 3.1.x

**Hinweis:** Wenn dieser Skill ausgeführt wurde, generiert `java-scaffold-skill`
`boundary/rest/` und `entity/dto/` **nicht** nochmal.

---

## java-scaffold-skill

**Zweck:** Erstellt den vollständigen Projekt-Rahmen für eine neue Java-Anwendung –
inklusive Build-Konfiguration, Infrastruktur und Architekturtests.

**Trigger:** `Erstelle ein neues Quarkus-Projekt`

**Pflichtabfragen:** groupId · artifactId · Framework · benötigte Dienste (DB / Messaging / Keycloak)

**Generiert:**
| Artefakt | Beschreibung |
|----------|-------------|
| `pom.xml` | Mit aktuellen Versionen (immer aus dem Internet abgefragt) |
| `docker-compose.yml` | Nur mit bestätigten Diensten |
| `application.properties` | Framework-spezifisch vorkonfiguriert |
| `Dockerfile` | Spring: Projekt-Root · Quarkus: `src/main/docker/` |
| `ArchitectureTest.java` | Taikai-basierte BCE-Regel-Prüfung |
| `renovate.json` | Automatische Dependency-Update-PRs |

**Versions-Pflicht:** Vor jeder Generierung werden aktuelle Versionen im Internet
abgefragt – niemals aus dem Gedächtnis.

---

## doc-skill

**Zweck:** Erstellt oder aktualisiert `docs/<artifactId>.md` auf Basis des bestehenden
Projekts – liest Quellcode und Konfiguration automatisch aus, bevor Fragen gestellt werden.

**Trigger:** `Dokumentiere das Projekt` · `Aktualisiere die Projektdokumentation`

**Automatisch analysiert:** `pom.xml` · `application.properties` · `docker-compose.yml` ·
REST-Endpunkte · Entities · Flyway-Migrationen · vorhandene Specs

**Verhalten bei vorhandener Datei:** Nur leere oder veraltete Abschnitte werden
aktualisiert – manuelle Ergänzungen bleiben erhalten.

**Adaptive Abschnitte:** API-Referenz, Messaging, Keycloak/Auth erscheinen nur,
wenn die jeweiligen Dependencies in der `pom.xml` aktiv sind.

---

## infografik-skill

**Zweck:** Generiert professionelle Infografiken als PNG-Datei über die
Hugging Face Inference API (FLUX.1, kostenlos mit `HF_TOKEN`).

**Trigger:** `Erstelle eine Infografik zu ...` · `Visualisiere das` · `Mach das übersichtlich`

**Voraussetzung:** `HF_TOKEN` als Umgebungsvariable auf dem Host gesetzt
(einmalige Einrichtung unter https://huggingface.co/settings/tokens)
