---
name: java-scaffold-skill
description: Scaffolding fuer Java-Projekte mit Spring Boot oder Quarkus, PostgreSQL, RabbitMQ, LangChain4j AI und Docker. Generiert pom.xml, BCE-Paketstruktur, Flyway-Migrationen, Architekturtests (Taikai), Dockerfile und docker-compose. Unterstuetzt AI-Fachanwendungen mit LangChain4j (AI Services, Tools/Function Calling, RAG, Guardrails). Verwende diesen Skill bei neuen Java-Anwendungen, neuen Entities, Dockerfiles, docker-compose, Architekturtests, AI-Services oder AI-Integrationen – auch bei "erstelle ein neues Projekt", "scaffold", "neues Modul", "neue Entity", "AI Service", "Chatbot", "RAG", "LangChain4j".
argument-hint: "[framework] [beschreibung]"
---

# Java Scaffold Skill

Scaffolding für Java-Projekte mit Spring Boot oder Quarkus – inklusive AI-Support via LangChain4j.

> **Philosophie:** Vor jeder Generierung: lessons-learned.md prüfen + aktuelle Versionen
> im Internet abfragen – niemals veraltete Versionen aus dem Gedächtnis verwenden.

---

## What This Skill Does

1. **Fragt Projekt-Koordinaten ab** – groupId, artifactId, Framework (Spring Boot / Quarkus)
2. **Prüft aktuelle Versionen** – Spring Boot, Quarkus, Taikai, LangChain4j im Internet verifizieren
3. **Generiert Projektstruktur** – pom.xml, application.properties, docker-compose.yml
4. **Erstellt BCE-Schichten** – Entity, Repository, Service, Controller/Resource im BCE-Pattern
5. **Erstellt AI-Schichten** (optional) – AI Service, Tools, RAG, Guardrails via LangChain4j
6. **Erstellt Flyway-Migration** – Initiales SQL-Schema passend zur Entity
7. **Erstellt Infrastruktur** – Dockerfile, Health Checks, Swagger UI, Renovate-Config
8. **Erstellt Architekturtests** – Taikai-basierter ArchitectureTest (inkl. AI-Schicht-Regeln)

## How to Use

```
Erstelle ein neues Quarkus Projekt mit PostgreSQL und AI-Support (LangChain4j)
```

```
Erstelle eine Fachanwendung mit Chatbot und RAG (Dokumentensuche)
```

```
Erstelle ein neues Spring Boot Projekt mit PostgreSQL und RabbitMQ
```

```
Erstelle eine neue Entity "Product" mit Name und Preis
```

```
Generiere einen AI Service mit Tool-Integration fuer mein Quarkus-Projekt
```

---

## Instructions

> **Vor jeder Generierung**:
> 1. `.claude/lessons-learned.md` prüfen
> 2. **Aktuelle Versionen im Internet abfragen** (Maven Central / GitHub Releases) – niemals veraltete Versionen aus dem Gedächtnis verwenden!

### Schritt 1 – Pflichtabfrage

Vor jeder neuen Anwendung oder jedem Modul – sofern nicht bereits bekannt – **immer alle
folgenden Fragen stellen, bevor Code generiert wird**:

#### 1a – Projekt-Koordinaten

| # | Angabe | Beispiel |
|---|--------|---------|
| 1 | `groupId` | `com.example.orders` |
| 2 | `artifactId` | `order-service` |
| 3 | **Framework** | `Spring Boot` oder `Quarkus` |

#### 1b – OpenAPI Spec vorhanden? (optional)

**Vor dem Scaffold fragen:** Gibt es eine OpenAPI-Spezifikation für dieses Projekt?

- **Ja** → zuerst `openapi-skill` ausführen lassen; danach beim Scaffold
  `boundary/rest/` und `entity/dto/` **nicht** nochmal generieren – nur Rahmen
  (pom.xml, docker-compose, application.properties, Flyway, Architekturtest, Dockerfile).
- **Nein** → normal weitermachen, alle Schichten generieren.

#### 1c – Benötigte Dienste

Explizit abfragen, welche Dienste tatsächlich benötigt werden:

