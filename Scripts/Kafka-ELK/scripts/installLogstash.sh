#!/bin/sh

 rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch


sudo wget https://artifacts.elastic.co/downloads/logstash/logstash-5.2.0.rpm


#sudo rpm -i logstash-5.2.0.rpm

sudo rpm --install logstash-5.2.0.rpm

#sudo systemctl daemon-reload
sudo systemctl enable logstash.service

#sudo systemctl start logstash.service


#echo "[logstash-5.x]
#name=Elastic repository for 5.x packages
#baseurl=https://artifacts.elastic.co/packages/5.x/yum
#gpgcheck=1
#gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
#enabled=1
#autorefresh=1
#type=rpm-md" >  sudo /etc/yum.repos.d/logstash.repo 


#sudo yum install logstash
