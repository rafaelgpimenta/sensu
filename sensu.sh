echo "Install and Configure RabbitMQ"
sleep 3
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install socat erlang-nox -y
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server_3.6.10-1_all.deb
sudo dpkg -i rabbitmq-server_3.6.10-1_all.deb
sudo apt-get update -y
sudo apt-get install rabbitmq-server -y
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo rabbitmqctl add_vhost /sensu
sudo rabbitmqctl add_user sensu senha
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

echo "Install Redis Server"
sleep 3
sudo apt-get install redis-server apt-transport-https -y
sudo systemctl start Redis-server
sudo systemctl enable Redis-server

echo "Install and Configure Sensu"
sleep 3
wget -O- https://sensu.global.ssl.fastly.net/apt/pubkey.gpg | sudo apt-key add -
cp config/sensu.list /etc/apt/sources.list.d/
sudo apt-get update -y
sudo apt-get install sensu -y
cp config/rabbitmq.json /etc/sensu/conf.d/
cp config/redis.json /etc/sensu/conf.d/
cp config/api.json /etc/sensu/conf.d/

echo "Install and Configure Sensu Dashboard"
sleep 3
wget -O- https://sensu.global.ssl.fastly.net/apt/pubkey.gpg | sudo apt-key add -
cp config/uchiwa.list /etc/apt/sources.list.d/
sudo apt-get update -y
sudo apt-get install uchiwa -y
cp config/uchiwa.json /etc/sensu/conf.d/
sudo systemctl start sensu-server
sudo systemctl enable sensu-server
sudo systemctl start sensu-api
sudo systemctl enable sensu-api
sudo systemctl start sensu-client
sudo systemctl enable sensu-client
sudo systemctl start uchiwa
sudo systemctl enable uchiwa

echo "Access Sensu Dashboard"
sleep 3
sudo apt-get install ufw -y
sudo ufw enable
sudo ufw allow 3000
cp config/client.json /etc/sensu/conf.d/
sudo systemctl restart sensu-client

