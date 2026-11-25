# implement applies fix-now findings once, then reviews again

Amends ADR-0002.

When `code-review` passes with Medium or Low findings marked `fix now`, `implement` applies them, gets the test and lint commands clean, and runs `code-review` once more on the new diff. That second verdict decides as before: a pass is committed and its findings go to the user, and a must-fix commits nothing. A second pass never starts a third round. Handing every `fix now` finding back to the user turned each one-word fix into a full `/implement` and a fresh review, and each review flagged the next nit in the new wording: one small change took six rounds and eight commits in a single session. One extra pass ends almost every round in a single run, keeps every committed change reviewed, and caps the loop, which is what ADR-0002 feared in an open-ended fix loop.

## Consequences

- Findings marked `ticket`, and every finding of the second review, still go to the user; only `fix now` findings from the first review are applied automatically.
- When findings from both reviews are reported, `implement` numbers them as one list (first review's open findings first, continuing the count), and applied findings get no number.
- `code-review` judges only against the brief: a file the diff does not touch is a finding only when the diff makes it wrong, so the second review cannot widen the scope.
