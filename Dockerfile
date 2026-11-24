# syntax=docker/dockerfile:1.29
FROM nousresearch/hermes-agent:v0.23.4@sha256:ef0650d523ee1b5ab32c779acabc446d9936869a9932591553688a62bcf0c42f

# Hermes runs from its source tree, so the patches go straight into /opt/hermes.
RUN --mount=type=bind,source=.,target=/src \
    bash /src/scripts/apply-patches.sh /src/patches /opt/hermes
