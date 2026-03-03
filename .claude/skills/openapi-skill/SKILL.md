---
name: openapi-skill
description: Erstellt, erweitert und implementiert OpenAPI 3.x Spezifikationen. Verwende bei "erstelle eine API Spec", "erweitere die API", "neue OpenAPI Spec" oder "generiere Code aus der OpenAPI Spec".
argument-hint: "[api-name oder spec-pfad]"
---

# OpenAPI Skill

Erstellt, erweitert und implementiert OpenAPI 3.x Spezifikationen.
Unterstützt drei Modi: Spec **erstellen** (from scratch), Spec **erweitern** (bestehende Spec ergänzen)
und **Code generieren** (Java-Klassen im BCE-Pattern aus einer Spec).

> **Philosophie:** Die OpenAPI Spec ist der Vertrag. Ob sie erstellt, erweitert oder
> implementiert wird – der Vertrag steht im Mittelpunkt. Erst designen, dann bauen.

---

## When to Use This Skill

- Eine neue API soll designed und als OpenAPI Spec definiert werden
- Eine bestehende OpenAPI Spec soll um neue Endpunkte oder Schemas erweitert werden
- Eine OpenAPI-Spezifikation (YAML oder JSON) liegt vor und daraus soll Java-Code generiert werden
- Formulierungen wie "erstelle eine API Spec", "definiere die API", "erweitere die API", "generiere Code aus der OpenAPI Spec", "neue OpenAPI Spec"

## What This Skill Does

1. **Erkennt den Modus** – Spec erstellen, Spec erweitern oder Code generieren
2. **Erstellt OpenAPI Specs** – Per strukturiertem Interview: Datenmodelle, Endpunkte, Auth
3. **Erweitert bestehende Specs** – Liest vorhandene Spec ein, fügt neue Paths/Schemas hinzu
4. **Generiert Code aus Specs** – DTOs, REST-Endpunkte und Service-Stubs im BCE-Pattern

## How to Use

```
Erstelle eine neue API Spec für einen Order-Service
```

```
Erweitere die API in api/orders.yaml um einen Product-Endpunkt
```

```
Generiere Code aus der OpenAPI Spec in api/openapi.yaml
```

```
Definiere eine REST-API für Bestellungen und Produkte
```

---

## Instructions

> **Vor jeder Ausführung**:
> 1. `.claude/lessons-learned.md` prüfen

### Schritt 0 – Modus erkennen (PFLICHT)

**Mit `AskUserQuestion` abfragen – BEVOR das Interview startet.**

```
Was möchtest du tun?
```

Optionen:
- **Neue Spec erstellen** – Eine neue OpenAPI Spec from scratch designen
- **Bestehende Spec erweitern** – Neue Endpunkte oder Schemas zu einer vorhandenen Spec hinzufügen
- **Code aus Spec generieren** – Java-Code (DTOs, Controller, Services) aus einer bestehenden Spec erzeugen

Je nach Modus zu den entsprechenden Schritten springen:
- **Neue Spec erstellen** → Schritt A1–A4
- **Bestehende Spec erweitern** → Schritt B1–B4
- **Code aus Spec generieren** → Schritt 1–4 (bestehendes Verhalten)

---

### Modus A: Neue Spec erstellen

#### Schritt A1 – Grundlagen (PFLICHT)

**Mit `AskUserQuestion` abfragen:**

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **API-Name** | Kurzer Name, wird zum Dateinamen: `api/<name>.yaml` |
| 2 | **Beschreibung** | Ein Satz: Was macht diese API? |
| 3 | **Base Path** | z.B. `/api/v1` – Default: `/api/v1` |

**Zweite Frage per `AskUserQuestion`:**

```
Welches Auth-Schema soll die API verwenden?
```

Optionen:
- **Bearer JWT (Empfohlen)** – Standard für Keycloak / OAuth2-basierte Systeme
- **API Key** – Einfach, für interne Services
- **OAuth2** – Vollständiger OAuth2-Flow mit Scopes
- **Keine Authentifizierung** – Öffentliche API

#### Schritt A2 – Datenmodelle (PFLICHT)

