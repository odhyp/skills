---
id: T-0011
title: implement direct mode
type: feat
breaking: false
scope: implement
status: resolved
spec: S-0002
depends_on: [T-0009]
source: to-tickets
parent: none
diagrams: []
released_in: v0.3.0
---

## Context
`plugins/odhyp/skills/implement/SKILL.md` only builds tickets. Small, well-understood work found in the current session (a `session-review` or `code-review` finding, a small refactor the user asks for) must become a ticket first. `implement` should answer *How do we build it?* for both a ticket and a direct request, with the same quality bar. ADR-0007 (T-0009) allows direct work when its scope is clear and the user authorises it.

## Decisions that apply
- **Mode by argument:** `$ARGUMENTS` starting with `T-` or `@<tickets>/` → ticket mode, unchanged. Anything else (`finding 1`, `1`, `1,3`, `all`, free text) → direct mode. No argument keeps today's pick-the-next-ticket behaviour. Update `argument-hint` and `description` to cover both.
- **Direct brief:** restate the selected finding(s) or request as one or two lines of expected outcome, and state them before building. If the request is ambiguous or has significant architectural implications, ask, or send the user to `/shape`. Keep the scope to what was asked.
- **Build:** test-first in both modes. Changes with no testable behaviour (docs, skill text) skip red/green but still run the full test and lint commands. State this once, for both modes.
- **Review:** run `odhyp:code-review` in both modes; direct mode passes the restated brief as the argument (code-review already accepts `<request>`). MUST-FIX in direct mode: commit nothing, report the findings, stop.
- **Records:** direct mode has no ticket to update. Diagrams and a spec's `## Decisions` are still updated when the work touches them.
- **Commit:** direct mode commits `type(scope): subject` with no `Refs:` footer, except when the findings came from a review of ticket T-NNNN (then add `Refs: T-NNNN`). Several findings share one commit when they share type and scope, otherwise one commit each. The commit-msg hook does not require `Refs:`, and `release` already reads ticketless commits.
- **Never** create a ticket in direct mode unless the user asks; "too big for one session" in direct mode means stop and suggest `/to-tickets`, not split by itself.
- Ticket mode is unchanged.

## Files
- plugins/odhyp/skills/implement/SKILL.md (change)

## Acceptance criteria
- [x] `implement/SKILL.md` picks the mode from the argument as above.
- [x] Direct mode restates the brief, asks or points to `/shape` when ambiguous or architectural.
- [x] Test-first and the no-testable-behaviour exception are stated once for both modes.
- [x] Direct mode runs `odhyp:code-review` with the restated brief; MUST-FIX commits nothing.
- [x] Direct-mode commit rules (no `Refs:` unless from a ticket's review; grouping by type and scope) are stated.
- [x] Direct mode creates no tickets unless asked.
- [x] The ticket-mode steps read as before.
- [x] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- Relaying code-review's non-blocking findings after the commit, and removing follow-up-ticket wording (T-0012).
- README (T-0015).

## Questions

## Notes
- Mode is chosen from `$ARGUMENTS` at the top; each step keeps its ticket-mode text verbatim and adds a short "In direct mode" line, so ticket mode reads as before.
- Skill-text change: no red/green; `sh tests/commit-msg.test.sh` and both `claude plugin validate` runs pass (pre-existing ICON_MISSING warning only).
