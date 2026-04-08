#!/bin/bash
set -e

# Second Brain — Onboarding Script
# Scaffolds vault directory structure and verifies CLI tooling.
#
# Usage: bash onboarding.sh <vault-path> [vault-name] [domain-description] [domain-tags-csv]
# Output: JSON summary to stdout. Progress messages to stderr.

VAULT_ROOT="${1:-.}"
VAULT_NAME="${2:-$(basename "$VAULT_ROOT")}"
DOMAIN_DESCRIPTION="${3:-Personal knowledge base}"
DOMAIN_TAGS_CSV="${4:-knowledge-base,second-brain}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_ROOT="$(cd "$SKILL_DIR/../.." && pwd)"

echo "=== Second Brain Onboarding ===" >&2

# 1. Create directory structure
echo "Creating directory structure..." >&2
mkdir -p "$VAULT_ROOT/raw/assets"
mkdir -p "$VAULT_ROOT/wiki/sources"
mkdir -p "$VAULT_ROOT/wiki/entities"
mkdir -p "$VAULT_ROOT/wiki/concepts"
mkdir -p "$VAULT_ROOT/wiki/synthesis"
mkdir -p "$VAULT_ROOT/output"

# 2. Create wiki/index.md if it doesn't exist
if [ ! -f "$VAULT_ROOT/wiki/index.md" ]; then
  cat > "$VAULT_ROOT/wiki/index.md" << 'EOF'
# Index

Master catalog of all wiki pages. Updated on every ingest.

## Sources

## Entities

## Concepts

## Synthesis
EOF
  echo "Created wiki/index.md" >&2
else
  echo "wiki/index.md already exists, skipping" >&2
fi

# 3. Create wiki/log.md if it doesn't exist
if [ ! -f "$VAULT_ROOT/wiki/log.md" ]; then
  cat > "$VAULT_ROOT/wiki/log.md" << 'EOF'
# Log

Chronological record of all operations.

EOF
  echo "Created wiki/log.md" >&2
else
  echo "wiki/log.md already exists, skipping" >&2
fi

# 4. Generate single-agent config at workspace @skills/agent.md
echo "Generating agent config..." >&2
AGENT_TEMPLATE="$SKILL_DIR/references/agent-configs/agent.md"
WIKI_SCHEMA_FILE="$SKILL_DIR/references/wiki-schema.md"
AGENT_OUTPUT="$WORKSPACE_ROOT/skills/agent.md"

if [ -f "$AGENT_TEMPLATE" ] && [ -f "$WIKI_SCHEMA_FILE" ]; then
  if [ -f "$AGENT_OUTPUT" ]; then
    echo "Overwriting existing @skills/agent.md" >&2
  fi
  python3 - <<'PY' "$AGENT_TEMPLATE" "$WIKI_SCHEMA_FILE" "$AGENT_OUTPUT" "$VAULT_NAME" "$DOMAIN_DESCRIPTION" "$DOMAIN_TAGS_CSV"
import sys
from pathlib import Path

template_path = Path(sys.argv[1])
schema_path = Path(sys.argv[2])
output_path = Path(sys.argv[3])
vault_name = sys.argv[4]
domain_description = sys.argv[5]
domain_tags_csv = sys.argv[6]

template = template_path.read_text(encoding="utf-8")
schema = schema_path.read_text(encoding="utf-8")

idx = schema.find("## Architecture")
wiki_schema = schema[idx:].strip() if idx != -1 else schema.strip()
domain_tags = [t.strip() for t in domain_tags_csv.split(",") if t.strip()]
domain_tags_block = "\n".join([f"- {t}" for t in domain_tags]) if domain_tags else "- knowledge-base"

# Keep only the indented template block between the first '---' and '## 占位符说明'.
content = template
if "\n---\n" in content and "\n## 占位符说明" in content:
    content = content.split("\n---\n", 1)[1]
    content = content.split("\n## 占位符说明", 1)[0]
lines = content.splitlines()
deindented = []
for ln in lines:
    if ln.startswith("    "):
        deindented.append(ln[4:])
    else:
        deindented.append(ln)
template_body = "\n".join(deindented).strip() + "\n"

rendered = template_body
rendered = rendered.replace("{{VAULT_NAME}}", vault_name)
rendered = rendered.replace("{{DOMAIN_DESCRIPTION}}", domain_description)
rendered = rendered.replace("{{DOMAIN_TAGS}}", domain_tags_block)
rendered = rendered.replace("{{WIKI_SCHEMA}}", wiki_schema)

output_path.parent.mkdir(parents=True, exist_ok=True)
output_path.write_text(rendered, encoding="utf-8")
PY
  echo "Created @skills/agent.md from template" >&2
else
  echo "Template or schema missing, skipped agent config generation" >&2
fi

# 5. Check tooling
echo "" >&2
echo "Checking tooling..." >&2

TOOLS_JSON="[]"

check_tool() {
  local name="$1"
  local cmd="$2"
  local install_cmd="$3"
  local status="missing"

  if command -v "$cmd" &> /dev/null; then
    status="installed"
    echo "  [ok] $name" >&2
  else
    echo "  [missing] $name — install with: $install_cmd" >&2
  fi

  TOOLS_JSON=$(echo "$TOOLS_JSON" | python3 -c "
import sys, json
tools = json.load(sys.stdin)
tools.append({'name': '$name', 'status': '$status', 'install': '$install_cmd'})
print(json.dumps(tools))
" 2>/dev/null || echo "$TOOLS_JSON")
}

check_tool "summarize" "summarize" "npm i -g @steipete/summarize"
check_tool "qmd" "qmd" "npm i -g @tobilu/qmd"
check_tool "agent-browser" "agent-browser" "npm i -g agent-browser && agent-browser install"

echo "" >&2
echo "Onboarding complete." >&2

# 6. Output JSON result to stdout
VAULT_ABS=$(cd "$VAULT_ROOT" && pwd)
cat << JSONEOF
{
  "status": "complete",
  "vault_root": "$VAULT_ABS",
  "directories": [
    "raw/",
    "raw/assets/",
    "wiki/",
    "wiki/sources/",
    "wiki/entities/",
    "wiki/concepts/",
    "wiki/synthesis/",
    "output/"
  ],
  "files": [
    "wiki/index.md",
    "wiki/log.md",
    "skills/agent.md (workspace root)"
  ],
  "tools": $TOOLS_JSON
}
JSONEOF