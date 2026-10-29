# Ticket System Policy

## Purpose
Provide lightweight, AI-friendly issue tracking across all active projects.

## Core Principles
- **Simple Structure**: YAML format for easy AI parsing
- **Cross-Project**: Single system for all project tracking
- **Timestamp-Based IDs**: No complex ID generation
- **Minimal Overhead**: Essential fields only
- **Document Resolutions**: For future reference

## Required Fields
- **Title**: Clear, actionable description
- **Type**: Task, Story or Bug
- **Severity**: Risk/impact assessment (Blocker/Major/Minor)
- **Effort**: T-shirt size estimate (XS/S/M/L/XL)
- **Project**: Which codebase this affects
- **Working Directory**: Where the codebase is (absolute path to project root)
- **Created By**: Agent or user attribution

## Optional Fields
- **Acceptance Criteria**: Clear completion definition
- **Dependencies**: Linked ticket relationships
- **Related Files**: Relevant code locations
- **Assigned To**: Ownership tracking

## Debugging Fields (Mandatory for Bug Tickets)
- **Steps to Reproduce**: Numbered list of reproduction steps
- **Expected Behavior**: What should happen normally
- **Actual Behavior**: What actually occurs (the bug)
- **Error Messages**: Specific error output, stack traces, logs
- **Attempted Solutions**: Solutions tried and their outcomes

## Naming Convention
- Format: `YYYY-MM-DD-HHMMSS-<slug>.yaml`
- Slug: 2-3 words, kebab-case
- Example: `2024-09-25-143000-fix-login-bug.yaml`

## Status Lifecycle
1. **Open**: New, unassigned ticket
2. **In Progress**: Actively being worked
3. **Blocked**: Waiting on external dependency
4. **Resolved**: Work complete, awaiting verification (archived to `.claude/issues/resolved/YYYY-MM/`)
5. **Closed**: Verified complete and deployed

## Agent Responsibilities
- **Create**: Use natural language parsing to extract ticket details
- **Update**: Modify status and timestamps when changing tickets
- **Archive**: Move resolved tickets to `/.claude/issues/resolved/YYYY-MM/` directory
- **Link**: Reference ticket IDs in commit messages and PR descriptions
- **Close**: Add resolution summary when completing work

## When to Include Debugging Fields
- **Steps to Reproduce**: For any bug that can be replicated
- **Expected/Actual Behavior**: For functional bugs or unexpected outcomes
- **Error Messages**: When specific errors, exceptions, or logs are available
- **Attempted Solutions**: During development workflows after trying multiple approaches

## Quality Gates
- All tickets must have title, severity, effort, and project
- Acceptance criteria required for effort >= M
- Resolution description required when closing
- File references should use absolute paths when possible