#!/bin/bash

set -e
date

#################################################################
#                  Build EXOS from source                       #
#################################################################

build(){
        NPROC=$(nproc)
        echo "nproc: $NPROC"

	cd src
        sudo make -j$NPROC -f makefile.unix
        sudo cp exosd /usr/local/bin/exosd

        echo ""
        echo "Build completed ... copied src/exosd to /usr/local/bin/exosd"
        echo "Run the application by typing 'exosd' at the command prompt"
        exit 0
}

init(){
        config=~/.exos/exos.conf
        if [ ! -e "$config" ]
        then
           mkdir -p ~/.exos && touch $_/exos.conf
           user=$(gpw 1 7)
           password=$(pwgen 13 1)
           echo "daemon=1" >> $config
           echo "server=1" >> $config
           echo "rpcuser=$user" >> $config
           echo "rpcpassword=$password" >> $config
           echo "" >> $config
           echo "logtimestamps=1" >> $config
        fi

        file=/etc/init.d/exos
        if [ ! -e "$file" ]
	then
           { echo "#!/bin/sh"
             echo ""
             echo "### BEGIN INIT INFO"
             echo "# Provides:          exos"
             echo "# Required-Start:    $remote_fs $syslog"
             echo "# Required-Stop:     $remote_fs $syslog"
             echo "# Default-Start:     2 3 4 5"
             echo "# Default-Stop:      0 1 6"
             echo "# Short-Description: exosd initscript"
             echo "# Description:       This script is to be placed under /etc/init.d"
             echo "### END INIT INFO"
             echo ""
             echo "sudo exosd"
           } | sudo tee -a $file > /dev/null
           sudo chmod +x $file
           sudo update-rc.d exos defaults
	fi
}

version() { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

#################################################################
#   Update Ubuntu and install prerequisites for running EXOS    #
#################################################################
sudo apt-get update


#################################################################
#    Install all necessary packages for building EXOS           #
#################################################################
sudo apt-get install -y qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools \
     build-essential libboost-all-dev libssl-dev libdb++-dev libminiupnpc-dev \
     software-properties-common libqrencode-dev gpw pwgen

if [ $(version `lsb_release -rs`) -gt $(version "16.04") ]
then
     sudo apt-get install -y libssl1.0-dev
fi

sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev


init
build


