# alpine-pypy

[![Build Status](https://img.shields.io/travis/JayH5/alpine-pypy/master.svg)](https://travis-ci.org/JayH5/alpine-pypy)

> *Note:* New builds/images of PyPy will use the latest Alpine Linux release available as of the release of that version of PyPy. The Alpine Linux version will be included in the name of the built archive going forward. Also, new Docker images will be released only with the full PyPy and Alpine Linux versions included in the tag.

Docker-based builds for [PyPy](http://pypy.org) on [Alpine Linux](http://www.alpinelinux.org).

These are **unofficial** builds maintained by one person who hasn't yet figured out how to automate builds that take 1hr+ on dedicated VMs without spending lots of money. For downloads, see the [releases](https://github.com/JayH5/alpine-pypy/releases) page. For the Docker images used to build PyPy see this [Docker Hub page](https://hub.docker.com/r/jamiehewland/alpine-pypy-build/). For Docker images that use these PyPy builds, see the [`JayH5/docker-alpine-pypy`](https://github.com/JayH5/docker-alpine-pypy/) repository.

Currently, PyPy is only built for [glibc](https://www.gnu.org/software/libc/)/GNU-based Linux distributions, namely, Debian and Ubuntu. Recently, the Alpine Linux distribution has been gaining in popularity as a base OS for containers, due to its small size and container-friendly tools. A big way that Alpine achieves its small size is through its use of [musl](https://www.musl-libc.org) as its C standard library and [BusyBox](https://busybox.net) as its set of Unix tools. This means that PyPy binaries compiled for glibc/GNU are not compatible with Alpine Linux.

This repository seeks to make it easy to build PyPy for Alpine Linux.

## Docker images
Docker images are provided for building PyPy:

* `alpine-pypy-build:$PYPY_VERSION-bootstrap-$ALPINE_VERSION`: Images to build PyPy from source using cPython.
* `alpine-pypy-build:$PYPY_VERSION-$ALPINE_VERSION`: Images to build PyPy from source using an existing PyPy binary.

*Where:*
* `$PYPY_VERSION` is of the form `{2.7,3.5,3.6}-$VERSION` (e.g. `3.5-7.0.0`)
* `$ALPINE_VERSION` is of the form `alpine$VERSION` (e.g. `alpine3.6`)

## Building
### From scratch
PyPy requires a Python implementation in order to build itself. The recommended implementation to use is PyPy itself as it is much faster than standard cPython. But if you don't have a PyPy binary in the first place you'll have to settle for cPython.

The first step is to get the `bootstrap` image which you can either build from source or pull from Docker Hub:
```sh
cd 2.7/alpine3.9
docker build -t alpine-pypy-build:2.7-bootstrap-alpine3.9 -f bootstrap/Dockerfile .
```
or..
```sh
docker pull jamiehewland/alpine-pypy-build:2.7-7.0.0-bootstrap-alpine3.9
```

Then things should be as simple as running the container with a mounted volume:
```sh
docker run --rm -it -v "$(pwd)/tmp:/tmp" jamiehewland/alpine-pypy-build:2.7-7.0.0-bootstrap-alpine3.9
```

Unless you have a really fast computer this will take several hours. As [the PyPy people say](http://pypy.org/download.html#building-from-source): Enjoy Mandelbrot `:-)`.

Once this is all done, the built PyPy package should be at `./tmp/usession-release-$PYPY_VERSION-1/build` on the container host. `$PYPY_VERSION` is defined in the Dockerfile, but it's also possible to override the version that PyPy is packaged as by setting the `$PYPY_RELEASE_VERSION` environment variable.

### With an existing PyPy binary
PyPy compiles several times faster using itself rather than cPython. In general, we can use older versions of PyPy to build newer ones. The PyPy builder is based on the non-builder image.

```sh
docker run --rm -it -v "$(pwd)/tmp:/tmp" jamiehewland/alpine-pypy-build:2.7-7.0.0-alpine3.9
```

## Notes on building PyPy on Alpine Linux
There are a few workarounds for differences between Alpine Linux and the Debian-based Linux distributions that the PyPy team has thus far worked against.

### Issues when building all versions of PyPy
* The standard Python package currently in the Alpine package repositories has an issue that prevents PyPy from compiling. The bootstrap image is based on the Alpine variety of the [`python:2`](https://hub.docker.com/_/python/) Docker image which instead builds Python from source.

### Issues when building PyPy for Python 2
* The `ssl` module fails to compile against Alpine Linux's OpenSSL libraries. It's not clear why this is, but it may be due to issues compiling against OpenSSL 1.1.x. PyPy is instead compiled against LibreSSL, which Alpine previously (versions 3.5-3.8) used as its primary SSL library. LibreSSL (2.7) implements the older OpenSSL 1.0.2 API.

### Issues when building PyPy for Python 3
* RPython expects the `stdin`/`stdout`/`stderr` file handles in `stdio.h` of the standard libc to be of type `FILE*`. With musl these are of type `FILE *const` rather (see [this mailing list thread](https://www.openwall.com/lists/musl/2018/02/02/2)). We patch RPython with the correct type.
