#!/bin/sh

ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

sed -i "s/\[ v3_ca \]/\[ v3_ca \]\nsubjectAltName = IP: $ip /g" /etc/pki/tls/openssl.cnf

cd /etc/pki/tls

openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