| Dienst | Abhängigkeit (Spring) | Abhängigkeit (Quarkus) | Standard |
|--------|----------------------|------------------------|---------|
| **Datenbank** (PostgreSQL) | `spring-boot-starter-data-jpa`, `postgresql`, `spring-boot-starter-flyway`, `flyway-database-postgresql` | `quarkus-hibernate-orm-panache`, `quarkus-jdbc-postgresql`, Flyway | Ja |
| **REST / Swagger UI** | `springdoc-openapi-starter-webmvc-ui` | `quarkus-smallrye-openapi` | **Ja** (immer bei REST) |
| **Messaging** (RabbitMQ) | `spring-boot-starter-amqp` | `quarkus-messaging-rabbitmq` | Nein |
| **Auth / IAM** (Keycloak) | `spring-boot-starter-oauth2-resource-server` | `quarkus-oidc` | Nein |

Nur bestätigte Dienste werden in `pom.xml`, `docker-compose.yml` und `application.properties`
aufgenommen. Nicht benötigte Dienste vollständig weglassen – keine auskommentierten Blöcke.

Nie raten oder Defaults verwenden – immer explizit fragen.

#### 1d – AI-Support (LangChain4j) – optional

**Fragen:** Soll die Anwendung AI-Funktionalität (LLM-Integration) enthalten?

Wenn **Ja**, folgende Details abfragen:

| # | Angabe | Optionen | Standard |
|---|--------|----------|---------|
| 1 | **LLM-Provider** | `OpenAI`, `Ollama` (lokal), `Anthropic` (Claude) | OpenAI |
| 2 | **AI-Features** | `Chat` (einfacher AI Service), `Tools` (Function Calling), `RAG` (Dokumentensuche), `Guardrails` (Ein-/Ausgabevalidierung), `Agents` (Agentic Workflows) | Chat |
| 3 | **RAG-Vektorspeicher** (nur bei RAG) | `PgVector` (PostgreSQL), `Chroma`, `Redis` | PgVector |
| 4 | **Fault Tolerance** (Produktion) | `Ja` / `Nein` | Nein |

**AI-Profil-Übersicht (Quarkus):**

| Profil | Beschreibung | Dependencies | Templates |
|--------|-------------|-------------|-----------|
| **Chat** | Einfacher AI Service mit System-/User-Prompt | `quarkus-langchain4j-{provider}` | AiService, AiResource |
| **Chat + Tools** | AI Service mit Function Calling (Datenbankzugriff, REST-Calls) | + keine extra Dep (Teil des Core) | + AiTool |
| **Chat + RAG** | AI Service mit Dokumentensuche (Vektordatenbank) | + `quarkus-langchain4j-pgvector` | + RagIngestion, RagRetriever |
| **Chat + Guardrails** | AI Service mit Ein-/Ausgabevalidierung | + keine extra Dep (Teil des Core) | + AiGuardrail |
| **Agentic** | Autonome Agents mit Workflow-Orchestrierung | + `quarkus-langchain4j-agentic` | Agent, AgentWorkflow |
| **Fault Tolerant** | Produktionsreifes Setup mit Retry/Timeout/Fallback | + `quarkus-smallrye-fault-tolerance` | AiServiceWithFaultTolerance, AiServiceFallback |
| **Vollständig** | Alle Features kombiniert | Alle oben | Alle Templates |

### Schritt 2 – Versionspruefung

Veraltete Dependency-Versionen fuehren zu Inkompatibilitaeten und Sicherheitsluecken. Daher vor jeder Code-Generierung die aktuellen Versionen im Internet pruefen:

| Artifact | Wo prüfen |
|----------|-----------|
| Spring Boot Parent POM | https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-parent |
| Quarkus BOM | https://mvnrepository.com/artifact/io.quarkus.platform/quarkus-bom |
| Taikai | https://central.sonatype.com/artifact/com.enofex/taikai |
| versions-maven-plugin | https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin |
| quarkus-langchain4j | https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-openai |

**Bekannte Versionen (Stand 2026-03-01 – immer im Internet verifizieren!):**

| Artifact | Version | Java 25 kompatibel |
|----------|---------|-------------------|
| Spring Boot | 4.0.3 | ✅ (volles Java 25 Support) |
| Quarkus | 3.31.4 | ✅ (volles Java 25 Support ab 3.31) |
| Taikai | 1.60.0 | ✅ |
| versions-maven-plugin | 2.21.0 | ✅ |
| quarkus-langchain4j | 1.8.0.CR1 | ✅ (vor Generierung prüfen!) |

