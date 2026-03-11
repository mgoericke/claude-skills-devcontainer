# Sub-Agents für Claude Code

Dieses Projekt nutzt spezialisierte Sub-Agents für **parallele Code-Reviews**, **Architektur-Validierung** und **AI-Service-Generierung**.

## Überblick

| Agent | Typ | Tools | Modell | Einsatz |
|-------|-----|-------|--------|---------|
| **security-reviewer** | Review (read-only) | Read, Grep, Glob, Bash | Sonnet | Nach Code-Änderungen |
| **architecture-reviewer** | Review (read-only) | Read, Grep, Glob, Bash | Sonnet | Nach Code-Änderungen |
| **performance-reviewer** | Review (read-only) | Read, Grep, Glob, Bash | Sonnet | Nach Code-Änderungen |
| **ai-service-generator** | Generator (full tools) | Read, Write, Edit, Bash, Glob, Grep | Sonnet | Neue AI-Services |

## Detaillierte Beschreibung

### 1. Security Reviewer

**Zweck**: Sicherheits-Analyse von Code-Änderungen

**Fokus**:
- Hardcodierte Secrets (API-Keys, Passwords, Tokens)
- Authentication & Authorization (Keycloak, JWT, RBAC)
- Input Validation & SQL-Injection Prävention
- API Security (CORS, CSP, Rate Limiting)
- Datenbank-Sicherheit (Encryption, SSL/TLS)
- Dependency Vulnerabilities (CVE-Check)
- LangChain4j & AI Security (Prompt Injection Prevention)

**Triggern**:
```bash
# Manuell
/agents  # Wähle "security-reviewer" → "Use now"

# Oder direkt
Use the security-reviewer to analyze the recent changes
```

**Output**: Strukturierte Sicherheits-Issues nach Severität (Kritisch → Warnung → Info)

---

### 2. Architecture Reviewer

**Zweck**: Architektur- und Design-Pattern-Validierung

**Fokus**:
- BCE-Pattern Einhaltung (Boundary/Control/Entity Separation)
- Paket-Struktur Validierung
- Taikai Architecture Tests
- AI-Service Architektur (boundary/ai, control/ai)
- Dependency-Richtung (keine Circular Dependencies)
- Transaktionale Grenzen (`@Transactional`, `@Blocking`)
- Exception-Handling Patterns

**Triggern**:
```bash
# Manuell
Use the architecture-reviewer to check the design

# Mit spezifischem Fokus
Use the architecture-reviewer to validate the new AI service structure
```

**Output**: Architektur-Violations mit genauen Datei-Lokationen und Fix-Vorschlägen

---

### 3. Performance Reviewer

**Zweck**: Performance-Analyse und Optimierungspotenziale

**Fokus**:
- N+1 Query Probleme
- Ineffiziente Datenbankqueries (SELECT *, fehlende Indizes, große Result-Sets)
- Blocking Operations in Reactive Context
- Memory Leaks & Ressourcenmanagement
- Reactive Pattern Violations (Uni/Multi, Backpressure)
- Collection & Loop Performance
- Caching Strategien
- HTTP & REST Performance
- LangChain4j & AI Performance

**Triggern**:
```bash
# Manuell
Use the performance-reviewer to find bottlenecks

# Mit Fokus
Use the performance-reviewer to check for N+1 queries and blocking operations
```

**Output**: Performance-Issues mit Impact-Analyse (z.B. "100 extra queries statt 1")

---

### 4. AI Service Generator

**Zweck**: Vollständige LangChain4j AI-Service-Generierung

**Leistungen**:
- Anforderungen klären (Service-Name, Funktionalität, LLM-Provider, Tools, RAG, Guardrails)
- Komplette Package-Struktur nach BCE-Pattern
- Boundary Layer (REST-Endpoint, DTOs, Input-Validierung)
- Control Layer (Service, Tools mit `@Tool`, RAG, Guardrails)
- Entity Layer (JPA-Entities, Repositories)
- Konfiguration (application.properties mit LLM-Config)
- Flyway-Migration für DB-Tabellen
- Umfassende Tests (Boundary, Service, Tools, Architecture)
- Taikai-Integration

**Triggern**:
```bash
# Interaktiv (empfohlen)
Use the ai-service-generator to create a new AI service

# Mit spezifischen Details
Use the ai-service-generator to create a DocumentAnalyzer AI service with RAG and Tools
```

**Output**: Kompletter, produktionsreifer AI-Service mit Tests und Migration

---

## Parallele Code-Review Workflow

### Szenario: Nach größeren Code-Änderungen

```
1. Code geschrieben/committet
2. Starte alle 3 Review-Agents parallel:

   Use the security-reviewer, architecture-reviewer, and
   performance-reviewer to analyze the recent changes

3. Jeder Agent arbeitet isoliert (eigener Context)
4. Alle 3 Reports kommen zurück
5. Issues priorisieren und fixen
```

### Performance-Vorteile

- **Security Review**: ~10-20s (Grep-basiert)
- **Architecture Review**: ~15-25s (AST-basiert)
- **Performance Review**: ~15-25s (Query-Pattern-Suche)
- **Parallel statt Sequential**: 15-25s statt 40-70s ✅

---

## AI-Service Generierung Workflow

### Szenario: Neuer Chatbot-Service mit RAG

