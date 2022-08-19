#!/bin/bash

# install packages
sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev libwxgtk3.0-gtk3-dev

# create build dirs
mkdir -p ~/bin
mkdir -p ~/android/lineage

# install repo command
if [ ! -d "~/bin/repo" ] 
then
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
fi

# put bin in execution path
grep -qF 'if [ -d "$HOME/bin" ] ; then' ~/.profile || echo '# set PATH so it includes users private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi' >> ~/.profile

# download platform tools and add in execution path
wget -O platform-tools-latest-linux.zip https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip -d ~
grep -qF 'if [ -d "$HOME/platform-tools" ] ; then' ~/.profile || echo '# add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi' >> ~/.profile

# configure git
git config --global user.email "lennert.franssens@gmail.com"
git config --global user.name "Lennert Franssens"

# speed up builds
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
grep -qF 'ccache -M 50G' ~/.bashrc || echo 'ccache -M 50G' >> ~/.bashrc

cd ~/android/lineage
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1
repo sync
