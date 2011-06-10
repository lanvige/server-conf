#!/bin/sh
#
# MongoDB install script
#
# Copyright (c) 2011 Lanvige Jiang <lanvige@gmail.com>
#
## END

echo "Install mongoDB"

echo "Add mongodb user"
sudo useradd -r mongodb

# log file path
sudo mkdir /var/log/mongodb
# data file path
sudo mkdir /var/lib/mongodb
sudo chown mongodb /var/lib/mongodb

echo "Create ~/src to store mongodb source"
mkdir ~/src
cd ~/src

echo "Download the mongodb src and excert to /usr/local"
curl -O http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-1.8.1.tgz
sudo tar zxf ~/src/mongodb-linux-x86_64-1.8.1.tgz -C /usr/local
sudo ln -s /usr/local/mongodb-linux-x86_64-1.8.1 /usr/local/mongodb

echo "Config environment to add mongodb"
export PATH=/usr/local/mongodb/bin/:$PATH

echo "Config init script"
sudo cp ~/src/server-conf/mongod_init /etc/init.d/mongod
sudo chmod +x /etc/init.d/mongod

echo "Installing mongod as a service"
# Install mongod as a service
# /sbin/chkconfig mongod on
sudo update-rc.d mongod defaults

echo "Start the mongodb"
sudo /etc/init.d/mongod start

echo "Don't forget to add below line to your environment"
echo "export PATH='/usr/local/mongodb/bin/:$PATH'"

echo "Installer complete!"