# odhyp skills

My engineering workflow as Claude Code skills, installed once and used in every project.

**Tickets are the handoff between fresh contexts.** Planning and diagnosing write tickets; review findings go straight to `/implement` or become tickets, your choice. Only `implement` writes code. Run `/clear` between tickets.

## Install

Globally, as a Claude Code plugin (commands appear as `/odhyp:<skill>`):

```
/plugin marketplace add odhyp/skills
/plugin install odhyp@odhyp
```

Then run `/odhyp:setup` once in each project that uses the workflow. The skills read their templates from the plugin, so plugin install is the only supported method ([ADR 0003](docs/adr/0003-shared-templates-plugin-only.md)).

## Workflow

How the skills hand off, from `/setup` to `/release`: [`docs/diagrams/workflow.mmd`](docs/diagrams/workflow.mmd). Which skill reads or writes which file: [`docs/diagrams/data-flow.mmd`](docs/diagrams/data-flow.mmd).

## Skills

| Skill            | Invocation | Does                                                                                                                                                                                                                                                        |
| ---------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `setup`          | Manual     | Wires a project for the workflow. Run once per project. Writes the CLAUDE.md block (paths, version files, changelog, commands), VERSION, CHANGELOG, and the commit hook. Safe to re-run.                                                                    |
| `shape`          | Manual     | Settles what we are building and why. Entry point for features, small changes and known-cause bugs. Sizes the work, grills you in short rounds until you agree, draws diagrams if the structure changes, then names the next step.                          |
| `to-spec`        | Manual     | Records what we agreed to build: turns the agreed design into a spec (`S-NNNN`), confirms it with you in a loop, then commits it.                                                                                                                           |
| `to-tickets`     | Manual     | Splits a spec, review findings, or an agreed small change into self-contained tickets (`T-NNNN`).                                                                                                                                                           |
| `diagnose`       | Auto       | Finds why it is broken. When you report a bug whose cause is unknown: reproduces it, finds the root cause, writes a `fix` ticket. Does not fix.                                                                                                             |
| `diagram`        | Auto       | Shows what the system looks like. Creates or updates the `.mmd` diagrams: on request, from `shape`, or when a change makes an existing diagram wrong.                                                                                                       |
| `implement`      | Manual     | `/odhyp:implement @<ticket>` or `/odhyp:implement N`: builds one ticket or a direct request (a review finding, a small change) test-first, runs `code-review`, then commits on a pass or stops with the must-fix findings. The only skill that writes code. |
| `code-review`    | Auto       | Answers what is wrong with this code. Reviews the uncommitted diff against the ticket in a forked subagent, before the commit, and grades findings by severity. Writes no tickets. Also reviews a ticket's commits on request.                              |
| `release`        | Manual     | Computes the SemVer bump from what changed since the last version, updates the version and CHANGELOG, archives tickets and specs, then commits and tags after you confirm.                                                                                  |
| `session-review` | Manual     | Answers what we should improve. Run before `/clear`: reviews the session and lists ranked findings. Writes nothing.                                                                                                                                         |

## Development

- `sh tests/commit-msg.test.sh` checks the commit hook template.
- `claude plugin validate .` checks the marketplace; `claude plugin validate plugins/odhyp` checks the plugin and its skills.
- Decisions and their reasons: [`docs/adr/`](docs/adr/). Vocabulary: [`GLOSSARY.md`](GLOSSARY.md).
- Layout: the plugin lives in `plugins/odhyp/` (skills, templates with the ticket and spec formats, `plugin.json`); the root holds the marketplace and this repo's own dev files, which installs never receive.
- Releases bump `version` in `VERSION` and `plugins/odhyp/.claude-plugin/plugin.json` together; clients only update when it increases. The marketplace entry carries no version, since `plugin.json` wins.
- `sh tests/review-smoke.sh` runs the plugin headless in a throwaway repo and checks that `code-review` forks and catches a planted bug. It calls the API (about $0.35), so it runs by hand, not in CI.
- CI (`.github/workflows/ci.yml`) runs the hook test and both validations on every push and pull request, except ones that only touch docs (`README.md`, `docs/**` and the other paths listed in the workflow).

## Feedback

- Bugs, questions and ideas: [Discussions](https://github.com/odhyp/skills/discussions). Bug reports go in Q&A, which has a form.
- This repo doesn't use GitHub Issues. Work is tracked as ticket files in [`docs/tickets/`](docs/tickets/), and good ideas from Discussions become tickets there.
- Pull requests are open to collaborators only. To propose a change, start a discussion.
- Security problems: report them privately, as [`SECURITY.md`](SECURITY.md) describes, not in Discussions.
- More in [`CONTRIBUTING.md`](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE)
