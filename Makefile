# Single entry point for the quality gates: local runs and the Lint workflow
# call the same targets.
SHELL := /bin/bash -euo pipefail

# Shared checks live in DaemonCores-CI. CI exports CI_REPO itself; locally the
# `ci-repo` target clones it into the untracked .ci/ directory on first use.
CI_REPO ?= .ci
CI_REPO_URL ?= https://github.com/DaemonCores/DaemonCores-CI.git

CONTAINERFILES := $(wildcard Containerfile Containerfile.*)
YAML_SRCS := $(shell find . -path ./.git -prune -o -path ./.ci -prune -o \( -name '*.yml' -o -name '*.yaml' \) -print)

.PHONY: check check-containerfile check-yaml check-shared ci-repo help

check: check-containerfile check-yaml check-shared

check-containerfile:
	@command -v hadolint >/dev/null 2>&1 || { echo "hadolint not found" >&2; exit 1; }
	hadolint $(CONTAINERFILES)

check-yaml:
	@command -v yamllint >/dev/null 2>&1 || { echo "yamllint not found" >&2; exit 1; }
	yamllint $(YAML_SRCS)

ci-repo:
	@if [ ! -d "$(CI_REPO)/scripts" ]; then \
	  git clone --depth 1 --quiet "$(CI_REPO_URL)" "$(CI_REPO)" \
	    || { echo "cannot fetch DaemonCores-CI: set CI_REPO" >&2; exit 1; }; \
	fi

# Same gates as every DaemonCores repository: the tests manifest (every test
# needs a diag) and the build context.
check-shared: ci-repo
	python3 $(CI_REPO)/scripts/check_tests_manifest.py --root .
	python3 $(CI_REPO)/scripts/check_build_context.py --root .

help:
	@echo "make check   run every gate"
