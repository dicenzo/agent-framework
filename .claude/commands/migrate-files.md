# Migrate Misplaced Files Command

**Purpose**: Identify and migrate misplaced files to proper `/deliverables/` structure

## Usage
```bash
/migrate-files [--dry-run] [--auto-fix]
```

## Implementation

### Step 1: Scan for Violations
```bash
#!/bin/bash

echo "🔍 Scanning for misplaced files..."

# Track violations
declare -a violations=()
declare -a suggestions=()

# Check .claude/issues for non-YAML files
while IFS= read -r file; do
  if [[ ! "$file" =~ \.yaml$ ]]; then
    violations+=("$file")

    # Determine proper location
    if [[ "$file" =~ summary ]]; then
      suggestions+=("deliverables/reports/executive/$(basename "$file")")
    elif [[ "$file" =~ analysis|report ]]; then
      suggestions+=("deliverables/reports/incidents/$(basename "$file")")
    else
      suggestions+=("deliverables/working/$(basename "$file")")
    fi
  fi
done < <(find .claude/issues -type f 2>/dev/null)

# Check root directory for documents
while IFS= read -r file; do
  if [[ "$file" != "./README.md" ]]; then
    violations+=("$file")

    # Categorize by content
    if [[ "$file" =~ IMPLEMENTATION|SUMMARY|COMPLETE ]]; then
      suggestions+=("deliverables/reports/status/$(basename "$file")")
    elif [[ "$file" =~ ANALYSIS|RESEARCH ]]; then
      suggestions+=("deliverables/analysis/technical/$(basename "$file")")
    elif [[ "$file" =~ QUICK|REFERENCE|GUIDE ]]; then
      suggestions+=("deliverables/documentation/internal/$(basename "$file")")
    else
      suggestions+=("deliverables/working/$(basename "$file")")
    fi
  fi
done < <(find . -maxdepth 1 -type f -name "*.md" -o -name "*.txt" 2>/dev/null)

# Check source directories
while IFS= read -r file; do
  violations+=("$file")
  suggestions+=("deliverables/documentation/internal/$(basename "$file")")
done < <(find ./src ./packages -type f \( -name "*.md" -o -name "*.txt" -o -name "*.doc" \) -not -name "README.md" 2>/dev/null)
```

### Step 2: Display Violations
```bash
if [ ${#violations[@]} -eq 0 ]; then
  echo "✅ No misplaced files found!"
  exit 0
fi

echo "⚠️  Found ${#violations[@]} misplaced files:"
echo ""

for i in "${!violations[@]}"; do
  echo "❌ ${violations[$i]}"
  echo "   → Suggested: ${suggestions[$i]}"
  echo ""
done
```

### Step 3: Migration Plan
```bash
function generate_migration_script() {
  echo "#!/bin/bash"
  echo "# Auto-generated migration script"
  echo "# Generated: $(date)"
  echo ""
  echo "# Create deliverables structure"
  echo "mkdir -p deliverables/{analysis/{business,technical,requirements},reports/{executive,status,incidents,handoffs},designs/{architecture,ui-ux,database},documentation/{api,user-guides,internal},working}"
  echo ""

  for i in "${!violations[@]}"; do
    src="${violations[$i]}"
    dst="${suggestions[$i]}"

    echo "# Migrate: $(basename "$src")"
    echo "mkdir -p $(dirname "$dst")"
    echo "mv \"$src\" \"$dst\""
    echo "echo \"Moved: $src → $dst\""
    echo ""
  done

  echo "echo '✅ Migration complete!'"
}
```

### Step 4: Execute Migration
```bash
if [[ "$1" == "--dry-run" ]]; then
  echo "📋 DRY RUN - No files will be moved"
  echo "Migration script:"
  echo "=================="
  generate_migration_script
  exit 0
fi

if [[ "$1" == "--auto-fix" ]]; then
  echo "🚀 Executing automatic migration..."

  # Create directory structure
  mkdir -p deliverables/{analysis/{business,technical,requirements},reports/{executive,status,incidents,handoffs},designs/{architecture,ui-ux,database},documentation/{api,user-guides,internal},working}

  # Execute migrations
  for i in "${!violations[@]}"; do
    src="${violations[$i]}"
    dst="${suggestions[$i]}"

    mkdir -p "$(dirname "$dst")"
    if mv "$src" "$dst" 2>/dev/null; then
      echo "✅ Moved: $src → $dst"
    else
      echo "❌ Failed to move: $src"
    fi
  done

  echo ""
  echo "🎉 Migration complete!"
  echo "Run 'git status' to review changes"
  exit 0
fi

# Interactive mode
echo ""
echo "Would you like to:"
echo "1. Generate migration script (save for review)"
echo "2. Execute migration now (--auto-fix)"
echo "3. See dry run (--dry-run)"
echo "4. Cancel"
echo ""
read -p "Choice [1-4]: " choice

case $choice in
  1)
    generate_migration_script > migrate-files-$(date +%Y%m%d-%H%M%S).sh
    echo "✅ Migration script saved"
    ;;
  2)
    $0 --auto-fix
    ;;
  3)
    $0 --dry-run
    ;;
  *)
    echo "Cancelled"
    ;;
esac
```

## Validation After Migration

```bash
# Verify no violations remain
echo "🔍 Post-migration validation..."

remaining=$(find . -name "*.md" -o -name "*.txt" | \
  grep -E "(^\.\/[^\/]+\.(md|txt)|^\.\/\.claude\/issues\/[^\.]*\.(md|txt))" | \
  grep -v "^./README.md" | \
  grep -v "^./deliverables/" | \
  wc -l)

if [ "$remaining" -eq 0 ]; then
  echo "✅ All files properly organized!"
else
  echo "⚠️  $remaining files still need attention"
fi
```

## Git Integration

After migration, create a commit:
```bash
git add -A
git commit -m "refactor: Migrate files to /deliverables/ structure per file-organization policy

- Moved executive summaries from .claude/issues/ to deliverables/reports/executive/
- Moved root-level deliverables to appropriate deliverables/ subdirectories
- Cleared documentation from src/ directories
- Established proper information architecture

Refs: .claude/policies/file-organization.md"
```

## Schedule Regular Checks

Add to CI/CD:
```yaml
- name: Check file organization
  run: |
    .claude/commands/migrate-files.md --dry-run
    if [ $? -ne 0 ]; then
      echo "::error::Misplaced files detected. Run migrate-files command."
      exit 1
    fi
```

## Success Criteria
- Zero files in `.claude/issues/` except YAML tickets
- Zero documents in project root except README.md
- Zero documentation in `/src/` or `/packages/`
- All deliverables under `/deliverables/` hierarchy
- Clear audit trail of migrations