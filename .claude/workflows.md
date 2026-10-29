# Workflow Patterns & Orchestration

## Overview
This document serves as the navigation index for all workflow implementations in the `/.claude/workflows/` directory. Each workflow follows our core orchestration patterns and integrates with our agent ecosystem.

For detailed technical requirements and validation criteria, see `.claude/policies/engineering.md`.

---

## Core Workflow Categories

### 1. Orchestration & Coordination

#### [Orchestration Protocols](./workflows/orchestration-protocols.md)
**Master coordination patterns, decision matrices, and handoff contexts**

- Complexity assessment framework
- Agent routing decisions (Simple → Moderate → Complex → Enterprise)
- Context management triggers
- Deliverable tracking & verification
- Quality gate integration points
- Error handling and recovery protocols

**Use when:** You need to determine which orchestration approach to use, understand handoff protocols, or establish coordination patterns.

#### [Direct Coordination Workflow](./workflows/direct-coordination-workflow.md)
**Fast-track sequential patterns for 2-3 agents**

- Simple sequential or basic parallel coordination
- Straightforward execution paths
- Single domain or simple cross-domain work
- Minimal coordination overhead

**Use when:** Project requires exactly 2-3 agents with clear sequential dependencies.

#### [Complex Planning + Direct Execution](./workflows/complex-planning-direct-execution-workflow.md)
**Strategic planning phase followed by direct agent coordination**

- Moderate complexity (4-6 agents)
- Planning delegation to workflow-orchestrator
- Direct execution coordination after planning
- Multi-domain with moderate interdependencies

**Use when:** Project needs strategic planning before execution but direct coordination is manageable post-planning.

#### [Complex Planning + Delegated Execution](./workflows/complex-planning-delegated-execution-workflow.md)
**Enterprise-grade workflow with planning and parallel execution**

- High complexity (7 or more agents)
- Strategic planning via workflow-orchestrator
- Parallel execution via session-orchestrator
- Multi-session state persistence
- Complex dependency management

**Use when:** Project requires both strategic planning and parallel coordination of 7 or more agents with complex dependencies.

---

### 2. Development & Engineering

#### [Development Workflow](./workflows/development-workflow.md)
**Complete development lifecycle with quality gates**

- Test-first implementation
- TypeScript compliance (zero tolerance)
- Lint compliance protocol (zero errors/warnings)
- Performance validation
- Code quality review
- QA & testing
- Deployment protocols

**Use when:** Any development task requiring code changes, regardless of complexity.

**Key Features:**
- 7-stage workflow with resolution loops (max 3 iterations)
- Mandatory validation commands before stage completion
- Context manager integration for handoffs
- Automatic ticket creation for blocked stages
- Integration with ticket system for escalations

---

### 3. Operations & Management

#### [Ticket Management](./workflows/ticket-management.md)
**Issue tracking and assignment automation**

- Ticket creation process with severity/effort matrices
- Auto-assignment logic based on complexity and domain
- Status lifecycle management (Open → In Progress → Resolved → Closed)
- Archive organization for resolved tickets
- Integration with orchestration for assignment

**Use when:** Creating, updating, or managing tickets across all projects.

**Key Features:**
- Severity guidelines (Blocker, Major, Minor)
- Effort estimates (XS, S, M, L, XL)
- Domain-to-agent routing
- Automatic archive to `.claude/issues/resolved/YYYY-MM/` when resolved

#### [Handoff Report](./workflows/handoff-report-workflow.md)
**One session report so the next session can resume**

- Collect tickets, git status, and verification results before writing
- Fill `.claude/templates/handoff-report-template.md`
- Write exactly one file to `deliverables/reports/handoffs/`

**Use when:** A session ends and the next one needs the current state.

#### [File Persistence Protocol](./workflows/file-persistence-protocol.md)
**Consistent file handling across agents**

- Mandatory file persistence verification
- Pre-completion checklist for all file writes
- False completion prevention patterns
- Verification commands (git status, git diff)
- Integration with development workflow

**Use when:** ANY task that requires file modifications - this is a universal protocol.

**Critical Rule:** A task is NOT complete until ALL changes are written to disk and verified.

