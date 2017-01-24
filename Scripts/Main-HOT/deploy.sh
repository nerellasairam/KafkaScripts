#!/bin/bash

echo "launching the stack"

heat --insecure stack-create  --template-file LaunchInstances.yaml MYSTACK

sleep 80

 ip_kafka1=$(heat --insecure output-show MYSTACK instance_ip_kafka1 | tee /dev/tty)
 ip_kafka2=$(heat --insecure output-show MYSTACK instance_ip_kafka2 | tee /dev/tty)
 ip_kafka3=$(heat --insecure output-show MYSTACK instance_ip_kafka3 | tee /dev/tty)
 floating_ip_kafka1=$(heat --insecure output-show MYSTACK ip_kafka1 | tee /dev/tty)
 floating_ip_kafka2=$(heat --insecure output-show MYSTACK ip_kafka2 | tee /dev/tty)
 floating_ip_kafka3=$(heat --insecure output-show MYSTACK ip_kafka3 | tee /dev/tty)

temp1="${ip_kafka1%\"}"
temp1="${temp1#\"}"

temp2="${ip_kafka2%\"}"
temp2="${temp2#\"}"

temp3="${ip_kafka3%\"}"
temp3="${temp3#\"}"

tempp1="${floating_ip_kafka1%\"}"
tempp1="${tempp1#\"}"

tempp2="${floating_ip_kafka2%\"}"
tempp2="${tempp2#\"}"

tempp3="${floating_ip_kafka3%\"}"
tempp3="${tempp3#\"}"


echo "kafka1 "$temp1
echo "kafka2 is "$temp2

echo "kafka3 is "$temp3

echo "[all]
$tempp1
$tempp2
$tempp3
[zk]
$tempp1
$tempp2
$tempp3
[kafka]
$tempp1 broker_id=1 zooconnect=$temp1:2181,$temp2:2181,$temp3:2181
$tempp2 broker_id=2 zooconnect=$temp1:2181,$temp2:2181,$temp3:2181
$tempp3 broker_id=3 zooconnect=$temp1:2181,$temp2:2181,$temp3:2181 " > /home/invlab06/Documents/work/ansible/kafka-cluster/hosts

ssh-keyscan $tempp1 >> ~/.ssh/known_hosts
ssh-keyscan $tempp2 >> ~/.ssh/known_hosts
ssh-keyscan $tempp3 >> ~/.ssh/known_hosts


cat ~/.ssh/id_rsa.pub | ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp1 'cat >> .ssh/authorized_keys && echo "Key copied"'
cat ~/.ssh/id_rsa.pub | ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp2 'cat >> .ssh/authorized_keys && echo "Key copied"'
cat ~/.ssh/id_rsa.pub | ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp3 'cat >> .ssh/authorized_keys && echo "Key copied"'

ssh -t ec2-user@$tempp1 "sudo sed -i 's/nameserver 192.168.10.2/nameserver 8.8.8.8/g' /etc/resolv.conf"
ssh -t ec2-user@$tempp2 "sudo sed -i 's/nameserver 192.168.10.2/nameserver 8.8.8.8/g' /etc/resolv.conf"
ssh -t ec2-user@$tempp3 "sudo sed -i 's/nameserver 192.168.10.2/nameserver 8.8.8.8/g' /etc/resolv.conf"

ssh -t ec2-user@$tempp1 "sudo -- sh -c 'echo $temp1 kafka1>> /etc/hosts' && sudo -- sh -c 'echo $temp2 kafka2>> /etc/hosts' && sudo -- sh -c 'echo $temp3 kafka3>> /etc/hosts'"
ssh -t ec2-user@$tempp2 "sudo -- sh -c 'echo $temp1 kafka1>> /etc/hosts' && sudo -- sh -c 'echo $temp2 kafka2>> /etc/hosts' && sudo -- sh -c 'echo $temp3 kafka3>> /etc/hosts'"
ssh -t ec2-user@$tempp3 "sudo -- sh -c 'echo $temp1 kafka1>> /etc/hosts' && sudo -- sh -c 'echo $temp2 kafka2>> /etc/hosts' && sudo -- sh -c 'echo $temp3 kafka3>> /etc/hosts'"

echo "keys copy done"
#sleep 15

  zk_cluster_info="{
    'zk-node-1' => {'$temp1' => 1 },
    'zk-node-2' => {'$temp2' => 2 },
    'zk-node-3' => {'$temp3' => 3 },

  }"

  # Note that broker_id must be unique for each host in the cluster. It should ideally not change
  # throughout the lifetime of the Kafka installation on a given machine.
  kafka_cluster_info="{
    'kafka-node-1' => { :broker_id => 1 },
    'kafka-node-2' => { :broker_id => 2 },
    'kafka-node-3' => { :broker_id => 3 }
  }"
echo $zk_cluster_info

echo "zk_cluster_info:
  $tempp1:
    zk_id: 1
  $tempp2:
    zk_id: 2
  $tempp3:
    zk_id: 3" >> /home/invlab06/Documents/work/ansible/kafka-cluster/roles/zookeeper/defaults/main.yml

echo "running ansible"
ansible-playbook -i /home/invlab06/Documents/work/ansible/kafka-cluster/hosts /home/invlab06/Documents/work/ansible/kafka-cluster/main.yml --extra-vars="zk_port=2181 zk_pip=[$ip_kafka1,$ip_kafka1,$ip_kafka1] $zk_cluster_info $kafka_cluster_info"
echo "done"


ssh -t ec2-user@$tempp1 "sudo -- sh -c 'echo advertised.host.name=kafka1 >> /etc/kafka_2.11-0.10.1.0/config/server.properties' && sudo -- sh -c 'service kafka restart'"
ssh -t ec2-user@$tempp2 "sudo -- sh -c 'echo advertised.host.name=kafka2 >> /etc/kafka_2.11-0.10.1.0/config/server.properties' && sudo -- sh -c 'service kafka restart'"
ssh -t ec2-user@$tempp3 "sudo -- sh -c 'echo advertised.host.name=kafka3 >> /etc/kafka_2.11-0.10.1.0/config/server.properties' && sudo -- sh -c 'service kafka restart'"

echo -e "\n ~~~~~~~~~~~~~~~~Sanity test start for server~~~~~~~~~~~~~~~~~~~~~ " $tempp1
ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp1 /home/ec2-user/starttest.sh

echo -e "\n  ~~~~~~~~~~~~~~~~Sanity test for server~~~~~~~~~~~~~~~~~~~~~  " $tempp2
ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp2 /home/ec2-user/starttest.sh

echo -e "\n ~~~~~~~~~~~~~~~~ Sanity test for server~~~~~~~~~~~~~~~~~~~~~  " $tempp3
ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp3 /home/ec2-user/starttest.sh

echo -e "end of sanity test"