> ⚠️ **Quarkus 3.27 (LTS) läuft zwar mit Java 25, produziert aber Warnungen.**
> Für Java 25 zwingend **Quarkus 3.31+** verwenden.

### Schritt 3 – Code generieren

Reihenfolge der Generierung:

1. `pom.xml` mit allen Dependencies, versions-maven-plugin, Taikai
2. `application.properties` (DB, Flyway, Health, ggf. Messaging, Auth, AI)
3. Entity + Repository (`entity/`)
4. Service (`control/`)
5. Controller/Resource (`boundary/rest/`)
6. Consumer (`boundary/messaging/`) – nur wenn RabbitMQ bestätigt
7. Security-Config – nur wenn Keycloak bestätigt
8. **AI Service** (`boundary/ai/`) – nur wenn AI-Support bestätigt
9. **AI Tools** (`control/ai/`) – nur wenn Tools bestätigt
10. **RAG-Komponenten** (`control/ai/`) – nur wenn RAG bestätigt
11. **Guardrails** (`control/ai/`) – nur wenn Guardrails bestätigt
12. **AI REST-Endpunkt** (`boundary/rest/`) – wenn AI-Support bestätigt
13. Flyway-Migration (`db/migration/V1__create_<entity>_table.sql`)
14. Architekturtest (`ArchitectureTest.java`) – inkl. AI-Schicht-Regeln bei AI-Support
15. Dockerfile (Spring: Root, Quarkus: `src/main/docker/Dockerfile.jvm`)
16. `docker-compose.yml` mit Health Checks (bei AI: `docker-compose-ai.yml` mit PgVector/Ollama)
17. `renovate.json`

### Schritt 3a – AI Dependencies (Quarkus + LangChain4j)

Bei AI-Support folgende Dependencies in die `pom.xml` aufnehmen:

**LLM Provider (genau EINEN wählen):**

| Provider | Dependency (groupId:artifactId) | Version |
|----------|-------------------------------|---------|
| **OpenAI** (oder kompatible API) | `io.quarkiverse.langchain4j:quarkus-langchain4j-openai` | Teil des Quarkiverse BOM |
| **Ollama** (lokal) | `io.quarkiverse.langchain4j:quarkus-langchain4j-ollama` | Teil des Quarkiverse BOM |
| **Anthropic** (Claude) | `io.quarkiverse.langchain4j:quarkus-langchain4j-anthropic` | Teil des Quarkiverse BOM |

**RAG – Vektorspeicher (nur bei RAG-Feature):**

| Speicher | Dependency | Hinweis |
|----------|-----------|---------|
| **PgVector** | `io.quarkiverse.langchain4j:quarkus-langchain4j-pgvector` | Nutzt vorhandene PostgreSQL-DB |
| **Easy RAG** | `io.quarkiverse.langchain4j:quarkus-langchain4j-easy-rag` | Einfachste Variante, auto-ingestion aus Verzeichnis |
| Chroma | `io.quarkiverse.langchain4j:quarkus-langchain4j-chroma` | Externer Service nötig |
| Redis | `io.quarkiverse.langchain4j:quarkus-langchain4j-redis` | Externer Service nötig |

**Agentic Workflows (nur bei Agents-Feature):**

| Feature | Dependency | Hinweis |
|---------|-----------|---------|
| Agentic | `io.quarkiverse.langchain4j:quarkus-langchain4j-agentic` | @Agent, Workflow-Patterns |
| MCP Client | `io.quarkiverse.langchain4j:quarkus-langchain4j-mcp` | Remote Tools via Model Context Protocol |

**Fault Tolerance (empfohlen für Produktion):**

| Feature | Dependency | Hinweis |
|---------|-----------|---------|
| Fault Tolerance | `io.quarkus:quarkus-smallrye-fault-tolerance` | @Timeout, @Retry, @Fallback |

**Quarkiverse BOM** – statt einzelner Versionen die BOM verwenden:
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.quarkiverse.langchain4j</groupId>
            <artifactId>quarkus-langchain4j-bom</artifactId>
            <version><!-- VOR GENERIERUNG PRÜFEN: https://mvnrepository.com/artifact/io.quarkiverse.langchain4j/quarkus-langchain4j-bom --></version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### Schritt 3b – AI Paketstruktur (BCE)

