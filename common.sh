app_user=roboshop
script=$(reaslpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[36m>>>>>>>>> $1 <<<<<<<<<<\e[0m"
}

func_schema_setup() {

  if [ "schema_setup" == "mongo" ]; then

  func_print_head "Copy MongoDB Repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  func_print_head "Install MongoDB Client"
  yum install mongodb-org-shell -y

  func_print_head "Load Schema "
  mongo --host mongodb-dev.bhaskar77.online </app/schema/${component}.js

fi
}

Func_nodejs() {

  func_print_head "Configuring NodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "Install NodeJs"
  yum install nodejs -y

  func_print_head  "Add Application User "
  useradd ${app_user}

  func_print_head  "Create Application Directory "
  rm -rf /app
  mkdir /app

  func_print_head "Download App content "
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  func_print_head  "Unzip App content"
  unzip /tmp/${component}.zip


  func_print_head  "Install NodeJS Dependencies"
  npm install

  func_print_head "Copy  SystemD file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "Start system Service"

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_schema_setup
}
