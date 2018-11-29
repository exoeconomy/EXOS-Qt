FROM debian:8-slim as builder

LABEL maintainer="Ernesto Serrano <ernesto@exolever.com>"

WORKDIR /app

RUN apt-get update && apt-get install -y \
        libminiupnpc-dev \
        build-essential \
        libdb++-dev \
        libcrypto++-dev \
        libboost-all-dev \
        libssl-dev \
        gpw \
        pwgen

# Copying rest of files
COPY . .

RUN cd src/ && make -f makefile.unix USE_UPNP=1 STATIC=1

FROM debian:8-slim as civxd

WORKDIR /app

COPY --from=builder /app/src/civxd /usr/bin/

RUN apt-get update && apt-get install -y \
        libminiupnpc10 \
        gpw \
        pwgen \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.civx/ && \
    echo "rpcuser=civxrpc" > /root/.civx/civx.conf && \
    echo "rpcpassword=$(pwgen -s 32 1)" >> /root/.civx/civx.conf


EXPOSE 16178

ENTRYPOINT ["civxd", "-upnp", "--daemon"]

CMD ["civxd", "help"]

#./civxd -upnp -printtoconsole -datadir=/dataxd
