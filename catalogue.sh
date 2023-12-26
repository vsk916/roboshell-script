#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
timestamp=$(date +%F-%H-%M-%S)

logfile="/tmp/$0-$timestamp.log"

echo "Script started executing at $timestamp" &>> $logfile

validate () {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is $R.........failure$N"
    else
        echo -e "$2 is $G.........success$N"
    fi

    }

    if [ $ID -ne 0 ]
then 
    echo -e "$R Error you are not in the root user$N"
else
    echo "You are in the root user"
fi

dnf module disable nodejs -y

validate $? "Disabling current nodejs"

dnf module enable nodejs:18 -y

validate $? "Enabling current nodejs"

dnf install nodejs -y

validate $? "Installing nodejs"

useradd roboshop

validate $? "Adding user"

mkdir /app

validate $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

validate $? "Downloading the application in tmp folder"

cd /app 

unzip /tmp/catalogue.zip

validate $? "Unzipping catalogue"

npm install 

validate $? "Installing dependencies"

cp /home/centos/roboshell-script/catalogue.service /etc/systemd/system/catalogue.service

validate $? "coping the catalogue service file"

systemctl daemon-reload

validate $? "daemon reload"

systemctl enable catalogue

validate $? "Enabling catalogue service"

systemctl start catalogue

validate $? "Starting catalogue service"

cp /home/centos/roboshell-script/mongo.repo /etc/yum.repos.d/mongo.repo

validate $? "coping mongodb repo"

dnf install mongodb-org-shell -y

validate $? "Installing mongodb client"

mongo --host mongodb.devopv.online </app/schema/catalogue.js

validate $? "Loading catalogue data in to mongodb"











