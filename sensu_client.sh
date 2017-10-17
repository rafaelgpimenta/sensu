#!/bin/bash
echo "Install and Configure Sensu"
sleep 3
wget -O- https://sensu.global.ssl.fastly.net/apt/pubkey.gpg | apt-key add -
cp config/sensu.list /etc/apt/sources.list.d/
apt-get update -y
apt-get install sensu -y
cp config/rabbitmq_client.json /etc/sensu/conf.d/rabbitmq.json
cp config/client.json /etc/sensu/conf.d/
cp config/transport.json /etc/sensu/conf.d/

systemctl start sensu-client
systemctl enable sensu-client
