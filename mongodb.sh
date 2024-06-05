#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP= $(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
    echo -e "script started executing at $TIMESTAMP" &>>$LOGFILE

VALIDATE () {

if [ $1 -ne 0 ]
then 
    echo -e "$2......$R FAILED $N"
    exit 1
else
    echo -e "$2.....$G SUCCESS $N"

fi

}

if [ $ID -ne 0 ]

then 
    echo -e "$R ERROR::Please run this script with root access $N"
    exit 1
else
    echo "you are root user "
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copied Mongodb repo"

yum install mongodb-org -y &>>$LOGFILE

VALIDATE $? "Installing Mongodb"

systemctl start mongod &>>$LOGFILE

VALIDATE $? "Enabling Mongodb"

systemctl start mongodb &>>$LOGFILE

VALIDATE $? Starting MongoDb 


