FROM ubuntu:20.04 AS build
RUN apt update \
    && apt install -y \
        gcc \
        g++ \
        gawk \
        autoconf \
        automake \
        python3-cmarkgfm \
        acl \
        libacl1-dev \
        attr \
        libattr1-dev \
        libxxhash-dev \
        libzstd-dev \
        liblz4-dev \
        libssl-dev \
        curl \
        make \
        libpopt-dev \
        libz-dev

RUN curl -O https://download.samba.org/pub/rsync/src/rsync-3.2.6.tar.gz \
    && tar -zxvf rsync-3.2.6.tar.gz \
    && cd rsync-3.2.6 \
    && ./configure \
    && make CFLAGS="-static" EXEEXT="-static"\
    && strip rsync-static



FROM scratch AS rsync

COPY --from=build /rsync-3.2.6/rsync-static /usr/local/bin/rsync

ENTRYPOINT ["/usr/local/bin/rsync"]
CMD ["--help"]
