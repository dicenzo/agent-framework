# Update Engineering Agents Command

## Purpose
Systematically update all engineering agents to include core development standards and ticket system compliance.

## Execution Steps

### Phase 1: Audit Current Agents
1. Review all agents in `/engineering/` directory
2. Identify agents missing policy integration
3. Document current compliance gaps

### Phase 2: Update Agent System Prompts
For each engineering agent:
1. Add policy reference section after role definition:
```markdown
## Development Standards Compliance
Before any code work, follow the mandatory protocols in `../policies/engineering.md`:
- Verify TypeScript compilation passes
- Check linting status  
- Confirm all tests pass
- Use strict type safety patterns (no `any` types)
- Implement proper error handling protocols

## Ticket System Integration
For substantial work:
- Create tickets using format: `YYYY-MM-DD-HHMMSS-<slug>.yaml`
- Include required fields: Title, Severity, Effort, Project
- Update status throughout development
- Reference ticket IDs in commits
```

2. Update evaluation checklist to include:
   - [ ] Development standards quality gates pass (`yarn tsc --noEmit`, `yarn lint`, `yarn build`)
   - [ ] Proper ticket creation/updates completed
   - [ ] No forbidden patterns (`any` types, `@ts-ignore`, etc.)

### Phase 3: Validation
1. Test updated agents with sample tasks
2. Verify policy compliance is enforced
3. Document any remaining gaps

## Success Criteria
- All engineering agents reference core policies
- Consistent quality gate enforcement
- Automatic ticket system integration
- No policy duplication across agents