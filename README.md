# DaemonCores image template

<p align="center">
  <img src="https://raw.githubusercontent.com/DaemonCores/.github/refs/heads/main/assets/banner.svg" alt="DaemonCores Banner" width="100%"/>
</p>

<p>
  <strong align="left">Simplify and Innovate for Everyone.</strong>
  <a href="https://github.com/DaemonCores/debian-bootc/wiki"><img align="right" src="https://img.shields.io/badge/Wiki-FFFFFF?style=for-the-badge&logoColor=white" alt="Documentation"/></a>
  <a href="https://github.com/orgs/DaemonCores/discussions"><img align="right" src="https://img.shields.io/badge/Community-000000?style=for-the-badge&logoColor=white" alt="Community"/></a>
  <a href="https://github.com/DaemonCores/debian-bootc"><img align="right" src="https://img.shields.io/badge/Base_debian_for_all_project-A81D33?style=for-the-badge&logo=debian&logoColor=white" alt="Debian Bootc"/></a>
  
  <em>Identify gaps and fill them, make improvements where possible, but above all, empower developers to offer more to users.</em>
</p>

---

Starting point for a bootable image built on
[debian-bootc](https://github.com/DaemonCores/debian-bootc). The pipeline logic
lives in [DaemonCores-CI](https://github.com/DaemonCores/DaemonCores-CI); this
repository only holds what makes your image different.

## Layout

| Path | Role |
|---|---|
| `Containerfile` | Your image, `FROM` the base. Add `Containerfile.<variant>` for more flavours: every `Containerfile*` becomes one image tag. |
| `Containerfile.base` | Base image plus this repository's own APT repository, configured implicitly from CI build-arguments. Usually left untouched. |
| `src/overlay/` | Files copied as-is to `/` in the image. |
| `workflows/bootc-debs-builder/packages.yml` | Manifest of the `.deb` packages built by CI. |
| `workflows/bootc-debs-builder/<package>/` | One directory per package: `DEBIAN/control` plus the files at their final path. |
| `workflows/env.yml` | Pipeline settings. |
| `workflows/tests.yml` | Boot tests run on the real image before it is pushed. Every test needs a `diag`. |
| `.github/workflows/` | Thin callers of the shared pipeline. |

## Use

1. Create a repository from this template.
2. Settings → Pages → Source: **GitHub Actions** (hosts the APT repository).
3. Add the secret `PIPELINE_PAT` (repository or organisation level): a
   fine-grained personal access token restricted to your repositories, with
   repository permissions Secrets (read and write) and Actions (read and write).
   It writes the generated repository secrets and dispatches pipelines across
   repositories. Image and package pushes use the job's own token, no PAT.
4. Run the `pipeline` workflow. The first run generates the APT signing keys and
   stores them as secrets, then restarts itself.
5. Replace `example-package` and `src/overlay/usr/share/example-overlay` with
   your own content, and adapt `workflows/tests.yml`.

## Result

Images are published to `ghcr.io/<owner>/<repo>` and the packages to
`https://<owner>.github.io/<repo>`.

## Documentation

What each YAML file does, how the pipeline reads it and how to extend the template are documented in the [wiki](../../wiki): `Containerfile`, `Containerfile.base`, `workflows/env.yml`, `packages.yml`, `tests.yml` and the callers under `.github/workflows/`.

## Quality gates

`make check` runs yamllint, hadolint and the tests manifest check, the same entry point as the `Lint` workflow. Every boot test needs a `diag`; the pipeline refuses a manifest without one.

## Community

[Contributing](CONTRIBUTING.md), [Code of Conduct](CODE_OF_CONDUCT.md), [Security](SECURITY.md), [Support](SUPPORT.md).

---

<p>
  <strong align="left">Made with ⭐ by the DaemonCores community</strong>
  <a href="https://github.com/DaemonCores/debian-bootc/wiki"><img align="right" src="https://img.shields.io/badge/Wiki-FFFFFF?style=for-the-badge&logoColor=white" alt="Documentation"/></a>
  <a href="https://github.com/orgs/DaemonCores/discussions"><img align="right" src="https://img.shields.io/badge/Community-000000?style=for-the-badge&logoColor=white" alt="Community"/></a>
  <a href="https://github.com/DaemonCores/debian-bootc"><img align="right" src="https://img.shields.io/badge/Base_debian_for_all_project-A81D33?style=for-the-badge&logo=debian&logoColor=white" alt="Debian Bootc"/></a>
</p>
