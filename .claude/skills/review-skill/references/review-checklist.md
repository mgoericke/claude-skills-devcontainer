# Review-Prüfkatalog

Detaillierter Prüfkatalog für den review-skill.
Jede Regel enthält: Was geprüft wird, wie ein Verstoß aussieht und wie die Lösung ist.

---

## 1. Architektur – BCE-Pattern

### 1.1 Boundary-Schicht (`boundary/rest/`, `boundary/messaging/`)

| Regel | Verstoß | Lösung |
|-------|---------|--------|
| Controller/Resource ruft nur Services auf | Direkter Repository-Zugriff im Controller | Service-Methode erstellen, Controller delegiert |
| Keine Geschäftslogik im Controller | if/else-Ketten, Berechnungen im Controller | Logik in Service (Control) verschieben |
| `@Valid` an Request-Body-Parametern | `@RequestBody` ohne `@Valid` | `@Valid` ergänzen |
| REST-Klassen in `boundary/rest/` | Controller in falschem Package | In `boundary/rest/` verschieben |
| Messaging-Klassen in `boundary/messaging/` | Consumer in falschem Package | In `boundary/messaging/` verschieben |

### 1.2 Control-Schicht (`control/`)

| Regel | Verstoß | Lösung |
|-------|---------|--------|
| Services sind `@Service` (Spring) oder `@ApplicationScoped` (Quarkus) | Fehlende Annotation | Annotation ergänzen |
| `@Transactional` bei schreibenden Methoden | Schreibende DB-Operation ohne Transaction | `@Transactional` ergänzen |
| `readOnly = true` bei Lesemethoden (Spring) | Lese-Methode ohne `readOnly` | `@Transactional(readOnly = true)` |
| Kein direkter Zugriff auf HTTP-Artefakte | `HttpServletRequest` im Service | HTTP-Logik in Boundary belassen |

### 1.3 Entity-Schicht (`entity/`, `entity/dto/`)

| Regel | Verstoß | Lösung |
|-------|---------|--------|
| JPA-Entity mit `@Entity` und `@Table` | Fehlende Annotationen | Ergänzen |
| UUID als ID-Typ | `Long` oder `Integer` als ID | `UUID` verwenden |
| Timestamps: `createdAt`, `updatedAt` | Fehlende Audit-Felder | Felder mit `@CreationTimestamp`/`@UpdateTimestamp` ergänzen |
| DTOs als Java Records | DTO als Klasse statt Record | Als `record` umschreiben |
| Keine Geschäftslogik in Entities | Service-Methoden in Entity-Klasse | In Control-Schicht verschieben |

---

## 2. Lessons-Learned Abgleich

Referenz: `.claude/lessons-learned.md`

### 2.1 Quarkus-spezifisch

| Regel | Verstoß | Referenz |
|-------|---------|----------|
| `@Blocking @Transactional` bei `@Incoming` mit DB | `@Incoming` ohne `@Blocking` | Abschnitt "Quarkus – @Blocking im Consumer" |
| RabbitMQ: `rabbitmq-host`, nicht `quarkus.rabbitmq.*` | Falsche Property-Keys | Abschnitt "Quarkus – RabbitMQ Messaging Config" |
| Dev Services pro Extension deaktivieren | `quarkus.devservices.enabled=false` global | Abschnitt "DevContainer – Dev Services vs. Docker Compose" |
| Dockerfile in `src/main/docker/` | Dockerfile im Projekt-Root | Abschnitt "Quarkus – Dockerfile-Konvention" |
| Quarkus 3.31+ für Java 25 | Quarkus < 3.31 mit Java 25 | Abschnitt "Quarkus – Java 25 Kompatibilität" |

### 2.2 Spring Boot-spezifisch

| Regel | Verstoß | Referenz |
|-------|---------|----------|
| `ddl-auto=validate`, nie `create`/`update` | `ddl-auto=create` oder `update` | Abschnitt "Spring Boot – ddl-auto=validate" |
| Flyway-Migration für jede Entity | Entity ohne Migration in `db/migration/` | Abschnitt "Spring Boot – ddl-auto=validate" |
| Dockerfile im Projekt-Root | Dockerfile in `src/main/docker/` | Abschnitt "Quarkus – Dockerfile-Konvention" (Umkehrschluss) |