```
1. Anforderung: "Erstelle einen Chatbot mit Document-Retrieval"

2. Agent klärt ab:
   - Service-Name: Chatbot
   - LLM-Provider: Anthropic (Claude)
   - Tools: DocumentSearch, UserContext
   - RAG: Ja (PgVector für Embeddings)
   - Guardrails: Rate-Limiting, Input-Validation

3. Agent generiert:
   ✅ boundary/ai/ChatbotBoundary.java
   ✅ boundary/ai/request/ChatRequest.java
   ✅ boundary/ai/response/ChatResponse.java
   ✅ control/ai/ChatbotService.java
   ✅ control/ai/ChatbotTools.java
   ✅ control/ai/ChatbotRAGService.java
   ✅ control/ai/ChatbotGuardrailService.java
   ✅ entity/ai/ChatHistory.java
   ✅ entity/ai/ChatDocument.java
   ✅ db/migration/V001__Create_chatbot_tables.sql
   ✅ Tests (BoundaryTest, ServiceTest, ToolsTest)
   ✅ application.properties mit LLM-Config
   ✅ ArchitectureTests Updates

4. Ready for local testing:
   docker compose up
   ./mvnw test
   # Service verfügbar auf /api/chatbot
```

---

## Best Practices

### Review-Agents Nutzen

✅ **Do**:
- Nach größeren Code-Änderungen (5+ Dateien) parallel reviewen
- Reviews vor PR-Creation durchführen
- Issues ernst nehmen und fixen, bevor ihr pusht
- Review-Output speichern (für Lessons-Learned)

❌ **Don't**:
- Reviews nur oberflächlich lesen
- Issues ignorieren und trotzdem pushen
- Zu häufig reviewen (nur bei signifikanten Änderungen)

### AI-Service-Generator Nutzen

✅ **Do**:
- Anforderungen klar formulieren (Intent, Provider, Features)
- Generated Code durchgehen und anpassen
- Tests schreiben/erweitern
- Mit generierten Entities arbeiten (nicht manuell ändern)

❌ **Don't**:
- Generator für kleine Features nutzen (overkill)
- Generated Code blindlings akzeptieren
- Manuelle Änderungen vor nächstem Generate durchführen

---

## Konfiguration

### Agents laden

Die Agents sind bereits in `.claude/agents/` definiert und werden automatisch geladen:

```bash
claude agents  # Zeige alle verfügbaren Agents
```

### Custom Agent erstellen

```bash
/agents  # Interaktives Menu
# → "Create new agent"
# → "Project-level" (speichert in .claude/agents/)
# → Details eingeben
```

### Agent-Konfiguration anpassen

Jeder Agent ist eine Markdown-Datei mit YAML-Frontmatter:

```yaml
---
name: security-reviewer              # Eindeutiger Name
description: Security specialist ... # Claude nutzt das zum Delegieren
tools: Read, Grep, Glob, Bash        # Verfügbare Tools
model: sonnet                         # Claude-Modell
permissionMode: default               # Permission-Handling
---

# Dann kommt der System-Prompt (Markdown)
```

---

## Troubleshooting

### "Agent wird nicht delegiert"

**Grund**: Description ist zu vague oder Agent-Name ist nicht eindeutig.

**Fix**:
```bash
/agents  # Edit Agent
# Description spezifischer schreiben: z.B. statt "Code review" →
# "Security specialist for code review. Analyzes for vulnerabilities..."
```

### "Agent hat nicht die richtige Antwort gegeben"

**Grund**: System-Prompt könnte präziser sein.

**Fix**:
```bash
.claude/agents/[agent-name].md  # Öffne direkt
# Erweitere Checklist oder gib mehr Context
# Beispiel: "Bei Review folgende Punkte prüfen: [Liste]"
```

### "Agent braucht mehr Tools"

**Grund**: `tools` Feld ist zu restriktiv.

**Fix**:
```yaml
tools: Read, Grep, Glob, Bash, Write  # Beispiel für Generator
```

---

## Memory & Lessons Learned

Nach jeder Session mit Agents sollten Erkenntnisse dokumentiert werden:

**Speichern in**: `.claude/lessons-learned.md`

**Beispiel**:
```markdown
## Sub-Agent Patterns

### Security-Reviewer erfolgreich eingesetzt für:
- JWT-Validierung Checks
- Secret-Detection
- CORS-Configuration Review

### Performance-Reviewer Issue:
- Findet N+1 Queries mit Grep gut
- Könnte bessere Context geben für DB-Indexes

### AI-Service-Generator Learnings:
- Funktioniert gut für Standalone Services
- Braucht manuelle Anpassung für Entity-Relationships
```

---

## Weitere Schritte

Nach Sub-Agents Implementierung:

1. **Hooks implementieren** (post-edit pom.xml, pre-prompt-submit)
2. **Agent-Teams einführen** (für massiv parallele Reviews)
3. **Memory-Persistierung** für Agents (`memory: user` oder `memory: project`)
4. **CI/CD Integration** (Tests + Reviews automatisiert)

---

## Links

- Agents Definitionsort: `.claude/agents/`
- Dokumentation: `code.claude.com/docs/en/sub-agents`
- Tutorial: Starte mit `/agents` → "Create new agent" → "Generate with Claude"
