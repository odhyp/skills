---
id: S-0002
title: Fix findings without tickets
status: accepted
tickets: [T-0009, T-0010, T-0011, T-0012, T-0013, T-0014, T-0015]
---

## Problem

ADR-0001 makes every unit of work, down to a one-line fix, a ticket. In practice this makes the workflow heavy:

- `session-review` gives long output, previews tickets and adds ticket overhead instead of naming what to improve.
- `code-review` writes follow-up tickets by itself, whatever the finding's weight.
- `implement` can only run a ticket, so a small, well-understood fix found in this session needs `to-tickets` first.
- `to-spec` writes the spec without a confirmation loop and never commits it.
- `.gitkeep` files stay after their folder gets real files (`docs/releases/.gitkeep` sits next to `v0.2.0/`).

## Goals / Non-goals

- Goal: each skill answers one question and does not do another skill's job:

  | Skill | Answers |
  |---|---|
  | `setup` | How is this project wired for the workflow? |
  | `shape` | What exactly are we building, and why? |
  | `diagnose` | Why is it broken? |
  | `to-spec` | What did we agree to build? |
  | `to-tickets` | What work should we track? |
  | `implement` | How do we build it? |
  | `code-review` | What is wrong with this code? |
  | `session-review` | What should we improve? |
  | `diagram` | What does the system look like? |
  | `release` | What changed since the last version? |

- Goal: a ticket tracks work; it is not a prerequisite for it. A finding can be fixed directly when the scope is clear and the user authorises it.
- Goal: review output is short, ranked, terminal-readable, with one recommended finding.
- Goal: review-only operations change nothing (no code, no tickets, no ticket state).
- Goal: an approved spec is always written and committed; an unapproved one never is.
- Goal: `.gitkeep` only in otherwise-empty folders.
- Non-goal: commit-on-approval for `to-tickets`.
- Non-goal: any change to `diagnose`.
- Non-goal: any change to the ticket or spec frontmatter (the Polaris contract).
- Non-goal: the version bump and CHANGELOG entry; `/odhyp:release` does those later.

## Design

### ADR-0007 supersedes ADR-0001

New `docs/adr/0007-tickets-track-work.md`, *Tickets track work; they are not a prerequisite for it*:

- Tickets remain the handoff **between contexts**: work that is deferred, large, or meant for a fresh session.
- Work done **in the current session** may go straight to `implement` with no ticket when its scope is clear and the user authorises it.
- Only `implement` writes code; this half of 0001 survives, so the review gate of ADR-0002 covers direct work too.

ADR-0001 is marked superseded by 0007. Reason: 0001 existed because long sessions drift, so context must be written down before a handoff; a finding fixed now, in the session that found it, has no handoff.

### `implement`: ticket mode and direct mode

- **Mode by argument:** starts with `T-` or `@<tickets>/` → ticket mode, unchanged. Anything else (`finding 1`, `1,3`, `all`, free text) → direct mode. No argument keeps today's pick-the-next-ticket behaviour.
- **Direct brief:** restate the selected finding(s) or request as one or two lines of expected outcome before building. Ambiguous, or with architectural impact: ask, or send the user to `/shape`.
- **Build:** test-first in both modes. Changes with no testable behaviour (docs, skill text) skip red/green but still run the full test and lint commands; this is stated once for both modes.
- **Review:** `odhyp:code-review` in both modes; direct mode passes the restated brief (code-review already accepts `<request>`).
- **Records:** direct mode has no ticket to update; diagrams and spec `## Decisions` are still updated when they apply.
- **Commit:** direct mode commits `type(scope): subject` with no `Refs:` footer. Several findings share one commit when they share type and scope, otherwise one commit each. The commit-msg hook does not require `Refs:`, and `release` already reads ticketless commits.
- **After review:** non-blocking findings from code-review are listed after the commit, then `implement` stops; the user picks `/implement N` or `/to-tickets N`. Must-fix findings in ticket mode still go under the ticket's `## Notes` as today.

### `session-review`: ranked findings, writes nothing

- Covers both the work (code problems seen in the session) and the way of working (retries, wrong assumptions, corrections, missing context). Evidence comes from the session; that is the line between it and `code-review`, which judges a diff against a brief.
- Output, terminal-friendly Markdown:

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

