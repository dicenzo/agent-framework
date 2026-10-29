---
description: Produce a design with a chosen agent, auto-QA it, and iterate once if it fails QA.
argument-hint: <agent> <brief> [brand=<name>] [platform=<platform>]
allowed-tools: Task(*), Read(*), Write(*)
---

**Request**: $ARGUMENTS

**Task**: Produce one design, have `design-qa-reviewer` score it, and revise once if the score is below 85.

**Production agents**: `brand-designer`, `graphic-design-artist`, `typography-specialist`, `senior-frontend-layout-expert`. If the named agent is not in this list, stop and ask for one of these.

**Instructions**:

1. Parse `$ARGUMENTS` into the agent, the brief, and optional `brand=<name>` and `platform=<platform>`.
2. Ask that agent to create the deliverable. The reply includes a SPEC as bullets, plus the artifact, brand, and origin agent. Save the artifact under `deliverables/designs/ui-ux/` (layout systems go under `deliverables/designs/architecture/`) per `.claude/policies/file-organization.md`.
3. Ask `design-qa-reviewer` to review the deliverable against the SPEC. It returns a markdown scorecard and a JSON object with `overall_score` (0-100), `pass` (true only when the score is 85 or higher), and `fix_plan` (a list of changes).
4. When `pass` is true, deliver the artifact path and the scorecard.
5. When `pass` is false, send `fix_plan` back to the same production agent for one revision. Ask `design-qa-reviewer` to review that revision once. Deliver the revised artifact and the second scorecard even if the second score is still below 85.
6. Do not run a third production pass.

**Output**: artifact path, final `overall_score`, and whether `pass` is true.
