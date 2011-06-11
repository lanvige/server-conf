#!/bin/sh
#
# Install Ruby 1.9.2-p180 with zlib, openssl module by ^RVM^ and Rails 3.1.0 RC3 script
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
sudo apt-get install openssl libssl-dev
sudo apt-get install libopenssl-ruby

# Some gem (nokogiri) need this lib
sudo apt-get install libxslt1-dev

# Install sqlite3 lib
sudo apt-get install sqlite3 libsqlite3-dev


echo "Install RVM"
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

echo "Using the bashrc templete to replace default"
# rvm need modify many palces, so just replace is quick way.
sudo cp ~/src/server-conf/bashrc ~/.bashrc
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
ruby extconf.rb
make
make install

echo "Install openssl for ruby"
cd ~/.rvm/src/ruby-1.9.2-p180/ext/openssl 
ruby extconf.rb 
make  
make install


echo "Update gemself"
gem update --system

echo "Install rails 3.1.0 rc3"
gem install rails -v '>=3.1.0rc3'

echo "Install Passenger"
gem install passenger

echo "Get the passenger path and build the nginx module"
passenger-config --root
cd `passenger-config --root`/ext/ngin
rvm rake nginx