# Development Workflow for AI Engineering & Product Agents

## Overview
This workflow orchestrates consistent, high-quality development practices across all AI engineering and product agents. Each stage includes finite resolution loops (max 3 iterations) and clear handoff protocols.

**Foundation**: All technical requirements and validation criteria are defined in `.claude/policies/engineering.md`. This document focuses on process orchestration and agent coordination.

---

## Stage 1: Initial Analysis & Context Setup

### Prerequisites
- **Context Handoffs**: Use `session-orchestrator` for state and context handoffs on long or multi-session work (the community `context-manager` agent is an optional alternative)
- **README Analysis**: Review all relevant README.md files in the project scope
- **Standards Compliance**: Follow `.claude/policies/engineering.md`

### Actions
```bash
# Baseline validation - see engineering.md for details
yarn tsc --noEmit  # Must pass before starting
yarn lint 2>&1 | tail -n 1  # Note current error/warning count
yarn lint --format json > .lint-baseline-$(date +%s).json  # Save timestamped baseline
```

### Success Criteria
- [ ] Relevant READMEs identified and reviewed
- [ ] Development standards understood
- [ ] Baseline TypeScript/lint status confirmed
- [ ] Context boundaries established (session-orchestrator for multi-session work)

### Resolution Loop
- **Max Iterations**: 3
- **Escalation**: Create ticket if context understanding incomplete after 3 iterations

---

## Stage 2: Planning & Architecture

### Prerequisites
- Stage 1 completed successfully
- Context manager engaged for handoff

### Actions
1. **Break work into cross-stack stages** with clear success criteria
2. **Define explicit type contracts** for all interfaces
3. **Plan test strategy** before implementation
4. **Document API shapes** using OpenAPI/Swagger format where applicable

### Validation Checklist
- [ ] Each stage has measurable completion criteria
- [ ] Dependencies between stages identified
- [ ] Test strategy defined for UI, API, and service layers
- [ ] Type safety approach planned

### Success Criteria
- [ ] Written plan with stage boundaries
- [ ] Test definitions ready
- [ ] Architecture decisions documented
- [ ] Performance considerations identified

### Resolution Loop
- **Max Iterations**: 3
- **Escalation**: Create architecture ticket if planning blocked

---

## Stage 3: Test-First Implementation

### Prerequisites
- Stage 2 planning completed
- Context manager transition executed

### Actions
**Follow implementation protocols per `engineering.md`:**
- Define tests BEFORE implementation (UI, APIs, Services)
- Implement minimal code to pass defined tests
- Apply TypeScript safety protocols (no `any`, use type guards, proper error handling)

### Mandatory Commands - During Development
```bash
# Run frequently during implementation
yarn lint --fix    # Auto-fix issues as you go
yarn tsc --noEmit  # Verify types continuously
yarn test          # Run relevant tests frequently
```

### Mandatory Commands - Before Moving to Next Stage
```bash
# ALL must return exit code 0 - ZERO TOLERANCE
yarn lint --fix                # Auto-fix all fixable issues first
yarn lint --max-warnings 0     # MUST PASS with 0 errors, 0 warnings
yarn tsc --noEmit              # MUST PASS with 0 type errors
yarn test                      # ALL tests must pass

# Optional: Run validation script
./.claude/scripts/validate-lint.sh  # Comprehensive validation
```

### Success Criteria
- [ ] Tests are deterministic, fast, and properly mocked
- [ ] All tests pass
- [ ] **LINT COMPLIANCE**: `yarn lint --max-warnings 0` passes (ZERO errors, ZERO warnings)
- [ ] **TYPE SAFETY**: `yarn tsc --noEmit` passes (ZERO type errors)
- [ ] No new lint violations vs baseline
- [ ] Code follows type safety protocols per engineering.md
- [ ] Error handling follows prescribed patterns
- [ ] No forbidden patterns (any, @ts-ignore, improper catches)

### Resolution Loop
- **Max Iterations**: 3
- **Escalation**: Create implementation ticket if blocked

---

## Stage 4: Performance Review