- Each finding: number, concise title, a tag for where the fix belongs (`code`, `CLAUDE.md`, `odhyp skill`), and one to two sentences of cause and consequence. Finding 1 is always the highest-priority one and the only ★ RECOMMENDED.
- No ticket previews, no diffs, no implementation plans, no files written. The CLAUDE.md diffs it showed before become findings that `implement` applies.
- Ends by suggesting the ★ fix and the options: `/implement 1`, `/implement 1,3`, `/implement all`, `/to-tickets N`.
- Outside the odhyp repo, an `odhyp skill` finding can only become a ticket (the installed plugin is read-only); on request, it is printed with `id: T-XXXX` for the user to copy into the odhyp repo.
- A smooth session: say so in one line, list nothing.

### `code-review`: severity, no tickets

- Each finding gets a severity:

  | Severity | Action |
  |---|---|
  | Critical | Stop and address immediately |
  | High | Fix before merging |
  | Medium | Fix directly when appropriate, or track as a ticket |
  | Low | Optional; avoid unnecessary work |

- Verdict: any Critical or High → `MUST-FIX` (blocks the commit, as ADR-0002); otherwise `PASS`.
- Findings return in priority order in the same numbered, ★-ranked format as `session-review`, each with a suggested action: `fix now` (small, well understood) or `ticket` (large, independent, or worth deferring).
- It never writes tickets and never changes ticket state, including the after-commit mode (which no longer sets the ticket back to `ready-for-agent`). `implement` is the one place that records state.

### `to-tickets`: accepts findings

Input is a spec, a small agreed change, or findings selected from this conversation. A ticket from a finding sets `source: session-review` or `source: code-review` (already in the enum) and `parent:` the reviewed ticket when there is one. No format change.

### `to-spec`: confirmation loop, then commit

1. Show the full draft spec (frontmatter and body) in chat; write nothing to disk.
2. Each revision request: apply it and show the whole spec again. Only an explicit approval ends the loop; an approval that also asks for a change is a revision and needs another round.
3. On approval: write `<specs>/NNNN-slug.md` with `status: draft`, apply the `.gitkeep` rule, and commit only those paths as `docs(spec): add S-NNNN <slug>`, no `Refs:` footer.
4. Report ID, path and commit hash; next step `/to-tickets S-NNNN`. Never continue to tickets or implementation.

Showing the draft in chat makes "never commit an unconfirmed spec" hold by construction; committing only the spec's paths leaves unrelated dirty files alone.

### `shape`: planned work only

The opening line becomes: planned work (features and changes the user decides to make) starts here; findings from `session-review` or `code-review`, and small explicit requests, may go straight to `/implement`. `implement`'s direct mode sends ambiguous or architectural requests back to `/shape`. `diagnose` is unchanged.

### `.gitkeep` rule

- `templates/claude-md-block.md` gains one line, roughly: *`.gitkeep` only in an otherwise-empty folder: remove it when you add a file there, add it back when you empty a folder that must stay.* It reaches every agent and every file in a project; `setup` re-run installs it. This repo's `CLAUDE.md` block is updated to match.
- `release` step 6 (the only skill that empties folders): remove `<releases>/.gitkeep`, keep a `.gitkeep` in `tickets/` and `specs/` when they end up empty.
- Delete `docs/releases/.gitkeep` in this repo.

### Docs

- README: the skill table above added to the skills section; the `code-review` and `session-review` rows and the workflow diagram's "Follow-ups" edge updated.
- GLOSSARY: **Ticket** — "the only handoff between contexts" becomes "the handoff between contexts"; **Follow-up** — "a ticket written from a review finding, at the user's request".

### Checks

Skill-text changes: `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass, and each skill change is checked against these acceptance points:

- `to-spec` loops until explicit approval and commits only the approved spec.
- `session-review` gives concise, ranked findings with one ★ RECOMMENDED, shows no ticket previews, and creates no tickets without being asked.
- `implement` accepts both tickets and direct requests.
- `code-review` grades by severity and separates fix-now from ticket findings.
- Review-only operations modify nothing.
- `.gitkeep` is removed when its folder gets real files.

## Decisions

- 2026-11-22: `implement` answers "How do we build it?", not "How do we fix it?", since it builds features from tickets as well as fixes. T-0015 also gained the README intro sentence and the direct-mode diagram details; skill names stay unchanged.
