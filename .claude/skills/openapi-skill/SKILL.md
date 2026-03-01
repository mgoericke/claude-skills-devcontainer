---
name: openapi-skill
description: >
  Liest eine OpenAPI-Spezifikation (YAML oder JSON) ein und generiert daraus typsichere
  REST-Endpunkte (Controller / Resource) und DTOs (Java Records) im BCE-Pattern.
  Verwende diesen Skill wenn eine OpenAPI-Spec vorhanden ist und daraus Java-Code generiert
  werden soll – auch bei Formulierungen wie "generiere Code aus der OpenAPI Spec",
  "erstelle Endpunkte aus der API-Beschreibung" oder "implementiere die REST-API laut Spec".
  Dieser Skill ist OPTIONAL – nur wenn eine OpenAPI-Spec existiert oder übergeben wird.
---

# OpenAPI Skill

Generiert typsichere REST-Endpunkte und DTOs aus einer OpenAPI 3.x Spezifikation.
Ergebnis sind Java-Klassen im **BCE-Pattern** (boundary/rest + entity/dto).

> **Philosophie:** Die OpenAPI Spec ist der Vertrag. Der generierte Code ist dessen
> Erfüllung – nicht umgekehrt. Nie vom Spec abweichen, auch wenn es scheinbar einfacher wäre.

---

## Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[openapi-skill]           wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, Infra – REST/DTOs NICHT nochmal generieren
        ↓
[doc-skill]               Projektdokumentation
```

**Wichtig für java-scaffold-skill:** Wenn openapi-skill bereits ausgeführt wurde, die
`boundary/rest/` und `entity/dto/` Klassen **nicht** erneut generieren – nur den Rest
des Projektrahmens (pom.xml, docker-compose, application.properties, Flyway, Architekturtest).

---

## ⚠️ Pflichtabfrage

Vor der Generierung – sofern nicht bereits bekannt:

| # | Frage | Hinweis |
|---|-------|---------|
| 1 | **Pfad zur OpenAPI Spec** | `.yaml`, `.yml` oder `.json`; relativ zum Projekt-Root |
| 2 | **Framework** | `Spring Boot` oder `Quarkus` |
| 3 | **groupId / Paket** | z.B. `com.example.orders` |
| 4 | **DTO-Stil** | `Java Record` (Standard) oder `Klasse mit Lombok` |
| 5 | **Security-Annotationen einbauen?** | Ja → `@RolesAllowed` / `@PreAuthorize` aus Spec-Security-Section |

---

## Ablauf

### Schritt 1 – Spec lesen und analysieren

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

### Schritt 2 – Zusammenfassung ausgeben

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

### Schritt 3 – Code generieren

Reihenfolge: DTOs zuerst, dann Endpunkte.

---

## Generierungsregeln

### DTOs (entity/dto/)

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

### REST-Endpunkte (boundary/rest/)

Gruppierung nach **OpenAPI-Tag**: Ein Tag → eine Klasse.
Kein Tag → Klasse nach erstem Pfadsegment benennen (`/orders/*` → `OrderResource`).

#### Spring Boot Controller

```java
// Template: templates/spring/Controller.java.template
@RestController
@RequestMapping("/pfad")
@Validated
public class {{TAG}}Controller {

    private final {{TAG}}Service {{tag}}Service;

    // Konstruktor-Injection

    @GetMapping("/{id}")
    public ResponseEntity<{{ResponseDTO}}> findById(@PathVariable Long id) {
        // TODO: Service-Aufruf
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

#### Quarkus Resource

```java
// Template: templates/quarkus/Resource.java.template
@Path("/pfad")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class {{TAG}}Resource {

    @Inject
    {{TAG}}Service {{tag}}Service;

    @GET
    @Path("/{id}")
    public {{ResponseDTO}} findById(@PathParam("id") Long id) {
        // TODO: Service-Aufruf
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

### Service-Stub

Für jeden Controller/Resource wird ein passender **leerer Service-Stub** in `control/`
angelegt – mit den Methodensignaturen aus der Spec, aber ohne Implementierung:

```java
@ApplicationScoped  // Quarkus
// @Service          // Spring Boot
public class {{TAG}}Service {
    // TODO: Implementierung
    public {{ResponseDTO}} findById(Long id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
```

---

## Konventionen

- **Sprache:** Englisch im Code, Deutsch in Javadoc-Kommentaren
- **Package:** `{{GROUP_ID}}.boundary.rest` (Endpunkte), `{{GROUP_ID}}.entity.dto` (DTOs), `{{GROUP_ID}}.control` (Service-Stubs)
- Kein Hibernate / JPA in DTOs – das sind reine Transfer-Objekte
- Keine Business-Logik im Controller/Resource – nur Delegation an Service
- `UnsupportedOperationException` als Placeholder – signalisiert "noch nicht implementiert"
- Co-Author-Hinweis in jeder generierten Datei:
  ```java
   * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via openapi-skill
  ```

---

## Unterstützte OpenAPI Features

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
