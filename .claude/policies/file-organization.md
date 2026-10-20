# File Organization & Information Architecture Policy

**Status**: ENFORCED
**Version**: 1.0.0
**Last Updated**: 2025-10-30
**Authority**: Supersedes all conflicting guidance

## CRITICAL: File Placement Rules

**VIOLATIONS OF THIS POLICY CONSTITUTE BUILD FAILURES**

### 🚫 FORBIDDEN LOCATIONS

The following locations are **STRICTLY FORBIDDEN** for agent-generated content:

1. **/.claude/issues/** - YAML tickets ONLY (no reports, summaries, or analysis)
2. **Project root (/)** - NO deliverables except approved README.md
3. **Feature folders** - NO standalone documents (code artifacts only)
4. **/src/**, **/packages/** - NO documentation (code only)
5. **/node_modules/** - NEVER write here

### ✅ MANDATORY OUTPUT LOCATIONS

All agent deliverables MUST use these locations:

```
/deliverables/
├── analysis/           # Research, market analysis, technical assessments
│   ├── business/      # Financial models, market research, strategy docs
│   ├── technical/     # Architecture decisions, performance analysis
│   └── requirements/  # BRDs, PRDs, specifications
│
├── reports/           # Structured reports and summaries
│   ├── executive/     # Executive summaries, board presentations
│   ├── status/        # Project status, sprint reviews
│   ├── incidents/     # Post-mortems, RCAs
│   └── handoffs/      # Session continuity reports
│
├── designs/           # Design artifacts
│   ├── architecture/  # System designs, diagrams
│   ├── ui-ux/        # Mockups, wireframes, prototypes
│   └── database/     # Schema designs, ERDs
│
├── documentation/     # User-facing documentation
│   ├── api/          # API docs, OpenAPI specs
│   ├── user-guides/  # End-user documentation
│   └── internal/     # Team wikis, runbooks
│
└── working/          # Temporary work products
    └── [session-id]/ # Session-specific scratch space
```

### 📋 File Type Routing

| Artifact Type | MUST Go To | Example |
|--------------|------------|---------|
| **Task Completion Updates** | **Update appropriate README.md** | **See README Update Protocol** |
| Executive Summary | `/deliverables/reports/executive/` | `epic-1.2-summary.md` |
| Issue Analysis | `/deliverables/reports/incidents/` | `auth-failure-analysis.md` |
| Market Research | `/deliverables/analysis/business/` | `competitor-analysis.md` |
| Technical Design | `/deliverables/designs/architecture/` | `payment-system-design.md` |
| Financial Model | `/deliverables/analysis/business/` | `revenue-projection.xlsx` |
| API Documentation | `/deliverables/documentation/api/` | `rest-api-v2.md` |
| Requirements Doc | `/deliverables/analysis/requirements/` | `mobile-app-brd.md` |
| UI Mockup | `/deliverables/designs/ui-ux/` | `checkout-flow.png` |

### 📝 README Update Protocol

**IMPORTANT:** For task completion documentation, agents should UPDATE README files instead of creating separate reports.

**README Selection:**
- Mobile app work → your mobile app README (example: `/apps/mobile/README.md`)
- Root/shared work → `/README.md`
- Specific package → `/{package}/README.md`

**Update Format:** Add to "Recent Updates" section (see orchestration.md for format). Keep only the **5 most recent entries** — remove older ones.

### 🎯 Agent-Specific Rules

#### Business Agents (financial-analyst, business-strategist, business-requirements-analyst, vc-advisor)
- **PRIMARY**: `/deliverables/analysis/business/`
- **REPORTS**: `/deliverables/reports/executive/`
- **NEVER**: `.claude/issues/` or project root

#### Development Agents (technical-architect, ios-expo-architect, integration-engineer)
- **CODE**: In appropriate `/src/` or `/packages/` locations
- **DESIGNS**: `/deliverables/designs/architecture/`
- **DOCS**: `/deliverables/documentation/api/`
- **NEVER**: Standalone docs in feature folders

#### Design Agents (brand-designer, graphic-design-artist, senior-frontend-layout-expert)
- **PRIMARY**: `/deliverables/designs/ui-ux/`
- **SYSTEMS**: `/deliverables/designs/architecture/`
- **NEVER**: `/src/` directories

#### Management Agents (project-manager, agent-orchestrator)
- **STATUS**: `/deliverables/reports/status/`
- **HANDOFFS**: `/deliverables/reports/handoffs/`
- **NEVER**: `.claude/` internal directories

### 🔒 Enforcement Mechanisms

#### 1. Pre-Write Validation
Before ANY file write operation:
```typescript
function validateFilePath(path: string, artifactType: string): boolean {
  // Check forbidden locations
  const forbidden = [
    /^\/\.claude\/issues\//,  // No docs in issues
    /^\/[^\/]+\.(md|txt|doc)$/, // No root-level docs
    /^\/src\/.*\.(md|txt|doc)$/, // No docs in src
  ];

  if (forbidden.some(regex => regex.test(path))) {
    throw new Error(`FORBIDDEN: ${artifactType} cannot be written to ${path}`);
  }

  // Validate correct location
  const routing = getRoutingRules(artifactType);
  if (!path.startsWith(routing.requiredPrefix)) {
    throw new Error(`MISPLACED: ${artifactType} must be in ${routing.requiredPrefix}`);
  }

  return true;
}
```

#### 2. Naming Conventions
All deliverables MUST follow these patterns:
- `YYYY-MM-DD-{type}-{description}.{ext}`
- Example: `2025-10-30-analysis-market-opportunity.md`
- Session-specific: `session-{id}-{type}-{description}.{ext}`

#### 3. Directory Creation
Agents MUST create directories if they don't exist:
```bash
mkdir -p /deliverables/analysis/business
mkdir -p /deliverables/reports/executive
```

### 📊 Compliance Monitoring

#### Self-Test Command
```bash
# Check for misplaced files
find . -name "*.md" -o -name "*.txt" | while read f; do
  if [[ "$f" =~ ^\./\.claude/issues/ ]] && [[ ! "$f" =~ \.yaml$ ]]; then
    echo "VIOLATION: Non-YAML file in issues: $f"
  fi
  if [[ "$f" =~ ^\./[^/]+\.(md|txt)$ ]] && [[ "$f" != "./README.md" ]]; then
    echo "VIOLATION: Document in project root: $f"
  fi
done
```

#### Migration Required
Existing misplaced files MUST be moved:
```bash
# Move misplaced executive summaries
mv .claude/issues/*-summary.md deliverables/reports/executive/

# Move root-level deliverables
mv IMPLEMENTATION_*.md deliverables/reports/status/
mv *_ANALYSIS.md deliverables/analysis/technical/
```

### 🚨 Violations & Consequences

1. **Build Failures**: CI/CD will FAIL if files are misplaced
2. **PR Blocks**: PRs with misplaced files will be auto-rejected
3. **Agent Scoring**: Violations reduce agent trust scores
4. **Rollback**: Misplaced files are automatically deleted

### 📝 Examples

#### ✅ CORRECT
```bash
# Business analysis
/deliverables/analysis/business/2025-10-30-market-segmentation.md

# Executive summary
/deliverables/reports/executive/2025-10-30-epic-1.2-summary.md

# Technical design
/deliverables/designs/architecture/2025-10-30-payment-gateway.md
```

#### ❌ INCORRECT
```bash
# WRONG: Executive summary in issues
/.claude/issues/epic-summary.md

# WRONG: Analysis in root
/market-analysis.md

# WRONG: Design doc in src
/src/components/design-notes.md
```

### 🔄 Policy Updates

This policy is version-controlled and changes require:
1. Review by senior engineering
2. Update to all agent definitions
3. Migration plan for existing files
4. CI/CD rule updates

### 📚 Related Policies

- `.claude/policies/engineering.md` - Code organization
- `.claude/policies/ticket-system.md` - Issue tracking
- `.claude/workflows/file-persistence-protocol.md` - File operations

---

**REMEMBER**: When in doubt, use `/deliverables/`. NEVER put documents in `.claude/issues/` or project root.