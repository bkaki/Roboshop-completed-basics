script=$(reaslpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$mysql_appuser_password" ]; then
  echo input mysql_appuser_password  is missing
  exit
fi

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
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"