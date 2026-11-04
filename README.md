# hermes-agent-patched

The [Hermes Agent](https://github.com/NousResearch/hermes-agent) image `nousresearch/hermes-agent`, plus our open upstream pull requests as patches. The [lares](https://github.com/alexander-zimmermann/lares) cluster runs this image instead of the upstream one, so a fix we need does not wait for its review.

## The rule

Every file in `patches/` is one open pull request in NousResearch/hermes-agent, and lares tracks each of them in [lares#2610](https://github.com/alexander-zimmermann/lares/issues/2610). A change without an upstream PR does not go in here. The goal is an empty `patches/`. Once it is empty, lares goes back to the upstream image and this repo is archived.

## How it works

The `Dockerfile` starts from one Hermes release, pinned by tag and digest. `scripts/apply-patches.sh` applies every patch to `/opt/hermes`, where Hermes runs from its source tree. The image has neither tests nor the docs site, so the hunks for `tests/` and `website/` are skipped.

1. Renovate checks Docker Hub every hour and opens a PR for a new Hermes release.
2. CI builds the image with the patches and imports every module they touch. If CI passes, the PR merges itself.
3. The release workflow builds the image and pushes it to `ghcr.io/alexander-zimmermann/hermes-agent-patched`, then tags the commit and creates a GitHub release that lists the patches.
4. Renovate in lares sees the new tag and opens the bump PR there, which is reviewed by hand.

Tags are `<hermes tag>-lares.<n>`, for example `v0.22.6-lares.1`. `n` counts the builds on the same Hermes release, so a new or refreshed patch gives `v0.22.6-lares.2`.

## When CI fails

`scripts/apply-patches.sh` names the patch and says why:

- **"… is already in this Hermes release"**: the PR has shipped. Delete the patch in the Renovate PR, then tick its box in lares#2610.
- **"… no longer applies"**: if the PR was merged in a changed form, delete the patch as above. Otherwise rebase the upstream PR on `main` and refresh the file (below).

## Add or refresh a patch

A patch file is named `<PR number>-<PR branch without its prefix>.patch`. It starts with the PR's URL, followed by the PR's diff:

```bash
n=143213
branch=jobs-api-script-jobs
{ echo "Upstream: https://github.com/NousResearch/hermes-agent/pull/$n"; echo; gh pr diff "$n" -R NousResearch/hermes-agent; } > "patches/$n-$branch.patch"
```

`gh pr diff` gives the diff against upstream `main`. When that no longer applies to the pinned release, edit the patch file by hand until it does.

To check locally:

```bash
docker build --platform linux/amd64 -t hermes-agent-patched:local .
```
