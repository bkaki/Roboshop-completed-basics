echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Add application directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Add app content <<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip app content <<<<<<<<<<\e[0m"
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>> Install  dependencies <<<<<<<<<<\e[0m"

pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>> setup  systemd service <<<<<<<<<<\e[0m"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>> Start payment service <<<<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable payment
systemctl restart payment