---
name: setup
description: Set up a project for the odhyp workflow (polaris.json, CLAUDE.md block, VERSION, CHANGELOG, commit hook, docs folders). Safe to re-run.
disable-model-invocation: true
---

Run once per project, and again after upgrading the plugin. Every step **updates in place**: re-running keeps existing values, never duplicates a folder, a block or a file, and never touches the project's tickets, specs or diagrams. It installs nothing; the skills are already installed globally.

Templates live in `${CLAUDE_PLUGIN_ROOT}/templates/`: `polaris.json`, `claude-md-block.md`, `commit-msg`.

## 1. Inspect

Look before asking. Note:

- Is this a git repo? If not, ask whether to `git init`; stop if no.
- An existing `polaris.json`. If present, its values are the defaults for this run.
- An existing odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`), and its test and lint commands.
- Whether `docs/` already belongs to something else: a docs site (Hugo `content/`, MkDocs, Docusaurus, Astro Starlight), or files unrelated to specs and tickets.
- The stack (`pyproject.toml`, `package.json`, `go.mod`, `hugo.toml`, …) and likely test and lint commands from its config.

## 2. Ask

Ask in one round, each with a recommended answer from step 1:

1. **Project name.** Default: the folder name.
2. **Test command** and **lint command**. `none` is a valid answer.
3. **Base path** for the odhyp folders. Default `docs/`; recommend another (e.g. `.odhyp/`) when step 1 found `docs/` taken.

## 3. Create

| Target | Action |
|---|---|
| `polaris.json` | From the template, with `name` and the four `paths` under the base path. If it exists, update only the values the user changed and keep every other field. It is the only place paths are written. |
| `<specs>`, `<tickets>`, `<diagrams>`, `<releases>` | Create if missing, each with a `.gitkeep` while empty. Draw no diagrams: they come later, on request or from `/shape`. |
| `VERSION` | Create with `0.1.0` only if missing. |
| `CHANGELOG.md` | Create only if missing: a `# Changelog` heading, one line naming Keep a Changelog and SemVer, and an empty `## [Unreleased]` section. |
| `.githooks/commit-msg` | Copy from the template, replacing any older copy. Make it executable (`chmod +x`, and `git add --chmod=+x` so the bit survives on Windows). |
| git config | Run `git config core.hooksPath .githooks`. |
| `CLAUDE.md` | Fill `claude-md-block.md` (`{{test}}`, `{{lint}}` from step 2). Replace the existing odhyp block between its markers, or append the block if there is none. Leave the rest of the file untouched. |

## 4. Report

List each target from step 3 as created, updated or unchanged, then the next step: `/shape` for planned work, or describe a bug whose cause is unknown for `diagnose`. Leave the changes uncommitted for the user to review.
