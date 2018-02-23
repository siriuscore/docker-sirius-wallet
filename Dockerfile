# Berkeley DB
FROM alpine as berkeleydb

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/${BERKELEYDB_VERSION}

RUN apk update &&\
    apk upgrade &&\
    apk --no-cache add autoconf automake build-base libressl &&\
    wget https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz &&\
    tar -xzf *.tar.gz &&\
    sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h &&\
    mkdir -p ${BERKELEYDB_PREFIX} &&\
    cd /${BERKELEYDB_VERSION}/build_unix &&\
    ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX} &&\
    make -j$(nproc) &&\
    make install

# Sirius Core
FROM alpine as sirius-core

ENV SIRIUS_REPO=siriuscore/sirius
ENV SIRIUS_VERSION=0.3
ENV SIRIUS_PREFIX=/opt/sirius-${SIRIUS_VERSION}

COPY --from=berkeleydb /opt /opt

RUN apk update &&\
    apk upgrade &&\
    apk add --no-cache \
        autoconf automake libtool build-base boost-dev \
        chrpath file libevent-dev libressl-dev linux-headers \
        protobuf-dev zeromq-dev jsoncpp-dev &&\
    wget https://github.com/${SIRIUS_REPO}/archive/${SIRIUS_VERSION}.tar.gz &&\
    tar -xzf *.tar.gz &&\
    cd /sirius-${SIRIUS_VERSION} &&\
    sed -i s:sys/fcntl.h:fcntl.h: src/compat.h &&\
    ./autogen.sh &&\
    ./configure LDFLAGS=-L`ls -d /opt/db*`/lib/ CPPFLAGS=-I`ls -d /opt/db*`/include/ \
        --prefix=${SIRIUS_PREFIX} \
        --mandir=/usr/share/man \
        --without-gui \
        --disable-tests \
        --disable-bench \
        --disable-ccache &&\
    make -j$(nproc) &&\
    make install &&\
    strip ${SIRIUS_PREFIX}/bin/sirius-cli &&\
    strip ${SIRIUS_PREFIX}/bin/sirius-tx &&\
    strip ${SIRIUS_PREFIX}/bin/siriusd &&\
    strip ${SIRIUS_PREFIX}/lib/libbitcoinconsensus.a &&\
    strip ${SIRIUS_PREFIX}/lib/libbitcoinconsensus.so.0.0.0

# Sirius Wallet
FROM alpine

LABEL maintainer="David Clutter <cluttered.code@gmail.com>"

ENV SIRIUS_VERSION=0.3
ENV SIRIUS_PREFIX=/opt/sirius-${SIRIUS_VERSION}
ENV PATH=${SIRIUS_PREFIX}/bin:$PATH

ENV STAKING=false
ENV PASSWORD=''

COPY --from=sirius-core /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh

RUN apk update &&\
    apk upgrade &&\
    apk --no-cache add boost boost-random boost-program_options libevent libressl libzmq jsoncpp &&\
    chmod +x /entrypoint.sh

VOLUME ["/root/.sirius"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["siriusd"]