AI-Komponenten folgen dem BCE-Pattern mit dedizierten Sub-Paketen:

```
src/main/java/{{GROUP_ID}}/
├── boundary/
│   ├── ai/              ← AI Services (@RegisterAiService Interfaces)
│   ├── rest/            ← REST-Endpunkte (inkl. AI-Resource)
│   └── messaging/       ← RabbitMQ Consumer (optional)
├── control/
│   ├── ai/              ← AI Tools, RAG, Guardrails
│   └── ...              ← Fachliche Services
└── entity/
    └── ...              ← JPA Entities, DTOs
```

**Architekturregeln für AI-Schichten:**
- `@RegisterAiService` Interfaces → `boundary/ai/`
- `@Tool`-Klassen → `control/ai/`
- RAG-Komponenten (Ingestion, Retriever) → `control/ai/`
- Guardrails → `control/ai/`
- AI REST-Endpunkte → `boundary/rest/`

### Schritt 3c – AI application.properties

AI-spezifische Properties aus Template `templates/quarkus/ai/application-ai.properties` als Referenz nutzen.
**Beim Generieren nur den gewählten Provider einbinden** – das Template enthält alle drei Provider als Referenz,
aber in die generierte `application.properties` wird **nur** der gewählte Provider übernommen (ohne auskommentierte Alternativen).

Wichtige Konfiguration je nach Provider:

| Provider | API-Key Property | Model Property |
|----------|-----------------|---------------|
| OpenAI | `quarkus.langchain4j.openai.api-key` | `quarkus.langchain4j.openai.chat-model.model-name` |
| Ollama | (kein Key nötig) | `quarkus.langchain4j.ollama.chat-model.model-id` |
| Anthropic | `quarkus.langchain4j.anthropic.api-key` | `quarkus.langchain4j.anthropic.chat-model.model-name` |

**Dev Services bei AI deaktivieren** (echte Services via Docker Compose):
```properties
quarkus.langchain4j.ollama.devservices.enabled=false
```

### Schritt 4 – Swagger UI

Jede Anwendung mit REST-Endpunkten erhält eine **Swagger UI**:

| Framework | Dependency (groupId:artifactId) | Swagger-UI-URL | OpenAPI-JSON-URL |
|-----------|---------------------------------|---------------|-----------------|
| **Spring Boot** | `org.springdoc:springdoc-openapi-starter-webmvc-ui` | `/swagger-ui.html` | `/v3/api-docs` |
| **Quarkus** | `io.quarkus:quarkus-smallrye-openapi` | `/q/swagger-ui` | `/q/openapi` |

**Versionen vor Generierung im Internet prüfen:**
- Spring Boot: https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-starter-webmvc-ui
- Quarkus: Teil des Quarkus BOM – keine eigene Version nötig

**Wichtig bei Security (Spring Boot):** Die `SecurityConfig` muss Swagger-UI-Pfade explizit
freigeben (bereits im Template enthalten):
```java
.requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**").permitAll()
```

**Wichtig bei Quarkus:** `quarkus.swagger-ui.always-include=true` aktivieren, damit die
Swagger UI auch im Produktions-Modus (nicht nur `quarkus:dev`) verfügbar bleibt.

### Schritt 5 – Health Checks

Health-Endpunkte sind die Grundlage fuer Docker-Healthchecks und Kubernetes-Probes. Ohne sie kann weder Docker noch ein Orchestrator den Zustand der Anwendung pruefen:

| Framework | Endpunkt | Dependency |
|-----------|----------|-----------|
| Spring Boot | `/actuator/health` | `spring-boot-starter-actuator` |
| Quarkus | `/q/health/live`, `/q/health/ready` | `quarkus-smallrye-health` |

Health Checks werden verwendet in:
- `HEALTHCHECK` im Dockerfile
- `healthcheck` im `docker-compose.yml`

### Schritt 6 – Architekturtests

Architekturtests mit Taikai stellen sicher, dass die BCE-Schichtentrennung auch bei wachsendem Projekt erhalten bleibt. Template: `templates/arch/ArchitectureTest.java.template`

Bei AI-Projekten enthält der ArchitectureTest zusätzliche Regeln:
- `@RegisterAiService` Interfaces müssen in `boundary.ai` liegen
- `@Tool`-Klassen müssen in `control.ai` liegen

