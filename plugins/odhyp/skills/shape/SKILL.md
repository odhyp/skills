---
name: shape
description: Size a feature, small change or trivial bug, grill it in short rounds until we agree on it, draw diagrams if the structure changes, then name the next step.
disable-model-invocation: true
argument-hint: "[what you want to build or change]"
---

Planned work, the features and changes the user decides to make, starts here. Findings from `session-review` or `code-review`, and small explicit requests, may go straight to `/implement`, whose direct mode sends ambiguous or architectural requests back here. A bug whose cause is unknown does not: send it to `diagnose` instead, since there is nothing to shape until the cause is known.

This skill writes no specs, tickets or code. Its only output besides the agreement is diagrams, in step 3.

## 1. Size it

From the request and a quick look at the code, say in one line whether this is a **feature** (new capability, several tickets, or decisions worth recording) or a **small change** (a small change or trivial bug with a known cause, fitting one or two tickets), and why. The user may override it. Re-size if the grilling shows the work is bigger or smaller than it looked.

## 2. Grill

Interview relentlessly in **rounds of at most 3 questions**, walking each branch of the design until every decision it depends on is settled.

- Ask only questions that do not depend on each other; a question that hangs on another one still open waits for the next round.
- Number each question, give your recommended answer and why, and word it so "yes" accepts the recommendation.
- When the codebase can answer a question, read the code instead of asking.
- Cover, as they apply:
  - **Feature:** the problem and who has it, what done looks like, scope edges (what is explicitly out), behaviour in edge and failure cases, data and interfaces touched, how it will be tested, and what it could break.
  - **Small change:** what done looks like, what it could break, and how it will be tested. Add an item from the feature list only when the code shows it applies.

**Done when** every branch is resolved and the user agrees with a summary you give. Feature: the problem, the decisions, and what is out of scope. Small change: two or three lines on what done looks like, what it could break, and how it will be tested.

## 3. Diagrams

If the agreed work adds, removes or rewires services, infrastructure, data flow or module boundaries, use the **diagram** skill to draw or update the diagrams of the agreed design. Show the user what changed and adjust until they agree it matches; skip this step for work that stays inside one module.

## 4. Name the next step

- **Feature:** next is `/to-spec`, then `/to-tickets`.
- **Small change, done now in this session:** next is `/implement <brief>`, with the brief written out from the agreed summary.
- **Small change for later or a fresh session:** next is `/to-tickets` straight from this conversation, with `spec: none`.

Say which and why in one line. The agreed conversation is the input to the next skill, so the user runs it now, before any `/clear`.
