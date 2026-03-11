# Sub-Agents Quick-Start Guide

Schneller Einstieg in die 4 Sub-Agents dieses Projekts.

## Installation

Die Agents sind bereits installiert in `.claude/agents/`:
- ✅ `security-reviewer.md`
- ✅ `architecture-reviewer.md`
- ✅ `performance-reviewer.md`
- ✅ `ai-service-generator.md`

Verifizieren:
```bash
claude agents  # Zeigt alle verfügbaren Agents
```

---

## Use Cases in 5 Minuten

### Szenario 1: Neue Feature implementiert (5 Dateien geändert)

```
1. Feature fertig, Code committet
2. Führe alle 3 Review-Agents aus:

Use the security-reviewer, architecture-reviewer, and
performance-reviewer to analyze my recent changes

3. Warte auf Reports (~20-30 Sekunden)
4. Lese Issues und fixe sie (falls vorhanden)
5. Committe Fixes
6. Ready for PR
```

**Was passiert**:
- Jeder Agent läuft isoliert in eigenem Context
- Security prüft auf Secrets, Auth, Injection
- Architecture prüft auf BCE-Violations
- Performance prüft auf N+1, Blocking
- Reports kommen parallel zurück

---

### Szenario 2: Neuer Chatbot-Service mit RAG

```
1. Product-Owner sagt: "Wir brauchen einen Chatbot mit Document-Retrieval"

2. Starte AI-Service-Generator:

Use the ai-service-generator to create a new Chatbot service
with Document Retrieval (RAG) and Tools integration

3. Agent stellt Fragen ab:
   - Service-Name? → Chatbot
   - LLM-Provider? → Anthropic Claude
   - Tools? → DocumentSearch, UserContext
   - RAG? → Ja, mit PgVector
   - Guardrails? → Ja, Rate-Limiting + Input-Validation

4. Agent generiert ~15 Dateien:
   ✅ REST-Endpoints
   ✅ DTOs
   ✅ Services + Tools
   ✅ Entities
   ✅ Flyway-Migration
   ✅ Tests
   ✅ application.properties

5. Ready to test:
   docker compose up
   ./mvnw test
   curl -X POST http://localhost:8080/api/chatbot -d '{"message":"Hallo"}'
```

**Was passiert**:
- Agent scaffoldet komplette, isolierte Package
- Alle Best-Practices (BCE-Pattern, @Blocking, Tests) bereits enthalten
- Code ist sofort produktionsreif

---

### Szenario 3: Nach Git-Merge Konflikt (zur Sicherheit)

```
1. Merge durchgeführt, Konflikte gelöst
2. Schneller Security-Check:

Use the security-reviewer to make sure we didn't accidentally
introduce any secrets or authentication issues after the merge

3. Bekomme sofortiges Feedback
```

---

## Command-Referenz

### Agents anzeigen
```bash
claude agents
# Zeigt:
# - Built-in Agents (Explore, Plan, General-Purpose)
# - Project Agents (.claude/agents/)
# - User Agents (~/.claude/agents/)
```

### Agent interaktiv verwalten
```bash
/agents  # Im Claude Code CLI
# Optionen: Create, Edit, Delete, View
```

### Agent direkt triggern
```
# Im Chat:
Use the [agent-name] to [task]

# Beispiele:
Use the security-reviewer to analyze the code
Use the architecture-reviewer to check the design
Use the performance-reviewer to find bottlenecks
Use the ai-service-generator to create a new service
```

### Mehrere Agents parallel
```
Use the security-reviewer, architecture-reviewer, and
performance-reviewer to analyze the changes

# Alle 3 laufen gleichzeitig!
```

---

## Output interpretieren

### Security-Reviewer Output

