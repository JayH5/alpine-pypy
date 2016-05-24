FROM python:2.7.11-alpine
MAINTAINER Jamie Hewland <jhewland@gmail.com>

# Add build dependencies
RUN apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        expat-dev \
        gcc \
        gdbm-dev \
        libc-dev \
        libffi-dev \
        linux-headers \
        make \
        ncurses-dev \
        openssl-dev \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tk-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION 5.1.1
RUN apk add --no-cache curl \
    && curl -fSL "https://bitbucket.org/pypy/pypy/downloads/pypy-$PYPY_VERSION-src.tar.bz2" -o pypy.tar.bz2 \
    && mkdir -p /usr/src \
    && tar -xjC /usr/src -f pypy.tar.bz2 \
    && mv "/usr/src/pypy-$PYPY_VERSION-src" /usr/src/pypy \
    && rm pypy.tar.bz2 \
    && apk del curl

COPY ./build.sh /build.sh

VOLUME /tmp

WORKDIR /usr/src/pypy
CMD ["/build.sh"]