---

## Workflow Selection Matrix

| Scenario | Agent Count | Complexity | Use Workflow |
|----------|------------|------------|--------------|
| Simple task, linear deps | 2-3 | Low | [Direct Coordination](./workflows/direct-coordination-workflow.md) |
| Multi-domain, some planning | 4-6 | Medium | [Complex Planning + Direct](./workflows/complex-planning-direct-execution-workflow.md) |
| Complex dependencies, parallel | 7+ | High | [Complex Planning + Delegated](./workflows/complex-planning-delegated-execution-workflow.md) |
| Any development task | Any | Any | [Development Workflow](./workflows/development-workflow.md) |
| Issue tracking | Any | Any | [Ticket Management](./workflows/ticket-management.md) |
| Session handoff report | 1 | Any | [Handoff Report](./workflows/handoff-report-workflow.md) |
| **ALL** file modifications | Any | Any | [File Persistence Protocol](./workflows/file-persistence-protocol.md) |

**Quick Decision Path:**
1. **Does it involve code changes?** → Use [Development Workflow](./workflows/development-workflow.md)
2. **Creating/managing tickets?** → Use [Ticket Management](./workflows/ticket-management.md)
3. **Ending a session?** → Use [Handoff Report](./workflows/handoff-report-workflow.md)
4. **How many agents needed?** → Use [Orchestration Matrix](./workflows/orchestration-protocols.md). 2–3 agents use direct coordination, 4–6 use planning then direct execution, 7 or more use delegated execution.
5. **Writing ANY files?** → Apply [File Persistence Protocol](./workflows/file-persistence-protocol.md)

---

## Integration Points

### With Agents (`/.claude/agents.md`)
- **agent-orchestrator**: Entry point for complex requests, delegates based on complexity
- **workflow-orchestrator**: Planning and optimization for 4+ agent workflows
- **session-orchestrator**: Parallel execution management for 7 or more agents
- **gatekeeper**: Quality validation at checkpoints and final delivery
- **context-manager** (optional community agent): Context handoffs for 10k+ token projects; session-orchestrator covers this when it is not installed

### With Policies (`/.claude/policies/`)
- **engineering.md**: Technical requirements, validation criteria, lint compliance
- **orchestration.md**: Output validation standards
- **ticket-system.md**: Issue tracking requirements and governance

### With Core Principles (`/.claude/CLAUDE.md`)
- Iterative delivery – ship small, working slices
- Test first – define checks before implementation
- Complete – no placeholders, no gaps (enforced by file persistence protocol)
- Readable > clever – optimize for future readers

---

## Example Workflow Scenarios

### Example 1: Full-Stack Feature Development
```yaml
workflow: development-workflow
agents: [technical-architect, react-vite-engineer, qa-engineer]
entry_point: agent-orchestrator
coordination: Direct (3 agents, familiar pattern)
quality_gates:
  - Stage 3: Test-first implementation
  - Stage 5: Code quality review
  - Stage 7: Final validation with file persistence
```

### Example 2: Complex Multi-Domain Project
```yaml
workflow: complex-planning-delegated-execution
complexity: High (8 agents, 3 parallel streams)
entry_point: agent-orchestrator
delegation_path:
  - agent-orchestrator → workflow-orchestrator (planning)
  - workflow-orchestrator → agent-orchestrator (execution plan)
  - agent-orchestrator → session-orchestrator (parallel execution)
quality_gates:
  - 25%, 50%, 75%, 100% completion milestones
  - Gatekeeper validation before final delivery
```

### Example 3: Bug Fix with Ticket
```yaml
workflow: development-workflow + ticket-management
agents: [qa-engineer, react-vite-engineer]  # add code-reviewer or typescript-pro from a community collection if installed
entry_point: /create-ticket (auto-assigned)
coordination: Direct (2 agents)
file_persistence: Mandatory verification before completion
quality_gates:
  - Lint compliance (zero tolerance)
  - Type safety (zero errors)
  - File writes verified with git diff
```

---

## Workflow Quality Standards

All workflows must adhere to these standards:

