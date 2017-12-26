#!/usr/bin/env sh
set -ex

BASE_DIR="/usr/src/pypy"
PYTHON="$(which pypy || which python)"

PYPY_NAME="pypy2"
PYPY_RELEASE_VERSION="${PYPY_RELEASE_VERSION:-$PYPY_VERSION}"
PYPY_ARCH="linux64"

# Translation
cd "$BASE_DIR"/pypy/goal
"$PYTHON" ../../rpython/bin/rpython --opt=jit

# Packaging
cd "$BASE_DIR"/pypy/tool/release
"$PYTHON" package.py --archive-name "$PYPY_NAME-v$PYPY_RELEASE_VERSION-$PYPY_ARCH"
