# Build stage for primecoind
FROM ubuntu:20.04 as primecoin-build
RUN apt update && apt install -y wget

ENV PRIMECOIN_VERSION=0.1.4 \
    PRIMECOIN_SHA=69239cbd7c39d9d08be8a304a488e856ceee592af9f41f882cfd9abebf448873 \
    PRIMECOIN_PREFIX=/opt/primecoin

RUN wget -q -O primecoind https://github.com/primecoin/primecoin/releases/download/v${PRIMECOIN_VERSION}xpm/primecoind-${PRIMECOIN_VERSION}-linux \
    && echo "${PRIMECOIN_SHA}  primecoind" | sha256sum -c -

RUN mkdir -p ${PRIMECOIN_PREFIX}/bin
RUN cp ./primecoind ${PRIMECOIN_PREFIX}/bin/
RUN chmod ugo+rx ${PRIMECOIN_PREFIX}/bin/primecoind

# Build stage for compiled artifacts
FROM ubuntu:20.04

RUN adduser --system primecoin && \
  apt update && \
  apt install -y gosu

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
