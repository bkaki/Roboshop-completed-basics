script=$(reaslpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_appuser_password=$1

if [ -z "$mysql_appuser_password" ]; then
  echo input mysql_appuser_password  is missing
  exit
fi

echo -e "\e[36m>>>>>>>>> Disable MySQl 8 version <<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>> copy MySQl repo file  <<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>> Install MySQl  <<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>> start MySQl  <<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>> Restart MySQl password  <<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_appuser_password}
