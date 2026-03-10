# AI-gestütztes Scaffolding: Projekt-Setup in Minuten statt Stunden

**Wie DevContainer und Claude Code Skills das Java-Bootstrapping revolutionieren**

---

Docker Compose aufsetzen, Maven konfigurieren, die richtige Java-Version installieren, Flyway einbinden, Health Checks nicht vergessen – war das jetzt `ddl-auto=validate` oder `ddl-auto=create`?

Mit DevContainern und AI-gestützten Skills dauert das keine fünf Minuten. Egal ob produktives Microservice-Projekt oder schneller Prototyp.

---

## Schnellstart: Einfach mal ausprobieren

**API Key setzen** (optional – alternativ `claude login` im DevContainer):

```bash
# auf dem Host in ~/.zshrc oder ~/.bashrc
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Repo clonen und in VS Code öffnen:**

```bash
git clone git@github.com:<deine-org>/claude-skills-devcontainer.git
code claude-skills-devcontainer
# → "Reopen in Container" wählen – fertig nach ~3–5 Min.
```

**Loslegen:**

```
Erstelle ein neues Spring Boot Projekt
```

Claude fragt nach `groupId`, `artifactId` und den benötigten Diensten – dann wird alles generiert: Projektstruktur, Konfiguration, Dockerfile, Architekturtests.

Das war's. Kein manuelles Setup. Keine vergessenen Konventionen.

---

## Was steckt dahinter?

### Das Template: Technische Vorgaben und Konventionen in einem

Das Template ist kein leerer Startpunkt. Es definiert klare technische Vorgaben, wie Anwendungen generiert werden – und liefert nebenbei auch Unternehmenskonventionen mit:

- **Base Image, Java-Version, Git** – festgelegt im `devcontainer.json`, nicht "installier mal Java 25"
- **Docker-in-Docker** – Container bauen und `docker compose` direkt im DevContainer nutzen
- **BOM und Dependency-Versionen** – der `java-scaffold-skill` fragt aktuelle Versionen live ab und generiert eine `pom.xml` mit `versions-maven-plugin` und `renovate.json`
- **Architektur-Vorgaben** – BCE-Pattern, Taikai-Architekturtests, Flyway statt ddl-auto
- **Infrastruktur** – PostgreSQL, RabbitMQ, Keycloak per `docker compose up -d` startklar
- **Health Checks** – `/actuator/health` (Spring) oder `/q/health` (Quarkus) sind Pflicht

Alles liegt unter Versionskontrolle. **Definiert, kontrollierbar, wiederholbar.** Änderungen sind im Git-Log nachvollziehbar und per Fork-Workflow auf alle Projekte verteilbar.

### Claude Code Skills: Team-Wissen kodifiziert

Skills in `.claude/skills/` bringen Claude Code bei, wie das Team arbeitet. Keine vagen Prompts, sondern kodifiziertes Wissen:

| Skill | Was er tut |
|-------|-----------|
| `java-scaffold-skill` | Generiert Projekte, Entities, Dockerfiles, **AI Services** nach Team-Konventionen |
| `spec-feature-skill` | Erfragt fachliche Requirements per Interview, erstellt Specs |
| `openapi-skill` | Erstellt, erweitert oder implementiert OpenAPI Specs per Interview |
| `review-skill` | Prüft Code gegen Architektur-Regeln und Best Practices |
| `doc-skill` | Erstellt und aktualisiert Projektdokumentation |
| `infografik-skill` | Generiert Infografiken per Hugging Face API |
| `blog-post-skill` | Erstellt technische Blog Posts (wie diesen hier) |
| `frontend-skill` | Baut Web-UIs: Dashboards (TailAdmin), Landing Pages (Tailwind CSS) |

Neben den Skills bringt das Template auch einen **MCP Server für PostgreSQL** mit. Damit lassen sich Datenbankinhalte direkt im Chat abfragen – in natürlicher Sprache, ohne SQL-Client zu öffnen.

Die Skills sind nicht generisch. Sie kennen den Stack des Teams. Der `java-scaffold-skill` weiß, dass Flyway Pflicht ist, dass Health Checks dazugehören, dass Taikai-Architekturtests in jedes Projekt müssen.

Die Konventionen stehen in der `CLAUDE.md` – für Mensch und Maschine lesbar:

```markdown
## Coding-Standards
- **Architektur**: BCE-Pattern (Boundary / Control / Entity)
- **Architekturtests**: Taikai – bei jedem neuen Projekt anlegen (PFLICHT)
- **Health Checks**: Jede Anwendung muss /actuator/health bereitstellen (PFLICHT)
- **Persistenz**: Flyway – kein ddl-auto=create
```

### Der Tech Stack

| Schicht | Technologie |
|---------|-------------|
| Java | 25 (Microsoft OpenJDK) |
| Frameworks | Spring Boot 4.x oder Quarkus 3.31+ |
| Datenbank | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (Spring AMQP / SmallRye) |
| Build | Maven 3.9 |
| Architektur-Tests | Taikai (ArchUnit) |
| Auth / IAM | Keycloak 26.x |
| AI (Entwickler-Tool) | Claude Code |
| AI (in der Anwendung) | Quarkus LangChain4j (OpenAI, Ollama, Anthropic) + PgVector |

### Lokale Modelle und Datensouveränität

Ein wichtiger Punkt für viele Unternehmen: Bei der Nutzung der Anthropic Cloud API werden Prompts, Kontext und **Quellcode** an externe Server gesendet. Für sensible Projekte, interne Architekturen oder regulierte Umgebungen ist das keine Option.

Das Template unterstützt deshalb auch lokale Modelle – etwa über **Ollama** oder **LM Studio**. Die Konfiguration erfolgt über zwei Umgebungsvariablen, kein Code-Umbau nötig:

```bash
export ANTHROPIC_BASE_URL="http://host.docker.internal:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
```

Der Code verlässt dann nie den Rechner. Auch Self-Hosted-Deployments im Unternehmensnetz sind möglich. Skills, `CLAUDE.md` und der gesamte Workflow funktionieren identisch – unabhängig davon, ob das Modell in der Cloud oder lokal läuft.

---

## Was kann ich damit machen?

### Neues Projekt aufsetzen

```
> Erstelle ein neues Spring Boot Projekt für einen Order-Service

