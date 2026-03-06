---
name: coworker-skill
description: Phasen-basierter Coworker fuer End-to-End Projekt-Setup. Fuehrt durch Spezifikation, API-Design und Code-Generierung mit Review nach jeder Phase. Verwende diesen Skill wenn ein neues Projekt von Grund auf aufgesetzt werden soll oder der Entwickler sich durch den kompletten Workflow fuehren lassen moechte. Auch bei "neues Projekt starten", "Coworker", "fuehr mich durch das Setup", "ich brauche ein neues Projekt" oder "Projekt aufsetzen end-to-end".
argument-hint: "[projektname oder thema]"
disable-model-invocation: true
---

# Coworker Skill

Phasen-basierter Coworker fuer das End-to-End Setup neuer Projekte.
Orchestriert die bestehenden Skills in der richtigen Reihenfolge – mit Review
und Feedback-Moeglichkeit nach jeder Phase.

> **Philosophie:** Ein guter Coworker denkt mit, schlaegt die naechsten Schritte vor
> und laesst dem Entwickler die Kontrolle. Jede Phase hat ein klares Ergebnis.
> Nichts passiert ohne Bestaetigung.

---

## What This Skill Does

1. **Fuehrt durch Phasen** – Spezifikation, API-Design, Code-Generierung
2. **Orchestriert bestehende Skills** – Nutzt `spec-feature-skill`, `openapi-skill`, `java-scaffold-skill`
3. **Review nach jeder Phase** – Ergebnis pruefen, Feedback geben, anpassen oder weitermachen
4. **Flexibel ueberspringen** – Phasen koennen uebersprungen werden, wenn Artefakte schon existieren

## How to Use

```
Starte den Coworker fuer ein neues Projekt
```

```
Ich brauche ein neues Projekt fuer einen Bestellservice
```

```
Coworker: neues Projekt aufsetzen
```

---

## Instructions

> **Vor jeder Ausfuehrung**:
> 1. `.claude/lessons-learned.md` pruefen
> 2. Pruefen ob bereits Artefakte existieren (`specs/`, `api/`, `pom.xml`)

### Ueberblick: Die Phasen

```
Phase 1: Projekt-Kontext          → Grundlegende Entscheidungen (Framework, Name, Scope)
         ↓ Bestaetigung
Phase 2: Feature spezifizieren    → specs/<feature>.md
         ↓ Review & Bestaetigung
Phase 3: API designen             → api/<service>.yaml
         ↓ Review & Bestaetigung
Phase 4: Code generieren          → Java-Projekt mit BCE, Tests, Docker, Infra
         ↓ Review & Bestaetigung
Phase 5: Zusammenfassung          → Was wurde erstellt, naechste Schritte
```

---

### Schritt 0 – Bestandsaufnahme

Vor dem Start pruefen, was bereits existiert:

- Gibt es eine `pom.xml`? → Projekt existiert bereits, Phasen 1+4 ggf. ueberspringen
- Gibt es Dateien in `specs/`? → Phase 2 ggf. ueberspringen
- Gibt es Dateien in `api/`? → Phase 3 ggf. ueberspringen

Ergebnis dem Benutzer mitteilen:

```
Bestandsaufnahme:
  Projekt:  ✅ vorhanden (order-service, Spring Boot)
  Specs:    ❌ keine gefunden
  API Spec: ❌ keine gefunden

Empfehlung: Mit Phase 2 (Feature spezifizieren) starten.
```

Oder bei leerem Projekt:

```
Bestandsaufnahme:
  Projekt:  ❌ kein Projekt gefunden
  Specs:    ❌ keine gefunden
  API Spec: ❌ keine gefunden

Empfehlung: Mit Phase 1 (Projekt-Kontext) starten.
```

---

### Phase 1 – Projekt-Kontext

**Ziel:** Die grundlegenden Entscheidungen treffen, bevor es losgeht.

**Mit `AskUserQuestion` abfragen:**

#### Frage 1 – Projektname und Zweck

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **Projektname** | Kurzer Name, z.B. `order-service` |
| 2 | **Was soll das Projekt tun?** | Ein Satz – wird fuer Spec und Doku verwendet |

#### Frage 2 – Framework

```
Welches Framework soll verwendet werden?
```

Optionen:
- **Spring Boot (Empfohlen)** – Spring Boot 4.x mit Spring AMQP, Actuator, Flyway
- **Quarkus** – Quarkus 3.31+ mit SmallRye, MicroProfile Health, Flyway

#### Frage 3 – Dienste

