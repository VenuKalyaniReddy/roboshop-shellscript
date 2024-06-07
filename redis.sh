#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
 
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/-$0-$TIMESTAMP.log"

VALIDATE () {
    
if [ $1 -ne 0 ]
then
    echo -e "$2......$R FAILE $N"
    exit 1
else
    echo -e "$2.......$G SUCESS $N"
fi
}

if [ $? -ne 0 ]
then 
    echo -e "ERROR:: Scripted started executing roor user"
    exit 1
else
    echo "you are root user"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE 
VALIDATE $? "Install redis repo"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Enable the redis"

dnf install redis -y &>> $LOGFILE
VALIDATE $? "Install redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf  &>> $LOGFILE  #s=substitute, g=globel
VALIDATE $? "allowing remote connections"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "Enable Redis"

systemctl start redis &>> $LOGFILE
VALIDATE $? "Start Redis"

