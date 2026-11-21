---
name: to-spec
description: Turn the design agreed in this conversation into a spec file (S-NNNN) in the project's specs folder.
disable-model-invocation: true
---

Read the odhyp block in `CLAUDE.md` for the specs folder and the path of `SPEC-FORMAT.md`, then read the format. It is the single source for fields, statuses and sections.

## 1. Check the input

The input is the design agreed earlier in this conversation (usually via `/shape`). If there is no agreed design, or a section of the format would be guesswork, ask only the questions that fill those gaps; do not re-interview settled decisions.

## 2. Write

- **ID:** the highest existing `S-` ID in the specs folder and the releases archive, plus one. Start at `S-0001`.
- **File:** `<specs>/NNNN-short-slug.md`, `status: draft`, `tickets: []`.
- **Body:** every section of the format. `## Design` records the decisions as agreed, including the reasons that are not obvious. `## Diagrams affected` names each diagram file and what changes in it, or stays empty. `## Decisions` starts empty.

## 3. Report

Give the spec's ID and path, and the next step: `/to-tickets S-NNNN`.
