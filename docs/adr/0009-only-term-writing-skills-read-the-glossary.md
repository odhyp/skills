# Only the term-writing skills read the glossary, and it is optional

`shape`, `to-spec` and `to-tickets` read the glossary at the path on the `Glossary:` line of the odhyp block. They use its terms and never an `_Avoid_` word in what they write. `implement` and `code-review` do not read it. Those three skills are the ones that coin terms and write them into questions, specs and tickets. `implement` and `code-review` work from tickets that already use the terms, so reading the glossary there would only cost context. When the `Glossary:` line or the file is missing, every reader skips the glossary silently, so projects set up before the glossary existed keep working without re-running `setup`. For the same reason the glossary never stops `shape`: it reads the odhyp block only for this line and runs without a block.

## Considered options

- `code-review` flags `_Avoid_` words: rejected as noisy. A glossary edit already shows up in the diff like any other file.
- A warning or a prompt to re-run `setup` when the glossary is missing: rejected. An absent glossary is a valid state, not an error.

## Consequences

- A new skill that writes terms into specs or tickets reads the glossary the same way: optional, and skipped silently.
- A skill that only consumes tickets does not read it.
