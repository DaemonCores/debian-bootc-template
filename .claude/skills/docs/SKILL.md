---
name: docs
description: Documentation conventions of a DaemonCores repository - the wiki is the documentation, markdown header and footer, what must never appear in docs. Use when writing or editing any .md file or wiki page.
---

# Documentation

- The wiki (`<repo>.wiki`) holds the documentation. Do not add explanatory READMEs next to the code; link to a wiki page instead.
- Every `.md` file in the repository, except the AI instruction files (`CLAUDE.md`, `SKILL.md`, whose first line must stay as it is), starts with the title, the DaemonCores banner block and the badges, and ends with the "Made with" footer. Copy them from `README.md`.
- Documentation describes the product, never incidents: no "this used to crash", no bug stories. That belongs in the commit message.
- No hostnames, IP addresses, personal names or private paths in docs, code or tests.
- Write for a developer discovering the topic: explain why a choice was made, not what the line does.
- Wiki pages: one topic per page, linked from `Home.md` and `_Sidebar.md`.
