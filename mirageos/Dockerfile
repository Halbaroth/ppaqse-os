FROM ocaml/opam:ubuntu-25.04-ocaml-5.3
ENV OPAMYES=yes

USER root
RUN rm /usr/bin/opam && ln -s /usr/bin/opam-2.4 /usr/bin/opam

RUN apt-get install -y  \
    neovim
#    gmp-dev        \
#    libffi-dev     \
#    openssl-dev    \
#    pcre-dev       \
#    zlib-dev       \
#    libseccomp-dev \
#    linux-headers  \
#    xen

USER opam
RUN opam init --bare
RUN opam switch create default ocaml-variants.4.14.2+options ocaml-option-fp
RUN opam install             \
    mirage                   \
    mirage-bootvar           \
    mirage-crypto-rng-mirage \
    mirage-mtime             \
    mirage-ptime             \
    mirage-runtime           \
    mirage-sleep             \
    mirage-xen               \
    memtrace                 \
    memtrace-mirage          \
    memtrace_viewer          \
    ocaml-solo5              \
    opam-monorepo            \
    solo5

COPY --chown=opam:opam ./examples /home/opam/examples
