---
name: /design-loop
description: Produce a design with a chosen agent, auto-QA it, and iterate once if it fails QA.
args:
  - name: agent
    required: true
    enum: [brand-designer, graphic-design-artist, typography-specialist, senior-frontend-layout-expert]  # ui-designer / ux-designer are optional community agents; add them here if installed
  - name: brief
    required: true
  - name: brand
    required: false
  - name: platform
    required: false
steps:
  - id: produce
    agent: $agent
    prompt: |
      Create the requested deliverable. Summarize the acceptance criteria as bullets under "SPEC".
      Return: {artifact: <link or inline>, spec: <bullets>, brand: {{brand}}, origin_agent: {{$agent}}, context: {platform: {{platform}}}}
  - id: qa
    agent: design-qa-reviewer
    prompt: |
      Review this:
      {{steps.produce.output}}
      Return ONLY the JSON block defined in your Output schema, then a terse human summary.
  - id: maybe-revise
    when: "{{steps.qa.output.overall_score < 85}}"
    agent: $agent
    prompt: |
      Apply the following fix_plan and resubmit a revised artifact:
      {{steps.qa.output.fix_plan}}
      Return the *updated* {artifact, spec, brand, origin_agent, context}.
  - id: re-qa
    when: "{{steps.qa.output.overall_score < 85}}"
    agent: design-qa-reviewer
    prompt: |
      Re-review the updated submission. Same JSON-first output.
outputs:
  - name: final
    value: "{{ steps.re-qa.output || steps.qa.output }}"
