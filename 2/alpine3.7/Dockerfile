FROM jamiehewland/alpine-pypy:2-5.10.0-alpine3.7
LABEL maintainer "Jamie Hewland <jhewland@gmail.com>"

# Add build dependencies
RUN apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        expat-dev \
        gcc \
        gdbm-dev \
        libc-dev \
        libffi-dev \
        libressl-dev \
        linux-headers \
        make \
        ncurses-dev \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tar \
        tk \
        tk-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION 5.10.0
ENV PYPY_SHA256SUM 1209f2db718e6afda17528baa5138177a14a0938588a7d3e1b7c722c483079a8

RUN set -ex; \
    apk add --no-cache wget; \
    wget -O pypy.tar.bz2 "https://bitbucket.org/pypy/pypy/downloads/pypy2-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2; \
    apk del wget

WORKDIR /usr/src/pypy

COPY build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
