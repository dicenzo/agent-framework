# Ticket Management Workflow

## Overview
Simple, AI-friendly issue tracking system for cross-project work coordination.

## Workflow States
```
Open → [Assignment] → In Progress → [Blocked] → Resolved → Closed
                  ↗              ↗           ↘
```

## Ticket Creation Process
1. **Parse Request** - Extract title, severity, effort, project from natural language
2. **Generate ID** - Format: `YYYY-MM-DD-HHMMSS-<slug>`
3. **Create File** - Use YAML template in `/.claude/issues/` directory
4. **Set Metadata** - Timestamp, creator, project context, project working directory
5. **Validate** - Ensure required fields are present

## Ticket Updates
- **Status Changes**: Update `status` and `updated_at` fields
- **Assignments**: Set `assigned_to` field
- **Resolution**: Add `resolution` description when closing
- **Dependencies**: Link related tickets via IDs

## Severity Guidelines
- **Blocker**: Prevents other work, requires immediate attention
- **Major**: Significant impact, should be prioritized
- **Minor**: Low impact, can be scheduled later

## Effort Estimates
- **XS**: < 1 hour (quick fix, typo)
- **S**: 1-4 hours (small feature, simple bug)
- **M**: 1-2 days (medium feature, complex bug)
- **L**: 3-5 days (large feature, refactoring)
- **XL**: > 1 week (major feature, architectural change)

## Assignment Protocol (Leverages Existing Orchestration)

### Automatic Assignment Process
1. **Complexity Analysis**: Use agent-orchestrator scoring framework
2. **Domain Detection**: Parse ticket content for domain keywords
3. **Routing Logic**: Apply dispatch protocol (delegate, don't solve)

### Assignment Complexity Scoring
```yaml
# Simple (Score 0-2): Direct assignment
effort: [XS, S] + single_domain → specialist_agent

# Moderate (Score 3-4): Workflow planning
effort: [M] + multi_domain → workflow-orchestrator → specialist_agent

# Complex (Score 5+): Full orchestration
effort: [L, XL] + complex_requirements → agent-orchestrator
```

### Domain-to-Agent Routing
- **Engineering**: qa-engineer, security-architect, technical-architect
- **Backend**: technical-architect, integration-engineer, cloud-infrastructure-architect
- **Frontend**: react-vite-engineer, senior-frontend-layout-expert
- **Mobile**: expo-react-native-specialist, ios-expo-architect, android-expo-architect
- **Business**: business-strategist, financial-analyst, project-manager
- **Creative**: brand-designer, graphic-design-artist, typography-specialist, design-qa-reviewer
- **Marketing**: marketing-expert, content-strategy-agent, branding-specialist

Optional community agents (see the README) slot into these lists when installed: `typescript-pro`, `code-reviewer`, `performance-engineer` (Engineering); `backend-architect` (Backend); `react-component-architect`, `nextjs-pro` (Frontend); `ui-designer`, `ux-designer` (Creative); `content-marketer` (Marketing). Route to them only if their files exist in `.claude/agents/`.

### Assignment Commands
```bash
# Manual assignment
/assign-ticket YYYY-MM-DD-HHMMSS-slug

# Auto-assignment during creation
/create-ticket [description], auto-assign: true
```

## File Management
- **Active Tickets**: `/.claude/issues/YYYY-MM-DD-HHMMSS-<slug>.yaml`
- **Resolved Archive**: `/.claude/issues/resolved/YYYY-MM/YYYY-MM-DD-HHMMSS-<slug>.yaml`
- **Format**: YAML for AI readability
- **Template**: Use `/.claude/issues/template.yaml` as base

### Archive Organization
When tickets reach "Resolved" status, they should be moved to the archive:
- **Archive Path**: `/.claude/issues/resolved/YYYY-MM/`
- **Month Folders**: Auto-created based on resolution date (e.g., `2025-09`)
- **File Names**: Preserve original ticket filename
- **Purpose**: Keep active issues directory clean while maintaining searchable history

### Archive Process
1. **Trigger**: When ticket status changes to "Resolved"
2. **Create Month Folder**: If `resolved/YYYY-MM` doesn't exist, create it
3. **Move File**: Transfer ticket from `/.claude/issues/` to `/.claude/issues/resolved/YYYY-MM/`
4. **Update Timestamp**: Set `updated_at` field during the move
5. **Preserve ID**: Keep original filename for reference consistency