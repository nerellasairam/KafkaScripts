#!/bin/sh

#sudo yum clean all

#sudo yum -y update

sudo yum -y install firewalld

sudo systemctl enable firewalld

sudo systemctl start firewalld

sudo firewall-cmd --permanent --add-port=80/tcp

sudo firewall-cmd --permanent --add-port=443/tcp

#sudo firewall-cmd --zone=public --permanent --add-port=5601/tcp

sudo firewall-cmd --zone=public --permanent --add-port=2181/tcp

sudo firewall-cmd --zone=public --permanent --add-port=2888-3888/tcp

sudo firewall-cmd --zone=public --permanent --add-port=9092/tcp


firewall-cmd --add-port=5044/tcp
firewall-cmd --add-port=5044/tcp --permanent

firewall-cmd --add-port=5601/tcp
firewall-cmd --add-port=5601/tcp --permanent

sudo firewall-cmd --reload
