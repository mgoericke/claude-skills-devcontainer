# Sub-Agents Architecture Übersicht

## System-Architektur

```
┌─────────────────────────────────────────────────────────────────┐
│                    Claude Code Main Session                     │
├─────────────────────────────────────────────────────────────────┤
│  Conversation Context                                           │
│  - Code Changes / New Feature                                   │
│  - User Instructions                                            │
│  - CLAUDE.md + Skills                                           │
└──────────────┬──────────────────────────────────────────────────┘
               │
               │ Spawn when needed
               ↓
    ┌──────────────────────────┐
    │   Sub-Agent Dispatcher   │
    └──────────────────────────┘
          │         │         │         │
          ↓         ↓         ↓         ↓
    ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐
    │Security  │ │Archect.  │ │Perform.  │ │AI Service    │
    │Reviewer  │ │Reviewer  │ │Reviewer  │ │Generator     │
    │(Read)    │ │(Read)    │ │(Read)    │ │(Full Tools)  │
    └────┬─────┘ └────┬─────┘ └────┬─────┘ └──────┬───────┘
         │            │            │              │
         │ Isolated   │ Isolated   │ Isolated    │ Isolated
         │ Context    │ Context    │ Context     │ Context
         │            │            │              │
         │ Report 1   │ Report 2   │ Report 3    │ Generated
         └────┬───────┴────┬───────┴────┬────────┴──────┐
              │                         │               │
              └─────────┬───────────────┘               │
                        ↓                               ↓
            ┌──────────────────────────┐    ┌──────────────────┐
            │   Synthesized Results    │    │  Generated Code  │
            │   - Issues by Severity   │    │  - 15+ Files     │
            │   - Action Items         │    │  - Tests         │
            │   - Fix Suggestions      │    │  - Migration     │
            └──────────────────────────┘    └──────────────────┘
                        │                            │
                        │ Return to Main Session     │
                        │ + Keep Conversation        │
                        │ Clean & Focused            │
                        ↓
            ┌──────────────────────────┐
            │    Main Conversation     │
            │    - Issues zu fixa      │
            │    - Code zu integieren  │
            └──────────────────────────┘
```

---

## Detaillierte Agent Flows

### Flow 1: Parallele Code-Reviews

```
START: Code-Änderungen vorhanden
│
├─ Trigger: "Use the security-reviewer, architecture-reviewer,
│            and performance-reviewer to analyze the changes"
│
├─ PARALLEL EXECUTION (t=0 bis t=~25s):
│
├─┬─ Security-Reviewer                    time: 10-15s
│ │  Read: src/main/java/**/*.java
│ │  Grep: hardcoded secrets, API keys
│ │  Check: Auth, CORS, Input-Validation
│ │  Output: Security Issues Report
│ │
│ ├─ [Results ready at t=12s]
│
├─┬─ Architecture-Reviewer                time: 15-20s
│ │  Read: Package-Structure
│ │  Grep: Layer Violations, Imports
│ │  Analyze: Taikai Rules
│ │  Output: Architecture Violations
│ │
│ ├─ [Results ready at t=18s]
│
└─┬─ Performance-Reviewer                 time: 15-20s
  │  Read: SQL Queries, Loop Patterns
  │  Grep: N+1, DISTINCT, select *
  │  Check: Blocking, Reactive
  │  Output: Performance Issues
  │
  └─ [Results ready at t=20s]

SYNTHESIS (t=~25s):
│
├─ Combine all 3 reports
├─ Prioritize by severity
├─ Return to Main Session
│
END: Ready for fixes
```

### Flow 2: AI-Service Generierung