**Zuerst:** Bestehende Entities im Projekt scannen (Verzeichnisse `entity/`, `entity/model/`, `entity/dto/`).

Falls Entities gefunden werden, per `AskUserQuestion` (multiSelect) anbieten:

```
Im Projekt wurden folgende Entities gefunden. Welche sollen in die API übernommen werden?
```

Optionen: gefundene Entity-Klassen auflisten (max. 4, Rest per "Other").

**Dann:** Für jedes neue Datenmodell interaktiv abfragen:

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **Schema-Name** | PascalCase, z.B. `Order`, `Product`, `OrderItem` |
| 2 | **Felder** | Name, Typ (`string`, `integer`, `number`, `boolean`, `array`, `$ref`), required? |
| 3 | **Beziehungen** | Referenzen auf andere Schemas (`$ref: '#/components/schemas/...'`) |

Wiederhole die Abfrage bis der Benutzer signalisiert, dass alle Modelle definiert sind.

**Request/Response-Varianten:** Für jedes Schema prüfen, ob separate Request- und Response-Varianten nötig sind (z.B. `CreateOrderRequest` ohne `id`, `OrderResponse` mit `id` und Timestamps).

#### Schritt A3 – Endpunkte (PFLICHT)

Pro Datenmodell per `AskUserQuestion` abfragen:

```
Welche Operationen soll die Ressource [SchemaName] unterstützen?
```

Optionen (multiSelect):
- **CRUD-Set (Empfohlen)** – GET (Liste + Detail), POST, PUT, DELETE
- **Nur Lesen** – GET (Liste + Detail)
- **Erstellen + Lesen** – POST + GET
- **Individuell definieren** – Eigene Endpunkte angeben

Für jeden Endpunkt definieren:
- HTTP-Methode + Pfad (aus Ressource ableiten: `/orders`, `/orders/{id}`)
- Request Body (Verweis auf Schema aus A2)
- Response Body + Status Codes (200, 201, 204, 400, 404)
- Query-Parameter (Pagination: `page`, `size`, Filterung)

#### Schritt A4 – Bestätigung und Generierung

Kompakte Zusammenfassung ausgeben:

```
API: Order Service (v1.0.0)
Auth: Bearer JWT
Base: /api/v1

Schemas (4):
  CreateOrderRequest, OrderResponse, ProductResponse, ErrorResponse

Endpunkte (5):
  GET    /api/v1/orders          → OrderResponse[]
  POST   /api/v1/orders          → OrderResponse
  GET    /api/v1/orders/{id}     → OrderResponse
  GET    /api/v1/products        → ProductResponse[]
  GET    /api/v1/products/{id}   → ProductResponse

Datei: api/order-service.yaml

Generieren?
```

**Erst nach Bestätigung** die YAML-Datei generieren. Template: `templates/openapi-spec.yaml.template`.

Nach der Generierung fragen:

```
Soll direkt Code aus der neuen Spec generiert werden?
```

Falls ja → weiter mit Schritt 1–4 (Code generieren).

---

### Modus B: Bestehende Spec erweitern

#### Schritt B1 – Spec einlesen

Pfad zur bestehenden Spec abfragen (falls nicht als Argument übergeben).
Spec einlesen und analysieren:

```
Bestehende Spec: api/orders.yaml (v1.0.0)

Vorhandene Schemas (3):
  CreateOrderRequest, OrderResponse, ErrorResponse

Vorhandene Endpunkte (3):
  GET    /api/v1/orders
  POST   /api/v1/orders
  GET    /api/v1/orders/{id}
```

#### Schritt B2 – Neue Datenmodelle

Wie Schritt A2, aber zusätzlich bestehende Schemas als Referenz anzeigen.
Bestehende Schemas können in `$ref`-Verweisen der neuen Schemas genutzt werden.

#### Schritt B3 – Neue Endpunkte

Wie Schritt A3, aber nur für neue Ressourcen oder zusätzliche Operationen auf bestehenden Ressourcen.

#### Schritt B4 – Bestätigung und Merge

