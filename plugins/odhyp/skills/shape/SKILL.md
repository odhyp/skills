---
name: shape
description: Help turn a vague idea into a clear need, size it as a feature or small change, grill it in short rounds until we agree on it, draw diagrams if the structure changes, then name the next step.
disable-model-invocation: true
argument-hint: "[an idea, a problem, or a change]"
---

Planned work, the features and changes the user decides to make, starts here, and so does an idea the user cannot yet put into words. Findings from `session-review` or `code-review`, and small explicit requests, may go straight to `/implement`, whose direct mode sends ambiguous or architectural requests back here. A bug whose cause is unknown does not: send it to `diagnose` instead, since there is nothing to shape until the cause is known.

This skill writes no specs, tickets or code. Its only output besides the agreement is diagrams, in step 4.

**Glossary:** read the odhyp block in `CLAUDE.md` only for its `Glossary:` line; a missing block does not stop this skill. With the line present and its file existing, read `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, then the file, and use its terms, never an `_Avoid_` word, in your questions and the summary. When the line or the file is missing, skip the glossary silently.

## 1. Explore

Run this step only when the request is too vague to size: the problem, who has it, or what done looks like is unknown. A clear request skips to step 2.

Ask about the problem before any solution, in rounds of at most 3 questions. Give each question 2–3 lettered options and recommend one. End the step in one of three ways:

- the need is concrete enough to size: go to step 2;
- nothing should be built (the need is already met, or not worth it): say so under `## Next step` and stop. When the reason is worth keeping ("we decided not to do X, because Y"), add a one-line offer of `/odhyp:to-adr` there; never run it yourself. A plain "already exists" gets no offer;
- another skill fits (e.g. a bug of unknown cause goes to `diagnose`): name it under `## Next step` and stop.

## 2. Size it

From the request and a quick look at the code, say in one line whether this is a **feature** (new capability, several tickets, or decisions worth recording) or a **small change** (a small change or trivial bug with a known cause, fitting one or two tickets), and why. The user may override it. Re-size if the grilling shows the work is bigger or smaller than it looked, and print the size line again.

## 3. Grill

Interview relentlessly in **rounds of at most 3 questions**, walking each branch of the design until every decision it depends on is settled.

- Ask only questions that do not depend on each other; a question that hangs on another one still open waits for the next round.
- Number each question, give your recommended answer and why, and word it so "yes" accepts the recommendation.
- When the codebase can answer a question, read the code instead of asking.
- Cover, as they apply:
  - **Feature:** the problem and who has it, what done looks like, scope edges (what is explicitly out), behaviour in edge and failure cases, data and interfaces touched, how it will be tested, and what it could break.
  - **Small change:** what done looks like, what it could break, and how it will be tested. Add an item from the feature list only when the code shows it applies; always add edge and failure cases when the change copies a pattern from elsewhere in the codebase or adds a loop.

**Done when** every branch is resolved and the user agrees with a summary you give.

## 4. Diagrams

If the agreed work adds, removes or rewires services, infrastructure, data flow or module boundaries, use the **diagram** skill to draw or update the diagrams of the agreed design. Show the user what changed and adjust until they agree it matches; skip this step for work that stays inside one module.

## 5. Name the next step

- **Feature:** next is `/to-spec`, then `/to-tickets`.
- **Small change, done now in this session:** next is `/implement this`; the summary's `## Done when` and `## Tested by` are the brief, so write no separate one.
- **Small change for later or a fresh session:** next is `/to-tickets` straight from this conversation, with `spec: none`.

Say which and why in one line, under the summary's `## Next step`. The agreed conversation is the input to the next skill, so the user runs it now, before any `/clear`.

## Output

Print the size line above the first grilling round, again on a re-size, and at the top of the summary once the work is sized:

```markdown
**Size: small change** — <why, in one line>.
```

Print each Explore round in this shape:

```markdown
# Shape — Round N

### 1. <question>

a) <option>
b) <option>

**Recommended:** b. <why>.
```

Print each grilling round in this shape:

```markdown
# Shape — Round N

### 1. <question>

**Recommended:** <answer>. <why>.
```

- Each question gets its own heading; the recommendation goes on its own line below it.
- Lettered options appear in Explore rounds only, and the user answers like `1b, 2a`. In grilling rounds "yes" accepts the recommendation.
- After the questions, add at most two lines on risk or anything not checked.

Print the summary in this shape:

```markdown
# Shape Summary

**Size: feature** — <why>.

## Problem
## Decisions
## Out of scope
## Glossary

## Next step

<one line, from step 5>.
```

- **Feature:** `## Problem`, `## Decisions` (a numbered list) and `## Out of scope`.
- **Small change:** `## Done when`, `## Could break` and `## Tested by` instead, two or three lines in all, plus one line per edge or failure case agreed in grilling, listed under `## Tested by` so the brief keeps them.
- `## Glossary`, for both sizes and **only when the agreed work adds, changes or removes terms**: each new or changed term as an entry in the format of `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, and each removed one as `**Term**: removed`. No term changes: leave the section out. `implement` later writes these into the glossary.
- An Explore that ends without building prints `# Shape Summary` with only `## Next step`.
