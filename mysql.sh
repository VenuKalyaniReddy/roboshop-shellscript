#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.aidevops.website

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP"&>> $LOGFILE

VALIDATE () {

if [ $1 -ne 0 ]
then

    echo -e "$2........$R FAILED $N" 
    exit 1
else
    echo -e "$2........$G SUCESS $N"
fi
}

if [ $? -ne 0 ]
then

    echo -e "$R ERROR:: Please run this script with root user $N"
    exit 1
else
    echo "You are root user"
fi

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "disable the current mysql"

cp /home/centos/roboshop-shellscript/mysql.repo  /etc/yum.repos.d/mysql.repo
VALIDATE $? "Copying mysql.repo file"

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "Install mysql community server"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "Enable mysql"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "validate mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "Setting  MySQL root password"