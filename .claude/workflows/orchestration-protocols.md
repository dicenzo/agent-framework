# Agent Orchestration Integration Protocols

## Overview
This document defines the integration protocols, decision matrices, and standardized procedures for coordinating between agent-orchestrator, workflow-orchestrator, session-orchestrator, and gatekeeper to eliminate role confusion and optimize multi-agent workflows.

## Orchestration Decision Matrix

### Request Complexity Assessment
| Complexity Level | Agent Count | Coordination Type | Primary Orchestrator | Delegation Pattern |
|-----------------|-------------|------------------|---------------------|-------------------|
| **Simple** | 2-3 agents | Sequential/basic parallel | agent-orchestrator | Direct coordination |
| **Moderate** | 4-6 agents | Complex sequencing | agent-orchestrator | → workflow-orchestrator → agent-orchestrator |
| **Complex** | 7–9 agents | Parallel coordination | agent-orchestrator | → workflow-orchestrator → session-orchestrator |
| **Enterprise** | 10+ agents | Multi-session parallel | agent-orchestrator | → workflow-orchestrator → session-orchestrator |

### Decision Criteria
**Route to workflow-orchestrator when:**
- Request spans 4+ distinct domains with complex interactions
- Complex dependency mapping required for optimization
- Resource optimization across multiple agents needed
- Strategic planning required before execution
- **Avoid for**: Familiar 4-agent patterns with linear dependencies

**Route to session-orchestrator when:**
- Parallel agent coordination required (7 or more agents)
- Multi-session state persistence needed
- Complex dependency management required
- Distributed agent synchronization needed
- Context size exceeds 10,000 tokens

**Fast-track direct coordination when:**
- Sequential workflow with 2-4 agents
- Clear execution path without complex dependencies
- Single domain or simple cross-domain coordination
- Familiar workflow patterns previously executed successfully
- Timeline pressure favors immediate execution

**Mandatory context checkpoint (session-orchestrator, or the optional community context-manager) when:**
- Projects exceeding 10k tokens
- Before major orchestrator handoffs
- At 25%, 50%, 75%, 100% completion milestones

## Standardized Handoff Context

### agent-orchestrator → workflow-orchestrator
```yaml
handoff_context:
  source_agent: "agent-orchestrator"
  target_agent: "workflow-orchestrator"
  request_type: "planning"
  original_request: "[complete user request]"
  complexity_indicators:
    - domain_count: 4
    - estimated_agents: 6
    - cross_domain_dependencies: true
    - resource_optimization_needed: true
  constraints:
    - timeline: "2 weeks"
    - quality_standards: "enterprise"
    - budget_considerations: "moderate"
  success_criteria:
    - "[specific measurable outcome 1]"
    - "[specific measurable outcome 2]"
  deliverable_manifest:  # NEW: Required for all handoffs
    expected_outputs:
      - path: "/absolute/path/to/deliverable1.md"
        type: "document"
        owner: "technical-writer"
      - path: "/absolute/path/to/deliverable2.yaml"
        type: "configuration"
        owner: "technical-architect"
  tool_availability:  # NEW: Pre-verified capabilities
    read: true
    write: true
    bash: true
    mcp_filesystem: false
  return_format: "structured_execution_plan"
```

### agent-orchestrator → session-orchestrator
```yaml
handoff_context:
  source_agent: "agent-orchestrator"
  target_agent: "session-orchestrator"
  request_type: "execution"
  execution_plan: "[structured plan from workflow-orchestrator or direct]"
  coordination_requirements:
    - parallel_streams: 3
    - session_persistence: true
    - state_management: "complex"
  agent_assignments:
    - stream_a: ["technical-architect", "integration-engineer"]
    - stream_b: ["react-vite-engineer", "senior-frontend-layout-expert"]
  deliverable_tracking:  # NEW: Required deliverable tracking
    stream_a_outputs:
      - "/path/to/backend/api.yaml"
      - "/path/to/database/schema.sql"
    stream_b_outputs:
      - "/path/to/frontend/components.tsx"
      - "/path/to/design/mockups.md"
    verification_checkpoints:
      - after_each_agent: true
      - consolidation_required: true
  success_criteria: "[execution completion criteria]"
  return_format: "coordination_progress_with_verification"
```

### workflow-orchestrator → agent-orchestrator
```yaml
execution_plan:
  complexity_assessment: "[Simple|Moderate|Complex|Enterprise]"
  recommended_coordination: "[Direct|Delegated_to_session_orchestrator]"
  resource_requirements:
    - total_agents: 6
    - specializations: ["backend", "frontend", "qa", "integration"]
    - estimated_duration: "10 days"
  workflow_architecture:
    - phase: "Phase_1_Foundation"
      agents: ["technical-architect"]
      dependencies: []
      outputs: ["api_specification", "database_schema"]
    - phase: "Phase_2_Parallel_Development"
      agents: ["integration-engineer", "react-vite-engineer"]
      dependencies: ["Phase_1_Foundation"]
      coordination_type: "parallel"
  quality_gates:
    - checkpoint: "Foundation_Complete"
      validation_criteria: ["API spec reviewed", "Schema validated"]
      gatekeeper_trigger: true
  implementation_guidance:
    - coordination_type: "Delegated_to_session_orchestrator"
    - critical_handoffs: ["API specification delivery", "Integration testing"]
```

