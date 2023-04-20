echo -e "\e[36m>>>>>>>>> Install erlang repos <<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>> Install Rabbitmq repos  <<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>> Install erlang & Rabbitmq  <<<<<<<<<<\e[0m"
yum install erlang rabbitmq-server -y

echo -e "\e[36m>>>>>>>>> Start rabbitmq services  <<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>> Add application user in Rabbitmq  <<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"