FROM python:2.7.13-alpine
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

# Download the source
ENV PYPY_VERSION="5.7.0" \
    PYPY_SHA256="f0f563b74f8b82ec33b022393219b93cc0d81e9f9500614fe8417b67a52e9569"
RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy3-v${PYPY_VERSION}-src" \
    && curl -SLO "https://bitbucket.org/pypy/pypy/downloads/$PYPY_FILE.tar.bz2" \
    && echo "$PYPY_SHA256  $PYPY_FILE.tar.bz2" | sha256sum -c - \
    && mkdir -p /usr/src/pypy \
    && tar -xjC /usr/src/pypy --strip-components=1 -f "$PYPY_FILE.tar.bz2" \
    && rm "$PYPY_FILE.tar.bz2" \
    && apk del curl

WORKDIR /usr/src/pypy

COPY patches /patches
RUN for patch in /patches/*.patch; do patch -p0 -E -i "$patch"; done

COPY ./build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
