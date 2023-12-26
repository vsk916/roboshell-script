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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>logfile

validate $? "mongo. repo is copied"

dnf install mongodb-org -y &>>logfile

validate $? "Mongodb is installed"

systemctl enable mongod &>>logfile

validate $? "Enabling mongodb"

systemctl start mongod &>>logfile

validate $? "Starting mongodb"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>>logfile

validate $? "Remote access to Mongodb"

systemctl restart mongod &>>logfile

validate $? "restarting mongodb"










