# Survey is separate from setup and writes ADRs only from stated reasons

Drafting the glossary, diagrams and ADRs of an existing codebase is its own manual skill, `survey`, not a step of `setup`. `setup` stays quick, idempotent and the same for every project; `survey` reads the code, git history and docs, so it is slow, costs tokens, and may be re-run later as the code grows. A run only adds: it drafts missing terms, diagrams and ADRs and never rewrites existing ones, because those hold decisions a person made; where the code contradicts them, it reports a finding instead. It writes an ADR only where a commit, PR or code comment states the reason. An ADR records the why, and one guessed from code invents reasons later sessions will trust. Every other decision it finds goes in the chat report as a one-line candidate for `/odhyp:to-adr`, never as a file, because a candidate has no reason and must not sit in the decisions folder looking like a record.

## Considered options

- Survey as a step of `setup`: rejected. It would make `setup` slow, costly and different per project, and re-running `setup` would re-survey.
- A candidates file in the decisions folder: rejected. An unreasoned candidate there reads as a record.

## Consequences

- A skill that drafts ADRs from existing code writes one only when the reason is stated in a commit, PR or code comment.
- Re-running `survey` never changes an existing glossary entry, diagram or ADR; drift goes to findings for `/implement N`.
