---
name: session-review
description: Review this session before /clear and answer "What should we improve?" with a short ranked list of findings. Writes nothing.
disable-model-invocation: true
---

Run before `/clear`: the evidence is this session's history, and `/clear` erases it. This is the line between this skill and `code-review`, which judges a diff against a brief.

## 1. Find the findings

Go through the session and list what should improve, in two kinds:
- **the work:** code problems seen in the session;
- **the way of working:** each moment that cost time or went wrong:
  - retries: a command, edit or approach that had to be repeated;
  - wrong assumptions: about the code, the tools, the paths or the user's intent;
  - corrections: anything the user had to say twice, or overrule;
  - missing context: something the agent had to search for, ask, or guess that a line in a file would have given.

Each finding names where its fix belongs: `code`, `CLAUDE.md`, or `odhyp skill`. Rank them; the first is the highest priority.

## 2. Report

Print the findings in this shape:

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

- Each finding: a concise title, its tag, and one to two sentences of cause and consequence, specific and backed by what happened in this session.
- Only finding 1 is ★ RECOMMENDED.
- No ticket previews, no diffs, no implementation plans. Write no files and apply no edits: fixing is `implement`'s job, tracking is `to-tickets`'.

End by offering: `/implement 1`, `/implement 1,3`, `/implement all`, or `/to-tickets N`. A ticket is only ever the user's explicit choice.

**Outside the odhyp repo** (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root) the installed plugin is read-only, so an `odhyp skill` finding can only become a ticket: offer only `/to-tickets N` for it.

If the session ran smoothly, say so in one line and list nothing.
