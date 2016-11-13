FROM jamiehewland/alpine-pypy:2-5.4.0-slim
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
        tar \
        tk \
        tk-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION="5.4.1" \
    PYPY_SHA256="45dbc50c81498f6f1067201b8fc887074b43b84ee32cc47f15e7db17571e9352"
RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy2-v${PYPY_VERSION}-src" \
    && curl -SLO "https://bitbucket.org/pypy/pypy/downloads/$PYPY_FILE.tar.bz2" \
    && echo "$PYPY_SHA256  $PYPY_FILE.tar.bz2" | sha256sum -c - \
    && mkdir -p /usr/src/pypy \
    && tar -xjC /usr/src/pypy --strip-components=1 -f "$PYPY_FILE.tar.bz2" \
    && rm "$PYPY_FILE.tar.bz2" \
    && apk del curl

WORKDIR /usr/src/pypy

COPY patches /patches
RUN for patch in /patches/*.patch; do patch -p0 -E -i "$patch"; done

COPY build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
