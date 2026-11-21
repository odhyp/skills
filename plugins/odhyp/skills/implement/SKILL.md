---
name: implement
description: Build one ticket test-first, get it reviewed, and commit it. The only odhyp skill that writes code.
disable-model-invocation: true
argument-hint: "@<tickets>/NNNN-slug.md"
---

Read `polaris.json` for the paths, the odhyp block in `CLAUDE.md` for the test and lint commands, and `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`.

## 1. Pick the ticket

The ticket is `$ARGUMENTS`. With no argument, pick the next eligible one: an `in-progress` ticket first, otherwise the lowest-numbered `ready-for-agent` ticket whose `depends_on` are all `resolved`. State its ID and title.

- `needs-info` with every item under `## Questions` answered: set `status: ready-for-agent` and continue.
- `in-progress`: resume. Check `git status` and `## Notes`; must-fix findings from an earlier review are listed there, and fixing them comes first.
- Otherwise set `status: in-progress`.

Refuse and stop when:
- it is `resolved` or `wontfix`: say so;
- it is `needs-info` with unanswered questions: show them;
- it is `ready-for-human`: say what the person has to do;
- any `depends_on` ticket is not `resolved`: list them.

## 2. Build, test-first

The ticket is the whole brief: build exactly its acceptance criteria, inside its `## Decisions that apply` and `## Out of scope`. Read the spec only as background.

For each acceptance criterion: write the test, run it and watch it go **red**, write the code that turns it **green**, refactor. A `fix` ticket starts with its `## Failing test to write first`.

Then run the full test and lint commands. **Done when** both are clean.

**Never guess.** When the ticket turns out to be:
- **unclear**: set `status: needs-info`, write the questions under `## Questions`, and stop;
- **too big** for one session: narrow this ticket to a first slice that fits, write the rest as new self-contained tickets (`parent:` this ticket, `source: implement`, depending on it), note the split in `## Notes`, set this ticket back to `ready-for-agent`, and stop.

## 3. Keep the records true

- If `diagrams` is not empty, update those diagrams using the **diagram** skill.
- If the work proved the spec wrong, add an entry under the spec's `## Decisions`: `date · T-NNNN · what changed and why`.
- Check off the acceptance criteria and append to `## Notes` what was done and anything a later reader needs.

## 4. Review

Run the odhyp **code-review** skill (`odhyp:code-review`) with the ticket ID as its argument. It reviews the uncommitted diff in a fresh context and writes any follow-up tickets itself.

- **MUST-FIX:** commit nothing. Add the findings under `## Notes` as `Must-fix (review):` with each `path:line` and required change, keep `status: in-progress`, and stop. Tell the user the findings and that the next step is `/implement` on this ticket again.
- **PASS** (with or without follow-ups): continue to step 5.

## 5. Commit

Set `status: resolved`. Stage the code, the tests, the ticket file and any diagram, spec or follow-up ticket files, and commit them together:

```
type(scope)!: subject

Refs: T-NNNN
```

`type`, `scope` and `!` (only when `breaking: true`) come from the ticket. Commit to the current branch.

## 6. Stop

Report the commit hash and any follow-up tickets, then end. The user decides what comes next: `/session-review`, `/clear`, or `/implement` on a follow-up.
