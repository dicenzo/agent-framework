---
description: Transform my request into a structured brief, then execute it.
allowed-tools: Task(*), Read(*), Write(*), Bash(*), MCP(*)
---

**Request**: $ARGUMENTS

**Task**: Execute the complete multi-agent workflow following the Agent Dispatch Protocol.

**Instructions**:
1. Parse the request prompt and any constraints from the user request/arguments
- What type of output would actually help me? (analysis, plan, draft, solution, etc.)
- What expertise would be most relevant?
- What additional constraints are needed?
- What format would be most useful?
- What level of detail makes sense?
2. Then ask the intent-translator agent to restructure the request as:
ROLE: [Infer appropriate expertise needed]
OBJECTIVE: [Make my vague request specific]
APPROACH: [Choose methodology that fits]
OUTPUT: [Deliver in most useful format]
3. This is a complex, multi-step task requiring delegation per the Agent Dispatch Protocol
4. Pass the complete updated request context to the agent-orchestrator agent with the orchestration context below.


**Orchestration Context**:
```
**Restructured Request**: $ARGUMENTS
**Working Directory**: .
**MCP Servers**: See `.claude/mcp_servers.md` if configured

Execute the complete multi-agent workflow:

1. Initialize project structure in /deliverables/ (choose the subfolder per `.claude/policies/file-organization.md`)
2. Execute sequential agent pipeline with quality gates:
 - Break down the request into steps, if necessary
 - Determine if there are dependencies in each step
 - Determine which agent is most appropriate to execute each step
 - Execute the request or the steps sequentially minding dependencies (use the workflow-orchestrator agent here if necessary)
 - Generate the output
3. Use agents from `.claude/agents/` as necessary (see `.claude/agents.md`)
4. Generate professional deliverable package

Begin execution now.
```