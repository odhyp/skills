---
name: setup
description: Set up a project for the odhyp workflow (CLAUDE.md block with the paths, VERSION, CHANGELOG, commit hook). Safe to re-run.
disable-model-invocation: true
---

Run once per project, and again after upgrading the plugin. Every step **updates in place**: re-running keeps existing values, never duplicates a folder, a block or a file, and never touches the project's tickets, specs or diagrams, except deleting `.gitkeep` files there and an import the user accepts in step 2. It installs nothing; the skills are already installed globally.

Templates live in `${CLAUDE_PLUGIN_ROOT}/templates/`: `claude-md-block.md`, `commit-msg`.

## 1. Inspect

Look before asking. Note:

- Is this a git repo? If not, ask whether to `git init`; stop if no.
- An existing odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`). If present, its paths, version files, changelog, test and lint commands are the defaults for this run.
- Whether `docs/` already belongs to something else: a docs site (Hugo `content/`, MkDocs, Docusaurus, Astro Starlight), or files unrelated to specs and tickets.
- The stack (`pyproject.toml`, `package.json`, `go.mod`, `hugo.toml`, …) and likely test and lint commands from its config.
- An existing version, when there is no block: a `VERSION` file, `__version__` in the package source, `version` in `pyproject.toml` or `package.json`, or the latest tag (`git describe --tags --abbrev=0`).
- A glossary file: the first of `GLOSSARY.md`, `CONTEXT.md`, `docs/glossary.md` that exists.
- An existing tracker outside the odhyp folders (e.g. `.scratch/`, `issues/`, `todo/`): Markdown files that read as issues, tasks, plans or PRDs.

## 2. Ask

Ask in one round, each with a recommended answer from step 1:

1. **Test command** and **lint command**. `none` is a valid answer.
2. **Base path** for the odhyp folders (`specs`, `tickets`, `diagrams`, `releases`, and `adr` for decisions). Default `docs/`; recommend another (e.g. `.odhyp/`) when step 1 found `docs/` taken. When a block exists, the default is instead to keep its folders as they are. The tickets, specs, releases and decisions folders must be tracked by git, because `/implement` commits ticket files, `/release` commits the archive and `/to-adr` commits ADRs: run `git check-ignore -v <folder>/x.md` for each, and when one is ignored (by `.gitignore` or `.git/info/exclude`), name the matching rule and recommend a path outside it.
3. **Import** (only when step 1 found a tracker): offer to import it, naming the folder and the file count. Recommend yes.

## 3. Create

| Target | Action |
|---|---|
| `<specs>`, `<tickets>`, `<diagrams>`, `<releases>`, `<decisions>` | Create no folders: these paths are only written into the `CLAUDE.md` block, and a skill creates its folder when it first writes a file there. Delete any `.gitkeep` in these five folders (`git rm` if tracked). Draw no diagrams: they come later, on request or from `/shape`. |
| Version files | Use every file step 1 found holding the version (`pyproject.toml`, `package.json`, the file with `__version__`, …) and create nothing; the primary is the first of `pyproject.toml`, `package.json`, the `__version__` file, `VERSION` that holds a literal version (a `dynamic` or placeholder version does not count). Only with no version file: create `VERSION` with the latest tag's version (without a leading `v`), or `0.1.0` when there is no tag. |
| Import (if accepted) | Skip the import, and say why in the report, while `git check-ignore` still matches any target folder. Rewrite each tracker file in the ticket or spec format (`${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`, `SPEC-FORMAT.md`): PRDs and plans become `S-NNNN` specs, issues and tasks become `T-NNNN` tickets, numbered from the next free ID in their old order, keeping the body; old metadata with no frontmatter field (labels, priority, assignee, dates) goes into a `## Imported` section at the end of the body as `key: value` lines. Tickets get `source: human`. Done and dropped items go to `<releases>/v<version>/tickets/` and `specs/` (tickets `resolved`/`wontfix` with `released_in: v<version>`, specs `done`), and that folder gets a `RELEASE.md` (unless it has one) saying these items were imported by setup on that date from the old tracker, not shipped in a release; open ones go to `<tickets>` and `<specs>` (tickets `needs-info` with the gaps under `## Questions` unless they already meet the ticket format, then `ready-for-agent`; specs `draft`). Rewrite every cross-reference (old filenames, numbers, links) to the new IDs, including `depends_on`, `spec:` and `tickets:`. Then remove every imported original (`git rm` when tracked, a plain delete otherwise), so a re-run finds no tracker to import again. Show the old-to-new ID map in the report. |
| Changelog (default `CHANGELOG.md`) | Create only if missing: a `# Changelog` heading, one line naming Keep a Changelog and SemVer, and an empty `## [Unreleased]` section. |
| `.githooks/commit-msg` | Copy from the template, replacing any older copy. Make it executable (`chmod +x`, and `git add --chmod=+x` so the bit survives on Windows). |
| git config | Run `git config core.hooksPath .githooks`. |
| `CLAUDE.md` | Fill `claude-md-block.md`: `{{test}}`, `{{lint}}` from step 2; `{{specs}}`, `{{tickets}}`, `{{diagrams}}`, `{{releases}}` from the existing block, or as those folders under the base path when there is no block or the user changed the base path; `{{decisions}}` from the existing block's `Decisions:` line, or as `<base path>/adr` (default `docs/adr`) when the block has no such line or the user changed the base path; `{{glossary}}` without asking, from the existing block's `Glossary:` line, else the glossary file found in step 1, else `GLOSSARY.md` (create no glossary file: an empty one is noise, and a skill creates it when the first term arrives); `{{version_files}}` and `{{changelog}}` from the existing block, else the version files above and `CHANGELOG.md`. Render `{{version_files}}` with each file in its own backticks, comma-separated, primary first: `` `VERSION`, `package.json` ``. It is the only place paths are written. Replace the existing odhyp block between its markers, or append the block if there is none. Leave the rest of the file untouched. |

## 4. Report

List each target from step 3 as created, updated or unchanged, and each `.gitkeep` deleted, any odhyp folder git still ignores, the import's ID map, and the glossary path (say the user can change it in the block), then the next step: `/shape` for planned work, or describe a bug whose cause is unknown for `diagnose`. Leave the changes uncommitted for the user to review.
