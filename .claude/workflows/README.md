# Workflows Directory

This directory contains **process flows and step-by-step procedures** for executing work.

## Structure

```
workflows/
├── README.md (this file)
│
├── Orchestration & Coordination
│   ├── orchestration-protocols.md
│   ├── direct-coordination-workflow.md
│   ├── complex-planning-direct-execution-workflow.md
│   └── complex-planning-delegated-execution-workflow.md
│
├── Development & Engineering
│   ├── development-workflow.md ⭐ PRIMARY DEV WORKFLOW
│   └── file-persistence-protocol.md
│
└── Operations & Management
    ├── ticket-management.md
    └── handoff-report-workflow.md
```

## Primary Workflow

### ⭐ development-workflow.md
**The standard process for all development tasks**

**7-Stage Workflow:**
1. Initial Analysis & Context Setup
2. Planning & Architecture
3. Test-First Implementation
4. Performance Review
5. Code Quality Review
6. QA & Testing
7. Final Validation & Completion

**Key Features:**
- Integrates with `policies/engineering.md` for validation criteria
- Resolution loops (max 3 iterations per stage)
- Automatic ticket creation when blocked
- Context manager integration for handoffs
- Zero-tolerance lint and type compliance

**When to use**: ANY task involving code changes

## Workflow Selection Matrix

| Scenario | Agent Count | Complexity | Use Workflow |
|----------|------------|------------|--------------|
| Simple task, linear deps | 2-3 | Low | direct-coordination-workflow.md |
| Multi-domain, some planning | 4-6 | Medium | complex-planning-direct-execution-workflow.md |
| Complex dependencies, parallel | 7+ | High | complex-planning-delegated-execution-workflow.md |
| **Any development task** | **Any** | **Any** | **development-workflow.md** |
| Issue tracking | Any | Any | ticket-management.md |
| Session handoff report | 1 | Any | handoff-report-workflow.md |

## Quick Decision Tree

```
Start
  ↓
Does it involve code changes?
  ├─ YES → Use development-workflow.md
  └─ NO  ↓
         Creating/managing tickets?
         ├─ YES → Use ticket-management.md
         └─ NO  ↓
                Generating handoff report?
                ├─ YES → Use handoff-report-workflow.md
                └─ NO  ↓
                       How many agents needed?
                       ├─ 2-3 → direct-coordination-workflow.md
                       ├─ 4-6 → complex-planning-direct-execution-workflow.md
                       └─ 7+  → complex-planning-delegated-execution-workflow.md
```

Any task that writes files also follows `file-persistence-protocol.md`.

## Workflow vs Policy vs Spec

**Confusion Point**: When to use workflows vs policies vs specs?

| Document Type | Purpose | Example | Location |
|--------------|---------|---------|----------|
| **Spec** | *What* to build | "Signup form needs 10 fields" | `/.claude/docs/specs/` |
| **Policy** | *How* to build it | "Use TypeScript, zero `any` types" | `/.claude/policies/` |
| **Workflow** | *Process* to build it | "Stage 1: Plan → Stage 2: Test..." | `/.claude/workflows/` |

**Mental Model**:
- Spec = Requirements (What)
- Policy = Standards (How)
- Workflow = Process (Steps)

## Integration Points

### With Policies
- `development-workflow.md` **requires** `policies/engineering.md` for validation
- `ticket-management.md` **requires** `policies/ticket-system.md` for ticket format
- All workflows **must** follow `policies/file-organization.md` for deliverables

### With Agents
- Workflows are **executed by** agents
- `agent-orchestrator` **selects** which workflow to use
- `workflow-orchestrator` **plans** complex workflows
- `session-orchestrator` **coordinates** parallel workflows

### With Core Principles
- All workflows implement `CLAUDE.md` core beliefs
- "Iterative delivery" → Resolution loops with max 3 iterations
- "Complete" → File persistence verification mandatory
- "Validated" → Quality gates at each stage

## What Goes Here

✅ **YES** - Place these in `/workflows/`:
- Step-by-step execution procedures
- Stage-based processes
- Coordination patterns
- Handoff protocols
- Completion checklists

❌ **NO** - Do NOT place these in `/workflows/`:
- Standards and rules → Use `/.claude/policies/`
- Requirements → Use `/.claude/docs/specs/`
- Analysis and reports → Use `/deliverables/`
- Agent definitions → Use `/.claude/agents/`

## Common Workflows

### Development Task
1. Use `development-workflow.md` (7 stages)
2. Follow `policies/engineering.md` for validation
3. Apply `policies/file-organization.md` for deliverables
4. Reference `docs/specs/` for requirements

### Multi-Agent Coordination
1. Start with `policies/orchestration.md` decision matrix
2. Select appropriate workflow (direct, planning+direct, or planning+delegated)
3. Follow handoff formats from orchestration protocols
4. Use `ticket-management.md` if escalation needed

### Ticket Creation
1. Use `/create-ticket` command OR
2. Follow `ticket-management.md` manual process
3. Comply with `policies/ticket-system.md` format
4. Auto-assignment via `policies/orchestration.md` protocols

## Quick Reference Commands

```bash
# Development workflow validation
yarn lint --fix                     # Auto-fix issues
yarn lint --max-warnings 0          # Zero tolerance check
yarn tsc --noEmit                   # Type safety check

# File verification (all workflows)
git status                          # Show modified files
git diff --stat                     # Show lines changed

# Ticket commands
/create-ticket [description], severity: [level], effort: [size]
/assign-ticket [ticket-id]

# Handoff report
/handoff-report [description]
```

## Related Documentation

- **Core Instructions**: `../CLAUDE.md` - Principles that workflows implement
- **Policies**: `../policies/` - Standards that workflows enforce
- **Orchestration**: `../policies/orchestration.md` - Multi-agent coordination protocols
- **Development Standards**: `../policies/engineering.md` - Quality gates for workflows
- **Navigation Index**: `../workflows.md` - Complete workflow catalog

---

**Last Updated**: 2026-01-12
**Purpose**: Process flows and procedures
**Maintenance**: Update when processes change, track in git
