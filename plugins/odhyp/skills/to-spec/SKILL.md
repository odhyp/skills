---
name: to-spec
description: Turn the design agreed in this conversation into one or more spec files (S-NNNN) in the project's specs folder.
disable-model-invocation: true
---

Read the odhyp block in `CLAUDE.md` for the specs and releases folders (No odhyp block: stop and say to run `/odhyp:setup`), then `${CLAUDE_PLUGIN_ROOT}/templates/SPEC-FORMAT.md`: the single source for fields, statuses and sections. Start each file from `${CLAUDE_PLUGIN_ROOT}/templates/spec.md`.

**Glossary:** when the odhyp block has a `Glossary:` line and its file exists, read `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, then the file, and use its terms, never an `_Avoid_` word, in your questions and the specs. When the line or the file is missing, skip the glossary silently.

## 1. Check the input

The input is the design agreed earlier in this conversation (usually via `/shape`). If there is no agreed design, or a section of the format would be guesswork, ask only the questions that fill those gaps; do not re-interview settled decisions.

## 2. Draft

Write one spec per separate feature in the agreed design; usually there is one.

- **IDs:** next `S-` ID (see the spec format), then onward in order.
- **File:** `<specs>/NNNN-short-slug.md`, `status: draft`, `tickets: []`.
- **Body:** every section of the format. `## Design` records the decisions as agreed, including the reasons that are not obvious. When the agreed design has a `## Glossary` list, copy it unchanged into `## Design` under a `Glossary:` line; with several specs, each entry goes into the spec whose feature uses the term. `## Decisions` starts empty.

Write each spec to disk, uncommitted. In chat, show only a table (ID, title, path) and, under it, one line per spec for anything it adds beyond the agreed design. The user reads the files themselves.

## 3. Confirm

Ask the user to approve the specs or ask for changes. For each revision request, edit the files and report one line per changed spec saying what changed. When a revision drops or merges specs, delete the files no longer used and renumber the rest of this run's files (file name, `id`, and every mention that names them) so the IDs stay consecutive. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop. If the user rejects or drops the specs, delete the files this run wrote, and nothing else.

## 4. Commit

On approval:

1. Stage only the written specs: `git add` the spec files. Never `git add -A`.
2. Commit only those files, so anything the user already had staged stays out: `git commit -m "docs(spec): add S-NNNN to S-MMMM" -- <files>` (one spec: `docs(spec): add S-NNNN <slug>`), with no `Refs:` footer. Never push.

## 5. Report

List the specs (ID, title, path) and give the commit hash. Next step: `/to-tickets S-NNNN` for each spec. Then stop: never continue to tickets or implementation.
