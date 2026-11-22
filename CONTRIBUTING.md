# Contributing

## Feedback

- **Bugs and questions:** [Discussions → Q&A](https://github.com/odhyp/skills/discussions/categories/q-a). The form asks for steps to reproduce.
- **Ideas:** [Discussions → Ideas](https://github.com/odhyp/skills/discussions/categories/ideas). Accepted ideas become ticket files in [`docs/tickets/`](docs/tickets/).
- **Security problems:** report privately, as [`SECURITY.md`](SECURITY.md) describes.

GitHub Issues are disabled because work is tracked as ticket files in the repo.

## Pull requests

Pull requests are open to collaborators only. To propose a change, start a discussion first.

## Working on the repo (collaborators)

1. Activate the commit hook once per clone: `git config core.hooksPath .githooks`.
2. Write commits as [Conventional Commits](https://www.conventionalcommits.org/): `type(scope)!: subject`, with a `Refs: T-NNNN` footer when the work has a ticket.
3. Before pushing, run:
   - `sh tests/commit-msg.test.sh`
   - `claude plugin validate . && claude plugin validate plugins/odhyp`
4. The plugin lives in `plugins/odhyp/`; everything else at the root is dev-only. Vocabulary is in [`GLOSSARY.md`](GLOSSARY.md), and decisions with their reasons are in [`docs/adr/`](docs/adr/).

Releases are cut by the maintainer with `/odhyp:release`.

By contributing you agree to the [Code of Conduct](CODE_OF_CONDUCT.md) and to license your work under the [MIT License](LICENSE).
