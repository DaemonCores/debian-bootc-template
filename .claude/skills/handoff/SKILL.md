---
name: handoff
description: Keep the project memory in the wiki so that work survives a context loss - current state, a report of every request with its state and proof, and a log of decisions. Use at the start of work, on each new request, before each commit.
---

# Handoff

The wiki is the memory. Three pages, kept up to date in the same turn as the work:

- `Handoff-Current-State.md`: where the project stands and what is not yet verified.
- `Handoff-Rapport.md`: every request, in order, with a state (OPEN, IN-PROGRESS, DONE-PROVEN, DONE-UNVERIFIED, BLOCKED, DROPPED) and the proof (command output, run id, file:line, commit). Never mark DONE-PROVEN without proof. Only the owner closes a request.
- `Handoff-Decisions.md`: every decision, however small, with the reason and the date. Never delete one; mark it superseded with the reason.

Read the three pages before starting work. The wiki is public: no hostnames, secrets or personal names.
