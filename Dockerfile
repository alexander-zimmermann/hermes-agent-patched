# syntax=docker/dockerfile:1.29
FROM nousresearch/hermes-agent:v0.23.2@sha256:d6746a084e9341baada483e3d6210444d3c1aeb7c130f0915150065fb2851459

# Hermes runs from its source tree, so the patches go straight into /opt/hermes.
RUN --mount=type=bind,source=.,target=/src \
    bash /src/scripts/apply-patches.sh /src/patches /opt/hermes
