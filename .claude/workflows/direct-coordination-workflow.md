# Direct Coordination Workflow

## Overview
Simple sequential workflow for projects requiring 2-3 specialized agents with straightforward coordination needs.

## Applicability Criteria
- **Agent Count**: 2-3 agents
- **Coordination Type**: Sequential or basic parallel
- **Complexity Level**: Simple
- **Dependencies**: Clear execution path without complex dependencies
- **Domain Scope**: Single domain or simple cross-domain coordination

## Workflow Steps

### 1. Initial Assessment
- Verify project requires exactly 2-3 agents
- Confirm sequential or basic parallel execution pattern
- Validate no complex dependency mapping needed

### 2. Agent Assignment
- Identify specific agent roles and deliverables
- Define clear handoff points between agents
- Establish success criteria for each agent

### 3. Direct Coordination
- Execute agents in planned sequence
- Monitor progress and handle simple conflicts
- Maintain context across agent handoffs

### 4. Quality Gate
- Trigger gatekeeper validation before final delivery
- Address any quality issues identified
- Integrate final outputs

### 5. Delivery Integration
- Synthesize all agent outputs into cohesive deliverable
- Ensure completeness against original request
- Deliver final integrated result to user

## Example Use Cases
- **Marketing Campaign**: content-strategy-agent → graphic-design-artist → brand-research-analyst
- **Simple Feature Development**: technical-architect → react-vite-engineer → qa-engineer
- **Content Creation**: technical-writer → content-strategy-agent → design-qa-reviewer

## Handoff Context Format
```yaml
direct_coordination_context:
  workflow_type: "direct_coordination"
  source_agent: "agent-orchestrator"
  coordination_mode: "sequential|basic_parallel"
  agent_sequence:
    - agent: "[agent_name]"
      role: "[specific_role]"
      deliverables: ["[deliverable_1]", "[deliverable_2]"]
      dependencies: ["[prerequisite_outputs]"]
  success_criteria:
    - "[measurable_outcome_1]"
    - "[measurable_outcome_2]"
  quality_gates:
    - checkpoint: "pre_delivery"
      validation_required: true
```

## Decision Points
**Use this workflow when:**
- Project clearly requires 2-3 agents maximum
- Execution path is straightforward and sequential
- No complex resource optimization needed
- Single domain focus or simple cross-domain work
- Direct coordination overhead is manageable

**Escalate to complex workflows when:**
- Agent count exceeds 3
- Complex dependency mapping required
- Parallel coordination becomes complex
- Cross-domain complexity increases significantly

## Success Metrics
- All agents complete deliverables within scope
- No coordination conflicts or blockers
- Quality gate validation passes
- Final integration meets original request criteria
- Delivery completed without escalation needs

## Risk Mitigation
- **Scope Creep**: Monitor for increasing complexity requiring workflow change
- **Agent Conflicts**: Maintain clear role boundaries and handoff protocols
- **Quality Issues**: Ensure gatekeeper validation before delivery
- **Context Loss**: Document all handoffs and maintain complete context