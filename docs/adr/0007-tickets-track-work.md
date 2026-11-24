# Tickets track work; they are not a prerequisite for it

Amends ADR-0001.

Tickets remain the handoff between contexts: work that is deferred, large, or meant for a fresh session gets a self-contained ticket. Work done in the current session may go straight to `implement` with no ticket when its scope is clear and the user authorises it. Only `implement` writes code; that half of ADR-0001 survives, so the review gate of ADR-0002 covers direct work too. ADR-0001 existed because long sessions drift, so context must be written down before a handoff; a finding fixed now, in the session that found it, has no handoff.
