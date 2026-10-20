---
description: Start work on a ticket by routing it through the agent orchestration system
allowed-tools: Task(*), Read(*), Grep(*), Glob(*)
---

**Request**: Start ticket resolution - $ARGUMENTS

**Task**: Route ticket through agent-orchestrator for automated assignment and resolution

**Instructions**:
1. Parse ticket path/ID from $ARGUMENTS
   - Accepts: full path, ticket ID (YYYY-MM-DD-HHMMSS-<slug>), or relative path
   - If only ID provided, prepend `.claude/issues/`
   - If relative path, resolve to absolute path

2. Validate ticket exists and is readable
   - Read the ticket YAML file
   - Verify it has required fields (title, description, severity, effort)

3. Invoke agent-orchestrator with full context:
   ```
   @agent-agent-orchestrator please work with the appropriate agents to resolve this issue: [absolute path to ticket]

   Ticket context:
   - Title: [ticket.title]
   - Severity: [ticket.severity]
   - Effort: [ticket.effort]
   - Status: [ticket.status]

   Please follow the orchestration protocols (.claude/policies/orchestration-protocols.md) to:
   1. Assess ticket complexity
   2. Determine appropriate agent(s) or orchestration pattern
   3. Coordinate resolution following development workflow (.claude/workflows/development-workflow.md)
   4. Ensure ticket is updated with progress and final resolution
   ```

4. The agent-orchestrator will:
   - Apply the decision matrix from orchestration-protocols.md
   - Route to appropriate specialist(s) or sub-orchestrators
   - Coordinate resolution with progress tracking
   - Update ticket status upon completion

**Example Usage**:
- `/start-ticket 2024-09-25-143000-fix-login-bug`
- `/start-ticket .claude/issues/2024-09-25-144500-performance-optimization.yaml`
- `/start-ticket /absolute/path/to/ticket.yaml`

**Output**:
- Ticket information summary
- Orchestration routing decision
- Progress updates from agent-orchestrator
- Final resolution status
