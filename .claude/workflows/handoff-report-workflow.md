# Handoff Report Generation Workflow

**Purpose**: Enforce strict compliance with handoff report generation standards to ensure ONE standardized file per session.

**Trigger**: When `/handoff-report` slash command is invoked

**Owner**: project-manager agent or any agent generating session handoffs

---

## Execution Protocol

### Phase 1: Data Collection (Do NOT Write Files Yet)

**Objective**: Gather all necessary information before generating any output files.

1. **Identify Session Scope**
   ```bash
   # Find tickets worked on
   glob .claude/issues/*.yaml
   # Check git status for changes
   git status
   git diff --stat
   ```

2. **Collect Session Metrics**
   - Files created/modified/deleted
   - Line counts (code, docs, tests)
   - Test results and coverage
   - Build status
   - Quality metrics

3. **Identify Blockers and Issues**
   - HIGH priority blockers
   - MEDIUM priority issues
   - LOW priority notes
   - Dependencies and prerequisites

4. **Document Deliverables**
   - Verify each file exists: `ls -la [path]`
   - Categorize by stream/task
   - Note completion status

**Gate**: All data collected → Proceed to Phase 2

---

### Phase 2: Report Content Generation

**Objective**: Populate the template with collected data.

1. **Read Template**
   ```bash
   Read: .claude/templates/handoff-report-template.md
   ```

2. **Fill Template Sections**
   - Header: Date, Time (with HHMMSS), Ticket IDs, Status, Progress %
   - Executive Summary: 3-5 bullet points
   - Session Metrics: Statistics table
   - Deliverables: By stream/task with project-root paths
   - What's Working Now: Completed features
   - What Needs to Be Done: Remaining tasks with estimates
   - Known Issues & Blockers: Categorized HIGH/MEDIUM/LOW
   - Integration Points: APIs, dependencies, cross-stream
   - File Changes: Created/Modified/Deleted with line counts
   - Next Session Kickoff: Clear instructions
   - Testing Instructions: Verification steps
   - Reference Documents: Key files with project-root paths

3. **Validate Content Completeness**
   - [ ] All template sections filled
   - [ ] Every file path is relative to the project root (`deliverables/...`, `.claude/issues/...`)
   - [ ] No path starts with `/`, `./`, or `../` (a leading `/` is the filesystem root, so `ls` would miss the file)
   - [ ] All placeholders replaced
   - [ ] Metrics are concrete numbers (not [XX])

**Gate**: Content validated → Proceed to Phase 3

---

### Phase 3: Filename Generation

**Objective**: Generate ONE standardized filename.

**Format**: `YYYY-MM-DD-HHMMSS-<description>-handoff.md`

**Components**:
- `YYYY-MM-DD`: Current date (e.g., 2025-10-30)
- `HHMMSS`: Current time with seconds (e.g., 171945)
- `<description>`: Brief slug from ticket or work summary (lowercase, hyphens)
  - If ticket ID: use ticket slug (e.g., `epic-1.2-mobile-share`)
  - If custom: use brief summary (e.g., `phase-2-completion`)
- `-handoff`: Required suffix
- `.md`: Extension

**Examples**:
- ✅ `2025-10-30-171945-epic-1.2-mobile-share-handoff.md`
- ✅ `2025-10-30-143022-phase-2-completion-handoff.md`
- ✅ `2025-10-30-092015-android-share-implementation-handoff.md`
- ❌ `EPIC-1.2-MOBILE-SHARE-20251030.md` (wrong format, no time, no -handoff)
- ❌ `2025-10-30-epic-handoff.md` (missing time with seconds)
- ❌ `handoff-report.md` (missing date and time)

**Validation**:
- [ ] Matches pattern: `YYYY-MM-DD-HHMMSS-*-handoff.md`
- [ ] Date is current date
- [ ] Time includes seconds (6 digits)
- [ ] Description is lowercase with hyphens
- [ ] Ends with `-handoff.md`

**Gate**: Filename validated → Proceed to Phase 4

---

### Phase 4: Write Single File

**Objective**: Write EXACTLY ONE file to the handoff directory.

**Path**: `deliverables/reports/handoffs/[generated-filename]`

**Process**:
1. Create directory if needed:
   ```bash
   mkdir -p deliverables/reports/handoffs
   ```

2. Write the single file:
   ```
   Write: deliverables/reports/handoffs/[YYYY-MM-DD-HHMMSS-description-handoff.md]
   Content: [populated template from Phase 2]
   ```

3. **STOP** - Do not create any additional files:
   - ❌ No INDEX.md
   - ❌ No MANIFEST.md
   - ❌ No QUICK-REFERENCE.md
   - ❌ No README.md updates (unless explicitly part of the command)
   - ❌ No other supplementary files

