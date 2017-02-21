#!/bin/bash

echo "launching the stack"

heat --insecure stack-create  --template-file LaunchInstances.yaml DEMOKAFKASTACK

sleep 80

 ip_kafka1=$(heat --insecure output-show DEMOKAFKASTACK instance_ip_kafka1 | tee /dev/tty)
 ip_kafka2=$(heat --insecure output-show DEMOKAFKASTACK instance_ip_kafka2 | tee /dev/tty)
 ip_kafka3=$(heat --insecure output-show DEMOKAFKASTACK instance_ip_kafka3 | tee /dev/tty)
 floating_ip_kafka1=$(heat --insecure output-show DEMOKAFKASTACK ip_kafka1 | tee /dev/tty)
 floating_ip_kafka2=$(heat --insecure output-show DEMOKAFKASTACK ip_kafka2 | tee /dev/tty)
 floating_ip_kafka3=$(heat --insecure output-show DEMOKAFKASTACK ip_kafka3 | tee /dev/tty)

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

echo "[kafka-servers]
$tempp1 broker_id=1 private_ip1=$temp1 private_ip2=$temp2 private_ip3=$temp3 host_name=kafka1
$tempp2 broker_id=2 private_ip1=$temp1 private_ip2=$temp2 private_ip3=$temp3 host_name=kafka2
$tempp3 broker_id=3 private_ip1=$temp1 private_ip2=$temp2 private_ip3=$temp3 host_name=kafka3" > /home/invlab06/Documents/work/ansible/kafka-cluster/hosts


echo "
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/tmp/zookeeper
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
server.1=$temp1:2888:3888
server.2=$temp2:2888:3888
server.3=$temp3:2888:3888" > ~/Documents/work/ansible/kafka-cluster/scripts/zoo.cfg


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


echo "running ansible"

ansible-playbook -i /home/invlab06/Documents/work/ansible/kafka-cluster/hosts /home/invlab06/Documents/work/ansible/kafka-cluster/kafka.yml

echo "kafka cluster is deployed"


echo -e "\n ~~~~~~~~~~~~~~~~Sanity test start~~~~~~~~~~~~~~~~~~~~~ "
ssh -i ~/Documents/work/ansible/ubuntu.key ec2-user@$tempp1 /home/ec2-user/starttest.sh
echo -e "end of sanity test"


echo -e "\n ~~~~~~~~~~~~~~~~ELK script start~~~~~~~~~~~~~~~~~~~~~ "


. /home/invlab06/Documents/work/ServiceAssurance/Kafka-Launch/deployELK.sh
