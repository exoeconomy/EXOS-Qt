FROM debian:8-slim as civxd

LABEL maintainer="Ernesto Serrano <ernesto@exolever.com>"


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
        libdb-dev \
        libcrypto++-dev \
        libqrencode-dev \
        libboost-all-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-thread-dev \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-thread-dev \
        libssl-dev \
        libdb++-dev \
        libssl-dev \
        ufw \
        gpw \
        pwgen



# Copying rest of files
COPY . .

RUN cd src/ && make -f makefile.unix

RUN mv src/civxd /usr/bin/

RUN apt-get remove --purge -y build-essential

# RUN mkdir /data

RUN mkdir -p /root/.civx/ && \
    echo "rpcuser=civxrpc" > /root/.civx/civx.conf && \
    echo "rpcpassword=$(pwgen -s 32 1)" >> /root/.civx/civx.conf

#iCMD src/civxd

EXPOSE 16178

ENTRYPOINT ["civxd", "-upnp", "-printtoconsole", "-daemon"]

CMD ["civxd --help"]

#./civxd -upnp -printtoconsole -datadir=/dataxd
