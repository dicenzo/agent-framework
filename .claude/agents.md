# Agent Directory

Catalog of the 44 agents included in this framework, grouped by category, plus the optional community agents the routing tables can use when installed.

**Purpose:** Quick reference for agent selection and cross-domain task coordination.

## Usage

Select agents by category based on the task. For work that needs 3 or more agents, start with `agent-orchestrator`, which scores complexity (0-10) and picks a workflow. Every orchestrated deliverable passes through `gatekeeper` before delivery.

## Agent Management (4 agents)

- **agent-orchestrator**: Entry point for multi-domain work; complexity scoring and workflow routing
- **gatekeeper**: Quality validation gate for deliverables
- **session-orchestrator**: Multi-session workflow state, checkpoints, and parallel execution
- **workflow-orchestrator**: Multi-agent execution planning

## Engineering (13 agents)

- **agent-systems-architect**: Multi-agent workflow design and governance
- **android-expo-architect**: Android-specific Expo development and optimization
- **cloud-infrastructure-architect**: Cloud infrastructure design, Terraform, AWS/GCP architecture
- **devops-engineer**: CI/CD, infrastructure, deployment automation
- **expo-react-native-specialist**: Cross-platform mobile development
- **integration-engineer**: System integrations and API connectivity
- **ios-expo-architect**: iOS-specific Expo development and optimization
- **qa-engineer**: Test strategy, automation, quality assurance
- **react-vite-engineer**: React/Vite applications, TypeScript, Tailwind CSS, front-end build optimization
- **security-architect**: Threat modeling, compliance, security design
- **tech-stack-analyst**: Technology evaluation and architecture audit
- **technical-architect**: System design, API and data architecture, roadmaps
- **template-systems-developer**: Template engines and systems

## Business (8 agents)

- **business-requirements-analyst**: Strategic requirements and operational planning
- **business-strategist**: Business models and go-to-market strategies
- **compliance-agent**: Regulatory compliance and legal documents
- **financial-analyst**: Financial modeling and viability assessment
- **legal-reviewer**: Legal risk assessment and compliance review
- **project-manager**: Timeline coordination and deliverable packaging
- **technical-writer**: API docs, guides, README creation
- **vc-advisor**: Investment analysis from an investor perspective

## Product (3 agents)

- **requirements-to-stories**: Requirements converted to user stories
- **spec-decomposer**: PRDs decomposed into development phases
- **spec-writer**: Roadmap phases expanded to developer specs

## Marketing (7 agents)

- **brand-hierarchy-strategist**: Brand architecture and portfolio strategy
- **brand-research-analyst**: Brand auditing and competitive analysis
- **branding-specialist**: App branding and visual identity
- **content-strategy-agent**: Messaging frameworks and voice guidelines
- **guerilla-marketing-strategist**: Low-cost, unconventional growth tactics
- **marketing-expert**: App store optimization and user acquisition
- **mobile-app-marketing-expert**: Mobile marketing and growth strategies

## Creative (6 agents)

- **brand-designer**: Visual identity systems and brand assets
- **creative-project-brainstormer**: Feature ideation and creative riffing
- **design-qa-reviewer**: Design quality scoring and assessment
- **graphic-design-artist**: Logos, graphics, marketing visuals
- **senior-frontend-layout-expert**: Advanced CSS and layout algorithms
- **typography-specialist**: Font selection and text hierarchy

## Utility (3 agents)

- **agent-optimizer**: Agent config tuning and optimization
- **ai-prompt-optimizer**: Prompt engineering and LLM optimization
- **intent-translator**: Requirement clarification into actionable tickets

## Optional Community Agents

These agents are not part of this framework. The routing tables in `commands/assign-ticket.md`, `workflows/ticket-management.md`, and the workflow examples mention them as optional. Install them from the community collections listed in the README, then route to them only if their files exist in `.claude/agents/`.

| Agent | Fills this role | Fallback in this framework |
|-------|-----------------|----------------------------|
| context-manager | Context handoffs on large projects | session-orchestrator |
| code-reviewer | Code review | qa-engineer + security-architect, then gatekeeper |
| typescript-pro | Advanced TypeScript | react-vite-engineer |
| performance-engineer | Profiling and optimization | technical-architect + qa-engineer |
| backend-architect | API and service design | technical-architect |
| react-component-architect, nextjs-pro | React / Next.js components | react-vite-engineer |
| ui-designer, ux-designer | Interface and experience design | senior-frontend-layout-expert, design-qa-reviewer |
| product-manager | Product strategy | spec-decomposer, spec-writer |
| market-research-analyst | Market research | business-strategist, brand-research-analyst |
| content-marketer | Blog, social, and email content | content-strategy-agent |
| documentation-expert | Documentation strategy | technical-writer |
| ai-engineer, data-scientist | LLM apps, analytics, ML | technical-architect |
