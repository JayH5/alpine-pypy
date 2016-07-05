#!/bin/sh
set -ex

BASE_DIR="/usr/src/pypy"
cd $BASE_DIR

# Translation
# ===========
cd pypy/goal
python ../../rpython/bin/rpython --opt=jit
cd $BASE_DIR

# Packaging
# =========
# Horrible workaround for non-standard tk/tcl libs in Alpine
cd lib_pypy/_tkinter
patch <<EOF
--- tklib_build.py	2016-05-24 16:27:31.000000000 +0200
+++ tklib_build.py	2016-05-24 16:29:35.000000000 +0200
@@ -22,12 +22,9 @@
     linklibs = ['tcl', 'tk']
     libdirs = []
 else:
-    for _ver in ['', '8.6', '8.5', '']:
-        incdirs = ['/usr/include/tcl' + _ver]
-        linklibs = ['tcl' + _ver, 'tk' + _ver]
-        libdirs = []
-        if os.path.isdir(incdirs[0]):
-            break
+    incdirs = []
+    linklibs = ['tcl8.6', 'tk8.6']
+    libdirs = []

 config_ffi = FFI()
 config_ffi.cdef("""
EOF
cd $BASE_DIR

cd pypy/tool/release
# Workaround for Busybox's tar not being very featureful
# We're in a container running as root anyway...
sed -i 's/--owner=root --group=root//' package.py

PYPY_RELEASE_VERSION="${PYPY_RELEASE_VERSION:-$PYPY_VERSION}"
./package.py --archive-name pypy3.3-v$PYPY_RELEASE_VERSION-linux64
cd $BASE_DIR
