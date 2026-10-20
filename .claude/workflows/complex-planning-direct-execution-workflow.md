# Complex Planning + Direct Execution Workflow

## Overview
Workflow for projects requiring sophisticated planning phase followed by direct coordination of 4-6 agents with moderate complexity.

## Applicability Criteria
- **Agent Count**: 4-6 agents
- **Coordination Type**: Complex sequencing with direct oversight
- **Complexity Level**: Moderate
- **Planning Needs**: Strategic planning required before execution
- **Domain Scope**: Multiple domains with some interdependencies

## Workflow Steps

### 1. Complexity Assessment
- Identify need for strategic planning phase
- Confirm 4-6 agent requirement
- Validate direct execution capability post-planning

### 2. Planning Delegation
- **Handoff to workflow-orchestrator**
- Provide comprehensive planning context
- Receive detailed execution plan with dependencies

### 3. Plan Integration
- Review and validate execution plan
- Confirm resource availability and feasibility
- Adjust timeline and success criteria as needed

### 4. Direct Execution Coordination
- Coordinate agents according to planned sequence
- Monitor complex dependencies between agents
- Handle conflicts and blockers as they arise

### 5. Progress Management
- Track execution against planned milestones
- Trigger quality gates at major checkpoints
- Maintain visibility across all agent streams

### 6. Final Integration
- Synthesize all agent outputs per plan
- Execute final gatekeeper validation
- Deliver integrated solution to user

## Planning Phase Handoff

### To workflow-orchestrator
```yaml
planning_handoff_context:
  source_agent: "agent-orchestrator"
  target_agent: "workflow-orchestrator"
  request_type: "planning"
  original_request: "[complete user request]"
  complexity_indicators:
    - domain_count: "[3-5]"
    - estimated_agents: "[4-6]"
    - cross_domain_dependencies: true
    - resource_optimization_needed: true
  constraints:
    - timeline: "[project timeline]"
    - quality_standards: "[basic|professional|enterprise]"
    - resource_limitations: "[budget/personnel constraints]"
  success_criteria:
    - "[specific measurable outcome 1]"
    - "[specific measurable outcome 2]"
  return_format: "structured_execution_plan"
```

### From workflow-orchestrator
```yaml
execution_plan_return:
  complexity_assessment: "Moderate"
  recommended_coordination: "Direct"
  resource_requirements:
    - total_agents: "[4-6]"
    - specializations: ["[domain_1]", "[domain_2]", "[domain_3]"]
    - estimated_duration: "[duration]"
  workflow_architecture:
    - phase: "[Phase_Name]"
      agents: ["[agent_list]"]
      dependencies: ["[prerequisite_phases]"]
      outputs: ["[expected_deliverables]"]
  quality_gates:
    - checkpoint: "[milestone_name]"
      validation_criteria: ["[criteria_list]"]
      gatekeeper_trigger: true
  implementation_guidance:
    - coordination_type: "Direct"
    - critical_handoffs: ["[key_integration_points]"]
```

## Example Use Cases
- **Complete Business Strategy**: business-strategist → business-requirements-analyst → financial-analyst → vc-advisor
- **Product Launch**: spec-decomposer → spec-writer → technical-architect → react-vite-engineer → marketing-expert
- **System Integration**: technical-architect → integration-engineer → security-architect → qa-engineer

Optional community agents (for example `market-research-analyst`, `product-manager`, `backend-architect`) can replace or extend steps above when installed.

## Decision Points
**Use this workflow when:**
- Project requires strategic planning before execution
- 4-6 agents needed with complex sequencing
- Direct coordination is manageable post-planning
- Resource optimization important but not critical
- Multiple domains with moderate interdependencies

**Escalate to delegated execution when:**
- Agent count approaches 6+
- Parallel coordination becomes unmanageable
- Multi-session state persistence required
- Execution complexity exceeds direct coordination capacity

## Success Metrics
- Planning phase produces actionable execution plan
- All agents execute according to plan timeline
- Dependencies managed without coordination breakdown
- Quality gates validate progress at checkpoints
- Final integration meets original success criteria

## Risk Mitigation
- **Planning Quality**: Ensure workflow-orchestrator delivers complete plan
- **Execution Complexity**: Monitor for signs requiring session-orchestrator delegation
- **Resource Conflicts**: Track agent availability and workload distribution
- **Context Preservation**: Maintain complete context across planning-execution handoff
- **Quality Assurance**: Implement checkpoints per planned quality gates