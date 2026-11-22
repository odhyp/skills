# odhyp/skills

Personal agent skills that carry Odhy's ticket-based engineering workflow into every project.

## Language

### Skills

**Skill**:
A folder with a `SKILL.md` that an agent loads to follow a workflow.
_Avoid_: command, prompt

**Manual skill**:
A **Skill** only a person can start, used for anything with side effects or whose timing the person decides.
_Avoid_: user skill, slash command

**Auto skill**:
A **Skill** the agent starts by itself when the trigger condition in its description is met; other skills may chain to it.
_Avoid_: model skill, background skill

**Setup skill**:
The **Skill** run once per project to write its **Project config** and **Rules**.
_Avoid_: init, bootstrap

**Shape**:
The grilling conversation that turns an idea, small change or known-cause bug into agreed work before any **Spec** or **Ticket** exists.
_Avoid_: plan, refine, groom

### Work items

**Ticket**:
One self-contained unit of work, sized for one fresh session; the handoff between contexts.
_Avoid_: issue, task, story

**Spec**:
The agreed design of a feature, background for its **Tickets** and the log of decisions changed during implementation.
_Avoid_: PRD, design doc, RFC

**Brief**:
What a review judges the work against: a **Ticket**, a **Spec**, or the original request when there is neither.
_Avoid_: requirements, context

**Follow-up**:
A **Ticket** written from a review finding, at the user's request.
_Avoid_: todo, tech debt item

**Release**:
A versioned cut of the project, with its resolved **Tickets** and done **Specs** archived under that version.
_Avoid_: deploy, ship

### Project

**Project config**:
The odhyp block in a project's `CLAUDE.md` that names where **Specs**, **Tickets**, **Diagrams** and **Releases** live, plus its version files and changelog; its presence marks a project as using the workflow.
_Avoid_: settings, manifest

**Diagram**:
A Mermaid `.mmd` file showing the project's infrastructure, architecture or data flow. Drawn only on request or when **Shape** settles structural work.
_Avoid_: chart, graph

**Rule**:
A written convention (e.g. SemVer, Conventional Commits) that the **Setup skill** places in a project for agents to read and follow.
_Avoid_: policy, standard, guideline

**Guardrail**:
Tooling that mechanically enforces a **Rule**, such as the commit-message hook.
_Avoid_: enforcement, lint (as a noun for this)

## Relationships

- A **Spec** has one or more **Tickets**; a **Ticket** has at most one **Spec**
- A **Ticket** may have a parent **Ticket** it was split from or follows up
- Tickets and Specs are numbered separately (`T-NNNN`, `S-NNNN`)
- A **Guardrail** enforces exactly one **Rule**; a **Rule** may have none
- The **Setup skill** writes the **Project config** and **Rules**; other **Skills** read them
