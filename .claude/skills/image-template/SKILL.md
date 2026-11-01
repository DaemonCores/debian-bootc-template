---
name: image-template
description: How to work on a repository created from the DaemonCores image template - adding packages, images and boot tests, and what the shared pipeline expects. Use before editing Containerfile*, workflows/ or .github/workflows/.
---

# Working on a DaemonCores image repository

The pipeline is shared: `.github/workflows/*.yml` are thin callers of DaemonCores-CI. Do not copy pipeline logic here; if the pipeline must change, change DaemonCores-CI.

## Map

| Task | Where |
|---|---|
| Change the image | `Containerfile`, files under `src/overlay/` (copied to `/`) |
| Add a flavour | `Containerfile.<variant>`; every `Containerfile*` becomes one image tag |
| Add a package | a directory under `workflows/bootc-debs-builder/<name>/` (`DEBIAN/control` plus files at their final path) and a variant in `packages.yml` |
| Change the build toolchain | `workflows/env.yml`, then rebuild the environment (`rebuild_env`) |
| Add a boot test | `workflows/tests.yml`; a `diag` is mandatory |

## Rules that bite

- `Containerfile.base` wires this repository's own APT repository from CI build arguments. Never write an owner, repository name, URL or key hash in it.
- The Pages URL keeps the repository name case in its path (only the host is lowercase).
- Bump `HELPERS_VER` in `packages.yml` when the DaemonCores-CI deb helpers change: that repository is outside the content hash.
- A boot test proves behaviour on the real image. Write the `diag` to show the runtime state behind a failure (unit status, journal tail), not to repeat the test.
- Installing a package from this repository's APT repo needs no extra configuration in a Containerfile.
- Secrets (`PIPELINE_PAT`, signing keys) are never printed or committed.

## Checks

`make check` runs yamllint, hadolint and the shared tests-manifest and build-context checks. Run it before each commit. hadolint may be missing locally: say so rather than skipping silently.
