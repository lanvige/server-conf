#!/bin/sh
#
# MongoDB install script
#
# Copyright (c) 2011 Lanvige Jiang <lanvige@gmail.com>
#
## END

echo "Updating the system"
sudo apt-get update
sudo apt-get upgrade

echo "Install the build essential suit." 
sudo apt-get install build-essential

echo "install git curl"
sudo apt-get install git-core
# for git::: emacsen-common git git-core git-man liberror-perl
sudo apt-get install curl libcurl4-openssl-dev
sudo apt-get install zlib1g-dev gettext
# Install openssl
sudo apt-get install libopenssl-ruby
sudo apt-get install openssl
sudo apt-get install libssl-dev



echo "Install RVM"
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
##?how to auto modify the .bashrc fild
source ~/.bashrc

echo "Install ruby 1.9.2"
rvm install 1.9.2
rvm use 1.9.2 --default

echo "Show ruby version"
ruby --version

echo "Create the gemset and set defautl"
rvm 1.9.2@rails --create
rvm 1.9.2@rails --default

echo "build the zlib for gem"
cd ~/.rvm/src/ruby-1.9.2-p180/ext/zlib
ruby ./extconf.rb
make
make install

echo "Update gemself"
gem update --system

echo "Install rails 3.1.0 rc3"
gem install rails -v '>=3.1.0rc'

echo "Install Passenger"
gem install passenger

echo "Get the passenger path and build the nginx module"
passenger-config --root
cd passenger-config --root/ext/ngin
rvm rake nginx












sudo sh -c "echo '## PPA ###' >> /etc/apt/sources.list"
# ubuntuzilla
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29
sudo sh -c "echo 'deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main #Ubuntuzilla' >>/etc/apt/sources.list"
# mplayer
sudo add-apt-repository ppa:rvm/mplayer
# smplayer
sudo add-apt-repository ppa:rvm/smplayer
# wine
sudo add-apt-repository ppa:ubuntu-wine/ppa
# wine-doors
sudo add-apt-repository ppa:wine-doors-dev-team/ppa
# vlc
sudo add-apt-repository ppa:c-korn/vlc
# getdeb
wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo sh -c "echo 'deb http://archive.getdeb.net/ubuntu karmic-getdeb apps #getdeb' >> /etc/apt/sources.list"
# medibuntu
echo deb http://packages.medibuntu.org/ karmic free non-free | sudo tee -a /etc/apt/sources.list
wget -q http://packages.medibuntu.org/medibuntu-key.gpg -O- | sudo apt-key add -
# ubuntu tweak
sudo add-apt-repository ppa:tualatrix/ppa
# update & upgrade #
sudo apt-get update
sudo apt-get upgrade
# REMOVE some unneeded apps #
sudo apt-get remove gnome-games gnome-games-common empathy
# INSTALL new apps #
sudo apt-get install smbfs nautilus-open-terminal vim mc openvpn geany smplayer minitube firefox-mozilla-build thunderbird-mozilla-build ubuntu-restricted-extras
# INSTALL deb files from directory #
sudo dpkg -i /home/enjoy/.install/deb/*.deb
# make some directories needed by fstab #
sudo mkdir /media/remotemachine
sudo mkdir /media/ntfs
# create samba credential files #
sudo touch /etc/samba/cred
sudo sh -c "echo 'username=yourusername' >> /etc/samba/cred"
sudo sh -c "echo 'password=yourpassword' >> /etc/samba/cred"
sudo chmod 0600 /etc/samba/cred
# add new hosts #
sudo sh -c "echo '192.168.0.105 remotemachinename' >> /etc/hosts"
# add drives to fstab #
sudo sh -c "echo 'UUID=791957C576AE1E67 /media/ntfs ntfs umask=000,utf8 0 0' >> /etc/fstab"
sudo sh -c "echo '//remoteIP/remote-dir /media/remotemachine cifs credentials=/etc/samba/cred,noperm,uid=1000,gid=1000 0 0' >> /etc/fstab"
# fixing umountcifs problem in Ubuntu on restart and shutdown #
sudo cp /home/yourusername/.install/scripts/umountcifs /etc/init.d/
sudo update-rc.d umountcifs stop 02 0 6
sudo ln -s /etc/init.d/umountcifs /etc/rc0.d/K01umountcifs
sudo ln -s /etc/init.d/umountcifs /etc/rc6.d/K01umountcifs
# copy OpenVPN certificates to /etc/openvpn #
sudo cp /home/yourusername/.install/vpn/* /etc/openvpn
sudo /etc/init.d/openvpn restart
# time needed to connect to the VPN server (30s with reserve) and mounting drives #
sleep 30 && sudo mount -a
# turn off pc speaker beeping #
echo "blacklist pcspkr" | sudo tee -a /etc/modprobe.d/blacklist
# turn off welcome sound #
sudo -u gdm gconftool-2 --set /desktop/gnome/sound/event_sounds --type bool false
# enabling cpufreq-applet CPU frequency scaling #
sudo chmod u+s /usr/bin/cpufreq-selector