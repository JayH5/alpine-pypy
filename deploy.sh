#!/usr/bin/env bash
set -e

cd "$VERSION"

IMAGE="$REGISTRY_USER/alpine-pypy-build:$VERSION${VARIANT:+-$VARIANT}"

# Parse the version of PyPy from the Dockerfile
if [[ -n "$VARIANT" ]]; then
  dockerfile="$VARIANT.dockerfile"
else
  dockerfile="Dockerfile"
fi
PYPY_VERSION="$(sed -n 's/.*PYPY_VERSION="\(.*\)".*/\1/p' $dockerfile)"

TAG="${IMAGE##*:}"

IFS=- read -r tag_start tag_end <<< "$TAG"
VERSION_TAG="$tag_start-$PYPY_VERSION${tag_end:+-$tag_end}"

docker-ci-deploy --login "$REGISTRY_USER:$REGISTRY_PASS" \
  --tag "$TAG" "$VERSION_TAG" \
  -- "$IMAGE"
