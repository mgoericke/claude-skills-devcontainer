# Sub-Agents for Claude Code

This project uses specialized sub-agents for **parallel code reviews**, **architecture validation**, and **AI service generation**.

## Overview

| Agent | Type | Tools | Model | Usage |
|-------|------|-------|-------|-------|
| **security-reviewer** | Review (read-only) | Read, Grep, Glob, Bash | Sonnet | After code changes |
| **architecture-reviewer** | Review (read-only) | Read, Grep, Glob, Bash | Sonnet | After code changes |
| **performance-reviewer** | Review (read-only) | Read, Grep, Glob, Bash | Sonnet | After code changes |
| **ai-service-generator** | Generator (full tools) | Read, Write, Edit, Bash, Glob, Grep | Sonnet | New AI services |

## Detailed Description

### 1. Security Reviewer

**Purpose**: Security analysis of code changes

**Focus**:
- Hardcoded secrets (API keys, passwords, tokens)
- Authentication & authorization (Keycloak, JWT, RBAC)
- Input validation & SQL injection prevention
- API security (CORS, CSP, rate limiting)
- Database security (encryption, SSL/TLS)
- Dependency vulnerabilities (CVE check)
- LangChain4j & AI security (prompt injection prevention)

**Triggering**:
```bash
# Manually
/agents  # Choose "security-reviewer" → "Use now"

# Or directly
Use the security-reviewer to analyze the recent changes
```

**Output**: Structured security issues by severity (Critical → Warning → Info)

---

### 2. Architecture Reviewer

**Purpose**: Architecture and design pattern validation

**Focus**:
- BCE pattern compliance (Boundary/Control/Entity separation)
- Package structure validation
- Taikai architecture tests
- AI service architecture (boundary/ai, control/ai)
- Dependency direction (no circular dependencies)
- Transactional boundaries (`@Transactional`, `@Blocking`)
- Exception handling patterns

**Triggering**:
```bash
# Manually
Use the architecture-reviewer to check the design

# With specific focus
Use the architecture-reviewer to validate the new AI service structure
```

**Output**: Architecture violations with exact file locations and fix suggestions

---

### 3. Performance Reviewer

**Purpose**: Performance analysis and optimization potential

**Focus**:
- N+1 query problems
- Inefficient database queries (SELECT *, missing indexes, large result sets)
- Blocking operations in reactive context
- Memory leaks & resource management
- Reactive pattern violations (Uni/Multi, backpressure)
- Collection & loop performance
- Caching strategies
- HTTP & REST performance
- LangChain4j & AI performance

**Triggering**:
```bash
# Manually
Use the performance-reviewer to find bottlenecks

# With focus
Use the performance-reviewer to check for N+1 queries and blocking operations
```

**Output**: Performance issues with impact analysis (e.g., "100 extra queries instead of 1")

---

### 4. AI Service Generator

**Purpose**: Complete LangChain4j AI service generation

**Capabilities**:
- Clarify requirements (service name, functionality, LLM provider, tools, RAG, guardrails)
- Complete package structure following BCE pattern
- Boundary layer (REST endpoint, DTOs, input validation)
- Control layer (service, tools with `@Tool`, RAG, guardrails)
- Entity layer (JPA entities, repositories)
- Configuration (application.properties with LLM config)
- Flyway migration for DB tables
- Comprehensive tests (boundary, service, tools, architecture)
- Taikai integration

**Triggering**:
```bash
# Interactive (recommended)
Use the ai-service-generator to create a new AI service

# With specific details
Use the ai-service-generator to create a DocumentAnalyzer AI service with RAG and Tools
```

**Output**: Complete, production-ready AI service with tests and migration

---

## Parallel Code Review Workflow

### Scenario: After major code changes

```
1. Code written/committed
2. Start all 3 review agents in parallel:

   Use the security-reviewer, architecture-reviewer, and
   performance-reviewer to analyze the recent changes

3. Each agent works in isolation (own context)
4. All 3 reports come back
5. Prioritize and fix issues
```

### Performance Benefits

- **Security Review**: ~10-20s (Grep-based)
- **Architecture Review**: ~15-25s (AST-based)
- **Performance Review**: ~15-25s (query pattern search)
- **Parallel instead of sequential**: 15-25s instead of 40-70s

