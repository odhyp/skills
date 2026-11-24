---
id: T-0025
title: to-adr skill and ADR template
type: feat
breaking: false
scope: adr
status: ready-for-agent
spec: S-0004
depends_on: [T-0024]
source: to-tickets
parent: none
diagrams: [workflow, data-flow]
released_in:
---

## Context
No odhyp skill writes ADRs, so decisions survive only in specs, which `release` archives.
This ticket adds the user-invocable `to-adr` skill and the ADR template. The offers from
`implement` and `shape` come in T-0026. T-0024 added `Decisions:` to the CLAUDE.md block.

## Decisions that apply
- `to-adr` records a decision only once it is settled: `implement` shipped it, or `shape`
  agreed on it with nothing to build. Half-shaped feature decisions stay in their spec.
- Manual skill: frontmatter `name: to-adr`, a `description`, `disable-model-invocation: true`,
  like `to-spec`.
- Steps:
  1. Read the odhyp block for `Decisions:`. No block: stop and say to run `/odhyp:setup`.
     Block without `Decisions:`: stop and say to re-run `/odhyp:setup`.
  2. Take the decision from the conversation, plus the spec and ticket when `implement`
     made the offer.
  3. Next ID: one above the highest `NNNN` in the decisions folder, starting at 0001; only
     that folder is scanned (ADRs are never archived). File: `NNNN-<kebab-title>.md`.
  4. If the decision overrides an existing ADR, in full or in part, name it; the user
     confirms the link.
  5. Show the full draft and get explicit approval before writing, in a loop like
     `to-spec`: a reply that approves and also asks for a change is a revision.
  6. Write the new ADR. If it links to an old one, add the back-link line to the old ADR
     right after its H1. That line is the only change `to-adr` makes to an existing ADR.
  7. Stage only the files it wrote and commit
     `git commit -m "docs(adr): add ADR-NNNN <slug>" -- <files>`, no `Refs:` footer. Never
     amend the `implement` commit (code-review already checked it). Never push.
- Format, held in `plugins/odhyp/templates/adr.md` (skill reads it via
  `${CLAUDE_PLUGIN_ROOT}/templates/adr.md`):
  - No frontmatter.
  - `# <the decision, as a statement>`.
  - Optional single line right after the H1: `Supersedes ADR-NNNN.` or `Amends ADR-NNNN.`;
    the old ADR gets `Superseded by ADR-NNNN.` or `Amended by ADR-NNNN.` in the same position.
  - One paragraph: the decision, then why. No `Reasons:` label.
  - Optional sections, only `## Considered options` (a rejected option worth keeping) and
    `## Consequences` (the decision binds later work).
  - References always written `ADR-NNNN`.
- Any shell command in the skill must run in both sh and PowerShell 5.1 (quote `@{...}`;
  no `&&`, `||` or `VAR=x cmd`); run each in both.
- Diagrams are already drawn and uncommitted in the working tree: `workflow.mmd` has the
  `/to-adr` node and both offer edges; `data-flow.mmd` has the `to-adr` skill, `adr.md` template,
  `adr/` folder and their edges. Check they match and commit them with this ticket.

## Files
- plugins/odhyp/skills/to-adr/SKILL.md (new)
- plugins/odhyp/templates/adr.md (new)
- README.md (change: add a `to-adr` row to the Skills table, Manual)
- docs/diagrams/workflow.mmd (change, already drawn)
- docs/diagrams/data-flow.mmd (change, already drawn)

## Acceptance criteria
- [ ] `to-adr/SKILL.md` follows the seven steps above and points to the template for the format.
- [ ] `templates/adr.md` shows the format above, optional parts marked as optional.
- [ ] README Skills table has a `to-adr` row.
- [ ] Both diagrams match the skill as built.
- [ ] `claude plugin validate . && claude plugin validate plugins/odhyp` passes; `sh tests/commit-msg.test.sh` passes.

## Out of scope
- Offers from `implement` and `shape` (T-0026).
- Fixing the existing ADRs (T-0027).
- Frontmatter or status fields on ADRs.
- `to-spec` or `release` writing or offering ADRs.

## Questions

## Notes
