---
id: T-0036
title: Align contradicting rules across the odhyp skills and formats
type: fix
breaking: false
scope: skills
status: resolved
spec: none
depends_on: []
source: diagnose
parent: none
diagrams: []
released_in: v0.10.0
---

## Context
A read-through of every skill and template in `plugins/odhyp/` found eight places where one
file's rule contradicts another's (or itself). Some make a handoff fail (survey → to-adr,
implement → code-review); the rest are stale or incomplete wording.

## Reproduction
Run from the repo root; each pair prints the two lines that disagree.
1. `grep -n "Candidates" plugins/odhyp/skills/survey/SKILL.md; grep -n "only once it is settled" plugins/odhyp/skills/to-adr/SKILL.md`
2. `grep -n "diagrams\` is not empty\|still update any diagram" plugins/odhyp/skills/implement/SKILL.md; grep -n "no other existing diagram" plugins/odhyp/skills/code-review/SKILL.md`
3. `grep -n "Drift\|Findings\*\*" plugins/odhyp/skills/survey/SKILL.md; grep -n "Do not otherwise read the glossary" plugins/odhyp/skills/implement/SKILL.md`
4. `grep -n "post-commit review" plugins/odhyp/templates/TICKET-FORMAT.md; grep -n "no ticket status or\|stays \`resolved\`" plugins/odhyp/skills/code-review/SKILL.md`
5. `grep -n "^| \`resolved\`\|^| \`ready-for-agent\`\|--> resolved\|--> wontfix" plugins/odhyp/templates/TICKET-FORMAT.md; grep -n "wontfix" plugins/odhyp/skills/implement/SKILL.md`
6. `grep -n "must be tracked by git" plugins/odhyp/skills/setup/SKILL.md`
7. `grep -n "ticket ID · what" plugins/odhyp/templates/SPEC-FORMAT.md; grep -n "date · what changed" plugins/odhyp/skills/implement/SKILL.md`
8. `grep -n "on request or from" plugins/odhyp/skills/setup/SKILL.md`

## Expected / Actual
- Expected: every rule one skill relies on is allowed by the skill it hands off to, and each format agrees with its own diagram and with the skills that write it.
- Actual:
  1. survey sends decisions already in the code to `/odhyp:to-adr`, whose gate accepts only decisions `implement` shipped or `shape` agreed.
  2. implement (ticket mode) updates only the ticket's `diagrams`; code-review grades any other diagram the change leaves wrong as at least High, so the run blocks.
  3. survey sends glossary and ADR drift to `/odhyp:implement N`, which never edits the glossary outside a brief's entries and never edits an ADR.
  4. TICKET-FORMAT says `## Notes` holds post-commit review findings; code-review and implement never write them there.
  5. TICKET-FORMAT's Statuses table says only implement sets `resolved`, and leaves implement out of the `ready-for-agent` setters, against its own state diagram and implement's text; the diagram lacks `ready_for_human`/`in_progress → wontfix`, which implement suggests.
  6. setup checks only specs, tickets, releases and decisions are tracked by git, though implement and survey also commit the diagrams folder and the glossary file.
  7. SPEC-FORMAT's `## Decisions` line needs a ticket ID; implement's direct mode writes none.
  8. setup says diagrams come "on request or from `/shape`", but its own report suggests `/odhyp:survey` to draft them.

## Root cause
Rules were added skill by skill (survey in T-0033/T-0034, direct mode and after-commit review
earlier) without updating the older skills and formats they hand off to: to-adr's gate predates
survey; implement's direct-mode diagram line was added without the matching ticket-mode line;
the TICKET-FORMAT table, diagram and Notes comment predate the after-commit review and the
`ready-for-human` exits.

## Failing test to write first
Skill text only; no testable behaviour (per ADR-0014, no manual trial). The check is the
Reproduction greps: after the fix, each pair no longer disagrees, and
`claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Decisions that apply
- Change wording only; add no new step, field, status or skill. The ticket frontmatter stays locked.
- to-adr still asks for the reason when it is missing (its step 2); a survey candidate has none, so that question is how it gets one.
- survey still never rewrites an existing glossary entry, diagram or ADR itself.
- Glossary drift goes to `/shape` to discuss and settle the term first; its summary's `## Glossary` then reaches implement as the brief. implement's glossary rule does not change.
- Shell commands touched must keep running in sh and PowerShell 5.1.

## Files
- plugins/odhyp/skills/to-adr/SKILL.md (change)
- plugins/odhyp/skills/implement/SKILL.md (change)
- plugins/odhyp/skills/survey/SKILL.md (change)
- plugins/odhyp/skills/setup/SKILL.md (change)
- plugins/odhyp/templates/TICKET-FORMAT.md (change)
- plugins/odhyp/templates/SPEC-FORMAT.md (change)

## Acceptance criteria
- [x] to-adr's settled rule also accepts a decision already in the code (such as a survey candidate).
- [x] implement step 3, ticket mode, updates the ticket's `diagrams` and any other existing diagram the work makes wrong; the direct-mode line no longer implies a rule ticket mode lacks.
- [x] survey's findings name the right next step by kind: `/odhyp:implement N` for code or a diagram, `/odhyp:to-adr` (supersede or amend) for an ADR, `/shape` for a glossary term.
- [x] TICKET-FORMAT's `## Notes` comment no longer mentions post-commit review findings.
- [x] TICKET-FORMAT's Statuses table lists implement for `ready-for-agent` and human for `resolved`; the state diagram has `ready_for_human --> wontfix` and `in_progress --> wontfix`.
- [x] setup step 2 also checks the diagrams folder and the glossary file with `git check-ignore`, and its reason names implement and survey.
- [x] SPEC-FORMAT's `## Decisions` comment makes the ticket ID optional (`date · [ticket ID ·] what changed and why`).
- [x] setup step 3 says diagrams come on request, from `/shape` or from `/odhyp:survey`.
- [x] Both `claude plugin validate` commands pass.

## Out of scope
- Version bump and CHANGELOG (done by /odhyp:release).
- Any change to the ticket or spec frontmatter.
- Other wording cleanups found while editing (separate ticket).

## Questions

## Notes
- Wording-only edits to to-adr, implement, survey, setup, TICKET-FORMAT and SPEC-FORMAT, one per Reproduction pair. setup step 2 now runs `git check-ignore -v <glossary file>` alongside the folder checks. Validate passes (the ICON_MISSING warning predates this ticket).
