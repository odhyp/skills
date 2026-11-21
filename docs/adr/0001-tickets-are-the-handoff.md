# Tickets are the only handoff between contexts

Every unit of work, down to a one-line fix, becomes a self-contained ticket, and the user runs `/clear` between tickets. Planning, diagnosing and reviewing write tickets; only `implement` writes code. Long sessions drift and carry stale assumptions, so a ticket must hold everything a fresh agent needs. The cost is a planning step (`shape` → `to-tickets`) even for small changes, accepted so that no change skips the thinking.
