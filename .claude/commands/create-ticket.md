---
description: Create a new ticket in the issues tracking system
allowed-tools: Read(*), Write(*), Bash(*)
---

**Request**: Create ticket - $ARGUMENTS

**Task**: Create a new ticket with the provided details

**Instructions**:
1. Parse the ticket request from $ARGUMENTS
2. Review the README.md file in the root of the project.
3. Review any technical specifications in .claude/docs/specs/ if available.
4. Generate a unique ticket ID using format: YYYY-MM-DD-HHMMSS-<slug>
5. Create the ticket file in `.claude/issues/` from `.claude/issues/template.yaml`
6. Use these fields. Argument form is `key=value` (for example `severity=Blocker`):
   - **title**: Brief description from the request
   - **type**: Task | Story | Bug (default: Task; use Bug when the request describes broken behavior)
   - **severity**: Blocker | Major | Minor (default: Major)
   - **effort**: XS | S | M | L | XL (default: M)
   - **project**: Active project name
   - **working_directory**: Absolute path to the project root
   - **created_by**: Use "claude" or the current agent name
   - **description**: Detailed description
   - **acceptance_criteria**: Extract or infer from the request
7. Include debugging fields when type is Bug:
   - **steps_to_reproduce**: For bugs that can be replicated
   - **expected_behavior** / **actual_behavior**: For functional issues
   - **error_messages**: Specific error output or logs
   - **attempted_solutions**: Solutions tried during development
8. For development tickets, reference .claude/policies/engineering.md.
9. Optional auto-assignment:
   - If `auto-assign=true` in the request, immediately route through `/assign-ticket`
   - Use orchestration protocols for intelligent agent selection

**Example Usage**:
- `/create-ticket Fix login bug - users can't authenticate type=Bug severity=Blocker effort=S`
- `/create-ticket Add dark mode toggle to settings type=Story project=my-app effort=L`
- `/create-ticket Performance issue in dashboard type=Bug severity=Major effort=M auto-assign=true`

**Output**:
- Create the ticket file
- Display ticket ID and summary
- Confirm ticket creation