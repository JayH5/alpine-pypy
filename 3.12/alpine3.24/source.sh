#!/usr/bin/env sh
set -ex
wget -O pypy.tar.gz "https://downloads.python.org/pypy/pypy${PYPY_PYTHON}-v${PYPY_VERSION}-src.tar.gz"
echo "$PYPY_SHA256SUM *pypy.tar.gz" | sha256sum -c -
mkdir -p /usr/src/pypy
tar -xzC /usr/src/pypy --strip-components=1 -f pypy.tar.gz
rm pypy.tar.gz
cd /usr/src/pypy
patch -p1 -E -i /pypy.patch
