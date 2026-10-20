---
description: Create a new ticket in the issues tracking system
allowed-tools: Read(*), Write(*), Bash(*)
---

**Request**: Create ticket - $ARGUMENTS

**Task**: Create a new ticket with the provided details

**Instructions**:
1. Parse the ticket request from $ARGUMENTS
2. Review the README.MD file in the root of the project.
3. Review any technical specifications in .claude/docs/specs/ if available.
4. Generate a unique ticket ID using format: YYYY-MM-DD-HHMMSS-<slug>
5. Create the ticket file in `.claude/issues/`
6. Use the template structure with these fields:
   - **title**: Brief description from request
   - **severity**: Blocker | Major | Minor (default: Major)
   - **effort**: XS | S | M | L | XL (default: M)
   - **project**: [active project name]
   - **created_by**: Use "claude" or detect agent name
   - **description**: Detailed description
   - **acceptance_criteria**: Extract or infer from request
7. Include debugging fields if applicable:
   - **steps_to_reproduce**: For bugs that can be replicated
   - **expected_behavior** / **actual_behavior**: For functional issues
   - **error_messages**: Specific error output or logs
   - **attempted_solutions**: Solutions tried during development
8. For develoment tickets, reference the .claude/policies/engineering.md.
9. Optional auto-assignment:
   - If `auto-assign: true` in request, immediately route through `/assign-ticket`
   - Use orchestration protocols for intelligent agent selection

**Example Usage**:
- `/create-ticket Fix login bug - users can't authenticate, severity: Blocker, effort: S`
- `/create-ticket Add dark mode toggle to settings, project: [active-project], effort: L`
- `/create-ticket Performance issue in dashboard, severity: Major, effort: M, auto-assign: true`

**Output**:
- Create the ticket file
- Display ticket ID and summary
- Confirm ticket creation