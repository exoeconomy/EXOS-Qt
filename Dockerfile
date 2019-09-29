FROM debian:8-slim as builder

LABEL maintainer="Ernesto Serrano <ernesto@openexo.com>"

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

FROM debian:8-slim as exosd

WORKDIR /app

COPY --from=builder /app/src/exosd /usr/bin/

RUN apt-get update && apt-get install -y \
        libminiupnpc10 \
        gpw \
        pwgen \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.exos/ && \
    echo "rpcuser=exosrpc" > /root/.exos/exos.conf && \
    echo "rpcpassword=$(pwgen -s 32 1)" >> /root/.exos/exos.conf && \
    echo "upnp=1" >> /root/.exos/exos.conf && \
    echo "datadir=/app/data" >> /root/.exos/exos.conf


EXPOSE 6782

CMD ["exosd"]

