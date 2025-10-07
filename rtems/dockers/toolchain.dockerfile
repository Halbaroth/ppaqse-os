FROM alpine:3.14
ENV USER=ppaqse
ENV GROUPNAME=$USER
ENV UID=12345
ENV GID=23456
ENV HOME="/home/$USER"

RUN addgroup \
    --gid "$GID" \
    "$GROUPNAME"

RUN adduser \
    --disabled-password \
    --ingroup "$GROUPNAME" \
    --uid "$UID" \
    "$USER"

RUN apk add \
    bash \
    python3 \
    python3-dev \
    git \
    build-base \
    flex \
    bison \
    sed \
    perl \
    xz \
    bsd-compat-headers

# Ensure that sb-check will found these commands.
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /bin/chgrp       /usr/bin/chgrp  && \
    ln -s /bin/chown       /usr/sbin/chown && \
    ln -s /bin/grep        /usr/bin/grep   && \
    ln -s /bin/sed         /usr/bin/sed    && \
    ln -s /bin/touch       /usr/bin/touch

USER "$USER"
WORKDIR "$HOME"

ENV RTEMS_DIR="$HOME/rtems"

RUN git clone https://gitlab.rtems.org/rtems/tools/rtems-source-builder.git \
    --depth 1 \
    --single-branch \
    --branch "6.1" \
    "$RTEMS_DIR/rsb"

RUN git clone https://gitlab.rtems.org/rtems/rtos/rtems.git \
    --depth 1 \
    --single-branch \
    --branch "6.1" \
    "$RTEMS_DIR/kernel"

ENV RTEMS_PREFIX="$HOME/build/v6"
ENV RSB_DIR="$RTEMS_DIR/rsb"
ENV PATH="$RSB_DIR/source-builder:$PATH"

RUN sb-set-builder \
    --topdir="$RSB_DIR/rtems" \
    --prefix="$RTEMS_PREFIX/tools" \
    "6/rtems-aarch64"
