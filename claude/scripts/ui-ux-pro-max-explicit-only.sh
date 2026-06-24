#!/usr/bin/env bash
# Re-apply `disable-model-invocation: true` to ui-ux-pro-max skills so they stay
# explicit-invoke-only (no auto-firing). Plugin auto-updates revert the frontmatter,
# so run this after any ui-ux-pro-max update.
set -euo pipefail

BASE="$HOME/.claude/plugins/cache/ui-ux-pro-max-skill/ui-ux-pro-max"
VER_DIR="$(find "$BASE" -maxdepth 1 -mindepth 1 -type d | sort -V | tail -1)"
SKILLS_DIR="$VER_DIR/.claude/skills"

for f in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$f" ] || continue
  if grep -q 'disable-model-invocation' "$f"; then
    echo "already set: $f"; continue
  fi
  # insert before the closing frontmatter '---' (second line that is exactly ---)
  awk '
    BEGIN{c=0}
    /^---[[:space:]]*$/{c++; if(c==2){print "disable-model-invocation: true"}}
    {print}
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  echo "patched: $f"
done
