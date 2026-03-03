# Von der Idee zum lauffähigen Projekt in unter 10 Minuten

**Wie ein DevContainer-Template den Projekteinstieg radikal vereinfacht – mit optionaler KI-Unterstützung.**

---

Kennt ihr das? Neues Projekt, und erstmal eine Stunde damit verbringen, die pom.xml zusammenzubauen, Docker Compose zu konfigurieren, Flyway einzurichten, Health Checks nicht zu vergessen, den Architekturtest aufzusetzen … und dabei beten, dass die Dependency-Versionen zusammenpassen.

Was wäre, wenn das in unter 10 Minuten erledigt wäre – inklusive lauffähiger Infrastruktur?

Genau dafür haben wir ein **DevContainer-Template** gebaut. Es kombiniert einen vorkonfigurierten Entwicklungscontainer mit optionalen KI-Skills, die wiederkehrende Aufgaben automatisieren. Das Template ist ein Fork-basiertes Repository: Ihr forkt es, öffnet es in VS Code, und habt sofort eine produktionsnahe Entwicklungsumgebung.

---

## Was steckt drin?

Das Template bringt einen vollständigen Stack mit – alles vorkonfiguriert, alles lokal:

| Was | Technologie |
|-----|-------------|
| Sprache | Java 25 |
| Frameworks | Spring Boot 4.x **oder** Quarkus 3.31+ |
| Datenbank | PostgreSQL 17 |
| Messaging | RabbitMQ 4 |
| Auth | Keycloak 26 |
| Build | Maven 3.9 |
| Architektur-Tests | Taikai (basiert auf ArchUnit) |
| Infrastruktur | Docker Compose – ein Befehl, alles läuft |

Die gesamte lokale Infrastruktur startet mit:

```bash
docker compose up -d
```

Danach sind PostgreSQL, RabbitMQ und Keycloak sofort erreichbar – mit Health Checks, Management-UIs und vorkonfigurierten Credentials für die Entwicklung.

---

## Der Happy Path: Von Null zum lauffähigen Service

So sieht der typische Ablauf aus, wenn ein neues Projekt entsteht:

### Schritt 1 – Fork und Container starten

```bash
# Repository forken (GitHub UI) und klonen
git clone git@github.com:meine-org/mein-service.git
code mein-service
# → "Reopen in Container" wählen
```

Nach 3–5 Minuten steht die Entwicklungsumgebung. Java, Maven, Docker-in-Docker, alle CLI-Tools – alles da.

### Schritt 2 – Projekt aufsetzen

Hier kommt die optionale KI-Unterstützung ins Spiel. Im Claude Code Terminal einfach beschreiben, was man braucht:

```
Erstelle ein neues Spring Boot Projekt
```

Das Template fragt dann strukturiert nach:
- **groupId** – z.B. `com.example.orders`
- **artifactId** – z.B. `order-service`
- **Welche Dienste?** – PostgreSQL, RabbitMQ, Keycloak (nur was wirklich gebraucht wird)

Danach wird generiert:

```
order-service/
├── pom.xml                          ← aktuelle Versionen, automatisch geprüft
├── docker-compose.yml               ← nur bestätigte Services, mit Health Checks
├── renovate.json                    ← automatische Dependency-Updates
├── Dockerfile                       ← Multi-Stage Build
├── src/main/java/.../
│   ├── boundary/rest/               ← Controller
│   ├── control/                     ← Services
│   ├── entity/                      ← JPA-Entities, Repositories
├── src/main/resources/
│   ├── application.properties       ← Framework-spezifisch vorkonfiguriert
│   └── db/migration/V1__initial.sql ← Flyway-Migration
└── src/test/java/.../
    └── ArchitectureTest.java        ← BCE-Regeln via Taikai
```

**Alles in einem Schritt.** Kein Copy-Paste aus alten Projekten, keine vergessenen Dependencies.

### Schritt 3 – Feature spezifizieren (optional)

Bevor Code geschrieben wird, kann eine Feature-Spec erstellt werden:

```
Ich möchte ein neues Feature spezifizieren
```

Ein strukturiertes Interview führt durch 4 Fragengruppen – Kontext, Verhalten, technische Hinweise, Akzeptanzkriterien. Das Ergebnis ist eine Markdown-Datei in `specs/`, die als gemeinsame Sprache zwischen Fachlichkeit und Code dient.

### Schritt 4 – Bauen und Starten

```bash
docker compose up -d              # Infrastruktur
./mvnw clean package              # Build
./mvnw spring-boot:run            # oder: quarkus:dev
```

Health Check:
```bash
curl http://localhost:8080/actuator/health
# → {"status":"UP"}
```

