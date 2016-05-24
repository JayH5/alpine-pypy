# alpine-pypy
Docker-based builds for [PyPy](http://pypy.org) on [Alpine Linux](http://www.alpinelinux.org).

Currently, PyPy is only built for [glibc](https://www.gnu.org/software/libc/)/GNU-based Linux distributions, namely, Debian and Ubuntu. Recently, the Alpine Linux distribution has been gaining in popularity as a base OS for containers, due to its small size and container-friendly tools. A big way that Alpine achieves its small size is through its use of [musl](https://www.musl-libc.org) as its C standard library and [BusyBox](https://busybox.net) as its set of Unix tools. This means that PyPy binaries compiled for glibc/GNU are not compatible with Alpine Linux.

This repository seeks to make it easy to build PyPy for Alpine Linux.

## Docker images
There are 3 Dockerfiles in this repo. Two are for compiling PyPy itself, and the third seeks to be a minimal PyPy image based on Alpine. The images are as follows:

* [`alpine-pypy:python-build`](python-build.dockerfile)): An image to build PyPy from source using cPython.
* [`alpine-pypy:pypy-build`](pypy-build.dockerfile)): An image to build PyPy from source using an existing PyPy binary.
* [`alpine-pypy`](Dockerfile): A minimal PyPy Docker image.

## Building
### From scratch
PyPy requires a Python implementation in order to build itself. The recommended implementation to use is PyPy itself as it is much faster than standard cPython. But if you don't have a PyPy binary in the first place you'll have to settle for cPython.

The first step is to get the `python-build` image which you can either build from source or pull from Docker Hub:
```sh
docker build -t alpine-pypy:python-build -f python-build.dockerfile .
```
or..
```sh
docker pull jamiehewland/alpine-pypy:python-build
```

Then things should be as simple as running the container with a mounted volume:
```sh
docker run --rm -it -v "$(pwd)/tmp:/tmp" jamiehewland/alpine-pypy:python-build
```

Unless you have a really fast computer this will take several hours. As [the PyPy people say](http://pypy.org/download.html#building-from-source): Enjoy Mandelbrot `:-)`.

Once this is all done, the built PyPy package should be at `./tmp/usession-release-$PYPY_VERSION-1/build` on the container host.

### With an existing PyPy binary
PyPy compiles several times faster using itself rather than cPython. In general, we can use older versions of PyPy to build newer ones. The PyPy builder is based on the non-builder image.

```sh
docker run --rm -it -v "$(pwd)/tmp:/tmp" jamiehewland/alpine-pypy:pypy-build
```

## Notes on building PyPy on Alpine Linux
There are a few workarounds for differences between Alpine Linux and the Debian-based Linux distributions that the PyPy team has thus far worked against.

* The standard Python package currently in the Alpine package repositories has an issue that prevents PyPy from compiling. The `alpine-pypy:python-build` image is based on the [`python:2-alpine`](https://hub.docker.com/_/python/) Docker image which instead builds Python from source.
* The tk/tcl libraries for Alpine have slightly non-standard names and paths. The PyPy script for building the CFFI bindings for tk in the Python standard library have a very simplistic way of looking up library locations. We instead patch that script to point to the correct files. It's also easy to switch off the compilation of the tk bindings completely by setting the `PYPY_PACKAGE_WITHOUTTK` environment variable to any value.
* The PyPy script for compressing the package expects that `tar` running on Linux supports the `--owner` and `--group` flags -- BusyBox's does not. We simply `sed` out those flags in the script `:-/`.
