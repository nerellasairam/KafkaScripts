#ystemctl start nginx/bin/sh
sleep 5
sudo rm /etc/nginx/conf.d/nginx.conf
sleep 2
sudo cp /tmp/scripts/nginx.conf /etc/nginx/nginx.conf
sleep 2
sudo cp /tmp/scripts/kibana.conf /etc/nginx/conf.d/kibana.conf
sleep 2
sudo systemctl start nginx

sudo systemctl enable nginx