Zusammenfassung zeigt nur die **neuen** Elemente:

```
Neue Schemas (2):
  ProductResponse, CreateProductRequest

Neue Endpunkte (2):
  GET    /api/v1/products        → ProductResponse[]
  POST   /api/v1/products        → ProductResponse

Bestehende Spec wird erweitert: api/orders.yaml

Fortfahren?
```

Bestehende YAML einlesen, neue Paths und Schemas hinzufügen, Datei überschreiben.
Bestehende Pfade und Schemas bleiben unverändert.

---

### Modus C: Code aus Spec generieren

### Schritt 1 – Pflichtabfrage

Vor der Generierung – sofern nicht bereits bekannt:

Wenn der Skill mit Argumenten aufgerufen wird (`/openapi-skill api/openapi.yaml`), wird `$ARGUMENTS` als Spec-Pfad verwendet.

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **Pfad zur OpenAPI Spec** | `.yaml`, `.yml` oder `.json`; relativ zum Projekt-Root. Entfällt wenn als `$ARGUMENTS` übergeben. |
| 2 | **Framework** | `Spring Boot` oder `Quarkus` |
| 3 | **groupId / Paket** | z.B. `com.example.orders` |
| 4 | **DTO-Stil** | `Java Record` (Standard) oder `Klasse mit Lombok` |
| 5 | **Security-Annotationen einbauen?** | Ja → `@RolesAllowed` / `@PreAuthorize` aus Spec-Security-Section |

### Schritt 2 – Spec lesen und analysieren

Die OpenAPI Spec einlesen und folgendes extrahieren:

| Was | Woher |
|-----|-------|
| Alle Pfade + Methoden (GET, POST, PUT, DELETE, PATCH) | `paths` |
| Request-Bodies (Schema-Referenzen) | `requestBody.content.*.schema` |
| Response-Schemas (alle Status-Codes) | `responses.*.content.*.schema` |
| Path- und Query-Parameter | `parameters` |
| Schema-Definitionen | `components/schemas` |
| Security-Definitionen | `components/securitySchemes` + `security` je Operation |
| Tags | `tags` – werden zur Gruppenbildung genutzt |

### Schritt 3 – Zusammenfassung ausgeben

Vor der Code-Generierung eine kurze Übersicht ausgeben und bestätigen lassen:

```
Gefundene Endpunkte: 5
Gefundene Schemas (DTOs): 4
Framework: Quarkus
Paket: com.example.orders

Geplante Dateien:
  boundary/rest/OrderResource.java      (3 Endpunkte: GET /orders, POST /orders, GET /orders/{id})
  boundary/rest/ProductResource.java    (2 Endpunkte: GET /products, GET /products/{id})
  entity/dto/OrderRequest.java          (Record)
  entity/dto/OrderResponse.java         (Record)
  entity/dto/ProductResponse.java       (Record)
  entity/dto/ErrorResponse.java         (Record)

Fortfahren?
```

### Schritt 4 – Code generieren

Reihenfolge: DTOs zuerst, dann Endpunkte, dann Service-Stubs.

#### DTOs (entity/dto/)

- **Standard: Java Record** – immutabel, kein Boilerplate
- Lombok-Variante nur auf explizite Anfrage
- Feldnamen 1:1 aus der Spec übernehmen (camelCase)
- Nullable Felder: `@Nullable` (JSpecify) + `Optional<T>` nur bei explizitem Bedarf
- Validierungs-Annotationen aus Spec übernehmen:
  - `minLength` / `maxLength` → `@Size`
  - `minimum` / `maximum` → `@Min` / `@Max`
  - `required` → `@NotNull` / `@NotBlank`
  - `pattern` → `@Pattern`
- Enum-Werte aus der Spec als eigene `enum`-Typen im selben Paket

**Namenskonvention:**

| Spec-Schema | Java-Klasse |
|-------------|-------------|
| `OrderRequest` | `OrderRequest.java` (Record) |
| `OrderResponse` | `OrderResponse.java` (Record) |
| `CreateOrderRequest` | `CreateOrderRequest.java` (Record) |
| Anonymes Inline-Schema | Eigener, sprechender Name ableiten |

