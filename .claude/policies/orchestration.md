# Orchestration Policy

## Dispatch Protocol

**Core rule**: Delegate, don't solve. Assign work to the right agent.

1. **Triage** — trivial? Answer directly. Otherwise → orchestrator.
2. **Dispatch** — call agent-orchestrator with the prompt.
3. **Wait** — return orchestrator's final consolidated output.

**Follow-ups:**
- Simple (typo, clarify) → answer directly
- Moderate (same domain, ≤3 agents) → reuse agents
- Complex (new scope/domain) → rerun orchestrator

**NEVER:**
- Try to solve complex prompts yourself
- Let agents write files to `.claude/issues/` (except YAML tickets)
- Allow deliverables in the project root

**ALWAYS:**
- Delegate, validate, return orchestrator's output
- Enforce file organization policy (deliverables go to `/deliverables/`)

---

## Quick Reference (Load First — ~200 tokens)

### Pre-Flight Check
```bash
echo "test" > /tmp/test-write-$$ && rm /tmp/test-write-$$ && echo "✅ Write OK" || echo "❌ Write FAILED"
```
- ✅ Write works → **PROCEED** with manifest creation
- ❌ Write fails → **ABORT** and notify user immediately

### Deliverable Manifest (Required Before Delegation)
```yaml
deliverable_manifest:
  - file: /absolute/path/to/file.md
    agent: technical-writer
    action: create
    verification: git diff shows changes
```

### Progressive Verification (After EACH Agent)
```bash
git status --short            # Must show changes
git diff --name-only          # Must include expected files
test -f /absolute/path/to/file  # File must exist
```

| Result | Action |
|--------|--------|
| All files present + git changes | ✅ PROCEED to next agent |
| Partial files (>50% present) | ⚠️ DOCUMENT gaps + PROCEED |
| No files created | ❌ FAIL agent task + RETRY once |
| Retry fails | 🚫 ABORT + notify user |

### Completion Actions
**Do NOT create separate reports unless explicitly requested.**

1. **Update assigned ticket** (`.claude/issues/*.yaml`): set status to Resolved, list files modified.
2. **Update appropriate README** (for example `/apps/mobile/README.md` or `/README.md`):

```markdown
## Recent Updates

### [Task Name] - YYYY-MM-DD
✅ Complete

**Files Modified:**
- /absolute/path/to/component.tsx (created, 156 lines)
- /absolute/path/to/README.md (+47 lines)

**Verification:** Git diff confirmed ✅
```
Keep only the 5 most recent updates in the README.

---

## Decision Matrix

| Complexity | Agents | Primary Orchestrator | Pattern |
|-----------|--------|---------------------|---------|
| Simple | 2–3 | agent-orchestrator | Direct coordination |
| Moderate | 4–6 | agent-orchestrator | → workflow-orchestrator → agent-orchestrator |
| Complex | 6+ | agent-orchestrator | → workflow-orchestrator → session-orchestrator |
| Enterprise | 10+ | agent-orchestrator | → workflow-orchestrator → session-orchestrator |

**Route to workflow-orchestrator when:**
- Request spans 4+ distinct domains with complex interactions
- Complex dependency mapping required
- Strategic planning required before execution

**Route to session-orchestrator when:**
- Parallel agent coordination required (6+ agents)
- Multi-session state persistence needed
- Context size exceeds 15k tokens

**Fast-track direct coordination when:**
- Sequential workflow with 2–4 agents
- Clear execution path without complex dependencies
- Familiar workflow patterns previously executed
- Timeline pressure favors immediate execution

**Mandatory context checkpoint (session-orchestrator, or the optional community context-manager) when:**
- Projects exceeding 10k tokens
- Before major orchestrator handoffs
- At 25%, 50%, 75%, 100% completion milestones

---

## Pre-Flight Verification Protocol

Before ANY orchestration begins, verify tool availability:

