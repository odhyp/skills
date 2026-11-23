---
name: implement
description: Build one ticket, or a direct request such as a review finding or a small refactor, test-first; get it reviewed and commit it. The only odhyp skill that writes code.
disable-model-invocation: true
argument-hint: "@<tickets>/NNNN-slug.md | T-NNNN | finding 1 | 1,3 | all | <request>"
---

Read the odhyp block in `CLAUDE.md` for the paths and the test and lint commands (No odhyp block: stop and say to run `/odhyp:setup`), and `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`.

**Mode** comes from `$ARGUMENTS`:
- starts with `T-` or `@<tickets>/`, or is empty: **ticket mode**;
- anything else (`finding 1`, `1`, `1,3`, `all`, free text): **direct mode**, for small, well-understood work found in this session.

Each step below says what differs in direct mode.

## 1. Pick the work

### Ticket mode

The ticket is `$ARGUMENTS`. With no argument, pick the next eligible one: an `in-progress` ticket first, otherwise the lowest-numbered `ready-for-agent` ticket whose `depends_on` are all `resolved`. State its ID and title.

- `needs-info` with every item under `## Questions` answered: set `status: ready-for-agent` and continue.
- `in-progress`: resume. Check `git status` and `## Notes`; must-fix findings from an earlier review are listed there, and fixing them comes first.
- Otherwise set `status: in-progress`.

Refuse and stop when:
- it is `resolved` or `wontfix`: say so;
- it is `needs-info` with unanswered questions: show them;
- it is `ready-for-human`: say what the person has to do;
- any `depends_on` ticket is not `resolved`: list them.

With no argument and no eligible ticket, change nothing and stop:
- no open tickets (every ticket is `resolved` or `wontfix`): say so and point to `/shape` for new work;
- otherwise: list each open ticket with the refusal reason above that blocks it.

### Direct mode

Restate the selected finding(s) from this session, or the request, as one or two lines of expected outcome: the **brief**. State it before building. Keep the scope to what was asked.

Ask instead of building when the request is ambiguous; when it has significant architectural implications, send the user to `/shape`.

## 2. Build, test-first

In ticket mode, the ticket is the whole brief: build exactly its acceptance criteria, inside its `## Decisions that apply` and `## Out of scope`. Read the spec only as background. In direct mode, build exactly the brief.

For each acceptance criterion (direct mode: each expected outcome): write the test, run it and watch it go **red**, write the code that turns it **green**, refactor. A `fix` ticket starts with its `## Failing test to write first`. Changes with no testable behaviour (docs, skill text) skip red/green.

Then run the full test and lint commands, in both modes. **Done when** both are clean.

**Never guess.** When the ticket turns out to be:
- **unclear**: set `status: needs-info`, write the questions under `## Questions`, and stop;
- **too big** for one session: narrow this ticket to a first slice that fits, write the rest as new self-contained tickets (`parent:` this ticket, `source: implement`, depending on it), note the split in `## Notes`, set this ticket back to `ready-for-agent`, and stop.

In direct mode: unclear → ask the user and stop; too big → stop and suggest `/to-tickets`. Direct mode never creates a ticket unless the user asks.

## 3. Keep the records true

- If `diagrams` is not empty, update those diagrams using the **diagram** skill.
- If the work proved the spec wrong, add an entry under the spec's `## Decisions`: `date · T-NNNN · what changed and why`.
- Check off the acceptance criteria and append to `## Notes` what was done and anything a later reader needs.

In direct mode there is no ticket to update; still update any diagram the work makes wrong, and add an entry under the `## Decisions` of any spec the work proves wrong: `date · what changed and why` (put `T-NNNN ·` after the date only when the findings came from a review of that ticket).

## 4. Review

Run the odhyp **code-review** skill (`odhyp:code-review`) with the ticket ID as its argument (direct mode: the brief). It reviews the uncommitted diff in a fresh context and returns a verdict and ranked findings; it changes nothing.

- **MUST-FIX:** commit nothing. Add the Critical and High findings under `## Notes` as `Must-fix (review):` with each `path:line` and required change, keep `status: in-progress`, and stop. Tell the user the findings and that the next step is `/implement` on this ticket again. In direct mode: commit nothing, report the findings, and stop.
- **PASS:** continue to step 5 and commit the diff as reviewed. Change nothing for Medium or Low findings, even ones marked `fix now`; step 6 hands them to the user.

## 5. Commit

Set `status: resolved`. Stage the code, the tests, the ticket file and any diagram or spec files, and commit them together:

```
type(scope)!: subject

Refs: T-NNNN
```

`type`, `scope` and `!` (only when `breaking: true`) come from the ticket. Commit to the current branch.

In direct mode there is no ticket status to set; stage the code, the tests and any diagram or spec files. Pick `type` and `scope` from the change and commit `type(scope): subject` with no `Refs:` footer, unless the findings came from a review of ticket T-NNNN: then add `Refs: T-NNNN`. Findings that share type and scope share one commit; otherwise one commit each.

## 6. Stop

Report the commit hash(es), then list the review's non-blocking findings as it returned them, and end. The user decides what comes next: `/implement N` or `/to-tickets N` on a finding, `/session-review`, or `/clear`.
