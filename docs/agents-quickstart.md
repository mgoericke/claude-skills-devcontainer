# Sub-Agents Quick-Start Guide

Quick introduction to the 4 sub-agents in this project.

## Installation

The agents are already installed in `.claude/agents/`:
- `security-reviewer.md`
- `architecture-reviewer.md`
- `performance-reviewer.md`
- `ai-service-generator.md`

Verify:
```bash
claude agents  # Shows all available agents
```

---

## Use Cases in 5 Minutes

### Scenario 1: New feature implemented (5 files changed)

```
1. Feature done, code committed
2. Run all 3 review agents:

Use the security-reviewer, architecture-reviewer, and
performance-reviewer to analyze my recent changes

3. Wait for reports (~20-30 seconds)
4. Read issues and fix them (if any)
5. Commit fixes
6. Ready for PR
```

**What happens**:
- Each agent runs in isolation in its own context
- Security checks for secrets, auth, injection
- Architecture checks for BCE violations
- Performance checks for N+1, blocking
- Reports come back in parallel

---

### Scenario 2: New chatbot service with RAG

```
1. Product owner says: "We need a chatbot with document retrieval"

2. Start the AI service generator:

Use the ai-service-generator to create a new Chatbot service
with Document Retrieval (RAG) and Tools integration

3. Agent asks questions:
   - Service name? → Chatbot
   - LLM provider? → Anthropic Claude
   - Tools? → DocumentSearch, UserContext
   - RAG? → Yes, with PgVector
   - Guardrails? → Yes, rate limiting + input validation

4. Agent generates ~15 files:
   REST endpoints
   DTOs
   Services + Tools
   Entities
   Flyway migration
   Tests
   application.properties

5. Ready to test:
   docker compose up
   ./mvnw test
   curl -X POST http://localhost:8080/api/chatbot -d '{"message":"Hello"}'
```

**What happens**:
- Agent scaffolds a complete, isolated package
- All best practices (BCE pattern, @Blocking, tests) already included
- Code is immediately production-ready

---

### Scenario 3: After a git merge conflict (for safety)

```
1. Merge completed, conflicts resolved
2. Quick security check:

Use the security-reviewer to make sure we didn't accidentally
introduce any secrets or authentication issues after the merge

3. Get immediate feedback
```

---

## Command Reference

### Show agents
```bash
claude agents
# Shows:
# - Built-in Agents (Explore, Plan, General-Purpose)
# - Project Agents (.claude/agents/)
# - User Agents (~/.claude/agents/)
```

### Manage agents interactively
```bash
/agents  # In the Claude Code CLI
# Options: Create, Edit, Delete, View
```

### Trigger an agent directly
```
# In chat:
Use the [agent-name] to [task]

# Examples:
Use the security-reviewer to analyze the code
Use the architecture-reviewer to check the design
Use the performance-reviewer to find bottlenecks
Use the ai-service-generator to create a new service
```

### Multiple agents in parallel
```
Use the security-reviewer, architecture-reviewer, and
performance-reviewer to analyze the changes

# All 3 run simultaneously!
```

---

## Interpreting Output

### Security Reviewer Output

```
[CRITICAL] Hardcoded API Key detected
  Location: src/main/java/.../ChatbotService.java:42
  Issue: private static final String ANTHROPIC_KEY = "sk-ant-..."
  Risk: API key exposure in source code
  Fix: Move to environment variable

[WARNING] Missing input validation
  Location: src/main/java/.../ChatbotBoundary.java:28
  Issue: Request.message() not validated
  Fix: Add @NotBlank on message field

[INFO] Consider CORS configuration
  Location: n/a
  Issue: CORS not yet configured
  Recommendation: Add @CrossOrigin or configure in application.properties
```

### Architecture Reviewer Output

```
[VIOLATION] Entity imported by Boundary
  File: boundary/ChatbotBoundary.java:15
  Issue: import entity.ChatHistory (should only be DTOs)
  Fix: Create ChatHistoryResponse DTO, use that instead

[DESIGN] Circular dependency detected
  Files: control/ChatbotService.java ↔ control/ChatbotTools.java
  Issue: Service injects Tools, Tools injects Service
  Fix: Refactor: Service calls Tools, not the other way around

[BEST PRACTICE] Taikai test coverage
  Info: New entities + services added
  Recommendation: Update ArchitectureTests.java with new rules
```

### Performance Reviewer Output

```
[ISSUE] N+1 Query detected
  Location: control/ChatbotService.java:85
  Code: for (ChatHistory h : histories) { ... h.getUser().getId() }
  Impact: 100 histories = 101 queries instead of 1
  Fix: Use fetch join: SELECT h FROM ChatHistory h JOIN FETCH h.user

[WARNING] Missing pagination
  Location: boundary/ChatbotBoundary.java:32
  Issue: getAllMessages() loads all messages
  Recommendation: Add @QueryParam int page, int size

[OPTIMIZATION] Caching opportunity
  Info: DocumentSearch is frequently called with the same keywords
  Suggestion: Cache SearchResults for 5 minutes
```

