# v0.3.0

Released 2026-11-23.

Review findings and small requests can be fixed without a ticket: `implement` gains a direct mode, and `session-review` and `code-review` return graded findings instead of writing tickets.
Also adds a confirmation loop to `to-spec`, drops `.gitkeep` from `setup`, and gives each skill's question in the README.

## Tickets

### feat
- T-0010 session-review returns ranked findings and writes nothing
- T-0011 implement direct mode
- T-0012 code-review grades by severity and writes no tickets
- T-0013 to-spec confirmation loop, then commit

### fix
- T-0014 Drop .gitkeep and state the next-ID rule

### docs
- T-0009 ADR-0007: tickets track work, not a prerequisite for it
- T-0015 README: one question per skill
- T-0016 implement direct mode wording in records and commit steps

## Specs
- S-0002 Fix findings without tickets
