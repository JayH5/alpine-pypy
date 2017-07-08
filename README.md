# alpine-pypy

[![Build Status](https://img.shields.io/travis/JayH5/alpine-pypy/master.svg)](https://travis-ci.org/JayH5/alpine-pypy)

Docker-based builds for [PyPy](http://pypy.org) on [Alpine Linux](http://www.alpinelinux.org).

These are **unofficial** builds maintained by one person who hasn't yet figured out how to automate builds that take 1hr+ on dedicated VMs without spending lots of money. For downloads, see the [releases](https://github.com/JayH5/alpine-pypy/releases) page. For the Docker images used to build PyPy see this [Docker Hub page](https://hub.docker.com/r/jamiehewland/alpine-pypy-build/). For Docker images that use these PyPy builds, see the [`JayH5/docker-alpine-pypy`](https://github.com/JayH5/docker-alpine-pypy/) repository.

Currently, PyPy is only built for [glibc](https://www.gnu.org/software/libc/)/GNU-based Linux distributions, namely, Debian and Ubuntu. Recently, the Alpine Linux distribution has been gaining in popularity as a base OS for containers, due to its small size and container-friendly tools. A big way that Alpine achieves its small size is through its use of [musl](https://www.musl-libc.org) as its C standard library and [BusyBox](https://busybox.net) as its set of Unix tools. This means that PyPy binaries compiled for glibc/GNU are not compatible with Alpine Linux.

This repository seeks to make it easy to build PyPy for Alpine Linux.

## Docker images
Docker images are provided for building PyPy:

* `alpine-pypy-build:2-bootstrap`: An image to build PyPy from source using cPython.
* `alpine-pypy-build:2`: An image to build PyPy from source using an existing PyPy binary.

## Building
### From scratch
PyPy requires a Python implementation in order to build itself. The recommended implementation to use is PyPy itself as it is much faster than standard cPython. But if you don't have a PyPy binary in the first place you'll have to settle for cPython.

The first step is to get the `bootstrap` image which you can either build from source or pull from Docker Hub:
```sh
docker build -t alpine-pypy-build:2-bootstrap -f 2/bootstrap.dockerfile 2
```
or..
```sh
docker pull jamiehewland/alpine-pypy-build:2-bootstrap
```

Then things should be as simple as running the container with a mounted volume:
```sh
docker run --rm -it -v "$(pwd)/tmp:/tmp" jamiehewland/alpine-pypy-build:2-bootstrap
```

Unless you have a really fast computer this will take several hours. As [the PyPy people say](http://pypy.org/download.html#building-from-source): Enjoy Mandelbrot `:-)`.

Once this is all done, the built PyPy package should be at `./tmp/usession-release-$PYPY_VERSION-1/build` on the container host. `$PYPY_VERSION` is defined in the Dockerfile, but it's also possible to override the version that PyPy is packaged as by setting the `$PYPY_RELEASE_VERSION` environment variable.

### With an existing PyPy binary
PyPy compiles several times faster using itself rather than cPython. In general, we can use older versions of PyPy to build newer ones. The PyPy builder is based on the non-builder image.

```sh
docker run --rm -it -v "$(pwd)/tmp:/tmp" jamiehewland/alpine-pypy-build:2
```

## Notes on building PyPy on Alpine Linux
There are a few workarounds for differences between Alpine Linux and the Debian-based Linux distributions that the PyPy team has thus far worked against.

### Issues when building all versions of PyPy
* The standard Python package currently in the Alpine package repositories has an issue that prevents PyPy from compiling. The `alpine-pypy-build:2-bootstrap` image is based on the [`python:2-alpine`](https://hub.docker.com/_/python/) Docker image which instead builds Python from source.
* The tk/tcl libraries for Alpine have slightly non-standard names and paths. The PyPy script for building the CFFI bindings for tk in the Python standard library have a very simplistic way of looking up library locations. We instead patch that script to point to the correct files. It's also easy to switch off the compilation of the tk bindings completely by setting the `PYPY_PACKAGE_WITHOUTTK` environment variable to any value.

### Issues when building PyPy for Python 3
* The build process checks for the value of a certain [`confstr`](http://man7.org/linux/man-pages/man3/confstr.3.html): `_CS_GNU_LIBPTHREAD_VERSION`. Unfortunately, this is a GNU thing and isn't present in Alpine Linux. We replace (`sed`) the `os.confstr()` lookup in the PyPy build process with the value `"NPTL"`, which is used to build OpenJDK on Alpine Linux [here](https://github.com/alpinelinux/aports/blob/master/community/openjdk8/icedtea-hotspot-uclibc-fixes.patch). :-/
* RPython expects the `stdin`/`stdout`/`stderr` file handles in `stdio.h` of the standard libc to be of type `FILE*`. With musl these are of type `FILE *const` rather. We patch RPython with the correct type.
* Another issue that surfaces when **running** PyPy is that the Alpine libraries for Berkeley DB (a.k.a. `libdb`) are not built with the historical dbm interface (`--enable-dbm`) which the [`dbm.ndbm`](https://docs.python.org/3/library/dbm.html#module-dbm.ndbm) module bundled with PyPy3 expects. When Alpine's `db` package is installed, PyPy3 will crash when trying to import any `dbm` module as the symbols it wants are missing. A solution is to delete the `dbm.ndbm` (`lib-python/3/dbm/ndbm.py`) module completely.
