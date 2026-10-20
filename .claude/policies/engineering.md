# Engineering Standards for AI Agents

## BEFORE ANY CODE CHANGES

1. **READ** existing patterns in the codebase first
2. **VERIFY** TypeScript compilation: `yarn tsc --noEmit`
3. **CHECK** linting status: `yarn lint --max-warnings 0`
4. **CONFIRM** all tests pass before starting

## Architecture Directives

**ALWAYS APPLY:**
- Use composition over inheritance
- Define explicit type contracts for all interfaces
- Never use `any` types — use `unknown` with type guards
- Optimize code for testability and future readability
- Reference `expo-react-native.md` when working with React Native

**Decision Tree:**
```
New Feature → Plan in stages → Define tests → Implement minimal → Refactor → Validate
Bug Fix     → Understand existing → Write failing test → Fix minimal → Validate fix
Type Error  → Never use `any` → Use `unknown` + type guards → Verify compilation
```

## Development Workflow

### Stage 1 — Planning
Break work into cross-stack stages with measurable completion criteria.

### Stage 2 — Test Definition
Define tests BEFORE implementation. Tests must be deterministic, fast, and properly mocked.
- UI: test visible changes and user interactions
- APIs: test responses, status codes, and side effects
- Services: test business logic and error scenarios

### Stage 3 — Minimal Implementation
Write only enough code to pass defined tests. No "nice-to-haves."

### Stage 4 — Safe Refactoring
Requires ≥80% test coverage. All tests must still pass after changes.

### Stage 5 — Quality Gates
```bash
yarn lint --fix                  # Auto-fix safe issues first
yarn lint --max-warnings 0       # MUST return 0 errors and 0 warnings
yarn tsc --noEmit                # MUST return 0 type errors
yarn build                       # MUST succeed for affected packages
./.claude/scripts/validate-lint.sh  # If available
```

## Lint Compliance — Zero Tolerance

**ALL engineering agents must achieve zero lint errors and warnings before task completion.**

### Critical Lint Categories

**🔴 BLOCKERS** — fix immediately:
- `@typescript-eslint/no-misused-promises` — async handler violations
- `react-hooks/rules-of-hooks` — conditional hook usage
- `@typescript-eslint/no-floating-promises` — unhandled promises
- `@typescript-eslint/no-explicit-any` — explicit `any` usage
- `@typescript-eslint/no-unused-vars` — unused variables/imports

**🟡 HIGH PRIORITY** — fix during implementation:
- `import/order` — import organization (auto-fixable)
- `@typescript-eslint/prefer-nullish-coalescing` — use `??` over `||`
- `@typescript-eslint/no-unsafe-*` — unsafe type operations
- `react-hooks/exhaustive-deps` — missing dependencies
- `no-console` — use logger instead

**🟢 QUALITY** — fix before completion:
- `prefer-template` — string concatenation
- `react/no-unescaped-entities` — unescaped HTML entities
- `@typescript-eslint/require-await` — unnecessary async

### Mandatory Lint Workflow

```bash
# Pre-implementation: capture baseline
yarn lint --format json > .lint-baseline-$(date +%s).json

# During implementation: run frequently
yarn lint --fix
yarn lint

# Pre-completion: zero-tolerance check (MANDATORY — ALL must return exit 0)
yarn lint --fix
yarn lint --max-warnings 0
yarn tsc --noEmit
yarn build
```

### Common Violation Fixes

**Import Order** (`import/order`) — AUTO-FIXABLE: always run `yarn lint --fix` first.

**React Hooks** (`react-hooks/rules-of-hooks`):
```typescript
// ❌ Conditional hook
if (condition) { const value = useMemo(() => compute(), []); }

// ✅ Hook at top level, conditional logic inside
const value = useMemo(() => {
  if (!condition) return null;
  return compute();
}, [condition]);
```

**Promise Handling** (`@typescript-eslint/no-misused-promises`):
```typescript
// ❌ Async in handler
<Button onPress={async () => await save()} />

// ✅ Wrap async
const handlePress = useCallback(async () => { await save(); }, [save]);
<Button onPress={() => { void handlePress(); }} />
```

**Unsafe Type Operations** (`@typescript-eslint/no-unsafe-*`):
```typescript
// ❌ Unsafe
const data: any = await fetch();

// ✅ Type guards
function isExpectedData(data: unknown): data is ExpectedData {
  return typeof data === 'object' && data !== null && 'field' in data;
}
const data = await fetch();
if (isExpectedData(data)) { /* safe */ }
```

