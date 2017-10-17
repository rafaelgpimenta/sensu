#!/bin/bash
echo "Install and Configure RabbitMQ"
sleep 3
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
apt-get update -y
apt-get install socat erlang-nox -y
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server_3.6.10-1_all.deb
dpkg -i rabbitmq-server_3.6.10-1_all.deb
apt-get update -y
apt-get install rabbitmq-server -y
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu senha
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

echo "Install Redis Server"
sleep 3
apt-get install redis-server apt-transport-https -y
systemctl start Redis-server
systemctl enable Redis-server

echo "Install and Configure Sensu"
sleep 3
wget -O- https://sensu.global.ssl.fastly.net/apt/pubkey.gpg | apt-key add -
cp config/sensu.list /etc/apt/sources.list.d/
apt-get update -y
apt-get install sensu -y
cp config/rabbitmq.json /etc/sensu/conf.d/
cp config/redis.json /etc/sensu/conf.d/
cp config/api.json /etc/sensu/conf.d/

echo "Install and Configure Sensu Dashboard"
sleep 3
wget -O- https://sensu.global.ssl.fastly.net/apt/pubkey.gpg | apt-key add -
cp config/uchiwa.list /etc/apt/sources.list.d/
apt-get update -y
apt-get install uchiwa -y
cp config/uchiwa.json /etc/sensu/
systemctl start sensu-server
systemctl enable sensu-server
systemctl start sensu-api
systemctl enable sensu-api
systemctl start sensu-client
systemctl enable sensu-client
systemctl start uchiwa
systemctl enable uchiwa

echo "Access Sensu Dashboard"
sleep 3
apt-get install ufw -y
ufw enable
ufw allow 3000
cp config/client.json /etc/sensu/conf.d/
systemctl restart sensu-client

