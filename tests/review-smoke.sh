#!/bin/sh
# Smoke test: code-review forks and catches a planted bug. Calls the API (~$0.35); run by hand.
# Run: sh tests/review-smoke.sh
set -e
plugin="$(cd "$(dirname "$0")/../plugins/odhyp" && pwd)"
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
cd "$t"
git init -q && git config user.email t@t && git config user.name t
mkdir -p docs/tickets
printf '<!-- odhyp:start -->\n## odhyp skills\n- Specs: `docs/specs`\n- Tickets: `docs/tickets`\n- Diagrams: `docs/diagrams`\n- Releases: `docs/releases`\n- Version files: `VERSION`\n- Changelog: `CHANGELOG.md`\n- Test: python -m unittest -q · Lint: none\n<!-- odhyp:end -->\n' > CLAUDE.md
printf 'def add(a, b):\n    return a + b\n' > calc.py
git add -A && git commit -qm "chore: init"
cat > docs/tickets/0001-subtract.md <<'TICKET'
---
id: T-0001
title: Add subtract
type: feat
breaking: false
scope: calc
status: in-progress
spec: none
depends_on: []
source: human
parent: none
diagrams: []
released_in:
---
## Context
calc.py needs subtract(a, b).
## Acceptance criteria
- [ ] subtract(a, b) returns a - b
- [ ] covered by a test
## Out of scope
Anything else.
## Notes
TICKET
# planted bug: subtract adds, and no test exists
printf 'def add(a, b):\n    return a + b\n\ndef subtract(a, b):\n    return a + b\n' > calc.py

claude -p --plugin-dir "$plugin" --output-format stream-json --verbose --max-budget-usd 1.5 \
  --permission-mode acceptEdits --allowedTools "Bash(git *)" "Bash(python *)" Read Glob Grep Skill \
  -- "I finished the code for ticket T-0001. Review my uncommitted work before I commit." \
  < /dev/null > out.jsonl

python -I - out.jsonl <<'PY'
import json, sys
events = [json.loads(l) for l in open(sys.argv[1], encoding="utf-8") if l.strip().startswith("{")]
skill = any(c.get("type") == "tool_use" and c.get("name") == "Skill" and "code-review" in json.dumps(c.get("input"))
            for e in events if e.get("type") == "assistant" for c in e["message"]["content"])
forked = any(e.get("type") == "system" and e.get("subtype") == "task_started" for e in events)
result = next((e for e in events if e.get("type") == "result"), {})
text = str(result.get("result", "")).lower()
caught = "a - b" in text or ("subtract" in text and ("+" in text or "adds" in text))
checks = {"code-review skill invoked": skill, "ran in a forked subagent": forked,
          "planted bug reported": caught, "cost": result.get("total_cost_usd")}
for k, v in checks.items(): print(f"{k}: {v}")
sys.exit(0 if skill and forked and caught else 1)
PY
