#!/usr/bin/env sh
set -ex

BASE_DIR="/usr/src/pypy"
PYTHON="$(which pypy || which python)"

PYPY_NAME="pypy3.6"
PYPY_RELEASE_VERSION="${PYPY_RELEASE_VERSION:-$PYPY_VERSION}"
PYPY_ARCH="linux64-alpine$(cut -d. -f1,2 /etc/alpine-release)"

# set thread stack size to 1MB so we don't segfault before we hit sys.getrecursionlimit()
# https://github.com/alpinelinux/aports/commit/2026e1259422d4e0cf92391ca2d3844356c649d0
export CFLAGS="-DTHREAD_STACK_SIZE=0x100000 $CFLAGS"

# Translation
cd "$BASE_DIR"/pypy/goal
"$PYTHON" ../../rpython/bin/rpython --opt=jit

# Packaging
cd "$BASE_DIR"/pypy/tool/release
"$PYTHON" package.py --archive-name "$PYPY_NAME-v$PYPY_RELEASE_VERSION-$PYPY_ARCH"