```
START: New AI Service Feature
│
├─ Trigger: "Use the ai-service-generator to create a Chatbot
│            service with RAG and Tools integration"
│
├─ PLANNING PHASE (isolated context):
│ │
│ ├─ Query requirements:
│ │  - Service Name? → Chatbot
│ │  - LLM Provider? → Anthropic
│ │  - Tools? → DocumentSearch, UserContext
│ │  - RAG? → Yes (PgVector)
│ │  - Guardrails? → Yes
│ │
│ └─ Plan package structure
│
├─ GENERATION PHASE (isolated context):
│ │
│ ├─ Boundary Layer (3 files):
│ │  - ChatbotBoundary.java (REST-Endpoint)
│ │  - request/ChatRequest.java (DTO)
│ │  - response/ChatResponse.java (DTO)
│ │
│ ├─ Control Layer (4 files):
│ │  - ChatbotService.java (Orchestration)
│ │  - ChatbotTools.java (@Tool Definitions)
│ │  - ChatbotRAGService.java (Vector-Search)
│ │  - ChatbotGuardrailService.java (Validation)
│ │
│ ├─ Entity Layer (2 files):
│ │  - ChatHistory.java (JPA Entity)
│ │  - ChatDocument.java (RAG Documents)
│ │
│ ├─ Infrastructure (3 files):
│ │  - V001__Create_chatbot_tables.sql (Flyway)
│ │  - application.properties (Config)
│ │  - Tests (3 Test classes)
│ │
│ └─ Generated: ~15 Files total
│
├─ VALIDATION PHASE:
│ │
│ ├─ Taikai Architecture Tests Updated
│ ├─ All imports correct (BCE-Pattern)
│ ├─ Tests compileable
│ │
│ └─ Ready-to-test state
│
END: Integration into main codebase

POST-GENERATION (Main Session):
│
├─ Review generated code (20-30 min)
├─ Customize business logic
├─ Add domain-specific details
├─ Run tests: ./mvnw test
├─ Commit: feat: add Chatbot AI service
│
END: Feature complete
```

---

## Context Management

### Sub-Agent Context

Jeder Sub-Agent hat **isolierten, frischen Context**:

```
┌─────────────────────────────────────────┐
│      Sub-Agent Isolated Context         │
├─────────────────────────────────────────┤
│ System Prompt (Agent-spezifisch)        │
│ CLAUDE.md (Projekt-Conventions)         │
│ Git Status (aktuelle Branch)             │
│ Skill Content (falls preloaded)         │
│ Tool Access (restricted)                │
│ Session ID (independent)                │
│ Permission Mode (agent-spezifisch)      │
└─────────────────────────────────────────┘

Größe: ~5-10k Tokens (abhängig von Codebase)
Dauer: 1-5 Minuten (depending on Task Complexity)
Cost: ~1-5¢ pro Agent (~0.3-1.5k output tokens)
```

### Main Session Context (Vor Sub-Agents)

```
┌─────────────────────────────────────────┐
│    Main Session Context (Erhalten)      │
├─────────────────────────────────────────┤
│ Conversation History                    │
│ User Instructions                       │
│ Project Context (CLAUDE.md, Skills)     │
│ Previous Decisions                      │
│ Full Tool Access                        │
│ Interactive Permissions                 │
└─────────────────────────────────────────┘
```

### Kontext Flow

```
Session Start:
  Main Context = ~20k tokens
         ↓
Sub-Agent Spawn (Security-Reviewer):
  - Main Context remains unchanged
  - Sub-Agent gets fresh ~5k token context
  - Independent execution
         ↓
Sub-Agent Returns Results (~1k summary tokens):
  - Appended to Main Context
  - User reads + decides
  - Main Context now ~21k tokens
         ↓
Repeat for other Sub-Agents:
  - Same isolation pattern
  - Parallel execution
  - Results synthesized
         ↓
Main Context grows to ~25-30k tokens
  - Still within reasonable limits
  - Full conversation history preserved
  - Ready for next task
```

---

## Tool Access Matrix

| Tool | Security | Architecture | Performance | AI-Generator |
|------|----------|--------------|-------------|--------------|
| Read | ✅ | ✅ | ✅ | ✅ |
| Grep | ✅ | ✅ | ✅ | ✅ |
| Glob | ✅ | ✅ | ✅ | ✅ |
| Bash | ✅ | ✅ | ✅ | ✅ |
| Write | ❌ | ❌ | ❌ | ✅ |
| Edit | ❌ | ❌ | ❌ | ✅ |
| Agent | ❌ | ❌ | ❌ | ❌ |