### Prerequisites
- Stage 3 implementation completed
- Context handoff to the performance reviewer

### Actions
1. **Engage a performance reviewer**: `performance-engineer` (optional community agent) if installed; otherwise `technical-architect` for query and architecture review and `qa-engineer` for load and regression testing
2. **Review for**:
   - Bundle size impact
   - Runtime performance
   - Memory usage
   - Database query efficiency
   - Network request optimization

### Performance Checklist
- [ ] No performance regressions introduced
- [ ] Bundle size within acceptable limits
- [ ] Database queries optimized
- [ ] Async operations properly handled
- [ ] Memory leaks prevented

### Success Criteria
- [ ] Performance review passed
- [ ] Optimizations implemented if required
- [ ] Performance metrics documented

### Resolution Loop
- **Max Iterations**: 3
- **Escalation**: Create performance ticket if optimization blocked

---

## Stage 5: Code Quality Review

### Prerequisites
- Stage 4 performance review completed
- Context handoff to the code reviewer

### Actions
1. **Run Lint Compliance Check**:
   ```bash
   yarn lint --fix                # Auto-fix first
   yarn lint --max-warnings 0     # MUST PASS with ZERO tolerance
   ```
2. **Engage a code reviewer**: `code-reviewer` (optional community agent) if installed; otherwise `qa-engineer` for the review and `security-architect` for security-sensitive changes, followed by `gatekeeper`
3. **Review criteria per engineering.md Lint Compliance Protocol**

### Code Quality Checklist
- [ ] **LINT COMPLIANCE**: `yarn lint --max-warnings 0` passes (ZERO errors, ZERO warnings)
- [ ] All auto-fixable issues resolved via `yarn lint --fix`
- [ ] Manual fixes applied for non-auto-fixable issues
- [ ] Code follows established patterns
- [ ] Type safety protocols followed (per engineering.md)
- [ ] Error handling consistent
- [ ] Code is self-documenting
- [ ] No forbidden patterns detected

### Success Criteria
- [ ] Code review passed
- [ ] All quality issues resolved
- [ ] Refactoring completed if needed (with ≥60% test coverage)

### Resolution Loop
- **Max Iterations**: 3
- **Escalation**: Create code quality ticket if unresolvable issues

---

## Stage 6: QA & Testing

### Prerequisites
- Stage 5 code review completed
- Context manager handoff to qa-engineer

### Actions
1. **Engage QA Engineer**: `.claude/agents/engineering/qa-engineer.md`
2. **Execute comprehensive testing**:
   - Unit tests
   - Integration tests
   - End-to-end tests (if applicable)
   - Edge case validation
   - Error scenario testing

### QA Checklist
- [ ] Test coverage ≥60% (per engineering.md)
- [ ] All test types executed successfully
- [ ] Edge cases covered
- [ ] Error scenarios tested
- [ ] Cross-browser/platform testing (if applicable)

### Success Criteria
- [ ] All tests pass
- [ ] Coverage requirements met
- [ ] QA approval obtained
- [ ] Test documentation updated

### Resolution Loop
- **Max Iterations**: 3
- **Escalation**: Create QA ticket if testing blocked

---

## Stage 7: Final Validation & Completion

### Prerequisites
- All previous stages completed
- Context manager final validation

### Validation Protocol
**Execute mandatory pre-completion protocol per `engineering.md`:**

#### Phase 1: File Persistence Verification
```bash
git status                    # Verify changes written
git diff --stat              # Verify lines changed
```

#### Phase 2: Lint and Type Validation (ZERO TOLERANCE)
```bash
yarn lint --fix                     # Auto-fix all fixable issues
yarn lint --max-warnings 0          # MUST EXIT 0 (zero errors, zero warnings)
yarn tsc --noEmit                   # MUST EXIT 0 (zero type errors)
yarn build                          # MUST SUCCEED

# Run comprehensive validation
./.claude/scripts/validate-lint.sh  # MUST PASS
```

