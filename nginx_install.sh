#!/bin/sh
#
# Nginx 1.0.2 with passenger install script
#
# Copyright (c) 2011 Lanvige Jiang <lanvige@gmail.com>
## END

echo "Install libpcre3-dev from apt"
sudo apt-get install libpcre3-dev

mkdir ~/src
cd ~/src
sudo mkdir /var/tmp/nginx
sudo mkdir /var/tmp/nginx/client
sudo mkdir /var/log/nginx

echo "Download nginx src"
curl -O http://nginx.org/download/nginx-1.0.2.tar.gz
tar zxvf nginx-1.0.2.tar.gz
cd nginx-1.0.2

echo "Build and install nginx 1.0.2"
./configure --prefix='/usr/local/nginx-1.0.2' --with-http_ssl_module --add-module='/home/ubuntu/.rvm/gems/ruby-1.9.2-p180@rails/gems/passenger-3.0.7/ext/nginx' --conf-path='/etc/nginx/nginx.conf'  --pid-path='/var/run/nginx.pid'  --lock-path=/var/lock/nginx.lock  --http-log-path=/var/log/nginx/access.log  --error-log-path=/var/log/nginx/error.log  --with-http_stub_status_module  --with-http_gzip_static_module  --http-client-body-temp-path=/var/tmp/nginx/client/  --http-proxy-temp-path=/var/tmp/nginx/proxy/
make
sudo make install
sudo ln -s /usr/local/nginx-1.0.2/ /usr/local/nginx

echo 'Prepare the NGINX init script'
sudo cp nginx /etc/init.d/nginx
#sudo chown root:root /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx

echo "Start the nginx server"
sudo /etc/init.d/nginx start
sudo /etc/init.d/nginx status

echo "Start the start init script"
sudo /usr/sbin/update-rc.d -f nginx defaults
