# Claude Instructions (Template)

Copy this file to your project root (or `~/.claude/CLAUDE.md`) and edit the
"Project Layout" section to match your repository.

## Core Beliefs
- **Iterative delivery**: ship small, working slices.
- **Understand before you act**: trace patterns before changing.
- **Pragmatism over ideology**: choose what serves the goal.
- **Readable > clever**: optimize for future readers.
- **Cross-domain consistency**: apply the same quality bar whether in dev, finance, marketing, or design.

---

## Universal Process
1. **Plan**: break into clear stages with success criteria.
2. **Test First**: define checks (unit, data, logic, citations).
3. **Implement Minimal**: only what's needed to pass checks.
4. **Refactor / Clarify**: improve clarity once safe.
5. **Review & Deliver**: validate against goals and quality gates.

---

## Quality Gates
- **Complete**: no placeholders, no gaps.
- **Validated**: tests pass, sources cited, or calculations correct.
- **Consistent**: follows patterns and vocabulary.
- **Readable**: understandable in 6 months.

**Definition of Done:**
- All checks/tests pass
- Docs updated
- No unresolved errors/warnings
- Meets scope & success criteria

---

## Never / Always
**NEVER:**
- Merge failing builds or incomplete work
- Skip validation/tests
- Change contracts or assumptions silently
- **Place deliverables in `.claude/issues/` or project root** (see file-organization policy)

**ALWAYS:**
- Ship vertical slices
- Keep outputs consistent across domains
- Cite sources for research
- Document meaningful errors and risks
- **Follow file organization rules**: `/deliverables/` structure per policy

---

## Quick Reference
- Agents: `/.claude/agents.md`
- Commands: `/.claude/commands.json`
- Workflows: `/.claude/workflows.md` (navigation index for all workflow patterns)
- MCP Servers: `/.claude/mcp_servers.md`

## Project Layout (example, edit for your repo)
- Mobile app: `/apps/mobile`
- Database functions and migrations: `/supabase`
- Shared services: `/services`
- Infrastructure and deployment scripts: `/infrastructure`
- Project README: `/README.md`

---

## Next Steps
For deeper guidance, see:
- **`/.claude/policies/file-organization.md`: where to place ALL deliverables**
- **`/.claude/policies/engineering.md`: dev standards, lint compliance, type safety**
- `/.claude/policies/expo-react-native.md`: React Native/Expo guidelines (delete if unused)
- `/.claude/policies/orchestration.md`: dispatch rules, orchestration protocols, deliverable verification
- `/.claude/policies/ticket-system.md`: ticket format and lifecycle
- `/.claude/policies/writing.md`: writing standards
- `/.claude/policies/mcp_server_guidelines.md`: MCP design and testing
- `/.claude/agents.md`: agent catalog
- `/.claude/workflows.md`: workflow navigation index
- `/.claude/workflows/`: workflow implementations (development, tickets, handoffs)
