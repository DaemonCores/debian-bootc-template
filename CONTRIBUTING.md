# Contributing

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

Contributions are welcome: packages, image layers, overlay files, boot tests and documentation.

## Bug reports

Use the repository issue forms. Include the commit or image digest, the deployment method, the hardware or VM configuration, reproduction steps and relevant service logs. Follow [SECURITY.md](SECURITY.md) for private reports.

## Where things live

| Area | Main paths |
| --- | --- |
| Image layer | `Containerfile`, `Containerfile.*`, `src/overlay/` |
| Packages | `workflows/bootc-debs-builder/` |
| Runtime validation | `workflows/tests.yml` |
| Pipeline settings | `workflows/env.yml` |
| Shared pipeline caller | `.github/workflows/pipeline.yml` |

## Change requirements

- Run `make check` before opening a pull request.
- Add or update a boot test, with its `diag`, for every behaviour you add.
- Do not weaken a check to make it pass: fix the cause.
- State which paths you could not test.
- Update the documentation in the same pull request.

---

<p>
  <strong align="left">Made with ⭐ by the DaemonCores community</strong>
  <a href="https://github.com/DaemonCores/debian-bootc/wiki"><img align="right" src="https://img.shields.io/badge/Wiki-FFFFFF?style=for-the-badge&logoColor=white" alt="Documentation"/></a>
  <a href="https://github.com/orgs/DaemonCores/discussions"><img align="right" src="https://img.shields.io/badge/Community-000000?style=for-the-badge&logoColor=white" alt="Community"/></a>
  <a href="https://github.com/DaemonCores/debian-bootc"><img align="right" src="https://img.shields.io/badge/Base_debian_for_all_project-A81D33?style=for-the-badge&logo=debian&logoColor=white" alt="Debian Bootc"/></a>
</p>