#### Phase 3: Type Safety Audit
```bash
# Scan for forbidden patterns
grep -r ": any" src/ --exclude-dir=node_modules
grep -r "@ts-ignore" src/ --exclude-dir=node_modules
grep -r "catch.*:" src/ --exclude-dir=node_modules | grep -v "unknown"
```

#### Phase 4: Import Resolution & Build Test
```bash
# Verify cross-package imports
yarn workspace [package] build  # For affected packages
```

### Final Checklist
- [ ] **LINT COMPLIANCE**: Zero errors and warnings (`yarn lint --max-warnings 0` passes)
- [ ] **TYPE SAFETY**: Zero type errors (`yarn tsc --noEmit` passes)
- [ ] **BUILD SUCCESS**: All affected packages build successfully
- [ ] **FILE PERSISTENCE**: All changes confirmed via `git status` and `git diff`
- [ ] **NO FORBIDDEN PATTERNS**: No `any`, `@ts-ignore`, improper catches
- [ ] **BASELINE COMPARISON**: No new lint violations vs baseline
- [ ] Documentation updated
- [ ] Context properly handed back to requesting agent

### Definition of Done
- [ ] All checks per engineering.md passed
- [ ] **README updated** with task completion (not separate report)
  - Mobile work → your mobile app README (example: `/apps/mobile/README.md`)
  - Root work → `/README.md`
  - Package work → `/{package}/README.md`
- [ ] No unresolved errors/warnings
- [ ] Meets scope & success criteria
- [ ] File persistence verified

---

## Issue Ticketing System

### When to Create Tickets
- Any stage exceeds 3 iteration limit
- Blocking issues that prevent workflow completion
- Technical debt identified during review
- Performance issues requiring future optimization
- Unresolved errors/warnings at workflow completion

### Integration with Ticket System
Use the centralized ticket system via `/create-ticket` command or direct YAML creation:

### Ticket Creation Process
```bash
# For blocking issues during workflow
/create-ticket [Description], severity: Blocker, effort: [XS|S|M|L|XL], project: [project-name]

# Examples:
/create-ticket TypeScript compilation failing in auth module, severity: Blocker, effort: S
/create-ticket Performance optimization needed for dashboard queries, severity: Major, effort: L
```

### Workflow-Specific Ticket Fields
When creating tickets during development workflow, include:

- **Stage Context**: Which workflow stage encountered the issue
- **Agent Context**: Which agent was executing when issue occurred
- **Iteration Count**: How many attempts were made (max 3)
- **Related Files**: Specific file paths where issue manifests
- **Acceptance Criteria**: Clear completion criteria for resolution

### Additional Debug Fields (When Applicable)
- **Steps to Reproduce**: Exact commands/actions that trigger the issue
- **Expected vs Actual**: What should happen vs what actually occurs
- **Error Messages**: Full error output, stack traces, build logs
- **Attempted Solutions**: List of approaches tried during the 3 iterations

### Severity Mapping from Development Workflow
- **Blocker**: Prevents workflow completion, build failures, security issues
- **Major**: Functionality issues, performance regressions, failing tests
- **Minor**: Code quality issues, technical debt, documentation gaps

### Effort Estimates for Development Issues
- **XS**: Quick fixes, typos, simple config changes
- **S**: Single file changes, minor bug fixes, lint fixes
- **M**: Multiple file changes, moderate refactoring, test additions
- **L**: Feature changes, architecture updates, complex debugging
- **XL**: Major refactoring, breaking changes, system redesign

### Auto-Ticket Creation
Agents should automatically create tickets when:
1. **Resolution Loop Exceeds Limit**: After 3 failed iterations in any stage
2. **Lint Compliance Fails**: When `yarn lint --max-warnings 0` fails after fixes attempted
3. **Type Check Fails**: When `yarn tsc --noEmit` fails after corrections attempted
4. **Quality Gates Fail**: When mandatory commands return non-zero exit codes
5. **Unresolved Warnings**: When workflow completes but issues remain
6. **Context Handoff Failures**: When agent transitions fail