### Handoff Requirements
- Every workflow must define clear handoff contexts
- Maximum 3 retry attempts per stage
- Mandatory deliverable tracking
- Context budget enforcement at handoffs (10,000 tokens max)

### Quality Gates
- Gatekeeper validation between major stages
- Automatic triggers at 25%, 50%, 75%, 100% completion
- Pre-delivery validation mandatory for all orchestrators
- File persistence verification for all file modifications

### Context Management
- Checkpoint context via session-orchestrator (or the optional community context-manager) for projects >10k tokens
- Structured handoffs using standardized formats
- Context validation before proceeding to next stage
- Essential information only (remove intermediate discussion)

### Error Handling
- Clear escalation paths for common failure scenarios
- Automatic ticket creation when resolution loops exceed 3 iterations
- Recovery protocols restore from last stable checkpoint
- No cascading or compounding errors

---

## Adding New Workflows

When creating a new workflow:

1. **Create workflow file** in `/.claude/workflows/`
2. **Follow orchestration-protocols.md** handoff format
3. **Define decision criteria** and complexity scoring
4. **Add entry to this index** under appropriate category
5. **Update selection matrix** if needed
6. **Include in agents.md** if agent-specific
7. **Create test cases** in `/.claude/tests/workflows/` (when testing framework exists)

### New Workflow Template Structure
```yaml
workflow_name: "[descriptive-name]"
category: "[orchestration|development|operations|quality]"
applicability:
  agent_count: "[range]"
  complexity_level: "[simple|moderate|complex|enterprise]"
  coordination_type: "[sequential|parallel|hybrid]"

stages:
  - stage_name: "[name]"
    prerequisites: "[requirements]"
    actions: "[what to do]"
    success_criteria: "[measurable outcomes]"
    resolution_loop: "[max iterations and escalation]"

integration_points:
  agents: "[list of agents]"
  policies: "[list of policies]"
  workflows: "[related workflows]"

handoff_format:
  # Follow orchestration-protocols.md standard
```

---

## Workflow Governance

### Versioning
- Each workflow file should include a version header (recommendation)
- Major changes require ticket per ticket-system.md
- Track changes in git commit history

### Maintenance
- Quarterly review of workflow effectiveness
- Dead workflow deprecation process
- Performance metrics collection per workflow
- Update this index when workflows are added/deprecated

### Quality Metrics
- Completion rate: % workflows completed without escalation
- Iteration efficiency: Average iterations per stage
- File persistence rate: % tasks with verified file writes (target: 100%)
- Lint compliance rate: % passing on first try

---

## Quick Reference Commands

### Starting a Workflow
```bash
# For development tasks
# Follow development-workflow.md stages 1-7

# For orchestration decisions
# Consult orchestration-protocols.md decision matrix

# For ticket management
/create-ticket [description], severity: [level], effort: [size], project: [name]
/assign-ticket [ticket-id]
```

### During Workflow Execution
```bash
# File persistence verification
git status                    # Show modified files
git diff --stat              # Show lines changed

# Development validation
yarn lint --fix              # Auto-fix issues
yarn lint --max-warnings 0   # Zero tolerance check
yarn tsc --noEmit            # Type safety check
```

### Workflow Completion
```bash
# Mandatory pre-completion sequence
git status                           # Verify files modified
git diff --stat                      # Verify lines changed
yarn lint --max-warnings 0           # Must exit 0
yarn tsc --noEmit                    # Must exit 0
./.claude/scripts/validate-lint.sh   # Comprehensive validation
```

---

## Related Documentation

- **Core Instructions**: `/.claude/CLAUDE.md` - Essential principles and beliefs
- **Agent Catalog**: `/.claude/agents.md` - All available agents and their roles
- **Development Standards**: `/.claude/policies/engineering.md` - Technical requirements
- **Dispatch Protocol**: `/.claude/policies/orchestration.md` - Agent delegation rules
- **MCP Servers**: `/.claude/mcp_servers.md` - External service integrations

---

**Last Updated**: 2025-10-28
**Maintainer**: agent-systems-architect
**Version**: 2.0 (Navigation index with full workflow directory integration)
