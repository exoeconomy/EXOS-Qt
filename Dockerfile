FROM debian:8-slim as builder

LABEL maintainer="Ernesto Serrano <ernesto@exolever.com>"

WORKDIR /app

# Install build deps, then run `pip install`, then remove unneeded build deps all in a single step. Correct the path to your production requirements fil
RUN apt-get update && apt-get install -y \
        # libboost \
        # libdb \
        # miniupnpc \
        # libqrencode3 \
        # libssl \
        # build-essential \
        # libboost-dev \
        # libdb-dev \
        libminiupnpc-dev \
        # libqrencode-dev \
        # libssl-dev \
        build-essential \
        libdb++-dev \
        # libdb-dev \
        libcrypto++-dev \
        # libqrencode-dev \
        libboost-all-dev \
        # libboost-system-dev \
        # libboost-filesystem-dev \
        # libboost-program-options-dev \
        # libboost-thread-dev \
        # libboost-filesystem-dev \
        # libboost-program-options-dev \
        # libboost-thread-dev \
        libssl-dev \
        # ufw \
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
        # libdb5.3++ \
        # libcrypto++ \
        # libqrencode3 \
        # libboost-all-dev \
        # libboost-system-dev \
        # libboost-filesystem-dev \
        # libboost-program-options-dev \
        # libboost-thread-dev \
        # libboost-filesystem-dev \
        # libboost-program-options-dev \
        # libboost-thread-dev \
        # libssl1.0.0 \
        # ufw \
        gpw \
        pwgen \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.civx/ && \
    echo "rpcuser=civxrpc" > /root/.civx/civx.conf && \
    echo "rpcpassword=$(pwgen -s 32 1)" >> /root/.civx/civx.conf


EXPOSE 16178

#ENTRYPOINT ["civxd", "-upnp", "-printtoconsole", "-daemon"]

CMD ["civxd", "help"]

#./civxd -upnp -printtoconsole -datadir=/dataxd