Claude: Bevor ich das Projekt generiere, brauche ich ein paar Angaben:

  groupId?        com.acme
  artifactId?     order-service
  Dienste?        PostgreSQL, RabbitMQ

Claude generiert das Projekt …

✅ pom.xml             – Spring Boot 4.0.3, PostgreSQL-Driver, Spring AMQP
✅ BCE-Paketstruktur   – boundary/, control/, entity/
✅ Taikai-Tests        – Architekturregeln als Unit-Tests
✅ Flyway              – db/migration/ mit initialer Migration
✅ Health Check         – /actuator/health inkl. DB- und RabbitMQ-Indicator
✅ Dockerfile          – Multi-Stage Build im Projekt-Root
✅ docker-compose.yml  – PostgreSQL 17, RabbitMQ 4, Keycloak 26
✅ renovate.json       – Automatische Dependency-Updates
✅ application.yml     – Datasource, RabbitMQ-Connection, Flyway konfiguriert

Projekt order-service ist bereit. Starte mit:
  docker compose up -d && ./mvnw spring-boot:run
```

Claude fragt nur das Nötigste ab – alles andere kommt aus den Team-Konventionen im Template. Dependency-Versionen werden live abgefragt, nicht aus dem Gedächtnis.

### Prototypen in Minuten

Gerade für Prototypen und Proof of Concepts Gold wert. Statt einen halben Tag in Setup zu investieren, steht die lauffähige Basis in Minuten – mit einer Architektur, die auch trägt, wenn aus dem Prototyp ein produktives System wird.

### Features spezifizieren

```
Feature spezifizieren: Bestellungen per Event an RabbitMQ senden
```

Der `spec-feature-skill` führt ein strukturiertes Interview und erstellt eine Spezifikation in `specs/`. Erst danach wird Code geschrieben – auf Basis der Spec, nicht auf Basis von Annahmen.

### API designen

```
Erstelle eine neue API Spec für den Order-Service
```

Der `openapi-skill` führt durch ein Interview: Datenmodelle, Endpunkte, Auth-Schema. Am Ende steht eine valide OpenAPI 3.x Spec in `api/`. Bestehende Entities im Projekt werden erkannt und zur Übernahme angeboten. Aus der fertigen Spec kann direkt Java-Code generiert werden – DTOs, Controller, Service-Stubs.

### AI-Fachanwendungen mit LangChain4j

Seit dem letzten Update kann der `java-scaffold-skill` auch **AI-gestützte Fachanwendungen** generieren. Statt nur CRUD-Services zu bauen, lassen sich jetzt komplette LLM-Integrationen scaffolden:

```
> Erstelle ein neues Quarkus Projekt mit AI-Support (LangChain4j)

