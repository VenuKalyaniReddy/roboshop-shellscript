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
    exit 1
else
    echo -e "$2.....$G SUCESS $N"
fi
}

if [ $? -ne 0 ]
then 
    echo -e "ERROR::Script start using root user"
    exit 1
else
    echo -e "You are root user"
fi

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Install nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "removed default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "Downloaded web application"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "moving nginx html directory"

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzipping web"

cp /home/centos/roboshop-shellscript/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE 
VALIDATE $? "copied roboshop reverse proxy config"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "restarted nginx"
