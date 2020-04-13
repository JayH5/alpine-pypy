FROM python:2.7-alpine3.11
LABEL maintainer "Jamie Hewland <jhewland@gmail.com>"

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
        tar \
        tk \
        tk-dev \
        xz-dev \
        zlib-dev

RUN pip install --no-cache-dir pycparser

# Download the source
ENV PYPY_VERSION 7.3.1
ENV PYPY_SHA256SUM 0c2cc3229da36c6984baee128c8ff8bb4516d69df1d73275dc4622bf249afa83

RUN set -ex; \
    wget -O pypy.tar.bz2 "https://bitbucket.org/pypy/pypy/downloads/pypy3.6-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2

WORKDIR /usr/src/pypy

COPY patches /patches
RUN set -ex; \
    for patch in /patches/*.patch; do \
        patch -p1 -E -i "$patch"; \
    done

COPY ./build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
