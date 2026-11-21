# polaris.json is the only place paths live

Each project's `polaris.json` names its specs, tickets, diagrams and releases folders, its version file and its changelog. Every skill reads paths from it, and the CLAUDE.md block points to it instead of repeating them, so the two cannot drift. Paths are configurable because some projects already use `docs/` for a docs site. Its presence also marks a project as using the workflow, which is how Polaris finds projects.
