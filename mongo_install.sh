#!/bin/sh
#
# MongoDB install script
#
# Copyright (c) 2011 Lanvige Jiang <lanvige@gmail.com>
#
## END

version="2.0.1"
src_path="~/src"
profile_file="~/.bashrc"

echo "The MongoDB $version installation/upgrade will be start"

echo "Please choose you action type"
echo "0: Install (full with user create and init script) "
echo "1: Upgrade (just upgrade the mongo engine)"

read type

# Download and Install
if [ ! -x "$src_path"]; then
	echo "Create ~/src to store mongodb source"
	mkdir ~/src
fi

cd $src_path

echo "Download the mongodb src and excert to /usr/local"
curl -O http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$version.tgz

sudo tar zxf ~/src/mongodb-linux-x86_64-$version.tgz -C /usr/local/
sudo mv /usr/local/mongodb-linux-x86_64-$version.tgz /usr/local/mongodb-$version
sudo ln -s /usr/local/mongodb-$version /usr/local/mongodb


if [ $type -eq i ] ; then
	echo "Add mongodb user"
	sudo useradd -r mongodb

	echo "Create mongodb db path"
	# log file path
	sudo mkdir /var/log/mongodb
	# data file path
	sudo mkdir /var/lib/mongodb
	sudo chown mongodb /var/lib/mongodb

	# Config
	echo "Config environment to add mongodb"
	echo '[[ -s "/usr/local/mongodb/bin/" ]] && source "/usr/local/mongodb/bin/" # Load MongoDB' >> "$profile_file"
	#export 'PATH=/usr/local/mongodb/bin/:$PATH'

	echo "Config init script"
	# Just use conf raw from github.
	curl https://raw.github.com/lanvige/server-conf/master/mongod_init >> ~/src/mongod
	sudo mv ~/src/mongod /etc/init.d/mongod
	sudo chmod +x /etc/init.d/mongod

	echo "Installing mongod as a service"
	# Install mongod as a service
	# /sbin/chkconfig mongod on
	sudo update-rc.d mongod defaults

	echo "Start the mongodb"
	sudo /etc/init.d/mongod start

	echo "Install complete!"
else if [ $type -eq u ] ; then
	echo "Restart the mongodb"
	sudo /etc/init.d/mongod restart

	echo "Upgrade complete!"
fi