**Read-Only Agents**: Können nicht ändern, nur analysieren
**Generator**: Kann schreiben/editieren, für Scaffolding

---

## Performance Charakteristiken

### Execution Time

```
Sequential (ohne Parallelisierung):
  Security-Review:    15s
  Architecture-Review: 20s
  Performance-Review:  20s
  ───────────────────────
  Total: 55 seconds

Parallel (Sub-Agents):
  All 3 parallel: 25 seconds (2.2x schneller! 🚀)
```

### Token Usage

```
Pro Sub-Agent Review:
  Input:  ~500 tokens (codebase + prompt)
  Output: ~1000 tokens (report)
  Cost:   ~0.5¢

Alle 3 parallel:
  Total Cost: ~1.5¢ (vs. $$$ für Manual Review)

AI-Service Generator:
  Input:  ~1000 tokens
  Output: ~3000 tokens (15 files)
  Cost:   ~2-3¢
```

---

## Skalierung: Wenn es größer wird

### Jetzt (< 10 Agents)
```
✅ Sub-Agents in .claude/agents/
✅ Parallel Execution
✅ Manual Triggering
```

### Später (10-50 Agents)
```
✅ Use Agent Teams für massive Parallelisierung
✅ Specialized agent routing (Coordinator Agent)
✅ Shared Memory between Agents (persistent)
✅ Conditional delegation (bei spezifischen File-Types)
```

### Enterprise (50+ Agents)
```
✅ Plugin-basierte Agent Distribution
✅ Agent Marketplace für Reuse
✅ Central Agent Registry
✅ Permission Policies
✅ Cost Tracking & Optimization
```

---

## Error Handling & Recovery

```
Szenario: Sub-Agent schlägt fehl

1. Agent Crash:
   ├─ Claude erkennt Fehler
   ├─ Gibt Error-Report zurück
   └─ Main Session bleibt intakt ✅

2. Permission Denied:
   ├─ Agent kann Tool nicht nutzen
   ├─ Fallback zu eingeschränkten Tools
   └─ User wird informiert

3. Timeout (>5 min):
   ├─ Agent wird abgebrochen
   ├─ Partial results zurückgegeben
   ├─ Can be resumed
   └─ Cost wird nicht berechnet

4. Recovery:
   Resume Agent mit: "Continue that task"
   └─ Behält full context
```

---

## Monitoring & Debugging

### Agent Ausführung tracken

```bash
# Siehe aktuelle/abgeschlossene Agents
claude agents

# Agent Logs (lokal gespeichert)
~/.claude/projects/[project]/[sessionId]/subagents/
  ├── agent-[id-1].jsonl
  ├── agent-[id-2].jsonl
  └── agent-[id-3].jsonl
```

### Agent Debug-Output

```bash
# Im Claude Code CLI:
/debug agents
# oder
claude --verbose (zeigt Agent execution details)
```

---

## Best Practices Summary

| Aspekt | DO ✅ | DON'T ❌ |
|--------|--------|----------|
| **Triggering** | Gruppe von Agents parallel | Einen Agent auf Zeile in Loop |
| **Context** | Agents für große Tasks | Main-Conversation für alle |
| **Results** | Synthesize + Summarize | Alle Reports ungefiltert |
| **Customization** | Agent-Prompts anpassen | Neue Agents ständig erstellen |
| **Tools** | Begrenzte Tools für Focus | Alle Tools für jeden Agent |

---

## Nächste Stufen in der Automation

Geplante Features (nach Sub-Agents):

1. **Hooks** (Level 2)
   - post-edit pom.xml → Version-Check
   - pre-prompt-submit → Checklist

2. **Rules** (Level 2)
   - `.claude/rules/java.md` → Language-specific Guidelines
   - `.claude/rules/quarkus.md` → Framework-spezifisch

3. **Agent Teams** (Level 3)
   - Koordinierte Agents mit Kommunikation
   - Shared Task-Lists
   - Peer-to-Peer Feedback

4. **Plugins** (Level 4)
   - Agents + Skills als installierbare Packages
   - Sharing across Projekte/Teams
