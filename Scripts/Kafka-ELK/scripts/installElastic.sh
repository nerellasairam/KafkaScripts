#!/bin/sh

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.0.rpm sha1sum elasticsearch-5.2.0.rpm

sudo rpm --install elasticsearch-5.2.0.rpm

#sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

#sudo systemctl start elasticsearch.service
#sudo systemctl stop elasticsearch.service

#sudo wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.noarch.rpm
#sudo rpm -ivh elasticsearch-1.7.3.noarch.rpm

