---
id: S-0001
title: Fix skill gaps and move project config into the CLAUDE.md block
status: done
tickets: [T-0001, T-0002, T-0003, T-0004, T-0005, T-0006, T-0007, T-0008]
---

## Problem

Reading the ten odhyp skills turned up four gaps:

- `release` updates only the `version_file` plus `package.json`/`pyproject.toml`. This repo also carries the version in `plugins/odhyp/.claude-plugin/plugin.json`, so `/odhyp:release` would cut a broken release here.
- The next-ID rule ("highest ID in the folder and the releases archive, plus one") is written out in `to-spec`, `to-tickets`, `diagnose` and `code-review`.
- `implement` with no argument says nothing about what to do when no ticket is eligible.
- `session-review` always prints its skill-improvement ticket for the user to number, even when it runs in the odhyp repo, where it could write the ticket.

Separately, every project carries a `polaris.json` that odhyp's setup writes and every skill reads. That ties odhyp to Polaris, which is only an optional helper, and Matt Pocock's skills show the alternative: project config lives in a block in `CLAUDE.md`, with no tool-named file.

## Goals / Non-goals

- Goal: odhyp neither writes nor reads `polaris.json`; its config lives in the odhyp CLAUDE.md block.
- Goal: `release` updates every file that carries the version, and shows them all before committing.
- Goal: the ID rule lives once, in the format files.
- Goal: `implement` explains an empty or blocked queue instead of doing nothing silently.
- Goal: `session-review` writes its ticket directly in the odhyp repo.
- Goal: the ticket and spec formats are documented as the public contract, usable by people with their own skills.
- Non-goal: Polaris's code. It gets one `ready-for-human` ticket in this repo, nothing more.
- Non-goal: `AGENTS.md` support.
- Non-goal: a path into `implement` without a ticket (ADR 0001 stands).
- Non-goal: rewriting skills that showed no gap.

## Design

### Config in the CLAUDE.md block

The odhyp block (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`) replaces `polaris.json` and holds:

- the specs, tickets, diagrams and releases folders;
- the version files: the primary one first (default `VERSION`), then any other file that carries the version;
- the changelog (default `CHANGELOG.md`);
- the test and lint commands, as today.

`templates/claude-md-block.md` gains placeholders for these. Every skill that read `polaris.json` reads the block instead. A skill that finds no block stops and says to run `/odhyp:setup`; there is no fallback to `polaris.json`, because two sources of the same paths drift (the reason behind ADR 0005, which a new ADR supersedes).

`setup`:
- drops `polaris.json` from its targets and from its templates (`templates/polaris.json` is deleted);
- no longer asks for a project name, which only `polaris.json` used;
- reads an existing block's values as defaults on re-run, as it does today for test and lint;
- ignores any `polaris.json` in the project: from now on that file belongs to Polaris.

This repo's own `polaris.json` is deleted, and its CLAUDE.md block rewritten with the paths and the version files `VERSION` and `plugins/odhyp/.claude-plugin/plugin.json`. `tests/review-smoke.sh` builds its fixture's block the new way instead of copying `polaris.json`. The README stops listing `polaris.json` as a setup output.

**Why the block:** agents load CLAUDE.md anyway, so the skills read one file fewer, nothing in the project names Polaris, and the version files from the `release` fix have a natural home.

### Polaris owns its own config

Polaris writes its own config when a project is added, and stores it in its app data (for example `%APPDATA%/polaris/`), keyed by repo path, not in the repo. For a project with an odhyp block it reads the paths from the block every time and keeps no copy. For a project without one, it stores the folders the user picks. Each fact then has one owner. This is Polaris's work; this repo records it as one `ready-for-human` ticket, which also covers accepting `source: session-review`.

### Format files are the public contract

`TICKET-FORMAT.md` and `SPEC-FORMAT.md` open with a line saying they are the contract any skills can write to so that Polaris can read their output, and the README gets a short section pointing to them. Their references to `polaris.json` change to the CLAUDE.md block. The format is not frozen: Polaris v2 is unfinished, so changing it now costs nothing beyond this repo.

### release

Step 5 writes the version into every version file the block names, plus `package.json`/`pyproject.toml` when present. Step 4's confirmation lists every file whose version will change, so a missed file shows up before anything is written.

### IDs

Each format file gets an `## IDs` section stating the rule once: the next ID is the highest existing ID of that kind in its folder and the releases archive, plus one, zero-padded, never reused. `to-spec`, `to-tickets`, `diagnose`, `code-review` (and `implement`, `session-review` where they create tickets) say "next `T-` ID (see the format)" instead of repeating it.

### implement with nothing eligible

With no argument and no eligible ticket, `implement` changes nothing and stops:
- no open tickets: says so and points to `/shape`;
- open tickets, all blocked: lists each with its reason, reusing step 1's refusal reasons (`needs-info` and its open questions, `ready-for-human` and what the person must do, unresolved `depends_on`).

### session-review

When `plugins/odhyp/.claude-plugin/plugin.json` exists at the repo root, `session-review` shows the proposed ticket like a CLAUDE.md diff and, once the user approves, writes it into the tickets folder with the next `T-` ID and `status: ready-for-agent`. Elsewhere it prints the ticket with `id: T-XXXX`, as today.

The ticket's `source` is `session-review`, a new value in the `source` enum. **Why:** every other value names the skill that wrote the ticket, and `human` means a person wrote it. The user's approval doesn't change who wrote it.

## Decisions