#### REST-Endpunkte (boundary/rest/)

Gruppierung nach **OpenAPI-Tag**: Ein Tag → eine Klasse.
Kein Tag → Klasse nach erstem Pfadsegment benennen (`/orders/*` → `OrderResource`).

**Spring Boot Controller:**
```java
@RestController
@RequestMapping("/pfad")
@Validated
public class {{TAG}}Controller {
    private final {{TAG}}Service {{tag}}Service;
    // Konstruktor-Injection
    @GetMapping("/{id}")
    public ResponseEntity<{{ResponseDTO}}> findById(@PathVariable Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

**Quarkus Resource:**
```java
@Path("/pfad")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class {{TAG}}Resource {
    @Inject
    {{TAG}}Service {{tag}}Service;
    @GET
    @Path("/{id}")
    public {{ResponseDTO}} findById(@PathParam("id") Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

#### Service-Stub (control/)

Für jeden Controller/Resource wird ein passender **leerer Service-Stub** angelegt:

```java
@ApplicationScoped  // Quarkus
// @Service          // Spring Boot
public class {{TAG}}Service {
    public {{ResponseDTO}} findById(Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

---

## References

| Datei | Beschreibung |
|-------|-------------|
| `.claude/lessons-learned.md` | Erkenntnisse und Korrekturen |
| [templates/openapi-spec.yaml.template](templates/openapi-spec.yaml.template) | OpenAPI Spec Template (Modus A/B) |
| [templates/spring/Controller.java.template](templates/spring/Controller.java.template) | Spring Boot Controller-Template (Modus C) |
| [templates/quarkus/Resource.java.template](templates/quarkus/Resource.java.template) | Quarkus Resource-Template (Modus C) |
| [templates/Dto.java.template](templates/Dto.java.template) | DTO-Template (Java Record, Modus C) |
| [templates/Service.java.template](templates/Service.java.template) | Service-Stub-Template (Modus C) |

### Unterstützte OpenAPI Features

| Feature | Unterstützt | Hinweis |
|---------|-------------|---------|
| OpenAPI 3.0.x / 3.1.x | ✅ | |
| `$ref` auf `components/schemas` | ✅ | Wird aufgelöst |
| Inline-Schemas | ✅ | Name wird abgeleitet |
| `oneOf` / `anyOf` / `allOf` | ⚠️ | Vereinfacht zu Interface oder gemeinsamer Basisklasse |
| Path-Parameter | ✅ | |
| Query-Parameter | ✅ | |
| Header-Parameter | ✅ | |
| Request Body | ✅ | |
| Response Body | ✅ | Nur 2xx-Responses |
| Security (`bearer`, `oauth2`) | ✅ | → `@RolesAllowed` / `@PreAuthorize` wenn aktiviert |
| Multipart / File Upload | ⚠️ | `MultipartFormDataInput` (Quarkus) / `MultipartFile` (Spring) |
| Webhooks | ❌ | Nicht unterstützt |

---

## Conventions

- **Sprache:** Englisch im Code, Deutsch in Javadoc-Kommentaren
- **Packages:** `{{GROUP_ID}}.boundary.rest` (Endpunkte), `{{GROUP_ID}}.entity.dto` (DTOs), `{{GROUP_ID}}.control` (Service-Stubs)
- Kein Hibernate / JPA in DTOs – das sind reine Transfer-Objekte
- Keine Business-Logik im Controller/Resource – nur Delegation an Service
- `UnsupportedOperationException` als Placeholder – signalisiert "noch nicht implementiert"
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via openapi-skill`

### Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[openapi-skill]           ◀ Spec erstellen ODER erweitern ODER Code generieren
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra – REST/DTOs NICHT nochmal generieren
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               Projektdokumentation
```

**Wichtig für java-scaffold-skill:** Wenn openapi-skill bereits Code generiert hat, die
`boundary/rest/` und `entity/dto/` Klassen **nicht** erneut generieren – nur den Rest
des Projektrahmens (pom.xml, docker-compose, application.properties, Flyway, Architekturtest).