```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version><!-- VOR GENERIERUNG AKTUELLE VERSION PRÜFEN: https://central.sonatype.com/artifact/com.enofex/taikai --></version>
    <scope>test</scope>
</dependency>
```

### Schritt 7 – versions-maven-plugin

Das versions-maven-plugin ermoeglicht Entwicklern, veraltete Dependencies lokal zu erkennen – ergaenzt Renovate fuer den CI/CD-Workflow. In jeder `pom.xml` im `<build><pluginManagement>` Block konfigurieren:

```xml
<build>
  <pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>versions-maven-plugin</artifactId>
        <version><!-- AKTUELLE VERSION: https://mvnrepository.com/artifact/org.codehaus.mojo/versions-maven-plugin --></version>
        <configuration>
          <generateBackupPoms>false</generateBackupPoms>
        </configuration>
      </plugin>
    </plugins>
  </pluginManagement>
</build>
```

Nützliche Befehle für Entwickler:
```bash
./mvnw versions:display-dependency-updates
./mvnw versions:display-plugin-updates
./mvnw versions:display-parent-updates
```

### Schritt 8 – Renovate

Renovate erstellt automatisch Pull Requests fuer Dependency-Updates und haelt das Projekt aktuell. Jedes generierte Projekt erhaelt `renovate.json` aus `templates/renovate.json`.

---

## References

| Datei | Beschreibung |
|-------|-------------|
| `.claude/lessons-learned.md` | Erkenntnisse und Korrekturen – vor jeder Generierung prüfen |
| [templates/spring/](templates/spring/) | Spring Boot Templates (Entity, Controller, Service, Consumer, Security, Dockerfile, Properties, docker-compose) |
| [templates/quarkus/](templates/quarkus/) | Quarkus Templates (Entity, Resource, Service) + `src-main-docker/` für Dockerfiles |
| [templates/quarkus/ai/](templates/quarkus/ai/) | **Quarkus AI Templates** (AI Service, Tools, RAG, Guardrails, Properties, docker-compose) |
| [templates/arch/ArchitectureTest.java.template](templates/arch/ArchitectureTest.java.template) | Taikai-basierter Architekturtest (inkl. AI-Schicht-Regeln) |
| [templates/db/V1__create_table.sql.template](templates/db/V1__create_{{ENTITY_NAME_LOWER}}_table.sql.template) | Initiale Flyway-Migration |
| [templates/renovate.json](templates/renovate.json) | Renovate-Konfiguration für automatische Dependency-Updates |

### AI Templates (Quarkus + LangChain4j)

| Template | Paket | Beschreibung |
|----------|-------|-------------|
| [AiService.java.template](templates/quarkus/ai/AiService.java.template) | `boundary.ai` | Einfacher deklarativer AI Service (`@RegisterAiService`) |
| [AiServiceWithTools.java.template](templates/quarkus/ai/AiServiceWithTools.java.template) | `boundary.ai` | AI Service mit `@ToolBox` Integration |
| [AiServiceWithRag.java.template](templates/quarkus/ai/AiServiceWithRag.java.template) | `boundary.ai` | AI Service mit RAG (RetrievalAugmentor) |
| [AiTool.java.template](templates/quarkus/ai/AiTool.java.template) | `control.ai` | Tool-Klasse mit `@Tool` Annotation für Function Calling |
| [RagIngestion.java.template](templates/quarkus/ai/RagIngestion.java.template) | `control.ai` | Dokument-Ingestion beim Start (EmbeddingStore) |
| [RagRetriever.java.template](templates/quarkus/ai/RagRetriever.java.template) | `control.ai` | RetrievalAugmentor Supplier für PgVector |
| [AiGuardrail.java.template](templates/quarkus/ai/AiGuardrail.java.template) | `control.ai` | Input-/Output-Guardrails für Validierung |
| [Agent.java.template](templates/quarkus/ai/Agent.java.template) | `boundary.ai` | Autonomer Agent mit `@Agent` und `@ToolBox` |
| [AgentWorkflow.java.template](templates/quarkus/ai/AgentWorkflow.java.template) | `boundary.ai` | Workflow-Orchestrierung (Sequence, Parallel, Loop, Supervisor) |
| [AiServiceWithFaultTolerance.java.template](templates/quarkus/ai/AiServiceWithFaultTolerance.java.template) | `boundary.ai` | AI Service mit `@Timeout`, `@Retry`, `@Fallback` |
| [AiServiceFallback.java.template](templates/quarkus/ai/AiServiceFallback.java.template) | `control.ai` | Fallback-Handler bei LLM-Ausfällen |
| [AiResource.java.template](templates/quarkus/ai/AiResource.java.template) | `boundary.rest` | REST-Endpunkt `/ai/chat` für den AI Service |
| [application-ai.properties](templates/quarkus/ai/application-ai.properties) | – | AI-spezifische Properties (Provider, RAG, Guardrails) |
| [docker-compose-ai.yml](templates/quarkus/ai/docker-compose-ai.yml) | – | Docker Compose mit PgVector und optionalem Ollama |

