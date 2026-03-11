# Sub-Agents Architecture Overview

## System Architecture

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
            │    - Issues to fix       │
            │    - Code to integrate   │
            └──────────────────────────┘
```

---

## Detailed Agent Flows

### Flow 1: Parallel Code Reviews

```
START: Code changes present
│
├─ Trigger: "Use the security-reviewer, architecture-reviewer,
│            and performance-reviewer to analyze the changes"
│
├─ PARALLEL EXECUTION (t=0 to t=~25s):
│
├─┬─ Security Reviewer                    time: 10-15s
│ │  Read: src/main/java/**/*.java
│ │  Grep: hardcoded secrets, API keys
│ │  Check: Auth, CORS, input validation
│ │  Output: Security Issues Report
│ │
│ ├─ [Results ready at t=12s]
│
├─┬─ Architecture Reviewer                time: 15-20s
│ │  Read: Package structure
│ │  Grep: Layer violations, imports
│ │  Analyze: Taikai rules
│ │  Output: Architecture violations
│ │
│ ├─ [Results ready at t=18s]
│
└─┬─ Performance Reviewer                 time: 15-20s
  │  Read: SQL queries, loop patterns
  │  Grep: N+1, DISTINCT, select *
  │  Check: Blocking, reactive
  │  Output: Performance issues
  │
  └─ [Results ready at t=20s]

SYNTHESIS (t=~25s):
│
├─ Combine all 3 reports
├─ Prioritize by severity
├─ Return to main session
│
END: Ready for fixes
```

### Flow 2: AI Service Generation

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
│ │  - ChatbotBoundary.java (REST endpoint)
│ │  - request/ChatRequest.java (DTO)
│ │  - response/ChatResponse.java (DTO)
│ │
│ ├─ Control Layer (4 files):
│ │  - ChatbotService.java (orchestration)
│ │  - ChatbotTools.java (@Tool definitions)
│ │  - ChatbotRAGService.java (vector search)
│ │  - ChatbotGuardrailService.java (validation)
│ │
│ ├─ Entity Layer (2 files):
│ │  - ChatHistory.java (JPA entity)
│ │  - ChatDocument.java (RAG documents)
│ │
│ ├─ Infrastructure (3 files):
│ │  - V001__Create_chatbot_tables.sql (Flyway)
│ │  - application.properties (config)
│ │  - Tests (3 test classes)
│ │
│ └─ Generated: ~15 files total
│
├─ VALIDATION PHASE:
│ │
│ ├─ Taikai architecture tests updated
│ ├─ All imports correct (BCE pattern)
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

Each sub-agent has **isolated, fresh context**:

```
┌─────────────────────────────────────────┐
│      Sub-Agent Isolated Context         │
├─────────────────────────────────────────┤
│ System Prompt (agent-specific)          │
│ CLAUDE.md (project conventions)         │
│ Git Status (current branch)             │
│ Skill Content (if preloaded)            │
│ Tool Access (restricted)                │
│ Session ID (independent)                │
│ Permission Mode (agent-specific)        │
└─────────────────────────────────────────┘

Size: ~5-10k tokens (depending on codebase)
Duration: 1-5 minutes (depending on task complexity)
Cost: ~1-5 cents per agent (~0.3-1.5k output tokens)
```

### Main Session Context (Before Sub-Agents)

```
┌─────────────────────────────────────────┐
│    Main Session Context (Preserved)     │
├─────────────────────────────────────────┤
│ Conversation History                    │
│ User Instructions                       │
│ Project Context (CLAUDE.md, Skills)     │
│ Previous Decisions                      │
│ Full Tool Access                        │
│ Interactive Permissions                 │
└─────────────────────────────────────────┘
```

### Context Flow

```
Session Start:
  Main Context = ~20k tokens
         ↓
Sub-Agent Spawn (Security Reviewer):
  - Main context remains unchanged
  - Sub-agent gets fresh ~5k token context
  - Independent execution
         ↓
Sub-Agent Returns Results (~1k summary tokens):
  - Appended to main context
  - User reads + decides
  - Main context now ~21k tokens
         ↓
