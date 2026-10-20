---
description: Execute comprehensive business strategy analysis for venture opportunities
allowed-tools: Task(*), Read(*), Write(*), Bash(*)
---

You are executing the Venture Pack business strategy analysis workflow.

**User Request**: $ARGUMENTS

**Task**: Run the multi-agent business strategy pipeline through the agent-orchestrator, following `.claude/policies/orchestration.md` and `.claude/policies/business-strategy.md`.

**Instructions**:
1. Parse the business opportunity prompt and any constraints from the arguments.
2. This is a multi-step task (5+ agents, sequential dependencies). Route it to the `agent-orchestrator` agent with the context below.
3. Create the output folder `/deliverables/analysis/business/YYYY-MM-DD-<slug>/` before the first agent runs.

**Orchestration Context**:
```
**User Request**: $ARGUMENTS
**Output Folder**: /deliverables/analysis/business/YYYY-MM-DD-<slug>/

Execute this sequential pipeline. Each stage reads the previous stage's files.

1. 01_market_scan.md: market and competitor research.
   Agent: business-strategist (market research mode). If the community
   market-research-analyst agent is installed, use it for this stage instead.
2. 02_strategy_brief.md: business model and go-to-market. Agent: business-strategist
3. 03_business_requirements.md: functional and operational requirements.
   Agent: business-requirements-analyst
4. 04_pro_forma.md: unit economics, projections, scenarios. Agent: financial-analyst
5. 05_risk_and_compliance.md (optional): regulatory and legal risk.
   Agent: legal-reviewer
6. 06_vc_feedback.md: investor-style critique. Agent: vc-advisor
7. 00_executive_summary.md: synthesis of all stages. Agent: agent-orchestrator

Quality gates:
- Run the gatekeeper agent after stages 1, 4, and 7.
- Verify every file exists on disk (git status / test -f) before reporting completion.
- Cite sources for market figures.

Begin execution now.
```
