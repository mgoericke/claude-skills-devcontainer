---
name: openapi-skill
description: Generiert typsichere REST-Endpunkte und DTOs aus einer OpenAPI 3.x Spezifikation im BCE-Pattern. Verwende diesen Skill wenn eine OpenAPI-Spec vorhanden ist und daraus Java-Code generiert werden soll.
argument-hint: "[spec-pfad]"
---

# OpenAPI Skill

Generiert typsichere REST-Endpunkte und DTOs aus einer OpenAPI 3.x Spezifikation.
Ergebnis sind Java-Klassen im **BCE-Pattern** (boundary/rest + entity/dto).

> **Philosophie:** Die OpenAPI Spec ist der Vertrag. Der generierte Code ist dessen
> Erfüllung – nicht umgekehrt. Nie vom Spec abweichen, auch wenn es scheinbar einfacher wäre.

---

## When to Use This Skill

- Eine OpenAPI-Spezifikation (YAML oder JSON) liegt vor und daraus soll Java-Code generiert werden
- REST-Endpunkte und DTOs sollen typsicher aus einer API-Beschreibung abgeleitet werden
- Formulierungen wie "generiere Code aus der OpenAPI Spec", "erstelle Endpunkte aus der API-Beschreibung", "implementiere die REST-API laut Spec"
- **Nicht verwenden**, wenn keine OpenAPI-Spec vorhanden ist – dann direkt `java-scaffold-skill` nutzen

## What This Skill Does

1. **Liest die OpenAPI Spec** – Pfade, Methoden, Schemas, Parameter, Security-Definitionen
2. **Erstellt eine Zusammenfassung** – Gefundene Endpunkte und Schemas zur Bestätigung
3. **Generiert DTOs** – Java Records in `entity/dto/` mit Validierungs-Annotationen aus der Spec
4. **Generiert REST-Endpunkte** – Controller (Spring) oder Resource (Quarkus) in `boundary/rest/`
5. **Generiert Service-Stubs** – Leere Service-Klassen in `control/` mit Methodensignaturen

## How to Use

```
Generiere Code aus der OpenAPI Spec in api/openapi.yaml
```

```
Erstelle REST-Endpunkte aus der API-Beschreibung specs/api.json
```

```
Implementiere die REST-API laut Spec für Quarkus
```

---

## Instructions

> **Vor jeder Ausführung**:
> 1. `.claude/lessons-learned.md` prüfen

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
| [templates/spring/Controller.java.template](templates/spring/Controller.java.template) | Spring Boot Controller-Template |
| [templates/quarkus/Resource.java.template](templates/quarkus/Resource.java.template) | Quarkus Resource-Template |
| [templates/Dto.java.template](templates/Dto.java.template) | DTO-Template (Java Record) |
| [templates/Service.java.template](templates/Service.java.template) | Service-Stub-Template |

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
[openapi-skill]           ◀ wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra – REST/DTOs NICHT nochmal generieren
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               Projektdokumentation
```

**Wichtig für java-scaffold-skill:** Wenn openapi-skill bereits ausgeführt wurde, die
`boundary/rest/` und `entity/dto/` Klassen **nicht** erneut generieren – nur den Rest
des Projektrahmens (pom.xml, docker-compose, application.properties, Flyway, Architekturtest).