### Platzhalter

| Platzhalter | Beispiel |
|-------------|---------|
| `{{GROUP_ID}}` | `com.example.orders` |
| `{{ARTIFACT_ID}}` | `order-service` |
| `{{PACKAGE_PATH}}` | `com/example/orders` |
| `{{ENTITY_NAME}}` | `Order` |
| `{{ENTITY_NAME_LOWER}}` | `order` |
| `{{CHANNEL_IN}}` | `orders-in` |
| `{{CHANNEL_OUT}}` | `orders-out` |
| `{{AI_SERVICE_NAME}}` | `OrderAssistant` |
| `{{TOOL_CLASS_NAME}}` | `OrderTools` |
| `{{TOOL_METHOD_NAME}}` | `findOrderById` |
| `{{RAG_INGESTION_CLASS}}` | `DocumentIngestion` |
| `{{RAG_RETRIEVER_CLASS}}` | `DocumentRetriever` |
| `{{INPUT_GUARDRAIL_NAME}}` | `InputValidator` |
| `{{AI_RESOURCE_NAME}}` | `AiResource` |
| `{{AGENT_NAME}}` | `OrderAgent` |
| `{{AGENT_DESCRIPTION}}` | `Bestellungs-Spezialist` |
| `{{AGENT_TASK_DESCRIPTION}}` | `Bearbeite die folgende Bestellanfrage` |
| `{{WORKFLOW_NAME}}` | `OrderWorkflow` |
| `{{DOMAIN_DESCRIPTION}}` | `Bestellverwaltung` |

---

## Conventions

- **Stack:** Java 25 · Spring Boot 4.x oder Quarkus 3.31+ · PostgreSQL 17 · RabbitMQ 4 · Keycloak 26.x · Maven 3.9 · Docker
- **AI-Stack:** Quarkus LangChain4j · OpenAI / Ollama / Anthropic · PgVector (RAG)
- **Architektur:** BCE-Pattern strikt (Boundary / Control / Entity)
- **AI-Architektur:** AI Services in `boundary/ai/`, Tools + RAG + Guardrails in `control/ai/`
- **Entities:** Lombok `@Data` + `@Builder` – `maven-compiler-plugin` muss Lombok als `annotationProcessorPath` konfigurieren
- **Persistenz:** Flyway für alle Migrationen – kein `ddl-auto=create`
- **Messaging:** RabbitMQ-Consumer immer in `boundary/messaging/`; Quarkus: `@Blocking` + `@Transactional` bei DB-Zugriffen im Consumer
- **AI Tools:** `@Blocking` + `@Transactional` bei Datenbankzugriffen in Tools
- **Dockerfile:** Spring Boot → `./Dockerfile` (Root); Quarkus → `src/main/docker/Dockerfile.jvm`
- **Docker Compose AI:** `pgvector/pgvector:pg17` statt `postgres:17-alpine` (PgVector Extension vorinstalliert)
- **Beispiele:** Fachlich neutral (`order`, `product`, `event`, `item`)
- **Sprache:** Deutsch in Kommentaren/Doku, Englisch im Code
- **Commits:** Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Co-Author:** `@author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill`

### Position im Workflow

```
[spec-feature-skill]      optional – fachliche Anforderungen
        ↓
[openapi-skill]           wenn OpenAPI Spec vorhanden
        ↓
[java-scaffold-skill]     Rahmen: DB, Messaging, AI, Infra
        ↓
[review-skill]            Code-Review
        ↓
[doc-skill]               Projektdokumentation
```
