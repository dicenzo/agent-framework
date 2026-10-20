#!/bin/bash

# Lint Validation Script
# Ensures zero lint errors and warnings before task completion
# Usage: ./.claude/scripts/validate-lint.sh

set -e  # Exit on first error

echo "🔍 Starting Lint Validation..."
echo "=============================="

# Check if we're in a project with package.json
if [ ! -f "package.json" ]; then
  echo "❌ Error: No package.json found in current directory"
  echo "   Run this script from the project root"
  exit 1
fi

# Check if yarn lint command exists
if ! grep -q '"lint"' package.json; then
  echo "⚠️  Warning: No 'lint' script found in package.json"
  echo "   Skipping lint validation"
  exit 0
fi

echo ""
echo "📋 Step 1: Auto-fixing issues..."
echo "--------------------------------"
if yarn lint --fix; then
  echo "✅ Auto-fix completed"
else
  echo "⚠️  Auto-fix had issues (may be expected)"
fi

echo ""
echo "📋 Step 2: Running lint with zero tolerance..."
echo "------------------------------------------------"
LINT_EXIT_CODE=0
LINT_OUTPUT=$(yarn lint --max-warnings 0 2>&1) || LINT_EXIT_CODE=$?

if [ $LINT_EXIT_CODE -eq 0 ]; then
  echo "✅ PASS: Zero lint errors and warnings"
else
  echo "❌ FAIL: Lint errors/warnings found"
  echo ""
  echo "Lint output:"
  echo "$LINT_OUTPUT"
  echo ""
  echo "🔧 Common fixes:"
  echo "  - Import order: yarn lint --fix (auto-fixable)"
  echo "  - Unused vars: Remove or prefix with '_'"
  echo "  - React Hooks: Move hooks to top level"
  echo "  - Async handlers: Wrap with () => { void asyncFn(); }"
  echo "  - Console logs: Replace with logger"
  echo ""
  echo "📖 See .claude/policies/engineering.md"
  echo "   Section: 🧹 LINT COMPLIANCE PROTOCOL"
  exit 1
fi

echo ""
echo "📋 Step 3: Running TypeScript check..."
echo "---------------------------------------"
if yarn tsc --noEmit; then
  echo "✅ PASS: No TypeScript errors"
else
  echo "❌ FAIL: TypeScript errors found"
  echo ""
  echo "🔧 Common fixes:"
  echo "  - Replace 'any' with 'unknown' + type guards"
  echo "  - Add proper type annotations"
  echo "  - Fix unsafe type operations"
  exit 1
fi

echo ""
echo "📋 Step 4: Checking for forbidden patterns..."
echo "----------------------------------------------"

FORBIDDEN_FOUND=0

# Check for 'any' types (excluding comments and test files)
if grep -r ": any" src/ --include="*.ts" --include="*.tsx" --exclude-dir=node_modules 2>/dev/null | grep -v "//.*: any" | grep -v "__tests__" >/dev/null; then
  echo "⚠️  WARNING: Found ': any' types in code"
  echo "   Replace with 'unknown' + type guards"
  FORBIDDEN_FOUND=1
fi

# Check for @ts-ignore
if grep -r "@ts-ignore" src/ --include="*.ts" --include="*.tsx" --exclude-dir=node_modules 2>/dev/null; then
  echo "⚠️  WARNING: Found '@ts-ignore' comments"
  echo "   Fix underlying type issues instead"
  FORBIDDEN_FOUND=1
fi

# Check for improperly typed catch blocks
if grep -r "catch.*:" src/ --include="*.ts" --include="*.tsx" --exclude-dir=node_modules 2>/dev/null | grep -v "unknown" | grep -v "//" >/dev/null; then
  echo "⚠️  WARNING: Found catch blocks without 'unknown' type"
  echo "   Use: catch (error: unknown)"
  FORBIDDEN_FOUND=1
fi

if [ $FORBIDDEN_FOUND -eq 0 ]; then
  echo "✅ PASS: No forbidden patterns found"
else
  echo ""
  echo "⚠️  Forbidden patterns detected (warnings only)"
fi

echo ""
echo "=============================="
echo "✅ VALIDATION COMPLETE"
echo "=============================="
echo ""
echo "Summary:"
echo "  ✅ Lint: Zero errors and warnings"
echo "  ✅ TypeScript: No type errors"
if [ $FORBIDDEN_FOUND -eq 1 ]; then
  echo "  ⚠️  Code quality: Warnings found (review above)"
else
  echo "  ✅ Code quality: No issues"
fi
echo ""
echo "Task is ready for completion."

exit 0
