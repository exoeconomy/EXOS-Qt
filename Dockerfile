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

FROM debian:8-slim as exosd

WORKDIR /app

COPY --from=builder /app/src/exosd /usr/bin/

RUN apt-get update && apt-get install -y \
        libminiupnpc10 \
        gpw \
        pwgen \
      && rm -rf /var/lib/apt/lists/*

RUN touch client.conf && \
    echo "upnp=1" >> client.conf && \
    echo "rpcuser=rutaniorpc" >> client.conf && \
    echo "rpcpassword=$(pwgen -s 32 1)" >> client.conf && \
    echo "datadir=/app/data" >> client.conf

ENTRYPOINT ["/usr/bin/exosd", "-conf=/app/client.conf"]

