---
name: setup-odhyp-skills
description: Set up a repo for the odhyp workflow (folders, ticket and spec formats, CLAUDE.md block, VERSION, CHANGELOG, commit hook). Safe to re-run.
disable-model-invocation: true
---

Run once per repo, and again after upgrading the plugin. Every step **updates in place**: re-running never duplicates a folder, a block or a file, and never overwrites the project's own VERSION, CHANGELOG, tickets or specs.

Bundled files live in `${CLAUDE_SKILL_DIR}/templates/`: `TICKET-FORMAT.md`, `SPEC-FORMAT.md`, `commit-msg`, `CLAUDE-BLOCK.md`.

## 1. Inspect

Look before asking. Note:

- Is this a git repo? If not, ask whether to `git init`; stop if no.
- An existing odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`). If present, its paths and commands are the defaults for this run.
- Whether `docs/` already belongs to something else: a docs site (Hugo `content/`, MkDocs, Docusaurus, Astro Starlight), or files unrelated to specs and tickets.
- The stack (`pyproject.toml`, `package.json`, `go.mod`, `hugo.toml`, …) and likely test and lint commands from its config.
- Whether the repo is empty (no commits and no files besides git metadata) or holds existing code.

## 2. Ask

Ask in one round, each with a recommended answer from step 1:

1. **Test command** and **lint command**. `none` is a valid answer.
2. **Base path** for the odhyp folders. Default `docs/`; recommend another (e.g. `.odhyp/`) when step 1 found `docs/` taken.
3. **Only for an empty repo:** start from a starter (Astro, Hugo Tailwind, Python)? If yes, ask for the starter's repo URL, copy it in without its `.git`, and commit it as `chore: start from <starter>` before continuing.

## 3. Create

With `<base>` from step 2:

| Target | Action |
|---|---|
| `<base>/specs/`, `<base>/tickets/`, `<base>/diagrams/`, `<base>/releases/` | Create if missing, each with a `.gitkeep` while empty. |
| `<base>/TICKET-FORMAT.md`, `<base>/SPEC-FORMAT.md` | Copy from templates, replacing any older copy: the plugin owns these. |
| `VERSION` | Create with `0.1.0` only if missing. |
| `CHANGELOG.md` | Create only if missing: a `# Changelog` heading, one line naming Keep a Changelog and SemVer, and an empty `## [Unreleased]` section. |
| `.githooks/commit-msg` | Copy from templates, replacing any older copy. Make it executable (`chmod +x`, and `git add --chmod=+x` so the bit survives on Windows). |
| git config | Run `git config core.hooksPath .githooks`. |
| `CLAUDE.md` | Fill `CLAUDE-BLOCK.md` (`{{docs}}` = `<base>`, `{{specs}}` = `<base>/specs/`, and so on; `{{test}}`, `{{lint}}` from step 2). Replace the existing odhyp block between its markers, or append the block if there is none. Leave the rest of the file untouched. |

## 4. Diagrams

Only for a repo with existing code and an empty `<base>/diagrams/`: use the **diagram** skill to draw the initial diagrams of the code as it is now.

## 5. Report

List each target from step 3 as created, updated or unchanged, then the next step: `/shape` for planned work, or describe a bug for `diagnose`. Leave the changes uncommitted for the user to review.