**Gate**: Single file written → Proceed to Phase 5

---

### Phase 5: Validation Gate (CRITICAL)

**Objective**: Verify output compliance before completing.

**Validation Checklist**:

```bash
# Count files in handoff directory created this session
ls -lt deliverables/reports/handoffs/ | head -5
```

- [ ] **Exactly ONE new file** created in `deliverables/reports/handoffs/`
- [ ] **Filename format** matches: `YYYY-MM-DD-HHMMSS-*-handoff.md`
- [ ] **Date in filename** matches today's date
- [ ] **Time in filename** includes seconds (HHMMSS)
- [ ] **Suffix** is `-handoff.md`
- [ ] **Template sections** are all present in file
- [ ] **File paths** in the report are project-root paths (no leading `/`, `./`, or `../`)
- [ ] **No additional files** created (INDEX, MANIFEST, etc.)

**If Validation Fails**:
1. Delete the incorrectly named file(s)
2. Delete any extra files created
3. Return to Phase 3 (filename generation)
4. Retry with correct format

**If Validation Passes**:
- Proceed to Phase 6

---

### Phase 6: Completion and Output

**Objective**: Inform user of successful handoff report generation.

**Output to User**:
```
✅ Handoff report generated successfully

📄 Report saved to:
   deliverables/reports/handoffs/[YYYY-MM-DD-HHMMSS-description-handoff.md]

📊 Session Summary:
   - Tickets updated: [count]
   - Deliverables verified: [count]
   - Report sections: [count] of [required]

🚀 Next Session:
   [Brief 1-2 sentence summary of next steps]
```

**Do NOT Output**:
- Multiple file paths
- References to INDEX or MANIFEST files
- Ambiguous "handoff package" language

**Final Checklist**:
- [ ] User informed of single file location
- [ ] Project-root path provided
- [ ] Brief summary included
- [ ] Next steps highlighted

---

## Error Handling

### If Multiple Files Were Created

**Detection**: More than one file in `deliverables/reports/handoffs/` with today's timestamp

**Resolution**:
1. Identify which file follows the standard: `YYYY-MM-DD-HHMMSS-*-handoff.md`
2. Delete non-compliant files (INDEX.md, MANIFEST.md, etc.)
3. If no file follows standard, delete all and regenerate
4. Inform user of correction

### If Filename Format is Wrong

**Detection**: File doesn't match `YYYY-MM-DD-HHMMSS-*-handoff.md` pattern

**Resolution**:
1. Read the file content
2. Generate correct filename based on content
3. Rename file: `mv [old-name] [correct-name]`
4. Verify renamed file exists
5. Inform user of correction

### If Template Sections Missing

**Detection**: Report missing required sections

**Resolution**:
1. Read current file
2. Identify missing sections
3. Add missing sections with appropriate content
4. Re-save file
5. Inform user of enhancement

---

## Integration Points

### Command Integration
- **Triggered By**: `/handoff-report` slash command
- **References**: `.claude/commands/handoff-report.md`
- **Template**: `.claude/templates/handoff-report-template.md`

### Policy Compliance
- **File placement**: `.claude/policies/file-organization.md` (`deliverables/reports/handoffs/`)
- **Deliverable Verification**: `.claude/policies/orchestration.md`
- **Development Standards**: `.claude/policies/engineering.md`

### Workflow Integration
- **Orchestration**: `.claude/workflows/orchestration-protocols.md`
- **Ticket Management**: `.claude/workflows/ticket-management.md`

---

## Success Criteria

**A successful handoff report generation MUST**:
- ✅ Create exactly ONE markdown file
- ✅ Use filename format: `YYYY-MM-DD-HHMMSS-description-handoff.md`
- ✅ Include all template sections
- ✅ Use project-root paths throughout (no leading `/`)
- ✅ Save to `deliverables/reports/handoffs/` directory
- ✅ Pass validation gate checklist
- ✅ Inform user of single file location

**Anti-patterns to AVOID**:
- ❌ Creating multiple files (INDEX, MANIFEST, QUICK-REFERENCE)
- ❌ Using wrong filename format (no time, wrong date format, no -handoff suffix)
- ❌ Missing template sections
- ❌ Prefixing paths with `/`, `./`, or `../`
- ❌ Creating "helpful" supplementary files

---

## Maintenance

**Review Frequency**: After each epic completion or every 10 handoff reports

**Metrics to Track**:
- Compliance rate (% of handoffs following standard)
- Common deviations from standard
- Time to generate report
- User feedback on report quality

**Update Triggers**:
- New template sections needed
- Filename format changes
- Additional validation requirements
- Integration with new tools

---

**Version**: 1.0
**Last Updated**: 2025-10-30
**Owner**: agent-systems-architect
**Status**: Active
