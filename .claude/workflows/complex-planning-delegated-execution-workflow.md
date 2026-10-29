# Complex Planning + Delegated Execution Workflow

## Overview
Enterprise-grade workflow for projects requiring sophisticated planning and parallel coordination of 7 or more agents with complex dependencies and multi-session state management.

## Applicability Criteria
- **Agent Count**: 7 or more agents
- **Coordination Type**: Parallel coordination with complex dependencies
- **Complexity Level**: Complex to Enterprise
- **Planning Needs**: Strategic planning with resource optimization
- **Execution Needs**: Multi-session parallel coordination required

## Workflow Steps

### 1. Enterprise Complexity Assessment
- Identify need for both strategic planning and parallel execution
- Confirm the work needs 7 or more agents with complex dependencies
- Validate need for multi-session state persistence

### 2. Strategic Planning Delegation
- **Handoff to workflow-orchestrator** for comprehensive planning
- Provide enterprise-level context and constraints
- Receive detailed execution plan optimized for parallel coordination

### 3. Execution Delegation
- **Handoff to session-orchestrator** for parallel execution management
- Provide structured execution plan and coordination requirements
- Maintain oversight while delegating operational coordination

### 4. Progress Integration
- Receive regular progress updates from session-orchestrator
- Monitor overall project health and milestone achievement
- Coordinate with workflow-orchestrator for plan adjustments if needed

### 5. Quality Orchestration
- Ensure gatekeeper validation at all major checkpoints
- Coordinate quality gates across multiple parallel streams
- Manage escalations and conflict resolution

### 6. Executive Integration
- Synthesize outputs from all coordinated agent streams
- Execute final enterprise-level quality validation
- Deliver comprehensive integrated solution to user

## Planning Phase Handoff

### To workflow-orchestrator
```yaml
enterprise_planning_context:
  source_agent: "agent-orchestrator"
  target_agent: "workflow-orchestrator"
  request_type: "enterprise_planning"
  original_request: "[complete user request]"
  complexity_indicators:
    - domain_count: "[5-8+]"
    - estimated_agents: "[6-15+]"
    - cross_domain_dependencies: true
    - parallel_coordination_required: true
    - resource_optimization_critical: true
    - multi_session_persistence: true
  constraints:
    - timeline: "[project timeline]"
    - quality_standards: "enterprise"
    - resource_limitations: "[comprehensive constraints]"
    - compliance_requirements: "[regulatory/security needs]"
  success_criteria:
    - "[enterprise_outcome_1]"
    - "[enterprise_outcome_2]"
    - "[enterprise_outcome_3]"
  return_format: "enterprise_execution_plan"
```

## Execution Phase Handoff

### To session-orchestrator
```yaml
execution_delegation_context:
  source_agent: "agent-orchestrator"
  target_agent: "session-orchestrator"
  request_type: "enterprise_execution"
  execution_plan: "[complete_plan_from_workflow_orchestrator]"
  coordination_requirements:
    - parallel_streams: "[3-5+]"
    - session_persistence: true
    - state_management: "complex"
    - dependency_complexity: "high"
  agent_assignments:
    - stream_foundation: ["[technical_agents]"]
    - stream_development: ["[implementation_agents]"]
    - stream_quality: ["[validation_agents]"]
    - stream_integration: ["[coordination_agents]"]
  success_criteria: "[execution_completion_criteria]"
  return_format: "coordination_progress_with_state"
```

### Progress Returns from session-orchestrator
```yaml
coordination_progress:
  workflow_stage: "[current_phase]"
  stream_status:
    - stream_name: "[stream_identifier]"
      agents_active: ["[agent_list]"]
      completion_percentage: "[0-100]"
      blockers: ["[current_blockers]"]
      next_milestones: ["[upcoming_deliverables]"]
  cross_stream_dependencies:
    - dependency: "[dependency_description]"
      status: "[pending|in_progress|completed|blocked]"
      impact_assessment: "[low|medium|high|critical]"
  quality_gate_status:
    - checkpoint: "[milestone_name]"
      validation_status: "[pending|passed|failed]"
      required_actions: ["[action_items]"]
  state_preservation:
    - session_continuity: "[maintained|at_risk|compromised]"
    - context_integrity: "[complete|partial|degraded]"
  escalation_needs: ["[issues_requiring_orchestrator_intervention]"]
```

## Example Use Cases
- **Complete Enterprise Platform**: 10+ agents across architecture, development, QA, security, DevOps, documentation
- **Market Entry Strategy**: Business analysis, financial modeling, technical architecture, marketing, legal, operations
- **Digital Transformation**: Legacy analysis, architecture design, development, migration, training, change management

## Decision Points
**Use this workflow when:**
- Project requires 7 or more specialized agents
- Parallel coordination is essential for timeline
- Complex dependency management required
- Multi-session state persistence needed
- Enterprise-level quality and compliance standards
- Resource optimization is critical for success

**Consider workflow optimization when:**
- Agent count exceeds 15 (may need workflow decomposition)
- Cross-dependencies create bottlenecks (revisit planning)
- Coordination overhead impacts efficiency (review delegation)

## Success Metrics
- Strategic planning produces optimized parallel execution plan
- Session coordination maintains state across complex workflows
- All parallel streams execute without critical blockers
- Dependencies managed proactively with minimal conflicts
- Quality gates validate progress across all streams
- Final integration meets enterprise success criteria
- Project completed within resource and timeline constraints

## Risk Mitigation
- **Planning Quality**: Ensure workflow-orchestrator optimizes for parallel execution
- **Coordination Complexity**: Monitor session-orchestrator capacity and performance
- **State Management**: Validate session persistence and context integrity
- **Dependency Conflicts**: Maintain proactive dependency tracking and resolution
- **Quality Assurance**: Implement distributed quality gates across parallel streams
- **Resource Optimization**: Track resource utilization and adjust allocation as needed
- **Escalation Management**: Maintain clear escalation paths for complex conflicts