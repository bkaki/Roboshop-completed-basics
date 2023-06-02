script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_appuser_password" ]; then
  echo input mysql_appuser_password is missing
  exit
fi


echo -e "\e[36m>>>>>>>>> Install Maven <<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>> Create application user <<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Create application directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download app content <<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>> unzip app content <<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>> Download maven dependencies <<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>> Install MySql <<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[36m>>>>>>>>> setup systemd services <<<<<<<<<<\e[0m"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>> Load schema <<<<<<<<<<\e[0m"
mysql -h mysql-dev.bhaskar77.online -uroot -p${mysql_userapp_password} < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>> restart system services <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping
