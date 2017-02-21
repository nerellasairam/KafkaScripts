#!/bin/sh

sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-x86_64.rpm sha1sum kibana-5.2.0-x86_64.rpm

sudo rpm --install kibana-5.2.0-x86_64.rpm
sleep 15
sudo systemctl daemon-reload
sudo systemctl enable kibana.service

#sudo systemctl start kibana.service
#sudo systemctl stop kibana.service