```
[KRITISCH] Hardcoded API Key detected
  Location: src/main/java/.../ChatbotService.java:42
  Issue: private static final String ANTHROPIC_KEY = "sk-ant-..."
  Risk: API-Key exposure in source code
  Fix: Move to environment variable

[WARNUNG] Missing input validation
  Location: src/main/java/.../ChatbotBoundary.java:28
  Issue: Request.message() nicht validiert
  Fix: Add @NotBlank on message field

[INFO] Consider CORS configuration
  Location: n/a
  Issue: CORS noch nicht konfiguriert
  Recommendation: Add @CrossOrigin or configure in application.properties
```

### Architecture-Reviewer Output

```
[VIOLATION] Entity imported by Boundary
  File: boundary/ChatbotBoundary.java:15
  Issue: import entity.ChatHistory (sollte nur DTOs sein)
  Fix: Erstelle ChatHistoryResponse DTO, nutze das stattdessen

[DESIGN] Circular dependency detected
  Files: control/ChatbotService.java ↔ control/ChatbotTools.java
  Issue: Service injiziert Tools, Tools injiziert Service
  Fix: Refaktor: Service ruft Tools auf, nicht umgekehrt

[BEST PRACTICE] Taikai test coverage
  Info: Neue Entities + Services hinzugefügt
  Recommendation: Update ArchitectureTests.java mit neuen Regeln
```

### Performance-Reviewer Output

```
[ISSUE] N+1 Query detected
  Location: control/ChatbotService.java:85
  Code: for (ChatHistory h : histories) { ... h.getUser().getId() }
  Impact: 100 histories = 101 queries statt 1
  Fix: Use fetch join: SELECT h FROM ChatHistory h JOIN FETCH h.user

[WARNING] Missing pagination
  Location: boundary/ChatbotBoundary.java:32
  Issue: getAllMessages() lädt alle Messages
  Recommendation: Add @QueryParam int page, int size

[OPTIMIZATION] Caching opportunity
  Info: DocumentSearch wird häufig mit gleichen Keywords aufgerufen
  Suggestion: Cache SearchResults für 5 Minuten
```

### AI-Service-Generator Output

```
Phase 1: Planning
  ✓ Service Name: Chatbot
  ✓ LLM Provider: Anthropic Claude (claude-opus-4-6)
  ✓ Tools: DocumentSearch, UserContext, SendNotification
  ✓ RAG: Enabled (PgVector for embeddings)
  ✓ Guardrails: Rate-Limiting (100 req/min), Input-Validation

Phase 2: Code Generation
  ✓ boundary/ai/ChatbotBoundary.java (REST-Endpoint)
  ✓ boundary/ai/request/ChatRequest.java (Input-DTO)
  ✓ boundary/ai/response/ChatResponse.java (Output-DTO)
  ✓ control/ai/ChatbotService.java (Orchestration)
  ✓ control/ai/ChatbotTools.java (LLM Tools)
  ✓ control/ai/ChatbotRAGService.java (Vector-Search)
  ✓ control/ai/ChatbotGuardrailService.java (Validation)
  ✓ entity/ai/ChatHistory.java (JPA Entity)
  ✓ entity/ai/ChatDocument.java (RAG Documents)

Phase 3: Infrastructure
  ✓ db/migration/V001__Create_chatbot_tables.sql
  ✓ application.properties (LLM Config)

Phase 4: Tests
  ✓ ChatbotBoundaryTest.java (REST Tests)
  ✓ ChatbotServiceTest.java (Service Tests)
  ✓ ChatbotToolsTest.java (Tool Tests)
  ✓ ArchitectureTests updated

Ready to use:
  docker compose up
  ./mvnw test
  curl -X POST http://localhost:8080/api/chatbot \
    -H "Content-Type: application/json" \
    -d '{"message":"Hello Chatbot"}'
```

---

## Best Practices

### Review-Agents richtig nutzen

✅ **Gut**:
```
# Groß genug für vollständigen Review
Use the security-reviewer to analyze the new authentication module

# Mehrere Agents parallel
Use all review agents to analyze my changes
```

❌ **Nicht optimal**:
```
# Zu klein (eine Zeile)
Use the security-reviewer to review this change

# Zu viel (ganze Codebase)
Use the security-reviewer to audit the entire project
```