```
Welche Dienste braucht das Projekt?
```

Optionen (multiSelect):
- **PostgreSQL** – Relationale Datenbank
- **RabbitMQ** – Messaging / Event-Kommunikation
- **Keycloak** – Authentifizierung und Autorisierung

**Phasen-Uebergang:**

```
Phase 1 abgeschlossen ✅

  Projekt:   order-service
  Framework: Spring Boot
  Dienste:   PostgreSQL, RabbitMQ

  Naechste Phase: Feature spezifizieren
  → Der spec-feature-skill fuehrt ein Interview und erstellt eine Spec-Datei.

Weiter mit Phase 2?
```

Per `AskUserQuestion` bestaetigen:
- **Weiter mit Phase 2** – Feature spezifizieren
- **Phase 2 ueberspringen** – Direkt zu Phase 3 (API designen)
- **Hier stoppen** – Spaeter weitermachen

---

### Phase 2 – Feature spezifizieren

**Ziel:** Eine fachliche Spezifikation erstellen, bevor Code geschrieben wird.

**Delegation an `spec-feature-skill`:**

Den `spec-feature-skill` ausfuehren – mit dem Projektkontext aus Phase 1 als Vorwissen.
Der Skill fuehrt sein eigenes Interview (4 Fragengruppen) und erstellt `specs/<feature>.md`.

**Nach Abschluss:**

```
Phase 2 abgeschlossen ✅

  Erstellt: specs/order-creation.md

  Zusammenfassung:
    Feature: Bestellungen erstellen und verwalten
    Akteure: Kunde, Admin
    Endpunkte: 5 (CRUD + Statusaenderung)
    Messaging: OrderCreatedEvent an RabbitMQ

  Naechste Phase: API designen
  → Der openapi-skill erstellt eine OpenAPI Spec basierend auf der Feature-Spec.

Weiter mit Phase 3?
```

Per `AskUserQuestion`:
- **Weiter mit Phase 3** – API Spec erstellen
- **Phase 2 wiederholen** – Weiteres Feature spezifizieren
- **Phase 3 ueberspringen** – Direkt zu Phase 4 (Code generieren)
- **Hier stoppen** – Spaeter weitermachen

---

### Phase 3 – API designen

**Ziel:** Eine OpenAPI Spec erstellen, die den API-Kontrakt definiert.

**Delegation an `openapi-skill` (Modus A: Neue Spec erstellen):**

Den `openapi-skill` im Modus "Neue Spec erstellen" ausfuehren.
Dabei die Informationen aus Phase 1 (Framework, Dienste) und Phase 2 (Feature-Spec) als Kontext uebergeben.

Falls in Phase 2 bereits Endpunkte und Datenmodelle definiert wurden, diese als Vorschlag anbieten
statt erneut abzufragen.

**Nach Abschluss:**

```
Phase 3 abgeschlossen ✅

  Erstellt: api/order-service.yaml (OpenAPI 3.1.0)

  Schemas:  CreateOrderRequest, OrderResponse, ErrorResponse
  Endpunkte: 5
    GET    /api/v1/orders
    POST   /api/v1/orders
    GET    /api/v1/orders/{id}
    PUT    /api/v1/orders/{id}
    DELETE /api/v1/orders/{id}

  Naechste Phase: Code generieren
  → Der java-scaffold-skill erstellt das Projekt, der openapi-skill generiert Code aus der Spec.

Weiter mit Phase 4?
```

Per `AskUserQuestion`:
- **Weiter mit Phase 4** – Projekt und Code generieren
- **Phase 3 wiederholen** – API Spec anpassen
- **Hier stoppen** – Spaeter weitermachen

---

### Phase 4 – Code generieren

**Ziel:** Das lauffaehige Projekt erstellen – Struktur, Code, Infra, Tests.

Diese Phase kombiniert zwei Skills:

**Schritt 4a – Projekt-Scaffolding (java-scaffold-skill):**
- `pom.xml`, BCE-Paketstruktur, Flyway, Docker, Health Checks
- `docker-compose.yml` mit den gewaehlten Diensten aus Phase 1
- Taikai-Architekturtests
- `renovate.json`, `.gitignore`

**Schritt 4b – Code aus API Spec (openapi-skill, Modus C):**
- DTOs in `entity/dto/` aus der OpenAPI Spec
- REST-Controller/Resources in `boundary/rest/`
- Service-Stubs in `control/`

**Nach Abschluss:**