---

## AI Service Generation Workflow

### Scenario: New chatbot service with RAG

```
1. Requirement: "Create a chatbot with document retrieval"

2. Agent clarifies:
   - Service name: Chatbot
   - LLM provider: Anthropic (Claude)
   - Tools: DocumentSearch, UserContext
   - RAG: Yes (PgVector for embeddings)
   - Guardrails: Rate limiting, input validation

3. Agent generates:
   boundary/ai/ChatbotBoundary.java
   boundary/ai/request/ChatRequest.java
   boundary/ai/response/ChatResponse.java
   control/ai/ChatbotService.java
   control/ai/ChatbotTools.java
   control/ai/ChatbotRAGService.java
   control/ai/ChatbotGuardrailService.java
   entity/ai/ChatHistory.java
   entity/ai/ChatDocument.java
   db/migration/V001__Create_chatbot_tables.sql
   Tests (BoundaryTest, ServiceTest, ToolsTest)
   application.properties with LLM config
   ArchitectureTests updates

4. Ready for local testing:
   docker compose up
   ./mvnw test
   # Service available at /api/chatbot
```

---

## Best Practices

### Using Review Agents

**Do**:
- Review in parallel after major code changes (5+ files)
- Run reviews before PR creation
- Take issues seriously and fix them before pushing
- Save review output (for lessons learned)

**Don't**:
- Only skim reviews superficially
- Ignore issues and push anyway
- Review too frequently (only for significant changes)

### Using the AI Service Generator

**Do**:
- Formulate requirements clearly (intent, provider, features)
- Review and adapt generated code
- Write/extend tests
- Work with generated entities (don't modify manually)

**Don't**:
- Use the generator for small features (overkill)
- Accept generated code blindly
- Make manual changes before the next generation

---

## Configuration

### Loading Agents

The agents are already defined in `.claude/agents/` and are loaded automatically:

```bash
claude agents  # Show all available agents
```

### Creating a Custom Agent

```bash
/agents  # Interactive menu
# → "Create new agent"
# → "Project-level" (saves in .claude/agents/)
# → Enter details
```

### Customizing Agent Configuration

Each agent is a Markdown file with YAML frontmatter:

```yaml
---
name: security-reviewer              # Unique name
description: Security specialist ... # Claude uses this for delegation
tools: Read, Grep, Glob, Bash        # Available tools
model: sonnet                         # Claude model
permissionMode: default               # Permission handling
---

# Then comes the system prompt (Markdown)
```

---

## Troubleshooting

### "Agent is not being delegated to"

**Reason**: Description is too vague or agent name is not unique.

**Fix**:
```bash
/agents  # Edit Agent
# Make description more specific: e.g., instead of "Code review" →
# "Security specialist for code review. Analyzes for vulnerabilities..."
```

### "Agent did not give the right answer"

**Reason**: System prompt could be more precise.

**Fix**:
```bash
.claude/agents/[agent-name].md  # Open directly
# Extend checklist or provide more context
# Example: "When reviewing, check the following points: [list]"
```

### "Agent needs more tools"

**Reason**: `tools` field is too restrictive.

**Fix**:
```yaml
tools: Read, Grep, Glob, Bash, Write  # Example for generator
```

---

## Memory & Lessons Learned

After every session with agents, findings should be documented:

**Save in**: `.claude/lessons-learned.md`

**Example**:
```markdown
## Sub-Agent Patterns

### Security Reviewer successfully used for:
- JWT validation checks
- Secret detection
- CORS configuration review

### Performance Reviewer issue:
- Finds N+1 queries well with Grep
- Could provide better context for DB indexes

### AI Service Generator learnings:
- Works well for standalone services
- Needs manual adjustment for entity relationships
```

---

## Next Steps

After sub-agents implementation:

1. **Implement hooks** (post-edit pom.xml, pre-prompt-submit)
2. **Introduce agent teams** (for massively parallel reviews)
3. **Memory persistence** for agents (`memory: user` or `memory: project`)
4. **CI/CD integration** (tests + reviews automated)

---

## Links

- Agents definition location: `.claude/agents/`
- Documentation: `code.claude.com/docs/en/sub-agents`
- Tutorial: Start with `/agents` → "Create new agent" → "Generate with Claude"
