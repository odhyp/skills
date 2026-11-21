---
name: code-review
description: Use after implement has written the code and tests for a ticket and before it commits, to review the uncommitted diff against ticket T-NNNN in a fresh context. Also when the user asks for a review of a ticket's work. Pass the ticket ID (or a spec ID, or the request text) as the argument.
argument-hint: "T-NNNN | S-NNNN | <request>"
context: fork
background: false
---

You are a reviewer with fresh eyes. You see the brief and the diff, not the implementer's reasoning; judge the work only against the brief.

**Brief:** `$ARGUMENTS`. A `T-` ID means that ticket (with its spec as background), an `S-` ID that spec, and anything else is the request itself. No argument: stop and return `MUST-FIX: no brief given; pass the ticket ID`.

## 1. Load

- The odhyp block in `CLAUDE.md`: paths, test and lint commands.
- `TICKET-FORMAT.md`, and the brief.
- The change: `git status --porcelain`, `git diff HEAD`, and the full content of every new untracked file.
- **Empty diff** and the ticket is `resolved`: review its commits instead (`git log --grep "Refs: T-NNNN" -p`). This is the post-commit mode below.

## 2. Check

Leave the project's code as it is: you report and write tickets, the implementer fixes. Check every item:

| Area | Must hold |
|---|---|
| Acceptance | Every acceptance criterion is met by the code and covered by a test. Nothing in `## Out of scope` was built. `## Decisions that apply` are followed. |
| Correctness | The logic is right on the edge and failure cases the ticket implies. No data loss, no secret in the diff, input validated at trust boundaries. |
| Tests | They test behaviour, would go red if the code were wrong, and pass. Run the test and lint commands yourself. |
| Records | The ticket's `## Notes` say what was done; the acceptance boxes are checked; `status: resolved` is staged with the code. A spec that the work proved wrong has a `## Decisions` entry. |
| Diagrams | Every file in the ticket's `diagrams` is updated. Any other change that adds, removes or rewires services, infrastructure, data flow or module boundaries has a diagram update too. |
| Commit | The planned `type(scope)!:` matches the ticket's `type`, `scope` and `breaking`. |

Sort each problem:
- **Must-fix:** breaks a row above. It blocks the commit.
- **Follow-up:** worth doing, outside this ticket's scope. Write it as a new ticket now: next `T-` ID, `source: code-review`, `from: <this ticket>`, `status: ready-for-agent`, self-contained per the format.

## 3. Return

Start with a verdict line, `PASS` or `MUST-FIX`, then:

- each must-fix finding: `path:line`, what is wrong, and the required change;
- the IDs and titles of follow-up tickets written.

**Post-commit mode** with must-fix findings: also set the ticket back to `status: ready-for-agent` and add the findings under its `## Notes`.
