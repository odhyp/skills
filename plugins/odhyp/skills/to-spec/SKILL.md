---
name: to-spec
description: Turn the design agreed in this conversation into a spec file (S-NNNN) in the project's specs folder.
disable-model-invocation: true
---

Read the odhyp block in `CLAUDE.md` for the specs and releases folders (No odhyp block: stop and say to run `/odhyp:setup`), then `${CLAUDE_PLUGIN_ROOT}/templates/SPEC-FORMAT.md`: the single source for fields, statuses and sections. Start the file from `${CLAUDE_PLUGIN_ROOT}/templates/spec.md`.

**Glossary:** when the odhyp block has a `Glossary:` line and its file exists, read `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, then the file, and use its terms, never an `_Avoid_` word, in your questions and the spec. When the line or the file is missing, skip the glossary silently.

## 1. Check the input

The input is the design agreed earlier in this conversation (usually via `/shape`). If there is no agreed design, or a section of the format would be guesswork, ask only the questions that fill those gaps; do not re-interview settled decisions.

## 2. Draft

- **ID:** next `S-` ID (see the spec format).
- **File:** `<specs>/NNNN-short-slug.md`, `status: draft`, `tickets: []`.
- **Body:** every section of the format. `## Design` records the decisions as agreed, including the reasons that are not obvious. `## Decisions` starts empty.

Show the full draft (frontmatter and body) in chat. Write nothing to disk yet.

## 3. Confirm

Ask the user to approve the draft or ask for changes. For each revision request, apply it and show the whole spec again. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop.

## 4. Write and commit

On approval:

1. Write the spec to `<specs>/NNNN-short-slug.md` with `status: draft` (written, not yet split into tickets).
2. Stage only that file: `git add` the spec file. Never `git add -A`.
3. Commit only that file, so anything the user already had staged stays out: `git commit -m "docs(spec): add S-NNNN <slug>" -- <spec file>`, with no `Refs:` footer. Never push.

## 5. Report

Give the spec's ID, path and commit hash, and the next step: `/to-tickets S-NNNN`. Then stop: never continue to tickets or implementation.
