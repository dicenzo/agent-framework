# File Persistence Protocol for Task Completion

## 🚨 CRITICAL: Definition of "Task Completion"

**A task is NOT complete until ALL changes are written to disk.**

Tasks reported as "completed" without actual file writes are **FALSE COMPLETIONS** and violate core quality gates.

## ⚡ Mandatory File Persistence Sequence

### PRE-COMPLETION VERIFICATION CHECKLIST

**EXECUTE IN THIS EXACT ORDER:**

```bash
# 1. Verify files exist and have been modified
ls -la [modified_files]        # Confirm files exist
git status                      # Show modified files
git diff --stat                 # Show lines changed

# 2. Validate written changes
git diff [file_path]            # Review actual changes
grep -n "[key_change]" [file]  # Confirm specific changes present

# 3. Run validation suite (from engineering.md)
yarn tsc --noEmit              # Must return exit code 0
yarn lint                      # Must return exit code 0
yarn build                     # Must succeed
```

## 🔴 FALSE COMPLETION PATTERNS (FORBIDDEN)

### ❌ NEVER Report Completion With These Patterns:

```markdown
❌ "I've updated the configuration to include..."  [No actual file write]
❌ "The changes have been made to the workflow..."  [Changes only described, not written]
❌ "I'll update the file to include..."            [Future tense = not done]
❌ "Here's what should be added..."                [Showing changes without writing]
❌ "The implementation is complete..."             [Without file persistence verification]
```

### ✅ CORRECT Completion Patterns:

```markdown
✅ "I've written the changes to `/path/to/file.md`. The file now includes..."
✅ "Updated `/absolute/path/file.ts` with the new implementation. Verified with `git diff`..."
✅ "Changes persisted to disk:
    - Written: `/path/to/file1.md` (added 45 lines)
    - Modified: `/path/to/file2.ts` (updated error handling)
    - Created: `/path/to/newfile.yaml` (new configuration)"
```

## 📋 Task Completion Protocol

### Stage 1: Implementation Planning
1. Identify ALL files that need modification
2. Document the specific changes required for each file
3. Create a file modification checklist

### Stage 2: File Modification Execution
1. **READ** existing file content (using Read tool)
2. **MODIFY** using Edit tool or Write tool
3. **VERIFY** each write operation succeeded
4. **TRACK** completion status per file

### Stage 3: Persistence Verification
```yaml
persistence_verification:
  for_each_modified_file:
    - confirm_file_exists: "ls -la [file_path]"
    - verify_modifications: "git diff [file_path]"
    - validate_specific_changes: "grep -n '[expected_content]' [file_path]"

  summary_validation:
    - list_all_changes: "git status"
    - count_modifications: "git diff --stat"
    - verify_no_pending: "Confirm no changes described but not written"
```

### Stage 4: Quality Gate Validation
Execute the standard validation from `engineering.md`:
- TypeScript compilation check
- Linting validation
- Build verification
- Test execution (if applicable)

### Stage 5: Completion Reporting
```yaml
completion_report:
  files_modified:
    - path: "/absolute/path/to/file1.md"
      action: "modified"
      lines_changed: "+50, -10"
      key_changes: "Added persistence verification section"

    - path: "/absolute/path/to/file2.ts"
      action: "created"
      lines_added: 125
      purpose: "New validation module"

  verification_status:
    git_diff_confirmed: true
    typescript_check: "passed"
    lint_check: "passed"
    build_status: "succeeded"

  completion_statement: |
    "All changes have been written to disk and verified.
     Modified 2 files with a total of +175/-10 lines changed.
     All quality gates passed."
```

## 🔄 Integration with Existing Workflows

### Update to Development Workflow (Stage 7)
**Location**: `.claude/workflows/development-workflow.md`

Add to "Final Validation & Completion" section:
```bash
# File Persistence Verification (NEW)
git status                    # Must show modified files
git diff --stat              # Must show lines changed
ls -la [modified_files]      # Files must exist with recent timestamps
```

### Update to Definition of Done
**ALL** workflows must include:
- [ ] Changes written to disk (verified with `git status`)
- [ ] File modifications confirmed (verified with `git diff`)
- [ ] File timestamps updated (verified with `ls -la`)
- [ ] No described changes left unwritten
- [ ] Absolute file paths documented in completion report

## 🚦 Agent Decision Tree for Completion

```
Task Received
    ↓
Plan Changes → Identify Files → Read Files
    ↓
Make Changes → Write/Edit Files → Verify Each Write
    ↓
Check: All planned changes written?
    ├─ NO → Continue writing remaining changes
    └─ YES → Run persistence verification
           ↓
       Check: Do files contain expected changes?
           ├─ NO → Re-write missing changes
           └─ YES → Run quality gates
                  ↓
              Check: All validations pass?
                  ├─ NO → Fix issues, re-validate
                  └─ YES → Generate completion report
                         ↓
                     ✅ TASK COMPLETE
```

## 🎫 Automatic Ticket Creation for Persistence Failures

When file persistence cannot be verified:

```bash
/create-ticket File persistence verification failed for [task_description],
  severity: Major,
  effort: S,
  details: "Changes described but not written to disk. Files requiring update: [file_list]"
```

## 📏 Compliance Measurement

### Success Metrics
- **File Persistence Rate**: % of tasks with verified file writes
- **False Completion Rate**: % of tasks claiming completion without file writes (target: 0%)
- **Verification Time**: Average time to verify persistence (target: <5 seconds)

### Audit Commands
```bash
# Check if agent wrote files in last task
git log -1 --stat          # Show files changed in last commit

# Verify working directory changes
git status --short         # Quick view of modifications

# Count actual lines modified
git diff --numstat         # Numerical summary of changes
```

## 🔗 Cross-References

This protocol integrates with:
- `.claude/workflows/development-workflow.md` - Stage 7 completion validation
- `.claude/policies/engineering.md` - Pre-completion protocol
- `.claude/CLAUDE.md` - Core belief: "Complete – no placeholders, no gaps"
- `.claude/workflows/orchestration-protocols.md` - Handoff verification

---

**Remember**: A task without file persistence is an incomplete task. Always write, always verify, then report completion.