## Integration Flow Patterns

### Pattern 1: Simple Direct Coordination
```
User Request → agent-orchestrator 
    ↓
agent-orchestrator coordinates 2-3 agents directly
    ↓
gatekeeper validates final output
    ↓
Integrated deliverable to user
```

### Pattern 2: Complex Planning + Direct Execution
```
User Request → agent-orchestrator
    ↓
agent-orchestrator → workflow-orchestrator (planning)
    ↓
workflow-orchestrator → agent-orchestrator (execution plan)
    ↓
agent-orchestrator coordinates agents per plan
    ↓
gatekeeper validates at checkpoints + final output
    ↓
Integrated deliverable to user
```

### Pattern 3: Complex Planning + Delegated Execution
```
User Request → agent-orchestrator
    ↓
agent-orchestrator → workflow-orchestrator (planning)
    ↓
workflow-orchestrator → agent-orchestrator (execution plan)
    ↓
agent-orchestrator → session-orchestrator (execution)
    ↓
session-orchestrator coordinates parallel agents
    ↓
session-orchestrator → agent-orchestrator (progress updates)
    ↓
gatekeeper validates at checkpoints + final output
    ↓
agent-orchestrator integrates → user
```

## Quality Gate Integration Points

### Automatic Triggers
- **Pre-delivery**: All orchestrators must invoke gatekeeper before final user delivery
- **Major milestones**: At 25%, 50%, 75%, 100% completion of planned phases
- **Cross-orchestrator handoffs**: When returning from workflow-orchestrator or session-orchestrator
- **Context checkpoints**: Save session state via session-orchestrator at the same milestones for projects >10k tokens

### Manual Triggers
- **Explicit user requests**: "Please validate this before proceeding"
- **Agent uncertainty**: When output quality is uncertain
- **Risk mitigation**: For high-stakes deliverables

### Integration Protocol
```yaml
gatekeeper_request:
  source_orchestrator: "[agent-orchestrator|workflow-orchestrator|session-orchestrator]"
  validation_type: "[checkpoint|final_delivery|manual_request]"
  content_to_validate: "[document/deliverable]"
  quality_standards: "[basic|professional|enterprise]"
  context:
    - previous_validations: "[any prior gatekeeper results]"
    - workflow_stage: "[current phase in overall plan]"
    - success_criteria: "[specific validation requirements]"
```

## Error Handling and Recovery

### Context Loss Prevention
- All handoffs include complete context preservation
- State files maintain full workflow history
- Recovery protocols restore from last stable checkpoint

### Coordination Failures
```yaml
failure_scenarios:
  planning_failure:
    trigger: "workflow-orchestrator returns incomplete plan"
    action: "agent-orchestrator requests plan revision with specific gaps identified"
  
  execution_failure:
    trigger: "session-orchestrator reports coordination breakdown"  
    action: "Rollback to last checkpoint, revise approach, resume with adjusted plan"
    
  validation_failure:
    trigger: "gatekeeper returns FAIL status"
    action: "Return to responsible agent for revision, do not proceed to next stage"
    
  delegation_confusion:
    trigger: "unclear which orchestrator should handle request"
    action: "Default to agent-orchestrator for complexity analysis and delegation decision"
```

## Troubleshooting Guide

### Common Issues

**Issue**: "Should I use workflow-orchestrator or session-orchestrator?"
- **Solution**: Always start with agent-orchestrator complexity analysis
- **Decision Path**: agent-orchestrator determines delegation based on planning vs execution needs

**Issue**: "Multiple orchestrators seem to overlap in functionality"
- **Solution**: Refer to Role Boundaries in each agent definition
- **Rule**: workflow-orchestrator plans only, session-orchestrator executes only, agent-orchestrator delegates and integrates

**Issue**: "When should gatekeeper be invoked?"
- **Solution**: Automatic triggers at delivery + manual triggers when needed
- **Rule**: Every final deliverable must pass gatekeeper validation

**Issue**: "Context being lost in handoffs"
- **Solution**: Use standardized handoff context format
- **Rule**: Complete context preservation is mandatory for all orchestrator handoffs

## Success Validation Checklist

✅ **Pre-Flight Verification** (NEW)
- Tool availability checked before orchestration starts
- Deliverable manifest created before delegation
- Agents warned if required tools unavailable

✅ **Clear Role Boundaries**
- Each orchestrator has distinct non-overlapping responsibilities
- Delegation rules are deterministic and unambiguous

✅ **Efficient Workflows**
- No unnecessary handoffs or coordination overhead
- Parallel opportunities identified and utilized

✅ **Quality Assurance**
- gatekeeper validation integrated at appropriate checkpoints
- Quality gates don't interrupt workflow efficiency

✅ **Deliverable Verification** (ENHANCED)
- All agents verify file writes before reporting completion
- No "false completions" without actual file modifications
- Completion reports include absolute file paths and git verification
- Orchestrators verify EACH agent's outputs independently
- Final manifest validation confirms ALL expected deliverables present
- Missing deliverables explicitly documented in completion reports

✅ **Context Preservation**
- Information integrity maintained across all handoffs
- State management enables full workflow resumability
- Deliverable manifests included in all handoff contexts

✅ **Recovery Mechanisms**
- Clear fallback procedures for common failure scenarios
- Error handling doesn't cascade or compound issues
- Tool unavailability detected early with user notification