FROM ocaml/opam:alpine-ocaml-5.3
ENV USER=docker
ENV GROUPNAME="$USER"
ENV UID=12345
ENV GID=12345
ENV OPAMYES=yes

USER root
RUN rm /usr/bin/opam && ln -s /usr/bin/opam-2.4 /usr/bin/opam

RUN addgroup     \
    --gid "$GID" \
    "$GROUPNAME"
RUN adduser                \
    --disabled-password    \
    --uid "$UID"           \
    --ingroup "$GROUPNAME" \
    "$USER"

RUN apk add        \
    neovim         \
    libseccomp-dev \
    linux-headers  \
    xen

USER docker
WORKDIR /home/docker
RUN opam init
RUN opam install             \
    mirage                   \
    mirage-bootvar           \
    mirage-crypto-rng-mirage \
    mirage-mtime             \
    mirage-ptime             \
    mirage-runtime           \
    mirage-sleep             \
    mirage-xen               \
    ocaml-solo5              \
    opam-monorepo            \
    solo5

COPY --chown=docker:docker ./examples /home/docker/examples
