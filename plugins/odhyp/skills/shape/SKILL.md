---
name: shape
description: Grill a feature, small change or trivial bug until we agree on it, draw diagrams if the structure changes, then name the next step.
disable-model-invocation: true
argument-hint: "[what you want to build or change]"
---

Planned work, the features and changes the user decides to make, starts here. Findings from `session-review` or `code-review`, and small explicit requests, may go straight to `/implement`, whose direct mode sends ambiguous or architectural requests back here. A bug whose cause is unknown does not: send it to `diagnose` instead, since there is nothing to shape until the cause is known.

This skill writes no specs, tickets or code. Its only output besides the agreement is diagrams, in step 2.

## 1. Grill

Interview relentlessly, **one question at a time**, walking each branch of the design until every decision it depends on is settled.

- With each question, give your recommended answer and why.
- When the codebase can answer a question, read the code instead of asking.
- Cover, as they apply: the problem and who has it, what done looks like, scope edges (what is explicitly out), behaviour in edge and failure cases, data and interfaces touched, how it will be tested, and what it could break.

**Done when** every branch is resolved and the user agrees with a short summary you give: the problem, the decisions, and what is out of scope.

## 2. Diagrams

If the agreed work adds, removes or rewires services, infrastructure, data flow or module boundaries, use the **diagram** skill to draw or update the diagrams of the agreed design. Show the user what changed and adjust until they agree it matches; skip this step for work that stays inside one module.

## 3. Size it and name the next step

- **Feature** (new capability, several tickets, or decisions worth recording): next is `/to-spec`, then `/to-tickets`.
- **Small change or trivial bug** (cause known, fits one or two tickets): next is `/to-tickets` straight from this conversation, with `spec: none`.

Say which and why in one line. The agreed conversation is the input to the next skill, so the user runs it now, before any `/clear`.
