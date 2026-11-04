# syntax=docker/dockerfile:1.28
FROM nousresearch/hermes-agent:v0.22.7@sha256:e6d81ae52ebf6a43efa529701405509f20054ba818f179ddd748bed4f8af584c

# Hermes runs from its source tree, so the patches go straight into /opt/hermes.
RUN --mount=type=bind,source=.,target=/src \
    bash /src/scripts/apply-patches.sh /src/patches /opt/hermes
