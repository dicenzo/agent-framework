---
description: Assign a ticket to appropriate agent using orchestration protocols
allowed-tools: Task(*), Read(*), Grep(*), Glob(*)
---

**Request**: Assign ticket - $ARGUMENTS

**Task**: Route ticket assignment through existing orchestration system (.claude/workflows/orchestration-protocols.md)

**Instructions**:
1. Parse ticket ID from $ARGUMENTS (format: YYYY-MM-DD-HHMMSS-<slug>)
2. Read the ticket YAML file from `.claude/issues/`
3. Analyze ticket complexity using agent-orchestrator scoring:
   - **Domain identification**: Engineering, Business, Creative, Marketing?
   - **Effort mapping**: XS/S = simple, M = moderate, L/XL = complex
   - **Severity impact**: Blocker = high priority routing

4. **Apply Dispatch Protocol**:
   - **Simple tickets (XS/S, single domain)**: Direct assignment to specialist
   - **Moderate tickets (M, 1-2 domains)**: Use workflow-orchestrator for planning
   - **Complex tickets (L/XL, multi-domain)**: Route through agent-orchestrator

5. **Domain-to-Agent Mapping**:
   - **Build/Type errors**: react-vite-engineer, qa-engineer
   - **Performance issues**: technical-architect, qa-engineer
   - **UI/UX bugs**: senior-frontend-layout-expert, react-vite-engineer, design-qa-reviewer
   - **Backend issues**: technical-architect, integration-engineer
   - **Testing problems**: qa-engineer
   - **Documentation**: technical-writer
   - **Optional community agents**: if installed, prefer `typescript-pro` / `code-reviewer` for build and type errors, `performance-engineer` for performance, `ui-designer` / `ux-designer` / `react-component-architect` for UI/UX, `backend-architect` for backend, and `documentation-expert` for documentation. Check that the agent file exists before assigning.

6. Update ticket with:
   - `assigned_to: [agent-name]`
   - `updated_at: [current-timestamp]`
   - `status: "In Progress"`

7. Ensure tickets reference using the ticket-managment workflow (.claude/workflows/ticket-management.md). 

8. Ensure tickets assigned to the engineering team reference the development workflow (.claude/workflows/development-workflow.md).

**Example Usage**:
- `/assign-ticket 2024-09-25-143000-fix-login-bug`
- `/assign-ticket 2024-09-25-144500-performance-optimization`

**Output**:
- Display assignment rationale
- Show assigned agent and reasoning
- Confirm ticket update