```yaml
pre_flight_checks:
  checks:
    - Read: "Attempt to read .claude/CLAUDE.md"         → fail: ABORT
    - Write/Edit: "Write to /tmp/test file"             → fail: ABORT (no deliverables possible)
    - Bash: "echo test"                                 → fail: WARNING (limited verification)
    - MCP filesystem: NOT available — use Write/Edit tools instead

  on_critical_fail:
    - Abort orchestration
    - Notify user with specific tool gap
    - Provide manual completion instructions
```

### Deliverable Manifest Declaration

**Create this BEFORE any delegation:**

```yaml
deliverable_manifest:
  task_id: "[timestamp]"
  expected_deliverables:
    - file_path: "/absolute/path/to/file1.md"
      action: "create|modify"
      description: "What this contains"
      success_criteria: "File exists with [X] content"
      owner: "agent-name"
```

---

## Deliverable Verification Policy

**Critical mandate**: Orchestration success ≠ Deliverable creation.

A task is ONLY complete when:
1. All promised deliverables exist on disk
2. Each deliverable is independently verified
3. A structured manifest confirms all outputs

### Enforcement Matrix

| Scenario | Response | Severity |
|----------|----------|----------|
| Tool unavailable at start | ABORT — notify user immediately | BLOCKER |
| No manifest created | BLOCK — cannot proceed | BLOCKER |
| Agent reports success, no files | FAIL — return to agent | MAJOR |
| Partial deliverables (50%+) | WARN — proceed, note gaps | MAJOR |
| <10% missing | PROCEED — note in report | MINOR |
| All deliverables verified | SUCCESS | NONE |

### Verification Commands

```bash
# Quick verification suite — run after each agent
git status --porcelain     # Must be non-empty
git diff --stat            # Must show lines changed
git diff --name-only       # Must include expected files

# Verify specific files
for file in "$@"; do
  if [ -f "$file" ]; then echo "✓ $file"
  else echo "✗ MISSING: $file"; fi
done
```

### Orchestrator Compliance Checklist

Before claiming ANY orchestration complete:
- [ ] Pre-flight tool check passed
- [ ] Deliverable manifest created and documented
- [ ] Each agent's outputs independently verified
- [ ] Git status shows expected modifications
- [ ] All file paths exist and are accessible
- [ ] Missing deliverables explicitly noted
- [ ] User informed of any gaps

---

## Agent Deliverable Requirements

**Every agent MUST comply with these requirements.**

**Core principle**: No agent may claim task completion without verifiable deliverables.

### Pre-Execution
1. Check tool availability (Read, Write/Edit, Bash) before any file operations
2. Declare expected deliverables at task start

### During Execution
```bash
# Verify immediately after each write
write_file "/path/to/file.md"
test -f "/path/to/file.md" || echo "Write failed"
```

**If file write fails:**
1. Retry twice
2. If still failing: report "Unable to write to [file]", provide content, mark INCOMPLETE

### Completion Requirements

**NO AGENT** may report completion without:
```bash
ls -la [each_modified_file]     # File exists
git diff [each_modified_file]   # Changes present
git status                      # All modifications visible
```

**Required reporting format:**
```markdown
✅ "Created `/path/to/config.yaml` with database settings (verified with git diff)"
✅ "Modified `/path/to/README.md` — added 50 lines of API documentation"
```

**Never report without files:**
```markdown
❌ "I've updated the configuration to include..."   [No file written]
❌ "The documentation has been enhanced with..."    [No actual changes]
```

### Agent-Specific Requirements

**Engineering agents** — MUST verify code compiles and imports resolve
**Documentation agents** — MUST verify markdown files created and structure present
**Configuration agents** — MUST verify config files are valid JSON/YAML
**Creative agents** — MUST verify asset files created with correct formats

---

## Handoff Context Formats