Claude: Welche AI-Features brauchst du?

  LLM-Provider?        OpenAI
  AI-Features?         Chat + Tools + RAG
  Vektorspeicher?      PgVector
  Fault Tolerance?     Ja

Claude generiert das AI-Projekt …

✅ pom.xml              – Quarkus 3.31+, LangChain4j BOM, PgVector, Fault Tolerance
✅ AI Service            – @RegisterAiService mit SystemMessage und ToolBox
✅ AI Tools              – @Tool-Klassen fuer Function Calling (DB-Zugriff)
✅ RAG Pipeline          – Document-Ingestion + RetrievalAugmentor mit PgVector
✅ Guardrails            – Input-Validierung gegen Prompt Injection
✅ REST-Endpunkt         – /ai/chat als JSON-API
✅ Fault Tolerance       – @Timeout, @Retry, @Fallback fuer Produktion
✅ docker-compose-ai.yml – pgvector/pgvector:pg17 + optionales Ollama
✅ Architekturtests      – AI Services in boundary/ai/, Tools in control/ai/
```

**7 AI-Profile** stehen zur Verfügung – von einem einfachen Chatbot bis hin zu agentic Workflows mit autonomen Agents:

| Profil | Beschreibung |
|--------|-------------|
| **Chat** | Einfacher AI Service mit System-/User-Prompt |
| **Chat + Tools** | Function Calling – das LLM greift auf Datenbank und REST-APIs zu |
| **Chat + RAG** | Dokumentensuche über PgVector (Retrieval Augmented Generation) |
| **Chat + Guardrails** | Ein-/Ausgabevalidierung gegen Prompt Injection |
| **Agentic** | Autonome Agents mit Workflow-Orchestrierung (Sequence, Parallel, Loop, Supervisor) |
| **Fault Tolerant** | Produktionsreifes Setup mit Retry, Timeout und Fallback |
| **Vollständig** | Alle Features kombiniert |

Die AI-Komponenten folgen dem gleichen BCE-Pattern wie der Rest der Anwendung:
- **AI Services** (`@RegisterAiService`) liegen in `boundary/ai/`
- **Tools, RAG, Guardrails** liegen in `control/ai/`
- **REST-Endpunkte** für den AI Service in `boundary/rest/`

Die Architekturtests erzwingen diese Struktur automatisch – ein `@Tool` in `boundary/rest/` lässt den Build fehlschlagen.

**Drei LLM-Provider** werden unterstützt:
- **OpenAI** (oder kompatible APIs wie vLLM, LM Studio)
- **Ollama** (lokal, ohne API-Key – perfekt für datensensible Projekte)
- **Anthropic** (Claude)

### Weitere Prompts zum Ausprobieren

```
Erstelle eine Fachanwendung mit Chatbot und RAG (Dokumentensuche)
```
```
Generiere einen AI Service mit Tool-Integration fuer mein Quarkus-Projekt
```
```
Erweitere die API in api/orders.yaml um einen Product-Endpunkt
```
```
Generiere Code aus der OpenAPI Spec api/openapi.yaml
```
```
Dokumentiere das Projekt
```
```
Erstelle eine Infografik zum Thema Microservice-Kommunikation
```

---

## Fazit

DevContainer machen die Umgebung reproduzierbar. Claude Code Skills machen die **Entscheidungen** reproduzierbar. Das Template liefert beides zusammen – technische Vorgaben und Konventionen, die nicht in einer Dokumentation verstauben, sondern im Repository leben: als `CLAUDE.md`, als Skills, als `lessons-learned.md`. Versioniert, reviewbar, und von einem AI-Assistenten ausführbar.

**Jedes neue Projekt im Team startet konventionskonform – nicht weil jemand daran gedacht hat, sondern weil es gar nicht anders geht.**

---

*Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via blog-post-skill*
