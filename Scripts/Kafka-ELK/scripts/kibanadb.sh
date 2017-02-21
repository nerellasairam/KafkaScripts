#!/bin/sh

sudo yum -y install unzip

unzip beats-dashboards-*.zip

cd beats-dashboards-*

./load.sh

cd ~

curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json

curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json