### 2.3 Framework-übergreifend

| Regel | Verstoß | Referenz |
|-------|---------|----------|
| Health Checks vorhanden | Keine Actuator/SmallRye-Health Dependency | Abschnitt "Health Checks sind Pflicht" |
| Taikai-Architekturtest vorhanden | Kein ArchitectureTest im Projekt | Abschnitt "Taikai vs. ArchUnit" |
| Co-Author im Javadoc | Generierte Datei ohne `@author Co-Author` | Abschnitt "Javadoc Co-Author Pflicht" |
| Fachlich neutrale Beispiele | Domänenspezifische Namen in Templates | Abschnitt "Fachlich neutrale Beispiele" |

---

## 3. Sicherheit

| Regel | Verstoß | Schwere |
|-------|---------|---------|
| Keine SQL-String-Konkatenation | `"SELECT * FROM x WHERE id = " + id` | Kritisch |
| Keine hartcodierten Secrets | `password = "geheim"` im Code | Kritisch |
| `@Valid` bei Request-Bodies | Fehlende Input-Validierung | Warnung |
| CORS nicht `*` in Produktion | `allowedOrigins("*")` ohne Profil-Trennung | Warnung |
| Swagger-UI in Security-Config freigegeben | 403 auf `/swagger-ui/**` | Hinweis |
| Keine sensiblen Daten in Logs | `log.info("Token: " + token)` | Kritisch |
| HTTPS/TLS bei externen Aufrufen | `http://` für externe APIs | Warnung |

---

## 4. Code-Qualität

| Regel | Verstoß | Schwere |
|-------|---------|---------|
| Keine Code-Duplikation | Gleiche Logik > 2x kopiert | Warnung |
| Keine leeren catch-Blöcke | `catch (Exception e) { }` | Warnung |
| Keine Magic Numbers/Strings | Hartcodierte Werte ohne Konstante | Hinweis |
| Unused Imports | Import ohne Verwendung | Hinweis |
| Methoden < 30 Zeilen | Überlange Methoden | Hinweis |
| Sinnvolle Variablennamen | `x`, `temp`, `data` als Variablennamen | Hinweis |
| Lombok sinnvoll | `@Data` auf Entity (ok), aber nicht auf DTOs (Records!) | Hinweis |

---

## 5. Konfiguration

| Datei | Regel | Verstoß |
|-------|-------|---------|
| `pom.xml` | `versions-maven-plugin` vorhanden | Plugin fehlt |
| `pom.xml` | Taikai als Test-Dependency | Fehlt oder falscher Scope |
| `renovate.json` | Datei im Projekt-Root | Datei fehlt |
| `application.properties` | Health-Endpunkte aktiviert | Actuator/SmallRye fehlt |
| `application.properties` | Flyway aktiviert | Flyway-Config fehlt |
| `docker-compose.yml` | Health Checks für alle Services | `healthcheck` Block fehlt |
| `Dockerfile` | `HEALTHCHECK` Direktive | Fehlt |

---

## 6. Tests

| Regel | Verstoß | Schwere |
|-------|---------|---------|
| Architekturtest (Taikai) vorhanden | Kein `ArchitectureTest.java` | Warnung |
| Service-Logik hat Unit-Tests | Neue Service-Methode ohne Test | Hinweis |
| Testklassen im richtigen Package | Test nicht im Spiegel-Package | Hinweis |
| Test-Naming: `should...When...` | Unklar benannte Testmethoden | Hinweis |

---

## 7. Sprache & Naming

| Regel | Verstoß |
|-------|---------|
| Code (Klassen, Methoden, Variablen): **Englisch** | Deutsche Bezeichner im Code |
| Kommentare, Javadoc: **Deutsch** | Englische Kommentare |
| Packages: lowercase, keine Unterstriche | `com.example.Order_Service` |
| Klassen: UpperCamelCase | `orderService` als Klassenname |
| Methoden: lowerCamelCase | `GetOrder` als Methodenname |
| Konstanten: UPPER_SNAKE_CASE | `maxRetries` als Konstante |
