---
name: setup
description: Set up a project for the odhyp workflow (CLAUDE.md block with the paths, VERSION, CHANGELOG, commit hook). Safe to re-run.
disable-model-invocation: true
---

Run once per project, and again after upgrading the plugin. Every step **updates in place**: re-running keeps existing values, never duplicates a folder, a block or a file, and never touches the project's tickets, specs or diagrams, except deleting `.gitkeep` files there. It installs nothing; the skills are already installed globally.

Templates live in `${CLAUDE_PLUGIN_ROOT}/templates/`: `claude-md-block.md`, `commit-msg`.

## 1. Inspect

Look before asking. Note:

- Is this a git repo? If not, ask whether to `git init`; stop if no.
- An existing odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`). If present, its paths, version files, changelog, test and lint commands are the defaults for this run.
- Ignore any Polaris config file in the project and never delete it; it belongs to Polaris, not odhyp.
- Whether `docs/` already belongs to something else: a docs site (Hugo `content/`, MkDocs, Docusaurus, Astro Starlight), or files unrelated to specs and tickets.
- The stack (`pyproject.toml`, `package.json`, `go.mod`, `hugo.toml`, …) and likely test and lint commands from its config.

## 2. Ask

Ask in one round, each with a recommended answer from step 1:

1. **Test command** and **lint command**. `none` is a valid answer.
2. **Base path** for the odhyp folders. Default `docs/`; recommend another (e.g. `.odhyp/`) when step 1 found `docs/` taken. When a block exists, the default is instead to keep its four folders as they are.

## 3. Create

| Target | Action |
|---|---|
| `<specs>`, `<tickets>`, `<diagrams>`, `<releases>` | Create no folders: these paths are only written into the `CLAUDE.md` block, and a skill creates its folder when it first writes a file there. Delete any `.gitkeep` in these four folders (`git rm` if tracked). Draw no diagrams: they come later, on request or from `/shape`. |
| Primary version file (default `VERSION`) | Create with `0.1.0` only if missing. |
| Changelog (default `CHANGELOG.md`) | Create only if missing: a `# Changelog` heading, one line naming Keep a Changelog and SemVer, and an empty `## [Unreleased]` section. |
| `.githooks/commit-msg` | Copy from the template, replacing any older copy. Make it executable (`chmod +x`, and `git add --chmod=+x` so the bit survives on Windows). |
| git config | Run `git config core.hooksPath .githooks`. |
| `CLAUDE.md` | Fill `claude-md-block.md`: `{{test}}`, `{{lint}}` from step 2; `{{specs}}`, `{{tickets}}`, `{{diagrams}}`, `{{releases}}` from the existing block, or as those folders under the base path when there is no block or the user changed the base path; `{{version_files}}` and `{{changelog}}` from the existing block, else `VERSION` and `CHANGELOG.md`. Render `{{version_files}}` with each file in its own backticks, comma-separated, primary first: `` `VERSION`, `package.json` ``. It is the only place paths are written. Replace the existing odhyp block between its markers, or append the block if there is none. Leave the rest of the file untouched. |

## 4. Report

List each target from step 3 as created, updated or unchanged, and each `.gitkeep` deleted, then the next step: `/shape` for planned work, or describe a bug whose cause is unknown for `diagnose`. Leave the changes uncommitted for the user to review.