**Unused Variables** (`@typescript-eslint/no-unused-vars`):
```typescript
// ❌ Unused destructured vars
const [data, error, loading] = useQuery();
// ✅ Prefix with underscore or only destructure what you need
const [data] = useQuery();
```

**Console Statements** (`no-console`):
```typescript
// ❌ console.log
// ✅ Use logger
import { logger } from '@/utils/logger';
logger.debug('Debug info:', data);
// console.warn and console.error are allowed
```

### Escalation — When Lint Cannot Be Fixed

1. Document the issue in code comments
2. Create a follow-up task in `.claude/issues/`
3. Get explicit user approval before proceeding
4. Use disable comments ONLY with justification:

```typescript
// Supabase types are generated and contain unavoidable 'any'
// Task: ISSUE-123 — Remove when Supabase types are fixed
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const result = await supabase.from('table').select();
```

## Error Handling Protocol

```typescript
// REQUIRED PATTERN
try {
  // operation
} catch (error: unknown) {
  const err = error as Error;
  logger.error(`Operation failed: ${err.message}`, { correlationId, context });
  throw new ServiceError(err.message, { cause: err, correlationId });
}
```

- **FAIL FAST**: surface errors immediately with descriptive messages
- **TRACE REQUESTS**: include correlation IDs for full-stack debugging
- **NEVER**: use silent catch blocks or swallow errors

## TypeScript Safety Protocol

### Before/After Any Type Modification
```bash
yarn tsc --noEmit  # verify before and after
```

Identify all files that import changed types. Document expected breaking changes.

### Database Type Rules
```typescript
// ✅ Use DB-specific types
interface DatabaseService {
  getOrder(id: string): Promise<DBOrderType>;
}

// ❌ Generic types don't match schema
interface BadService {
  getOrder(id: string): Promise<Order>;
}
```

### `any` Elimination
```typescript
// ❌ FORBIDDEN
function handleData(data: any) { }

// ✅ REQUIRED
function handleData(data: unknown) {
  if (isValidDataShape(data)) {
    return processData(data);
  }
  throw new Error('Invalid data shape');
}

function isValidDataShape(value: unknown): value is ExpectedDataType {
  return typeof value === 'object' && value !== null && 'requiredField' in value;
}
```

## Pre-Completion Checklist

### Phase 1 — File Persistence
```bash
git status           # Must show modified files
git diff --stat      # Must show lines changed
```
- [ ] All planned changes written to disk
- [ ] File modifications confirmed with git status and git diff

### Phase 2 — Lint and Type Validation
```bash
yarn lint --fix
yarn lint --max-warnings 0   # ZERO TOLERANCE
yarn tsc --noEmit
yarn build
```

### Phase 3 — Type Safety Scan
```bash
grep -r "any" src/ --exclude-dir=node_modules
grep -r "@ts-ignore" src/ --exclude-dir=node_modules
grep -r "catch.*:" src/ --exclude-dir=node_modules | grep -v "unknown"
```
- If `any` found → replace with `unknown` + type guards
- If `@ts-ignore` found → fix underlying type issue

### Final Checklist

**Lint Compliance (Zero Tolerance)**
- [ ] `yarn lint --fix` executed
- [ ] `yarn lint --max-warnings 0` returns exit code 0
- [ ] No new violations vs baseline

**Type Safety**
- [ ] `yarn tsc --noEmit` returns exit code 0
- [ ] No `any`, `@ts-ignore`, or improperly typed catches in new code
- [ ] Database operations use schema-specific types

**Build & Test**
- [ ] All tests pass with no failures
- [ ] `yarn build` succeeds for affected packages

**Code Quality**
- [ ] No conditional React Hooks
- [ ] No floating promises
- [ ] No async functions in event handlers (properly wrapped)
- [ ] All unused variables removed or prefixed with `_`
- [ ] Console statements replaced with logger (except warn/error)

## Agent Self-Assessment (Before Marking Complete)

1. Does `yarn lint --max-warnings 0` pass? (0 errors, 0 warnings)
2. Does `yarn tsc --noEmit` pass? (no type errors)
3. Did I add any `any` types? (must be zero)
4. Did I add any `@ts-ignore`? (must be zero)
5. Are all promises handled? (awaited or voided)
6. Are all hooks at top level with complete deps?
7. Did I run auto-fix first? (`yarn lint --fix`)
8. Are console.log statements absent or wrapped in `__DEV__`?

