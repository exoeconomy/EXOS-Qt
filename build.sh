#!/bin/bash

set -e
date

#################################################################
#                  Build CivX from source                       #
#################################################################

build(){
        NPROC=$(nproc)
        echo "nproc: $NPROC"

	cd src
        sudo make -j$NPROC -f makefile.unix
        sudo cp civxd /usr/bin/civxd

        echo ""
        echo "Build completed ... copied src/civxd to /usr/bin/civxd"
        echo "Run the application by typing 'civxd' at the command prompt"
        exit 0
}

init(){
        config=~/.civx/civx.conf
        if [ ! -e "$config" ]
        then
           mkdir -p ~/.civx && touch $_/civx.conf
           user=$(gpw 1 7)
           password=$(pwgen 13 1)
           echo "daemon=1" >> $config
           echo "server=1" >> $config
           echo "rpcuser=$user" >> $config
           echo "rpcpassword=$password" >> $config
           echo "" >> $config
           echo "logtimestamps=1" >> $config
        fi

        file=/etc/init.d/civx
        if [ ! -e "$file" ]
	then
	   printf '%s\n%s\n' '#!/bin/sh' 'sudo civxd' | sudo tee /etc/init.d/civx
           sudo chmod +x /etc/init.d/civx
           sudo update-rc.d civx defaults
	fi
}


#################################################################
#   Update Ubuntu and install prerequisites for running CivX    #
#################################################################
sudo apt-get update


#################################################################
#    Install all necessary packages for building CivX           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git gpw pwgen
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev


init
build


