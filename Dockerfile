FROM alpine:3.4
MAINTAINER Jamie Hewland <jhewland@gmail.com>

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# PyPy runtime dependencies
RUN apk add --no-cache \
        expat \
        libbz2 \
        libffi \
        ncurses-libs \
        sqlite-libs

ENV PYPY_VERSION="5.3.0" \
    PYPY_SHA256="3de8b074b2022bf92f4038e83af934e6aa3a57e198976292c0320e85c3882922"
# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.1.2

RUN set -x \
    && apk add --no-cache curl \
    && PYPY_FILE="pypy2-v${PYPY_VERSION}-linux64" \
    && curl -SLO "https://github.com/JayH5/alpine-pypy/releases/download/$PYPY_VERSION/$PYPY_FILE.tar.bz2" \
    && echo "$PYPY_SHA256  $PYPY_FILE.tar.bz2" | sha256sum -c - \
    && tar -xjf "$PYPY_FILE.tar.bz2" \
    && mv "$PYPY_FILE"/* /usr/local \
    && rm -r "$PYPY_FILE.tar.bz2" "$PYPY_FILE" \
    && curl -SL 'https://bootstrap.pypa.io/get-pip.py' | pypy \
    && pip install --upgrade pip==$PYTHON_PIP_VERSION \
    && apk del curl

CMD ["pypy"]
