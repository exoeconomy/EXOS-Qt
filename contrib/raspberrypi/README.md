# EXOS-Qt GUI Wallet on Raspberry Pi 4

---
_August 8, 2019_
## Instructions
Recommended Hardware: Raspberry Pi 4 with 4GB ram and 16GB NOOBS with Raspbian microSD card. A complete package can be ordered here: [Desktop Kit](https://www.raspberrypi.org/products/raspberry-pi-4-desktop-kit/).
## Install the Raspberry Pi
Install a clean Raspberry Pi 4 from the NOOPS by following the user manual. Connect to your network. Change the PW as requested. In this guide I have kept the “pi” username.

Update Raspbian software from the terminal:
```
sudo apt-get update
sudo apt-get dist-upgrade
```
## Set up SSH
It is recommended to have SSH access to the Pi. It means that you can remote access the Pi via Mac (or Windows) terminal. If you run directly from the Pi you can skip this sesction and go to **Install the wallet**. However you will need the SSH connection later if you want to copy an existing wallet onto the Pi.

On the Pi GUI Launch Raspberry Pi `Configuration` from the `Preferences menu`. Navigate to the `Interfaces` tab. Select Enable `SSH` and `OK`.

Open the terminal on the Pi and type:
```
hostname -I
```

 Note the `<IP>` number that looks something like this _192.156.1.222_

Open the Terminal on your computer and type:
```
ssh pi@<IP>
```
followed by your Pi Password. You will now control the Pi from you terminal on your computer (when on the same network). The prompt looks like this:
```
pi@raspberrypi:~ $
```
## Install the wallet
Raspberry Pi 4 runs Raspbian based on the Debiran `buster` release. The wallet was developed on `jessie`, so a few downgrades are needed.

### Prepare the environment
First we must install all the packages needed to compile the binaries for the wallet.

#### Step 1: Remove libssl
```
sudo apt-get remove libssl-dev
```
We will install the right version in the next Step

#### Step 2: Install the packages
```
sudo apt-get install -f build-essential autoconf automake git g++ libtool make unzip wget qt5-default
qt5-qmake qtbase5-dev qtbase5-dev-tools libqt5webkit5 libqt5webkit5-dev libqt5qml5 libqt5quickwidgets5
qml-module-qt-labs-settings qtdeclarative5-dev-tools qttools5-dev-tools libssl1.0-dev libminiupnpc-dev
libqrencode-dev libprotobuf-dev libdb++-dev libboost1.58-all-dev
```
This command will take some time to run, and you need to answer `Y` or `Yes` when asked. Note the following:
* libssl is downgraded to v1.0-dev
* libboost is downgraded to v1.58-all-dev

#### Step 3: Download the EXOS wallet source code from Github
```
git clone https://github.com/exoeconomy/EXOS-Qt
```
If you type `ls`you should see something like this:
```
pi@raspberrypi:~ $ ls
Desktop  Documents  Downloads  EXOS-Qt  MagPi  Music  Pictures  Public  Templates  Videos
pi@raspberrypi:~ $
```
Check that the `EXOS-Qt` folder is there.

### Compile the Binaries
Move to the EXOS-Qt folder.
```
cd EXOS-Qt
```
Generate the make file with (I use `USE_UPNP=-` that is needed when accessing the Pi via SSH):
```
qmake USE_UPNP=-
```
Folowed by
```
make USE_UPNP=-
```
To compile the wallet will take 15 minutes or more. Look out for errors. If you see something like `make: *** [makefile.unix:193: obj/init.o] Error 1` when the compiler stop, there is a error during compilation. Google the error message to investigate what the issue may be. Usually it is a version conflict with the packages.

When the binaries has compiled we can clean up with:
```
strip exos-qt
```

### Launch the GUI wallet on the Pi
On the Pi GUI locate the EXOS-Qt application in the EXOS-Qt folder (look for a Paper Plane Icon). Double click and check that the GUI Wallet is launching. It will immediately start updating the blockchain.


### Copy your wallet to the Pi
If you have an existing wallet exit the EXOS-Qt app on the Pi.
Rename the wallet on the Pi with:
```
mv wallet.dat wallet2.dat
```
Locate the `wallet.dat` file on your computer. Make sure that the EXOS-Qt wallet is not running on the compuuter. Are you on a Mac use the terminal to navigate to the wallet folder:
```
cd ~/Library/Application\ Support/EXOS
```
then
```
scp wallet.dat pi@<IP>:/home/pi/.exos/
```
to copy the wallet from your Mac to the Pi. `<IP>`in this case is the Raspberry Pi IP number we identified with `hostname -I`.

Switch to your Raspberry Pi and check that the wallet has been copied:
```
cd /home/pi/.exos/
ls -al
```
You will see the `wallet2.dat` and the `wallet.dat` copied from the computer.
```
pi@raspberrypi:~/.exos $ ls -al
total 251560
drwxr-xr-x  4 pi pi      4096 Aug  8 12:15 .
drwxr-xr-x 19 pi pi      4096 Aug  6 09:06 ..
-rw-------  1 pi pi 256129311 Aug  8 12:24 blk0001.dat
drwx------  2 pi pi      4096 Aug  6 00:03 database
-rw-------  1 pi pi         0 Aug  6 00:03 db.log
-rw-------  1 pi pi    836858 Aug  8 12:24 debug.log
-rw-------  1 pi pi         0 Aug  6 00:03 .lock
-rw-------  1 pi pi     24314 Aug  8 12:15 peers.dat
drwx------  2 pi pi     12288 Aug  8 12:01 txleveldb
-rw-------  1 pi pi     86016 Aug  6 00:05 wallet2.dat
-rw-r--r--  1 pi pi    475136 Aug  8 11:06 wallet.dat
pi@raspberrypi:~/.exos $

```
You can delete the `wallet2.dat`.

Launch the EXOS-Qt wallet on the Raspberry Pi GUI. You should immediately see you balance and the process to sync the Blockchain will start. Unlock the wallet to start staking.
## Check staking
You can disconnect the Raspberry Pi from screen and keyboard and leave it with power on. If you want to check the staking activities log on to to the Pi with
```
ssh pi@<IP>
```
and then
```
cd /home/pi/.exos/ && grep -B 3 "new proof-of-stake block found" debug.log
```
This command will search the log file and show you transactions recorded for each token received and a time stamp. Time stamps are in UTC. You can also use `ls -al` and check the time stamp of the `blk0001.dat` file. That should be within 1-2 minutes of the current time (local time) when the wallet is running.
