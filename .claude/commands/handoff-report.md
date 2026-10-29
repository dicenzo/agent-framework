---
description: Generate comprehensive handoff report for session continuity
allowed-tools: Read(*), Write(*), Bash(*), Glob(*), Grep(*)
---

**Request**: Generate handoff report - $ARGUMENTS

**Task**: Create a comprehensive handoff report for the current session's work, update all relevant tickets, and save the report to the handoff directory.

**CRITICAL CONSTRAINTS** (MUST FOLLOW):
- ✅ Generate EXACTLY ONE markdown file (not multiple files)
- ✅ Filename format: `YYYY-MM-DD-HHMMSS-<description>-handoff.md` (REQUIRED - include time with seconds)
- ✅ Use ONLY the template from `.claude/templates/handoff-report-template.md` (do not add extra files)
- ✅ Do NOT create additional files (no INDEX.md, MANIFEST.md, QUICK-REFERENCE.md, etc.)
- ✅ Save to: `deliverables/reports/handoffs/` directory
- ✅ Follow the workflow: `.claude/workflows/handoff-report-workflow.md`

**Instructions**:

1. **Identify Session Scope**:
   - Parse $ARGUMENTS for specific ticket IDs or use all tickets worked on in session
   - Glob `.claude/issues/*.yaml` to find tickets modified today or with status "In Progress"
   - Read each identified ticket to extract current status and progress

2. **Gather Session Deliverables**:
   - Use `git status` to identify all modified/created files
   - Use `git diff --stat` to get line counts for changes
   - For each deliverable, verify existence with `ls -la`
   - Categorize by stream/task if working on multi-stream tickets

3. **Update Ticket Status**:
   - For each ticket worked on, update only fields from `.claude/issues/template.yaml`:
     - `ticket.status` (In Progress, Blocked, or Resolved)
     - `tracking.updated_at`
     - `tracking.resolution` when the work is finished
     - `tracking.attempted_solutions` when a fix was tried
   - Put the completion percentage and blockers in the handoff report
   - Write updated ticket files back to `.claude/issues/`

4. **Quality Metrics Collection**:
   - Run test suites if applicable: `yarn test --coverage`
   - Check TypeScript compilation: `yarn tsc --noEmit`
   - Run linting: `yarn lint`
   - Capture error counts and coverage percentages

5. **Generate Handoff Report**:
   - Use template from `.claude/templates/handoff-report-template.md`
   - Fill in all sections with gathered information
   - Include:
     - Executive summary with completion percentage
     - Deliverables with verification status
     - Quality metrics and test results
     - Working features vs remaining work
     - Integration points and dependencies
     - Known issues categorized by priority
     - File changes summary
     - Next session kickoff instructions

6. **Save Report**:
   - Generate filename: `YYYY-MM-DD-HHMMSS-<description>-handoff.md`
   - Description should be ticket slug or brief summary
   - Save to: `deliverables/reports/handoffs/`
   - Create directory if it doesn't exist

7. **Verify Handoff Completeness**:
   - Ensure report contains enough context for seamless resumption
   - Verify every file path is relative to the project root and does not start with `/`, `./`, or `../`
   - Confirm all ticket updates were saved
   - Check that critical blockers are clearly documented

8. **File Output Validation** (REQUIRED - check before completing):
   - [ ] Exactly ONE markdown file generated in `deliverables/reports/handoffs/`
   - [ ] Filename matches format: `YYYY-MM-DD-HHMMSS-*-handoff.md` (with seconds)
   - [ ] File includes all required template sections from `.claude/templates/handoff-report-template.md`
   - [ ] No additional files created (no INDEX, MANIFEST, QUICK-REFERENCE, etc.)
   - [ ] All file paths in the report are project-root paths (no leading `/`, `./`, or `../`)
   - [ ] Report filename is returned to user

**Report Sections (Required)**:
- Date, Time, Ticket IDs, Status, Progress %
- Executive Summary (3-5 bullet points)
- What Was Delivered This Session
- Quality Metrics & Test Results
- What's Working Now
- What Needs to Be Done
- Known Issues & Blockers (HIGH/MEDIUM/LOW)
- Integration Points & Dependencies
- File Changes This Session
- Next Session Kickoff
- Agent Recommendations (if multi-agent work)

**Example Usage**:
- `/handoff-report` (generates for all session tickets)
- `/handoff-report 2025-10-28-131722-epic-1-2-phase-1` (specific ticket)
- `/handoff-report epic-1.2 phase-2 complete` (custom description)

**Output**:
- Display report summary with:
  - Tickets updated: [count]
  - Deliverables verified: [count]
  - Report saved to: [path]
  - Next session instructions highlighted

**Integration References**:
- Apply `.claude/policies/orchestration.md` for verification
- Follow `.claude/workflows/orchestration-protocols.md` for handoff context
- Use `.claude/workflows/ticket-management.md` for ticket updates
- Reference `.claude/policies/engineering.md` for quality checks