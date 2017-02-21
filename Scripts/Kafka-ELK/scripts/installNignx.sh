#!/bin/sh


sudo yum -y install epel-release

sleep 10
sudo yum -y install nginx httpd-tools

sleep 10
#sudo rm /etc/nginx/conf.d/nginx.conf

#sudo mv /tmp/scripts/nginx.conf /etc/nginx/conf.d/nginx.conf

#sudo mv /tmp/scripts/kibana.conf /etc/nginx/conf.d/kibana.conf

#sudo systemctl start nginx

#sudo systemctl enable nginx