### AI-Service-Generator richtig nutzen

✅ **Gut**:
```
# Klar und konkret
Use the ai-service-generator to create a DocumentAnalyzer service
with RAG integration and Tool support for database queries

# Mit Domain-Context
We need a RecommendationEngine that analyzes user behavior
and suggests products. Use the ai-service-generator to scaffold it.
```

❌ **Nicht optimal**:
```
# Zu vage
Use the ai-service-generator to create something with AI

# Unklare Anforderungen
Create an AI service (was soll es tun?)
```

---

## Häufige Fragen

### F: Werden die Agents meinen Code ändern?
**A**: Security, Architecture, Performance Agents sind **read-only**. Sie können nur lesen, nicht schreiben. Der AI-Service-Generator kann schreiben (neue Dateien generieren).

### F: Wie lange dauert ein Review?
**A**:
- Security-Review: ~10-15 Sekunden
- Architecture-Review: ~15-20 Sekunden
- Performance-Review: ~15-20 Sekunden
- Parallel: ~20-25 Sekunden (statt 45-55s Sequential)

### F: Kann ich die Agents selbst editieren?
**A**: Ja! `.claude/agents/[name].md` ist eine normale Markdown-Datei. Du kannst die Prompts anpassen:
```bash
# Edit direkt
vim .claude/agents/security-reviewer.md

# Oder via CLI
/agents → Edit → security-reviewer
```

### F: Was ist der Unterschied zu Manual Code Review?
**A**:
| Aspect | Agent | Manual |
|--------|-------|--------|
| Geschwindigkeit | ~20s | 30min+ |
| Konsistenz | 100% | ~70% (abhängig von Reviewer) |
| Gründlichkeit | Comprehensive | Selective |
| False Positives | ~5% | ~2% |
| Kosten | 1-2¢ | $500+ (zeitaufwand) |

**Best**: Kombination aus Agent + Manual Spot-Check!

### F: Kann ich Agents für andere Projekte nutzen?
**A**: Ja! Verschiebe die `.md`-Dateien zu:
```bash
~/.claude/agents/  # User-Level (alle Projekte)
```

Dann sind sie überall verfügbar.

---

## Troubleshooting

### Agent wird nicht delegiert

**Problem**: Claude nutzt Agent nicht automatisch.

**Lösung**:
1. Agent-Description präziser machen (`.claude/agents/[name].md`)
2. Oder direkt triggern: `Use the [name] agent to ...`

### Agent hat falsches Verhalten

**Problem**: Agent-Antwort ist nicht hilfreich.

**Lösung**:
1. Öffne `.claude/agents/[name].md`
2. Anpasse System-Prompt (Markdown-Teil nach YAML)
3. Addiere spezifischere Anweisungen/Checklisten
4. Speichere und versuche erneut

### Agent braucht mehr Tools

**Problem**: Agent kann bestimmte Checks nicht machen (z.B. Tests laufen).

**Lösung**:
1. Öffne `.claude/agents/[name].md`
2. Ändere `tools:` Feld:
   ```yaml
   tools: Read, Grep, Glob, Bash  # Füge "Bash" hinzu für ./mvnw test
   ```

---

## Nächste Schritte

1. **Ausprobieren**: Schreib Code → triggere Reviews
2. **Feedback einbauen**: Issues aus Reviews fixen
3. **Customize**: Anpasse Agent-Prompts nach deinen Bedürfnissen
4. **Dokumentieren**: Speichere Learnings in `.claude/lessons-learned.md`

**Dann**: Hooks implementieren (Automatisierung) → Agent-Teams (massiv parallel)

---

## Support

- **Agents-Doku**: [docs/sub-agents.md](sub-agents.md)
- **Agents-Architektur**: [docs/agents-architecture.md](agents-architecture.md)
- **Claude Code Docs**: https://code.claude.com/docs/en/sub-agents
- **Questions**: Frag einfach im Chat: "How do sub-agents work?"