### AI Service Generator Output

```
Phase 1: Planning
  Service Name: Chatbot
  LLM Provider: Anthropic Claude (claude-opus-4-6)
  Tools: DocumentSearch, UserContext, SendNotification
  RAG: Enabled (PgVector for embeddings)
  Guardrails: Rate limiting (100 req/min), input validation

Phase 2: Code Generation
  boundary/ai/ChatbotBoundary.java (REST endpoint)
  boundary/ai/request/ChatRequest.java (input DTO)
  boundary/ai/response/ChatResponse.java (output DTO)
  control/ai/ChatbotService.java (orchestration)
  control/ai/ChatbotTools.java (LLM tools)
  control/ai/ChatbotRAGService.java (vector search)
  control/ai/ChatbotGuardrailService.java (validation)
  entity/ai/ChatHistory.java (JPA entity)
  entity/ai/ChatDocument.java (RAG documents)

Phase 3: Infrastructure
  db/migration/V001__Create_chatbot_tables.sql
  application.properties (LLM config)

Phase 4: Tests
  ChatbotBoundaryTest.java (REST tests)
  ChatbotServiceTest.java (service tests)
  ChatbotToolsTest.java (tool tests)
  ArchitectureTests updated

Ready to use:
  docker compose up
  ./mvnw test
  curl -X POST http://localhost:8080/api/chatbot \
    -H "Content-Type: application/json" \
    -d '{"message":"Hello Chatbot"}'
```

---

## Best Practices

### Using Review Agents Effectively

**Good**:
```
# Large enough for a complete review
Use the security-reviewer to analyze the new authentication module

# Multiple agents in parallel
Use all review agents to analyze my changes
```

**Not optimal**:
```
# Too small (one line)
Use the security-reviewer to review this change

# Too much (entire codebase)
Use the security-reviewer to audit the entire project
```

### Using the AI Service Generator Effectively

**Good**:
```
# Clear and concrete
Use the ai-service-generator to create a DocumentAnalyzer service
with RAG integration and Tool support for database queries

# With domain context
We need a RecommendationEngine that analyzes user behavior
and suggests products. Use the ai-service-generator to scaffold it.
```

**Not optimal**:
```
# Too vague
Use the ai-service-generator to create something with AI

# Unclear requirements
Create an AI service (what should it do?)
```

---

## Frequently Asked Questions

### Q: Will the agents modify my code?
**A**: Security, Architecture, and Performance agents are **read-only**. They can only read, not write. The AI Service Generator can write (generate new files).

### Q: How long does a review take?
**A**:
- Security review: ~10-15 seconds
- Architecture review: ~15-20 seconds
- Performance review: ~15-20 seconds
- Parallel: ~20-25 seconds (instead of 45-55s sequential)

### Q: Can I edit the agents myself?
**A**: Yes! `.claude/agents/[name].md` is a regular Markdown file. You can customize the prompts:
```bash
# Edit directly
vim .claude/agents/security-reviewer.md

# Or via CLI
/agents → Edit → security-reviewer
```

### Q: What is the difference from manual code review?
**A**:
| Aspect | Agent | Manual |
|--------|-------|--------|
| Speed | ~20s | 30min+ |
| Consistency | 100% | ~70% (depends on reviewer) |
| Thoroughness | Comprehensive | Selective |
| False positives | ~5% | ~2% |
| Cost | 1-2 cents | $500+ (time investment) |

**Best**: Combination of agent + manual spot check!

### Q: Can I use agents for other projects?
**A**: Yes! Move the `.md` files to:
```bash
~/.claude/agents/  # User level (all projects)
```

Then they are available everywhere.

---

## Troubleshooting

### Agent is not being delegated to

**Problem**: Claude does not use the agent automatically.

**Solution**:
1. Make agent description more precise (`.claude/agents/[name].md`)
2. Or trigger directly: `Use the [name] agent to ...`

### Agent has incorrect behavior

**Problem**: Agent response is not helpful.

**Solution**:
1. Open `.claude/agents/[name].md`
2. Adjust the system prompt (Markdown section after YAML)
3. Add more specific instructions/checklists
4. Save and try again

### Agent needs more tools

**Problem**: Agent cannot perform certain checks (e.g., running tests).

**Solution**:
1. Open `.claude/agents/[name].md`
2. Change the `tools:` field:
   ```yaml
   tools: Read, Grep, Glob, Bash  # Add "Bash" for ./mvnw test
   ```

---

## Next Steps

1. **Try it out**: Write code → trigger reviews
2. **Incorporate feedback**: Fix issues from reviews
3. **Customize**: Adapt agent prompts to your needs
4. **Document**: Save learnings in `.claude/lessons-learned.md`

**Then**: Implement hooks (automation) → Agent teams (massively parallel)

---

## Support

- **Agents docs**: [docs/sub-agents.md](sub-agents.md)
- **Agents architecture**: [docs/agents-architecture.md](agents-architecture.md)
- **Claude Code Docs**: https://code.claude.com/docs/en/sub-agents
- **Questions**: Just ask in the chat: "How do sub-agents work?"
