script=$(reaslpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input rabbitmq_appuser_password  is missing
  exit
fi

component=payment

echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Add application directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Add app content <<<<<<<<<<\e[0m"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip app content <<<<<<<<<<\e[0m"
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>> Install  dependencies <<<<<<<<<<\e[0m"

pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>> setup  systemd service <<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

echo -e "\e[36m>>>>>>>>> Start payment service <<<<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}