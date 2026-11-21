# odhyp skills

My engineering workflow as agent skills: no project starts from zero.

**Tickets are the handoff between fresh contexts.** Planning, diagnosing and reviewing write tickets. Only `implement` writes code. Run `/clear` between tickets.

## Install

Claude Code (plugin, commands appear as `/odhyp:<skill>`):

```
/plugin marketplace add odhyp/skills
/plugin install odhyp@odhyp
```

Other agents, or an editable copy:

```
npx skills@latest add odhyp/skills
```

## Workflow

```mermaid
flowchart TD
    START(["Start"]) --> A1

    subgraph A["Setup (once per repo)"]
        A1["/setup-odhyp-skills 👤<br/>paths → CLAUDE.md · VERSION · hook"]
    end

    A1 --> X0{"Work type"}
    X0 -->|"Feature / small change / trivial bug"| B1
    X0 -->|"Bug, cause unknown"| B5

    subgraph B["Planning (writes specs & tickets)"]
        B1["/shape 👤<br/>Grill the work"]
        X1{"Size"}
        B2["/to-spec 👤<br/>docs/specs/S-NNNN"]
        B3["/to-tickets 👤<br/>docs/tickets/T-NNNN"]
        B5["/diagnose 🤖<br/>Root cause → fix ticket"]
        X2{"Diagrams affected?"}
        B4["/diagram 🤖<br/>docs/diagrams/*.mmd"]
        B1 --> X1
        X1 -->|"Feature"| B2 --> B3
        X1 -->|"Small change / trivial bug"| B3
        B3 --> X2
        X2 -->|"Yes"| B4
    end

    CL0["/clear ⚙️"]
    X2 -->|"No"| CL0
    B4 --> CL0
    B5 --> CL0
    T[("docs/tickets/<br/>status: ready-for-agent")]
    CL0 --> T

    T -->|"/implement @ticket"| C1

    subgraph C["Per ticket (fresh context)"]
        C1["/implement 👤<br/>in-progress → code + tests"]
        D1["/code-review 🤖<br/>uncommitted diff vs ticket/spec<br/>(forked subagent)"]
        C2["commit<br/>status: resolved (same commit)"]
        S1["/session-review 👤<br/>optional"]
        CL["/clear ⚙️"]
        C1 --> D1
        D1 -->|"Must-fix"| C1
        D1 -->|"Pass"| C2
        C2 --> S1
        C2 -->|"skip"| CL
        S1 --> CL
    end

    D1 -.->|"Follow-ups → new tickets"| T
    D1 -.->|"Infra changed"| B4

    CL --> X3{"Tickets left?"}
    X3 -->|"Yes"| T
    X3 -->|"No / milestone"| E1

    subgraph E["Release"]
        E1["/release 👤<br/>bump · CHANGELOG · archive · confirm · tag"]
    end

    E1 --> X0
    S1 -.->|"CLAUDE.md fixes"| CM[("CLAUDE.md")]
    S1 -.->|"Skill fixes → ticket"| SK[("odhyp skills repo")]

    classDef manual fill:#fde68a,stroke:#b45309
    classDef auto fill:#bfdbfe,stroke:#1d4ed8
    classDef builtin fill:#e9d5ff,stroke:#7e22ce
    classDef store fill:#e5e7eb,stroke:#374151
    class A1,B1,B2,B3,C1,S1,E1 manual
    class B4,B5,D1 auto
    class CL,CL0 builtin
    class T,CM,SK store
```

👤 manual skill · 🤖 auto skill (you can also call it) · ⚙️ built-in Claude Code command

## Skills

| Skill | Invocation | Does |
|---|---|---|
| `setup-odhyp-skills` | Manual | Run once per repo. Sets up structure, CLAUDE.md block, VERSION, CHANGELOG, commit hook, test/lint commands. On an existing repo, also draws the initial diagrams. Optionally starts from one of the starters. |
| `shape` | Manual | Entry point for features, small changes and trivial bugs. Grills you until we agree, then names the next step. Writes nothing. |
| `to-spec` | Manual | Turns the agreed conversation into `docs/specs/NNNN-slug.md`. |
| `to-tickets` | Manual | Splits a spec, or an agreed small change with no spec, into self-contained tickets in `docs/tickets/`. |
| `diagnose` | Auto | Triggers when you report a bug whose cause is unknown. Never triggers on failures in work that's in progress. Reproduces the bug, finds the root cause, then writes a `fix` ticket. **Does not fix.** |
| `diagram` | Auto | Creates or updates `docs/diagrams/*.mmd`. Triggers only when a change adds, removes or rewires services, infrastructure, data flow or module boundaries. |
| `implement` | Manual | `/implement @docs/tickets/NNNN-slug.md`: builds one ticket test-first, runs `code-review`, then commits. The only skill that writes code. |
| `code-review` | Auto | Runs after `implement` finishes and **before it commits**, in a forked subagent (`context: fork`). Reviews the uncommitted diff against the ticket, or the spec, or the request. Returns must-fix findings to `implement` and writes follow-up tickets. |
| `release` | Manual | Computes the SemVer bump from resolved tickets and commits, updates VERSION and CHANGELOG, archives, and tags after you confirm. |
| `session-review` | Manual | Run before `/clear`. Reviews *this session* and suggests improvements to the agent's environment. |

Manual skills have side effects or run when you decide. Auto skills start when their trigger condition is met.

Run `/setup-odhyp-skills` first in each project: it copies the ticket and spec formats into the project, so every other skill (and every agent) reads them from there.

## Development

- `sh tests/commit-msg.test.sh` checks the commit hook template.
- `claude plugin validate .` checks the manifests and skills.
- The full design is in [ODHYP-SKILLS-HANDOFF.md](ODHYP-SKILLS-HANDOFF.md).

## Versioning

SemVer, Conventional Commits, [CHANGELOG](CHANGELOG.md). Each release bumps `version` in both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (clients only update when it increases), and in `VERSION`.

## License

[MIT](LICENSE)
