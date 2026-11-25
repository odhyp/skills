---
name: survey
description: Draft the missing glossary entries, diagrams and ADRs of an existing codebase from its code, git history and docs, so a project set up with /odhyp:setup starts the workflow with shared terms. Run on an existing codebase that has no glossary, diagrams or ADRs yet, or to fill gaps later; only a person starts it.
disable-model-invocation: true
---

Read the odhyp block in `CLAUDE.md` for the `Glossary:`, `Diagrams:` and `Decisions:` lines. No odhyp block: stop and say to run `/odhyp:setup`. A missing `Diagrams:` or `Decisions:` line: draft no diagrams or no ADRs, and say in the report to re-run `/odhyp:setup` to add it.

A run only adds: it drafts missing terms, diagrams and ADRs and never rewrites an existing entry, diagram or ADR, because those hold decisions a person made.

## 1. Set the scope

The scope is the folders given as arguments (`/odhyp:survey src/api src/core`); with none, the whole repo. When the scope is too large to read well in one pass, change nothing, list its top-level folders, ask which to survey, and stop: a glossary drafted from skimmed code gives every later session wrong words.

## 2. Read

Read, within the scope: the code, the git history (`git log --format="%h %s%n%b" -- <folders>`), the README and the docs. Then read what already exists: the glossary file, the `.mmd` files in the diagrams folder, and the ADRs in the decisions folder.

## 3. Draft

Write every draft to disk, uncommitted.

**Glossary.** Skip silently when the `Glossary:` line is missing. Read `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`; entries follow it, project-specific terms only. Add only terms the file does not have; when the file is missing, create it at that path with a `# Glossary` H1 when the first term arrives. When the code uses two or more names for one thing, the most common becomes the term and the others go under `_Avoid_`; flag that entry in the table for the user to confirm. Before adding to an existing file, run `git status --porcelain -- <glossary file>`: any output means uncommitted changes the commit would sweep in, so add no terms, name the file, and say to commit or stash them and run `/odhyp:survey` again.

**Diagrams.** Run the `diagram` skill (`odhyp:diagram`) for each of its standard views the scope has something to show in and the diagrams folder does not yet have. Never edit an existing diagram.

**ADRs.** Write an ADR only where a commit, PR or code comment states the reason for a decision: an ADR records the why, and one guessed from code invents reasons later sessions will trust. Start each from `${CLAUDE_PLUGIN_ROOT}/templates/adr.md`, numbered from one above the highest `NNNN` in the decisions folder (`0001` when there is none), file `<decisions>/NNNN-<kebab-title>.md`. Skip a decision an existing ADR already records. Every other decision becomes a **candidate**: one line in the report (the decision and where it shows), never a file, because a candidate has no reason and must not sit in the decisions folder looking like a record.

**Drift.** Where the code contradicts an existing glossary entry, diagram or ADR, change nothing there; list it as a finding.

## 4. Report and confirm

In chat show only:

1. A table of this run's files: file, kind (glossary, diagram, ADR), what it adds. One row per glossary term, with flagged synonym entries marked for the user to confirm.
2. **Candidates** for `/odhyp:to-adr`, one line each.
3. **Findings**, numbered, each with `path:line` and what contradicts what, for `/odhyp:implement N`.

With nothing drafted, say so, give the candidates and findings, and stop.

Ask the user to approve the drafts or ask for changes. For each revision request, edit the files and report one line per changed file. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop. A rejection deletes the files this run created and removes the entries it added to an existing glossary, and nothing else.

## 5. Commit

On approval, stage and commit only this run's files, so anything the user already had staged stays out:

```
git add <files>
git commit -m "docs(survey): <subject>" -- <files>
```

No `Refs:` footer. Never `git add -A`. Never push.

Then give the commit hash and repeat the candidates and the numbered findings. Stop.