Swagger UI öffnen: http://localhost:8080/swagger-ui.html

**Das war's.** Ein produktionsnahes Setup mit Health Checks, Flyway-Migrationen, Architektur-Tests und Swagger UI – in unter 10 Minuten.

---

## Die Skills im Überblick

Das Template enthält spezialisierte Skills – kleine Wissensmodule, die Claude Code steuern. Sie sind keine Magie, sondern **kodifiziertes Teamwissen**: Architektur-Konventionen, Lessons Learned, Best Practices.

```
Idee / Anforderung
      │
      ▼
┌─────────────────┐
│ Spec-Skill      │  Feature strukturiert beschreiben
└────────┬────────┘
         ▼
┌─────────────────┐
│ OpenAPI-Skill   │  REST-Endpunkte aus API-Spec generieren (optional)
└────────┬────────┘
         ▼
┌─────────────────┐
│ Scaffold-Skill  │  Projektstruktur, Infra, Config, Tests
└────────┬────────┘
         ▼
┌─────────────────┐
│ Review-Skill    │  Code gegen Konventionen prüfen
└────────┬────────┘
         ▼
┌─────────────────┐
│ Doc-Skill       │  Projektdokumentation aus Quellcode erstellen
└─────────────────┘
```

Jeder Skill folgt einem einheitlichen Format und ist als Markdown-Datei einsehbar – kein Black-Box-Verhalten. Was die Skills tun, steht in `.claude/skills/` – transparent und nachvollziehbar.

---

## Was macht das Template besonders?

### Versionspflicht statt Versionschaos

Dependency-Versionen werden **nie aus dem Gedächtnis** verwendet. Vor jeder Generierung werden aktuelle Versionen von Maven Central abgefragt. Zusätzlich bekommt jedes Projekt:
- **versions-maven-plugin** für lokale Versionsabfragen (`./mvnw versions:display-dependency-updates`)
- **renovate.json** für automatische Update-PRs

### Architektur-Regeln sind Tests

Das BCE-Pattern (Boundary / Control / Entity) wird nicht nur empfohlen – es wird **getestet**. Jedes generierte Projekt enthält einen Taikai-basierten Architekturtest, der bei jedem Build prüft:
- Controller nur in `boundary/rest/`
- Services nur in `control/`
- Entities nur in `entity/`
- Keine Schichtverletzungen

### Datenbank-Zugriff im Chat

Über MCP (Model Context Protocol) kann Claude direkt die laufende PostgreSQL-Datenbank abfragen:

```
Zeige alle Produkte mit einem Preis über 50
```

Das wird automatisch in SQL übersetzt und ausgeführt – praktisch für schnelle Datenexploration während der Entwicklung.

### Lessons Learned als lebende Wissensbasis

Erkenntnisse und Korrekturen werden in `.claude/lessons-learned.md` festgehalten und vor jeder Generierung geprüft. Beispiele:
- Quarkus `@Incoming`-Consumer brauchen `@Blocking` bei DB-Zugriff
- `ddl-auto=create` ist verboten – immer Flyway
- Dev Services müssen pro Extension deaktiviert werden

Das ist **Teamwissen, das nicht vergessen wird**.

---

## "Muss ich dafür KI nutzen?"

**Nein.** Das Template funktioniert auch ohne Claude Code. Der DevContainer bringt Java, Maven und Docker mit – alles da, um manuell loszulegen. Die Skills sind eine optionale Beschleunigung, kein Zwang.

Wer neugierig ist, kann klein anfangen:
1. Fork erstellen und Container starten
2. `docker compose up -d` – Infrastruktur läuft
3. Im Terminal `claude` eingeben und einen ersten Prompt ausprobieren

Oder einfach die Skills lesen – sie sind gut strukturierte Markdown-Dateien, die auch ohne KI als Checklisten und Architektur-Guidelines funktionieren.

---

## Wie komme ich ran?

```bash
# 1. Fork erstellen (GitHub UI)
# 2. Klonen und öffnen
git clone git@github.com:<deine-org>/<dein-repo>.git
code <dein-repo>
# 3. "Reopen in Container" – fertig.
```

Weiterführende Docs:
- [Setup-Anleitung](setup.md) – Fork, Umgebungsvariablen, Artifactory
- [Skills-Übersicht](skills.md) – alle Skills im Detail
- [MCP-Datenzugriff](mcp.md) – PostgreSQL und RabbitMQ im Chat
- [Template-Updates](template-updates.md) – Upstream-Sync für neue Features

---

*Das Template ist ein Gemeinschaftsprojekt. Feedback, neue Skills und Verbesserungsvorschläge sind willkommen – am besten als Issue oder Pull Request.*
