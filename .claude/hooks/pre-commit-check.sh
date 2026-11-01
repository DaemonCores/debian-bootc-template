#!/usr/bin/env bash
# Runs `make check` before a `git commit` issued through the Bash tool and
# refuses the commit when a gate fails. Set CLAUDE_QUALITY_HOOKS=0 to opt out.
set -euo pipefail

[ "${CLAUDE_QUALITY_HOOKS:-1}" = "0" ] && exit 0

command=$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))')
[[ "${command}" =~ (^|[[:space:];&|])git[[:space:]]+commit([[:space:]]|$) ]] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}"
if ! output=$(make check 2>&1); then
  printf 'make check failed, fix the cause before committing:\n%s\n' "${output}" >&2
  exit 2
fi