**If any answer is "no" — the task is NOT complete.**

## Forbidden Patterns — Auto-Reject

```typescript
// ❌ Type safety violations
function bad(data: any) { }                     // Use unknown
catch (error: any) { }                          // Use catch (error: unknown)
const r = apiResponse as SomeType;              // Add runtime validation
// @ts-ignore                                    // Fix the underlying issue

// ❌ Database type violations
function getOrder(): Promise<Order> { }         // Use Promise<DBOrderType>
if (types resolve to 'never') { /* commit */ } // Must fix before commit

// ❌ Package management violations
export type { NonExistentType } from './missing';  // Remove or create type
```

## React Native Specifics

> **Authority**: `expo-react-native.md` is the canonical source for all RN/Expo patterns. The checks below are a quick-reference summary — when in conflict, defer to `expo-react-native.md`.

### Required Checks for Every Component

**TypeScript Safety**
- [ ] No `any` types — use `unknown` + type guards
- [ ] Error handling uses `catch (error: unknown)`

**React Hooks Compliance**
- [ ] Hooks called at top level only (never in conditions/loops)
- [ ] All effect dependencies listed
- [ ] No async functions passed directly to `useEffect`

**React Native Specific**
- [ ] `StyleSheet.create()` used for styles (not inline objects)
- [ ] Platform-specific code uses `Platform.OS` or `Platform.select`
- [ ] Accessibility props added (`accessibilityLabel`, `accessibilityRole`)
- [ ] `testID` added for E2E testing
- [ ] Images have `width`/`height` or use `aspectRatio`
- [ ] Screen-level components use `useSafeAreaInsets` (not `SafeAreaView`) — see `expo-react-native.md` §7

**Import Order** (auto-fixable via `yarn lint --fix`):
```typescript
import React from 'react';                         // 1. React
import { View, Text, Platform } from 'react-native'; // 2. React Native
import { useRouter } from 'expo-router';           // 3. External packages
import { api } from '@/lib/api';                   // 4. Aliases
import { LocalComponent } from './LocalComponent'; // 5. Relative
```

### React Native Common Fixes

**Async Event Handlers:**
```typescript
// ❌
<Button onPress={async () => await saveData()}>

// ✅
<Button onPress={() => void saveData()}>
// OR
<Button onPress={() => { saveData().catch(error => Alert.alert('Error', error.message)); }}>
```

**Console statements in RN:**
```typescript
// ✅
if (__DEV__) { console.log('Debug:', data); }
// OR
import { logger } from '@/utils/logger';
logger.debug('Debug:', data);
```

### Lint-Compliant Component Template

```typescript
import React, { useCallback, useEffect, useState } from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import type { ViewStyle, TextStyle } from 'react-native';

interface ComponentProps {
  title: string;
  onPress?: () => void;
  style?: ViewStyle;
}

export const Component: React.FC<ComponentProps> = ({ title, onPress, style }) => {
  const [isLoading, setIsLoading] = useState(false);

  const handlePress = useCallback(() => {
    if (onPress) {
      setIsLoading(true);
      try { onPress(); } finally { setIsLoading(false); }
    }
  }, [onPress]);

  useEffect(() => {
    // effect logic
  }, []); // empty deps for mount-only

  return (
    <Pressable
      onPress={handlePress}
      style={[styles.container, style]}
      accessibilityRole="button"
      accessibilityLabel={title}
      testID="component-button"
    >
      <Text style={styles.text}>{title}</Text>
    </Pressable>
  );
};

const styles = StyleSheet.create({
  container: { padding: 16, backgroundColor: '#007AFF', borderRadius: 8 } satisfies ViewStyle,
  text: { color: 'white', fontSize: 16, fontWeight: '600' } satisfies TextStyle,
});
```

## Ticket System Integration

- Create tickets for all substantial work using YAML format
- Filename: `YYYY-MM-DD-HHMMSS-<slug>.yaml`
- Required fields: Title, Type (Task/Story/Bug), Severity (Blocker/Major/Minor), Effort (XS/S/M/L/XL), Project, Working Directory, Created By
- Update status throughout development lifecycle
- Reference ticket IDs in commit messages
