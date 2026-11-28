# syntax=docker/dockerfile:1.29
FROM nousresearch/hermes-agent:v0.23.5@sha256:bc79a80fc9cb97521f4380c5d5b2ad88e2469e50fc1d5027339bbb42cc206854

# Hermes runs from its source tree, so the patches go straight into /opt/hermes.
RUN --mount=type=bind,source=.,target=/src \
    bash /src/scripts/apply-patches.sh /src/patches /opt/hermes
