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
  echo "   Section: Lint Compliance — Zero Tolerance"
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
SCAN_SKIPPED=0
SOURCE_DIRS=()
for dir in src app apps packages; do
  if [ -d "$dir" ]; then
    SOURCE_DIRS+=("$dir")
  fi
done

if [ ${#SOURCE_DIRS[@]} -eq 0 ]; then
  echo "⚠️  No src, app, apps, or packages directory found"
  echo "   Skipped forbidden-pattern scan"
  SCAN_SKIPPED=1
else
  # Explicit `any` (comment lines that mention the pattern are ignored)
  ANY_MATCHES=$(grep -R -n -E ': any([^[:alnum:]_]|$)' "${SOURCE_DIRS[@]}" \
    --include="*.ts" --include="*.tsx" --exclude-dir=node_modules 2>/dev/null \
    | grep -v -E "//.*: any" | grep -v "__tests__" || true)
  if [ -n "$ANY_MATCHES" ]; then
    echo "❌ FAIL: Found ': any' types"
    echo "   Replace with 'unknown' and type guards"
    echo "$ANY_MATCHES"
    FORBIDDEN_FOUND=1
  fi

  TS_IGNORE=$(grep -R -n "@ts-ignore" "${SOURCE_DIRS[@]}" \
    --include="*.ts" --include="*.tsx" --exclude-dir=node_modules 2>/dev/null || true)
  if [ -n "$TS_IGNORE" ]; then
    echo "❌ FAIL: Found '@ts-ignore' comments"
    echo "   Fix the underlying type error"
    echo "$TS_IGNORE"
    FORBIDDEN_FOUND=1
  fi

  # Type annotation inside the catch parentheses. `unknown` is the required type.
  # The match stops at the closing parenthesis, so a colon in the catch body is ignored.
  CATCH_MATCHES=$(grep -R -n -E "catch[[:space:]]*\([^)]*:[^)]*\)" "${SOURCE_DIRS[@]}" \
    --include="*.ts" --include="*.tsx" --exclude-dir=node_modules 2>/dev/null \
    | grep -v -E "catch[[:space:]]*\([^)]*:[[:space:]]*unknown[[:space:]]*\)" || true)
  if [ -n "$CATCH_MATCHES" ]; then
    echo "❌ FAIL: Found catch parameters typed as something other than 'unknown'"
    echo "   Use: catch (error: unknown)"
    echo "$CATCH_MATCHES"
    FORBIDDEN_FOUND=1
  fi
fi

if [ "$FORBIDDEN_FOUND" -ne 0 ]; then
  echo ""
  echo "❌ FAIL: Forbidden patterns detected"
  echo "📖 See .claude/policies/engineering.md"
  echo "   Section: Lint Compliance — Zero Tolerance"
  exit 1
fi

echo "✅ PASS: No forbidden patterns found"
echo ""
echo "=============================="
echo "✅ VALIDATION COMPLETE"
echo "=============================="
echo ""
echo "Summary:"
echo "  ✅ Lint: Zero errors and warnings"
echo "  ✅ TypeScript: No type errors"
if [ "$SCAN_SKIPPED" -eq 1 ]; then
  echo "  ⚠️  Code quality: Forbidden-pattern scan skipped (no source directory)"
else
  echo "  ✅ Code quality: No forbidden patterns"
fi
echo ""
echo "Task is ready for completion."

exit 0
