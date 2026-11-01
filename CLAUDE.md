# Working on this repository with an AI

This repository builds a bootable image on top of debian-bootc. The pipeline logic is shared (DaemonCores-CI); here you only edit what makes the image different. Read `.claude/skills/image-template/SKILL.md` before changing anything.

Rules:

- Write code, comments, commit messages and documentation in English.
- `make check` must pass before every commit. Never weaken a test, skip a check or silence an error to make it pass: fix the cause.
- Every boot test in `workflows/tests.yml` needs a `diag`.
- Nothing hard-coded: no repository name, owner, URL or path that the CI can derive.
- Documentation lives in the wiki, not in extra READMEs; see `.claude/skills/docs/SKILL.md`.
- Keep a record of what was asked and decided; see `.claude/skills/handoff/SKILL.md`.

The hooks in `.claude/settings.json` run `make check` before a commit. Set `CLAUDE_QUALITY_HOOKS=0` to disable them.