```
Phase 4 abgeschlossen ✅

  Generiert:
    ✅ pom.xml             – Spring Boot, PostgreSQL, Spring AMQP
    ✅ BCE-Paketstruktur   – boundary/, control/, entity/
    ✅ Taikai-Tests        – Architekturregeln als Unit-Tests
    ✅ Flyway              – db/migration/ mit initialer Migration
    ✅ Health Check        – /actuator/health
    ✅ Dockerfile          – Multi-Stage Build
    ✅ docker-compose.yml  – PostgreSQL, RabbitMQ
    ✅ REST-Endpunkte      – 5 Endpunkte aus der API Spec
    ✅ DTOs                – 3 Records mit Validierung
    ✅ Service-Stubs       – Business-Logik Platzhalter

  Starten mit:
    docker compose up -d && ./mvnw spring-boot:run

Weiter mit Phase 5 (Zusammenfassung)?
```

---

### Phase 5 – Zusammenfassung und naechste Schritte

**Ziel:** Ueberblick ueber alles, was erstellt wurde, und Empfehlungen fuer die naechsten Schritte.

```
Projekt order-service – Setup abgeschlossen ✅

Erstellte Artefakte:
  specs/order-creation.md          – Feature-Spezifikation
  api/order-service.yaml           – OpenAPI 3.1.0 Spec
  pom.xml                          – Spring Boot 4.x Projekt
  src/main/java/...                – BCE-Struktur mit 5 Endpunkten
  src/test/java/...                – Architekturtests
  docker-compose.yml               – PostgreSQL, RabbitMQ
  Dockerfile                       – Multi-Stage Build

Empfohlene naechste Schritte:
  1. docker compose up -d           – Infrastruktur starten
  2. ./mvnw spring-boot:run         – Anwendung starten
  3. Service-Stubs implementieren   – Business-Logik in control/
  4. Flyway-Migrationen anpassen    – Tabellen fuer Entities
  5. /review-skill                  – Code-Review durchfuehren
  6. /doc-skill                     – Projektdokumentation erstellen
```

---

## Phasen-Steuerung

### Ueberspringen von Phasen

Der Coworker erkennt automatisch, welche Phasen uebersprungen werden koennen:

| Wenn vorhanden | Phase ueberspringbar |
|----------------|---------------------|
| `pom.xml` | Phase 1 + 4a (Scaffolding) |
| `specs/*.md` | Phase 2 (Spec) |
| `api/*.yaml` | Phase 3 (API Design) |
| Klassen in `boundary/rest/` | Phase 4b (Code aus Spec) |

### Wiederholen von Phasen

Jede Phase kann wiederholt werden – z.B. um ein weiteres Feature zu spezifizieren
oder die API Spec zu erweitern. Der Coworker fragt nach jeder Phase explizit.

### Abbrechen und Fortsetzen

Der Coworker kann nach jeder Phase gestoppt werden. Beim naechsten Aufruf
erkennt die Bestandsaufnahme (Schritt 0), wo der Entwickler aufgehoert hat.

---

## References

| Datei | Beschreibung |
|-------|-------------|
| `.claude/lessons-learned.md` | Erkenntnisse und Korrekturen |
| `.claude/skills/spec-feature-skill/SKILL.md` | Feature-Spezifikation (Phase 2) |
| `.claude/skills/openapi-skill/SKILL.md` | API Design + Code-Generierung (Phase 3 + 4b) |
| `.claude/skills/java-scaffold-skill/SKILL.md` | Projekt-Scaffolding (Phase 4a) |
| `.claude/skills/review-skill/SKILL.md` | Code-Review (empfohlener naechster Schritt) |
| `.claude/skills/doc-skill/SKILL.md` | Projektdokumentation (empfohlener naechster Schritt) |

---

## Conventions

- **Sprache:** Deutsch in der Interaktion, Englisch im Code
- **Phasen-Uebergaenge:** Immer per `AskUserQuestion` bestaetigen lassen
- **Delegation:** Bestehende Skills nutzen, nicht deren Logik duplizieren
- **Kontext weitergeben:** Informationen aus frueheren Phasen in spaetere Phasen uebergeben
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via coworker-skill`

### Position im Workflow

```
[coworker-skill]          ◀ Orchestriert den gesamten Workflow
        │
        ├── [spec-feature-skill]     Phase 2
        ├── [openapi-skill]          Phase 3 + 4b
        ├── [java-scaffold-skill]    Phase 4a
        │
        └── empfiehlt danach:
            ├── [review-skill]       Code-Review
            └── [doc-skill]          Dokumentation
```
