---
id: T-0010
title: session-review returns ranked findings and writes nothing
type: feat
breaking: false
scope: session-review
status: ready-for-agent
spec: S-0002
depends_on: [T-0009]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`plugins/odhyp/skills/session-review/SKILL.md` today lists workflow friction, shows CLAUDE.md edits as diffs and applies the approved ones, and proposes a ticket for the odhyp skills (writing it in the odhyp repo, printing it elsewhere). The output is long and every improvement turns into ticket overhead. `session-review` should answer one question, *What should we improve?*, with a short ranked list, and leave fixing to `implement` and tracking to `to-tickets`. `to-tickets` must therefore accept findings as input.

## Decisions that apply
- Covers both the work (code problems seen in the session) and the way of working (retries, wrong assumptions, corrections, missing context; keep today's four friction kinds). Evidence comes from this session's history; that is the line between it and `code-review`, which judges a diff against a brief. Still run before `/clear`.
- Output is terminal-friendly Markdown in this shape:

  ```markdown
  # Session Review

  ## Findings

  1. ★ RECOMMENDED — <title>  `code`

     <cause>. <consequence>.

  2. <title>  `CLAUDE.md`

     <cause>. <consequence>.

  ## Recommendation

  Fix **Finding #1 — <title>** first. <one line on why>.
  ```

- Each finding: number, concise title, a tag for where the fix belongs (`code`, `CLAUDE.md`, `odhyp skill`), and one to two sentences of cause and consequence, specific and backed by session evidence. Finding 1 is always the highest-priority one and the only ★ RECOMMENDED.
- No ticket previews, no diffs, no implementation plans, no files written, no edits applied. The CLAUDE.md diffs it used to show become findings that `implement` applies.
- It ends by suggesting the ★ fix and offering: `/implement 1`, `/implement 1,3`, `/implement all`, or `/to-tickets N`. Ticket creation is only ever the user's explicit choice.
- Outside the odhyp repo (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root), an `odhyp skill` finding can only become a ticket, since the installed plugin is read-only; offer only `/to-tickets N` for it, and `to-tickets` then prints that ticket with `id: T-XXXX` for the user to copy into the odhyp repo instead of writing it.
- A smooth session: say so in one line, list nothing.
- `to-tickets`' **Input** line gains a third input: findings selected from this conversation (from `session-review` or `code-review`). A ticket written from a finding sets `source: session-review` or `source: code-review` (already in the format's enum) and `parent:` the reviewed ticket when there is one, else `none`; `spec: none`. No ticket-format change.

## Files
- plugins/odhyp/skills/session-review/SKILL.md (change)
- plugins/odhyp/skills/to-tickets/SKILL.md (change)

## Acceptance criteria
- [ ] `session-review/SKILL.md` produces the format above: numbered, tagged, finding 1 marked ★ RECOMMENDED, a `## Recommendation` line.
- [ ] It writes no files, applies no edits, shows no diffs or ticket previews.
- [ ] It ends by offering `/implement` (one, several, all) and `/to-tickets N`.
- [ ] The outside-the-odhyp-repo rule for `odhyp skill` findings is stated.
- [ ] A smooth session gets a one-line answer.
- [ ] `to-tickets/SKILL.md` accepts findings from the conversation and sets `source` and `parent` as above; outside the odhyp repo, an `odhyp skill` finding is printed with `id: T-XXXX`, not written.
- [ ] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- `implement` accepting `1,3` / `all` / free text (T-0011).
- `code-review` output (T-0012).
- README (T-0015).

## Questions

## Notes
