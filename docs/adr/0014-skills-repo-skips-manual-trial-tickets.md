# The skills repo skips manual trial tickets

New skills in this repo get no `ready-for-human` ticket for a manual trial run. A skill is tried by using it in real repos; what goes wrong there comes back through a session review or the run's output, handed off to this repo and worked on here as ordinary tickets. A planned trial ticket blocked a release on a person's free time and tested a single staged run, while real use tests the skill on the repos it was written for.

## Consequences

- Specs here name the automated tests and the two `claude plugin validate` commands as the test; they do not plan a manual run.
- A skill can ship with faults that only real use shows; they arrive later as handoff tickets.
- This rule is for this repo only: `to-tickets` still makes `ready-for-human` tickets for manual tests in other projects.
