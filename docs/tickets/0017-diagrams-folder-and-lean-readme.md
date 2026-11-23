---
id: T-0017
title: Move the workflow chart to docs/diagrams and trim the README
type: docs
breaking: false
scope: diagrams
status: resolved
spec: none
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
The repo ships a `diagram` skill but has no `docs/diagrams/` folder yet (the odhyp
block in `CLAUDE.md` already names `Diagrams: docs/diagrams`). The README is crowded:
it carries the full workflow flowchart inline, two overlapping Skills tables, and a
Roadmap that is no longer useful. This ticket dogfoods the `diagram` skill by moving
the workflow chart into a `.mmd` file, adds a second diagram that nothing shows today
(which skill reads or writes which file), and slims the README.

## Decisions that apply
- Use the `diagram` skill's rules (`plugins/odhyp/skills/diagram/SKILL.md`): line 1 is
  a `%%` header comment saying what the diagram covers; plain Mermaid; no HTML; no
  styling beyond `classDef`; node labels use the names in the code.
- `docs/diagrams/workflow.mmd`: the README's `## Workflow` flowchart moved as is (same
  nodes, IDs, edges, subgraphs, emoji). Only change: every `<br/>` label becomes a
  Mermaid markdown string (`` "`line one
  line two`" ``) so the file has no HTML.
- `docs/diagrams/data-flow.mmd`: a flowchart with the skills on one side and the files
  they touch on the other, with read and write edges. Derive the edges from each
  `plugins/odhyp/skills/*/SKILL.md`, not from memory. Files to cover as they apply:
  the odhyp block in `CLAUDE.md`, the specs, tickets, diagrams and releases folders,
  `VERSION` / `plugin.json`, `CHANGELOG.md`, `plugins/odhyp/templates/*`, and the
  commit hook.
- GitHub does not render `.mmd`; that is accepted (ADR 0004).
- README `## Workflow` becomes one short line linking to `docs/diagrams/workflow.mmd`.
  Keep the 👤 / 🤖 / ⚙️ legend only if the line needs it to make sense; otherwise move
  the legend into the `.mmd` header comment.
- README: merge the two Skills tables into one `Skill | Invocation | Does` table. Fold
  each skill's "Answers" question into its "Does" text where it adds something; keep
  the row order of the current second table.
- README: delete `## Roadmap` entirely, "Later" items included. No tickets are made
  from them.
- Leave `## Polaris contract`, Development, Feedback and License alone: Polaris is
  removed in T-0018.

## Files
- docs/diagrams/workflow.mmd (new)
- docs/diagrams/data-flow.mmd (new)
- README.md (change)

## Acceptance criteria
- [x] `docs/diagrams/workflow.mmd` opens with a `%%` header, contains no `<br/>` or other
      HTML, and has the same nodes and edges as the README chart it replaces.
- [x] `docs/diagrams/data-flow.mmd` opens with a `%%` header and shows every skill
      under `plugins/odhyp/skills/` with read/write edges matching its SKILL.md.
- [x] Both files parse in a Mermaid renderer (e.g. `npx -y @mermaid-js/mermaid-cli`
      or mermaid.live).
- [x] README has no mermaid block; its Workflow section links to `docs/diagrams/workflow.mmd`.
- [x] README has exactly one Skills table (`Skill | Invocation | Does`) and no Roadmap.
- [x] Every relative link in the README resolves to an existing file.
- [x] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope
- Any Polaris mention (T-0018).
- `architecture.mmd` / `infrastructure.mmd`: the skills have no imports and there are no services.
- Editing ADRs, the CHANGELOG, or any skill.

## Questions

## Notes
- `workflow.mmd`: the README chart moved verbatim; `<br/>` labels are now Mermaid
  markdown strings, and the 👤/🤖/⚙️ legend moved into the `%%` header.
- `data-flow.mmd`: dotted = reads, solid = writes, `calls` = skill invokes skill. Hyphenated
  skills use camelCase node IDs (`toSpec`, `codeReview`, …) with the real name as label,
  so arrows parse. Edges derived from each SKILL.md at v0.4.0. No subgraphs: they tangled
  the layout; `classDef` marks templates (dashed) and skills (bold) instead. The
  "every skill reads the odhyp block" edge lives in the header comment for the same reason.
- Parse check: `npx -y @mermaid-js/mermaid-cli@11.4.2 -p pp.json` with
  `{"executablePath": "<msedge.exe>"}`; mmdc's bundled Chrome is not installed here.
- README: Workflow is one line linking both diagrams; the two Skills tables merged and
  re-padded; Roadmap deleted. Polaris contract left for T-0018.
- Must-fix (review): `docs/diagrams/data-flow.mmd:68`: missing read edges that the
  SKILL.md files describe. Add `diagrams -.-> codeReview`, `diagrams -.-> toTickets`,
  `diagrams -.-> diagram`, `specs -.-> implement`, and `releases -.->|"next ID"| diagnose`.
- Must-fix fixed: added the five read edges; header now says shape and session-review
  do not read the odhyp block (review's Medium finding). Re-rendered, parses.
- Must-fix (review 2): `docs/diagrams/data-flow.mmd:79`: release edges missing. Add
  `version -.-> release`, `changelog -.-> release`, `release -->|"released_in"| tickets`,
  `release -->|"status"| specs`.
- Must-fix (review 2): `docs/diagrams/data-flow.mmd:1`: header says session-review reads
  only the session, but it checks for `plugins/odhyp/.claude-plugin/plugin.json`. Fix the
  header wording (implementer view: an existence check, not a version read, so no
  `version -.-> sessionReview` edge).
- Must-fix (review 2) fixed: release now reads version and changelog and writes
  `released_in` on tickets and `status` on specs. Header split into three `%%` lines; the
  plugin.json existence checks (to-tickets, session-review) and setup's .gitkeep deletes and
  git config are listed as "not drawn" instead of as edges.
- Full audit of every SKILL.md against the diagram also added: code read by setup (stack
  config), shape, implement and release (commits); "next ID" reads of specs/ (to-spec) and
  tickets/ (to-tickets, diagnose).
