# Build stage for BerkeleyDB
FROM alpine:3.3 as berkeleydb

RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add build-base
RUN apk --no-cache add openssl

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/berkleydb

RUN wget -q https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX}
RUN make -j4
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs

# Build stage for primecoind
FROM alpine:3.3 as primecoin-build

COPY --from=berkeleydb /opt/ /opt/

RUN apk --no-cache add autoconf \
    automake \
    boost-dev \
    build-base \
    chrpath \
    file \
    libevent-dev \
    openssl \
    openssl-dev \
    libtool \
    linux-headers \
    zeromq-dev \
    protobuf-dev

ENV PEERCOIN_VERSION=0.9.0ppc \
    PEERCOIN_SHA=95f4d50706f0eb2c14e3f3b149cbb3e7bfbc71ea33ef3e778dc9a477841a35b5 \
    PRIMECOIN_PREFIX=/opt/primecoin

ARG branch=primecoin-0.16.3
RUN apk --no-cache add git
RUN git clone https://github.com/primecoin/primecoin
RUN cd primecoin && git checkout ${branch} && echo `git status`

WORKDIR /primecoin

# ./configure can't find berkley db unless we do this
RUN ln -s /opt/berkleydb /usr/include/db4.8 \
    && ln -s /opt/berkleydb/include/* /usr/include  \
    && ln -s /opt/berkleydb/lib/* /usr/lib

RUN ./autogen.sh
RUN ./configure \
    --prefix=${PRIMECOIN_PREFIX} \
    --mandir=/usr/share/man \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --with-gui=no \
    --with-utils \
    --with-libs \
    --with-daemon
RUN make -j4
RUN make install
RUN strip ${PRIMECOIN_PREFIX}/bin/primecoin-cli
RUN strip ${PRIMECOIN_PREFIX}/bin/primecoin-tx
RUN strip ${PRIMECOIN_PREFIX}/bin/primecoind
RUN strip ${PRIMECOIN_PREFIX}/lib/libbitcoinconsensus.a
RUN strip ${PRIMECOIN_PREFIX}/lib/libbitcoinconsensus.so.0.0.0

# Build stage for compiled artifacts
FROM alpine:3.3

RUN adduser -S primecoin && \
  apk --no-cache add \
    boost \
    boost-program_options \
    libevent \
    openssl \
    libzmq \
    su-exec \
    bash

ENV XPM_DATA=/data
ENV PRIMECOIN_PREFIX=/opt/primecoin
ENV PATH=${PRIMECOIN_PREFIX}/bin:$PATH
ENV RPC_PASSWORD=xpmpass
ENV RPC_USER=xpmuser

COPY --from=primecoin-build /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["${XPM_DATA}"]

EXPOSE 9911 9912 9913 9914

ENTRYPOINT ["/entrypoint.sh"]

CMD ["primecoind"]
