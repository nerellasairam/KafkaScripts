#!/bin/bash


heat --insecure stack-create  --template-file singleInstance.yaml DEMOELKSTACK

sleep 60

 ip_kafka1=$(heat --insecure output-show DEMOELKSTACK instance_ip_k1 | tee /dev/tty)
 floating_ip_kafka1=$(heat --insecure output-show DEMOELKSTACK ip_k1 | tee /dev/tty)

temp1="${ip_kafka1%\"}"
temp1="${temp1#\"}"

tempp1="${floating_ip_kafka1%\"}"
tempp1="${tempp1#\"}"

echo "[elk-servers]
$tempp1 privateip=$temp1" >> /home/invlab06/Documents/work/ansible/kafka-cluster/hosts


echo "server {
    listen 80;

    server_name $temp1;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}" > /home/invlab06/Documents/work/ansible/kafka-cluster/scripts/kibana.conf

ssh-keyscan $tempp1 >> ~/.ssh/known_hosts
cat ~/.ssh/id_rsa.pub | ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp1 'cat >> .ssh/authorized_keys && echo "Key copied"'

#ssh -t ec2-user@$tempp1 "sudo -- sh -c 'echo $temp1 elkserverkafka >> /etc/hosts'"

ansible-playbook -i /home/invlab06/Documents/work/ansible/kafka-cluster/hosts /home/invlab06/Documents/work/ansible/kafka-cluster/elknew.yml


cp /home/invlab06/Documents/work/ansible/kafka-cluster/scripts/filebeatbackup.yml /home/invlab06/Documents/work/ansible/kafka-cluster/scripts/filebeat.yml
sed -i "s/12.12.12.245/$temp1/g" /home/invlab06/Documents/work/ansible/kafka-cluster/scripts/filebeat.yml

sleep 5

ansible-playbook -i /home/invlab06/Documents/work/ansible/kafka-cluster/hosts /home/invlab06/Documents/work/ansible/kafka-cluster/filebeat.yml


echo "done"
