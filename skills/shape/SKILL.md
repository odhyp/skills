---
name: shape
description: Grill a feature, small change or trivial bug until we agree on it, then name the next step. Writes nothing.
disable-model-invocation: true
argument-hint: "[what you want to build or change]"
---

Every piece of planned work goes through here, including a one-line fix, so no change skips the thinking. A bug whose cause is unknown does not: send it to `diagnose` instead, since there is nothing to shape until the cause is known.

This skill **writes nothing**: no files, no tickets, no code.

## 1. Grill

Interview relentlessly, **one question at a time**, walking each branch of the design until every decision it depends on is settled.

- With each question, give your recommended answer and why.
- When the codebase can answer a question, read the code instead of asking.
- Cover, as they apply: the problem and who has it, what done looks like, scope edges (what is explicitly out), behaviour in edge and failure cases, data and interfaces touched, how it will be tested, and what it could break.

**Done when** every branch is resolved and the user agrees with a short summary you give: the problem, the decisions, and what is out of scope.

## 2. Size it and name the next step

- **Feature** (new capability, several tickets, or decisions worth recording): next is `/to-spec`, then `/to-tickets`.
- **Small change or trivial bug** (cause known, fits one or two tickets): next is `/to-tickets` straight from this conversation, with `spec: none`.

Say which and why in one line. The agreed conversation is the input to the next skill, so the user runs it now, before any `/clear`.