### agent-orchestrator → workflow-orchestrator
```yaml
handoff_context:
  source_agent: "agent-orchestrator"
  target_agent: "workflow-orchestrator"
  request_type: "planning"
  original_request: "[complete user request]"
  complexity_indicators:
    domain_count: 4
    estimated_agents: 6
    cross_domain_dependencies: true
  constraints:
    timeline: "2 weeks"
    quality_standards: "enterprise"
  deliverable_manifest:
    expected_outputs:
      - path: "/absolute/path/to/deliverable1.md"
        type: "document"
        owner: "technical-writer"
  tool_availability:
    read: true
    write: true
    bash: true
    mcp_filesystem: false
  return_format: "structured_execution_plan"
```

### agent-orchestrator → session-orchestrator
```yaml
handoff_context:
  source_agent: "agent-orchestrator"
  target_agent: "session-orchestrator"
  request_type: "execution"
  execution_plan: "[plan from workflow-orchestrator]"
  agent_assignments:
    stream_a: ["technical-architect", "integration-engineer"]
    stream_b: ["react-vite-engineer", "senior-frontend-layout-expert"]
  deliverable_tracking:
    stream_a_outputs: ["/path/to/api.yaml", "/path/to/schema.sql"]
    stream_b_outputs: ["/path/to/components.tsx", "/path/to/mockups.md"]
    verification_checkpoints:
      after_each_agent: true
  return_format: "coordination_progress_with_verification"
```

---

## Integration Flow Patterns

### Pattern 1: Simple Direct Coordination (2–3 agents)
```
User → agent-orchestrator → coordinates agents → gatekeeper validates → user
```

### Pattern 2: Complex Planning + Direct Execution
```
User → agent-orchestrator → workflow-orchestrator (planning)
     → agent-orchestrator → coordinates agents per plan
     → gatekeeper validates → user
```

### Pattern 3: Complex Planning + Delegated Execution
```
User → agent-orchestrator → workflow-orchestrator (planning)
     → agent-orchestrator → session-orchestrator (parallel execution)
     → session-orchestrator → agent-orchestrator (progress updates)
     → gatekeeper validates → user
```

### Quality Gate Triggers

**Automatic:**
- Pre-delivery: all orchestrators invoke gatekeeper before final delivery
- Major milestones: at 25%, 50%, 75%, 100% of planned phases
- Cross-orchestrator handoffs

**Manual:**
- Explicit user request: "Please validate this before proceeding"
- Agent uncertainty about output quality
- High-stakes deliverables

---

## Error Recovery

### Coordination Failures
```yaml
planning_failure:
  trigger: "workflow-orchestrator returns incomplete plan"
  action: "Request revision with specific gaps identified"

execution_failure:
  trigger: "session-orchestrator reports coordination breakdown"
  action: "Rollback to last checkpoint, revise, resume"

validation_failure:
  trigger: "gatekeeper returns FAIL"
  action: "Return to responsible agent — do not proceed"

delegation_confusion:
  trigger: "unclear which orchestrator handles request"
  action: "Default to agent-orchestrator for complexity analysis"
```

### Tool Unavailability Response
```
⚠️ LIMITATION DETECTED: Write tool unavailable.
RECOMMENDATION: Use Read/Edit tools for existing files only.
ABORTING: Cannot guarantee deliverable creation without Write tool.
```

### Agent Claims Success But No Files
```
❌ VERIFICATION FAILED: Agent 'technical-writer' claimed completion but:
- Expected: /path/to/README.md
- Actual: No file modifications detected via git diff
- Action: Retrying with explicit file path requirements
```

---

## NEVER / ALWAYS

**NEVER:**
- Claim success without git diff verification
- Use MCP filesystem operations (not available)
- Proceed if Write tool is unavailable
- Delegate without a deliverable manifest

**ALWAYS:**
- Test tool availability before starting (pre-flight)
- Create manifest before delegation
- Verify after EACH agent completes
- Report absolute paths with verification status
- Document missing deliverables explicitly
