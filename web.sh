#!/bin/bash
ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp-$0-$TIMESTAMP.log"

VALIDATE () {

if [ $1 -ne 0 ]
then
    echo -e "$2....$R FAILED $N"
    exir 1
else
    echo -e "$@.....$G SUCESS $N"
fi
}

if [ $? -ne 0 ]
then 
    echo -e "ERROR::Script start using root user"
    exit 1
else
    echo -e "You are root user"
fi

dnf install nginx -y
VALIDATE $? "Install nginx"

systemctl enable nginx
VALIDATE $? "enable nginx"

systemctl start nginx
VALIDATE $? "start nginx"