### Lint-Specific Ticket Creation
When lint issues prevent completion:
```bash
/create-ticket Lint compliance failure: [X errors, Y warnings] in [component/area], severity: [Blocker|Major], effort: [S|M], project: [project-name]

# Include in ticket:
# - Full lint output
# - Auto-fix results
# - List of non-auto-fixable issues
# - Attempted manual fixes
```

### Ticket Location & Format
- **Location**: `.claude/issues/`
- **Format**: `YYYY-MM-DD-HHMMSS-<slug>.yaml`
- **Template**: Use `/.claude/issues/template.yaml` as base
- **Policy**: Follow `.claude/policies/ticket-system.md`

---

## Context Management Integration

### Handoff Protocol
1. **Context Preparation**: Summarize current state, decisions made, and next requirements
2. **Context Transfer**: Use session-orchestrator (or the optional community context-manager) to pass context between agents
3. **Context Validation**: Receiving agent confirms understanding before proceeding
4. **Context Compression**: Remove unnecessary details while preserving essential information

### Context Efficiency Rules
- **Maximum Context Size**: 10,000 tokens per handoff
- **Essential Information Only**: Remove intermediate discussion, keep decisions and current state
- **Structured Handoffs**: Use consistent format for agent-to-agent communication
- **Context Validation**: Confirm understanding before proceeding to next stage

---

## Escalation Protocols

### Immediate Escalation Triggers
- **Lint compliance failure** after auto-fix and manual attempts
- **Type check failure** after corrections attempted
- Any build failure
- Security vulnerabilities detected
- Data loss or corruption risk
- Breaking changes to public APIs

### Standard Escalation Process
1. **Document Issue**: Create detailed ticket
2. **Mark as Blocker**: If prevents other work
3. **Notify Context Manager**: For workflow coordination
4. **Provide Workaround**: If possible, implement temporary solution
5. **Schedule Resolution**: Set timeline for proper fix

### Emergency Protocols
- **Production Issues**: Immediate rollback if possible
- **Security Issues**: Isolate and assess impact
- **Data Issues**: Stop operations, assess integrity
- **Build Breaks**: Fix immediately or revert changes

---

## Success Metrics

### Workflow KPIs
- **Completion Rate**: % of workflows completed without escalation
- **Iteration Efficiency**: Average iterations per stage
- **Quality Score**: % passing all quality gates
- **Time to Completion**: Average time per workflow stage

### Quality Metrics
- **Lint Compliance Rate**: % tasks passing `yarn lint --max-warnings 0` on first try
- **Type Safety Score**: % code without `any` types
- **Test Coverage**: % code covered by tests
- **Performance Score**: No regressions introduced
- **Documentation Score**: % features properly documented
- **Auto-Fix Rate**: % of lint issues resolved by `yarn lint --fix`

### Lint Compliance Tracking
Track these metrics weekly to measure improvement:
1. **New Lint Violations**: Count after each task completion
2. **First-Pass Success**: % of tasks passing lint validation on first attempt
3. **Auto-Fix Effectiveness**: % of errors fixed automatically
4. **Agent Compliance**: % of tasks running full validation protocol

---

## Lint Compliance Quick Reference

### Before Starting
```bash
yarn lint 2>&1 | tail -n 1  # Note current count
yarn lint --format json > .lint-baseline-$(date +%s).json
```

### During Development
```bash
yarn lint --fix    # Auto-fix frequently
yarn tsc --noEmit  # Check types continuously
```

### Before Completion (MANDATORY)
```bash
yarn lint --fix                     # Auto-fix all issues
yarn lint --max-warnings 0          # MUST EXIT 0
yarn tsc --noEmit                   # MUST EXIT 0
./.claude/scripts/validate-lint.sh  # Comprehensive check
```

### Common Violations & Fixes
See `.claude/policies/engineering.md` section **Lint Compliance — Zero Tolerance** for:
- Import order fixes (auto-fixable)
- React Hooks violations (conditional hooks)
- Promise handling (async in handlers)
- Unsafe type operations
- Unused variables
- Console statements

---

This workflow ensures consistent, high-quality development while maintaining context efficiency and preventing endless iteration loops. All technical standards and validation requirements are defined in `engineering.md`.
