#!/bin/bash

sleep 10
topicname="topic$$"

echo -e "~~~~~~~~~ creating topic  ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --zookeeper kafka1:2181 --create --topic $topicname --replication-factor 3 --partitions 1
sleep 3

echo -e "\n~~~~~~~~~ running list of topics command from kafka1  ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --list --zookeeper kafka1:2181

sleep 2

echo -e "~~~~~~~~~ creating topic to test delete  ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --zookeeper kafka1:2181 --create --topic topicdelete --replication-factor 3 --partitions 1

sleep 3

echo -e "\n~~~~~~~~~ running list of topics command   ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --list --zookeeper kafka1:2181

sleep 2

echo -e "~~~~~~~~~ creating topic to test delete  ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --zookeeper kafka1:2181 --delete --topic topicdelete

sleep 3

echo -e "\n~~~~~~~~~ running list of topics after deleting topic   ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --list --zookeeper kafka1:2181

sleep 2

echo -e  "\n~~~~~~~~~ posting message on created topic ~~~~~~~~~"
echo " Hi Kafka , Have a nice day. Thankyou." > /home/ec2-user/new.txt
echo "Hi Kafka , Have a nice day. Thankyou."

sleep 3

/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-console-producer.sh --broker-list kafka1:9092 --topic $topicname < /home/ec2-user/new.txt

echo -e "\n~~~~~~~~~ consuming the message from topic ~~~~~~~~~"
/home/ec2-user/kafka_2.11-0.10.1.0/bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic $topicname --from-beginning &
TASK_PID=$!

sleep 2

kill -15 $TASK_PID
#sleep 2
exit
