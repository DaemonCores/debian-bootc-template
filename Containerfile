#####################################################################################
# Your image
#####################################################################################
# The shared CI (bootc-build.yml) builds Containerfile.base once per job as
# localhost/debian-bootc-base and passes it as BASE_IMAGE. That base is the
# published debian-bootc image with this repository's own APT repository already
# configured, so you only write what makes YOUR image different.
#
# You can add as many Containerfile.<variant> as you want next to this one (a
# desktop flavour, a minimal flavour...): the CI builds every Containerfile* it
# finds, each becoming one image tag.
ARG BASE_IMAGE=localhost/debian-bootc-base
FROM ${BASE_IMAGE}
STOPSIGNAL SIGRTMIN+3

# Name shown in the image metadata, injected by the CI from the repository name.
ARG PRODUCT_NAME=""
LABEL org.opencontainers.image.title="${PRODUCT_NAME}"
LABEL org.opencontainers.image.base.name="ghcr.io/daemoncores/debian-bootc:latest"
LABEL org.opencontainers.image.licenses="LGPL-2.1"
LABEL containers.bootc=1
LABEL ostree.bootable=1

ENV DEBIAN_FRONTEND=noninteractive
# Fail the build on any error in a pipeline.
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# Files that are shipped as-is into the image: everything under src/overlay is
# copied to /. Put configuration files and systemd units there.
COPY ./src/overlay /

# Packages: Debian ones, and the ones built by this repository from
# workflows/bootc-debs-builder (see packages.yml). Replace the example.
RUN apt update \
    && apt install -y \
        example-package \
    && apt clean

# bootc images are updated in-place via ostree; no runtime healthcheck applies.
HEALTHCHECK NONE
