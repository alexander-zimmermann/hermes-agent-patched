# syntax=docker/dockerfile:1.29
FROM nousresearch/hermes-agent:v0.23.3@sha256:3e9fe4c6ef36490f43aa0d0d80f9df64e9c92a576eee3042f1a97c8813c05355

# Hermes runs from its source tree, so the patches go straight into /opt/hermes.
RUN --mount=type=bind,source=.,target=/src \
    bash /src/scripts/apply-patches.sh /src/patches /opt/hermes