Repeat for other sub-agents:
  - Same isolation pattern
  - Parallel execution
  - Results synthesized
         ↓
Main context grows to ~25-30k tokens
  - Still within reasonable limits
  - Full conversation history preserved
  - Ready for next task
```

---

## Tool Access Matrix

| Tool | Security | Architecture | Performance | AI Generator |
|------|----------|--------------|-------------|--------------|
| Read | Yes | Yes | Yes | Yes |
| Grep | Yes | Yes | Yes | Yes |
| Glob | Yes | Yes | Yes | Yes |
| Bash | Yes | Yes | Yes | Yes |
| Write | No | No | No | Yes |
| Edit | No | No | No | Yes |
| Agent | No | No | No | No |

**Read-Only Agents**: Cannot modify, only analyze
**Generator**: Can write/edit, for scaffolding

---

## Performance Characteristics

### Execution Time

```
Sequential (without parallelization):
  Security review:      15s
  Architecture review:  20s
  Performance review:   20s
  ───────────────────────
  Total: 55 seconds

Parallel (sub-agents):
  All 3 parallel: 25 seconds (2.2x faster!)
```

### Token Usage

```
Per sub-agent review:
  Input:  ~500 tokens (codebase + prompt)
  Output: ~1000 tokens (report)
  Cost:   ~0.5 cents

All 3 in parallel:
  Total cost: ~1.5 cents (vs. $$$ for manual review)

AI Service Generator:
  Input:  ~1000 tokens
  Output: ~3000 tokens (15 files)
  Cost:   ~2-3 cents
```

---

## Scaling: When It Gets Bigger

### Now (< 10 Agents)
```
Sub-agents in .claude/agents/
Parallel execution
Manual triggering
```

### Later (10-50 Agents)
```
Use agent teams for massive parallelization
Specialized agent routing (coordinator agent)
Shared memory between agents (persistent)
Conditional delegation (for specific file types)
```

### Enterprise (50+ Agents)
```
Plugin-based agent distribution
Agent marketplace for reuse
Central agent registry
Permission policies
Cost tracking & optimization
```

---

## Error Handling & Recovery

```
Scenario: Sub-agent fails

1. Agent crash:
   ├─ Claude detects the error
   ├─ Returns error report
   └─ Main session remains intact

2. Permission denied:
   ├─ Agent cannot use a tool
   ├─ Fallback to restricted tools
   └─ User is informed

3. Timeout (>5 min):
   ├─ Agent is terminated
   ├─ Partial results returned
   ├─ Can be resumed
   └─ Cost is not charged

4. Recovery:
   Resume agent with: "Continue that task"
   └─ Retains full context
```

---

## Monitoring & Debugging

### Tracking Agent Execution

```bash
# View current/completed agents
claude agents

# Agent logs (stored locally)
~/.claude/projects/[project]/[sessionId]/subagents/
  ├── agent-[id-1].jsonl
  ├── agent-[id-2].jsonl
  └── agent-[id-3].jsonl
```

### Agent Debug Output

```bash
# In the Claude Code CLI:
/debug agents
# or
claude --verbose (shows agent execution details)
```

---

## Best Practices Summary

| Aspect | DO | DON'T |
|--------|-----|-------|
| **Triggering** | Group of agents in parallel | One agent per line in a loop |
| **Context** | Agents for large tasks | Main conversation for everything |
| **Results** | Synthesize + summarize | All reports unfiltered |
| **Customization** | Adapt agent prompts | Constantly create new agents |
| **Tools** | Limited tools for focus | All tools for every agent |

---

## Next Levels of Automation

Planned features (after sub-agents):

1. **Hooks** (Level 2)
   - post-edit pom.xml → version check
   - pre-prompt-submit → checklist

2. **Rules** (Level 2)
   - `.claude/rules/java.md` → language-specific guidelines
   - `.claude/rules/quarkus.md` → framework-specific

3. **Agent Teams** (Level 3)
   - Coordinated agents with communication
   - Shared task lists
   - Peer-to-peer feedback

4. **Plugins** (Level 4)
   - Agents + skills as installable packages
   - Sharing across projects/teams
