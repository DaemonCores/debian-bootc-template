# Architecture — DaemonCores image template

This repository is the starting point for a DaemonCores bootc image built on
`debian-bootc`. It contains no pipeline logic: the build graph lives in
`DaemonCores/DaemonCores-CI`, and a fork only carries what makes its image
different (Containerfiles, an overlay tree, a `.deb` manifest, boot tests, thin
workflow callers).

## Layers

```
ghcr.io/daemoncores/debian-bootc:latest      base: Debian 13, bootc, OSTree,
        |                                    boot stack, installer contract
Containerfile.base                           + this repository's own APT repo
        |                                    (built once per job as
        |                                     localhost/debian-bootc-base,
        |                                     never pushed)
Containerfile (and Containerfile.<variant>)  the image(s) of the fork
```

`Containerfile.base` takes `PRODUCT_NAME`, `BOOTC_APT_URL` and
`BOOTC_GPG_SHA256` as build arguments the CI derives (repository name, Pages URL,
`APT_GPG_KEY`). When the URL and digest are empty the repository's own APT
source is simply not configured, so a fresh fork builds against Debian and
`debian-bootc` packages only. No URL, key digest or repository name is committed.

Every root-level `Containerfile*` becomes one image tag: `Containerfile` is the
`latest` family, `Containerfile.<name>` the `<name>` family. Each job builds the
base once, then the variant on the same layers; only the variants are pushed.

## Image definition

`Containerfile` copies `src/overlay/` to `/` (configuration files, systemd units,
anything the image ships as-is), installs packages with `apt`, and sets
`HEALTHCHECK NONE` — bootc images update in place through OSTree, so a runtime
healthcheck would be wrong. It also carries the OCI and bootc labels
(`containers.bootc=1`, `ostree.bootable=1`) and a strict bash shell
(`-euo pipefail`).

The template's content is an example: `example-package` (built from
`workflows/bootc-debs-builder/example-package/`) and
`src/overlay/usr/share/example-overlay/README`. Replace both.

## Package manifest (`workflows/bootc-debs-builder/packages.yml`)

One entry per package *class*; the `variants` mapping expands a class over its
packages, so a new package is a few lines and its directory, not a new job. The
template uses the `custom` class (`deb_custom`: package a tree you wrote —
`DEBIAN/control` plus files at their final path). The shared helper library
`DaemonCores-CI/scripts/deb_helpers.sh` is imported implicitly by `build-deb.sh`
and also offers `repacked` (`deb_repack`) and `overlay-tree`
(`deb_overlay_tree`); larger examples, including source builds and kernels, are
in `DaemonCores-VE`.

`HELPERS_VER` is hashed per entry and must be bumped whenever that shared library
changes — the other repository is invisible to the content hash. `{{ VER }}` and
`{{ DEPS }}` in `DEBIAN/control` are filled in by the builder.

`workflows/env.yml` is the build-environment recipe: `base`, `env` and ordered
`phases` (`apt:` or `run:`). The shared `build-env.yml` workflow assembles it
with buildah (no Containerfile) into `ghcr.io/<owner>/<repo>-buildenv`, rebuilt
monthly, so per-package jobs start with the toolchain already present. The
template's chain is: SSL/clone dependencies, packaging kit, then checksum-pinned
`yq` and `gh` binaries downloaded per architecture (the build one-deb workflow
deletes old artifacts through `gh api`).

## Boot tests (`workflows/tests.yml`)

The shared `image-test` action installs the image to a virtual disk, boots it
under QEMU/KVM with UEFI firmware and runs the manifest over SSH before the image
is pushed. Keys: `boot_timeout` (900 s), `reboot_timeout` (300 s), and per test
`name`, `run`, optional `expect` (substring pass) and **`diag` — required**: the
`check_tests_manifest.py` gate fails the build when a test lacks one, so a red
test can never be undiagnosable.

The template ships three inherited checks (booted through bootc, composefs root,
no failed units) and two example checks that follow the example package and
overlay.

## Continuous integration

Three thin callers, all `uses:` a reusable workflow in `DaemonCores-CI@main`:

| Workflow | Triggers | Shared workflow |
| --- | --- | --- |
| `pipeline.yml` | push `main` (ignoring `docs`, `**.md`), monthly `schedule`, `workflow_dispatch` | `full-pipeline.yml` |
| `lint.yml` | push `main` (ignoring `**.md`), `pull_request`, `workflow_dispatch` | `lint.yml` (runs `make check`) |
| `release.yml` | push `main` → `edge`; `workflow_dispatch` → `stable` | `release.yml` |

Versions come from Conventional Commits: a releasable push publishes
`vX.Y.Z-edge.N`, and `stable` only ever runs by hand. Images are published to
`ghcr.io/<owner>/<repo>` and the `.deb` packages to
`https://<owner>.github.io/<repo>`, which requires Pages → Source = GitHub
Actions. The first pipeline run generates the APT signing keys and stores them as
secrets, then restarts itself; `PIPELINE_PAT` (fine-grained, Secrets and Actions
read/write) is the only secret a fork must provide.

## Quality gate (`Makefile`)

| Target | Effect |
| --- | --- |
| `make check` | `check-containerfile` (hadolint), `check-yaml` (yamllint), `check-shared` — the same entry point as the `Lint` workflow |
| `make check-shared` | `check_tests_manifest.py` and `check_build_context.py` from a `DaemonCores-CI` checkout |
| `make ci-repo` | Clones `DaemonCores-CI` into the untracked `.ci/` and exports it as `CI_REPO` |

There are no Python sources here, so the gate is hadolint + yamllint + the shared
checks. `.claude/settings.json` runs the same gate as a pre-commit hook
(`.claude/hooks/pre-commit-check.sh`); `CLAUDE_QUALITY_HOOKS=0` disables it.

## Repository conventions

`CLAUDE.md` states the rules a fork inherits: English only, `make check` green
before every commit with no weakened test or silenced check, a `diag` on every
boot test, nothing hard-coded that the CI can derive, documentation in the wiki
rather than extra READMEs, and a record of what was asked and decided.
`.claude/skills/{image-template,docs,handoff}/SKILL.md` carry the details.
