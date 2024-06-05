#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="\tmp\ $0-$TIMESTAMP.log"
echo "script started exectuing at $TIMESTAMP" &>>$LOGFILE

VALIDATE () {

if [ $1- ne 0 ]

then

    echo -e "$2...$R FAILED $N"
    exit 1
else
    echo -e "$2 ....$G SUCCESS $N"

fi

if [ $ID -ne 0 ]

then

    echo -e "$R ERROR :: Please run this script with root access $N"
    exit 1
else
    echo "you are root user"
fi

}

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling current NODEJS"
dnf module enable nodejs:18 -y &>>$LOGFILE
VALIDATE $? "Enabling the nodejs:18"
dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id roboshop

if [ $? -ne 0 ]
then 
useradd roboshop
VALIDATE $? "roboshop user creation"
else
echo -e "roboshop user already exist $Y SKIPPING $N" &>>$LOGFILE
fi


