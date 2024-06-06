#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.aidevops.website

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="\tmp\ $0-$TIMESTAMP.log"
echo "script started exectuing at $TIMESTAMP" &>>$LOGFILE

VALIDATE () {

if [ $1 -ne 0 ]
then
    echo -e "$2...$R FAILED $N"
    exit 1
else
    echo -e "$2 ....$G SUCCESS $N"

fi

}

if [ $? -ne 0 ]

then

    echo -e "$R ERROR :: Please run this script with root access $N"
    exit 1
else
    echo "you are root user"
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling current NODEJS"
dnf module enable nodejs:18 -y &>>$LOGFILE
VALIDATE $? "Enabling the nodejs:18"
dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id roboshop #if roboshop user does not exist, then it is failure

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N" &>>$LOGFILE
fi

mkdir -p /app &>> $LOGFILE #-p means when ever you execute if directory is not abvailable i will create , other wise not

VALIDATE $? "creating app directory "

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE   ## o means we are running so many time scrpt if is not exectued it will executed other wise it showing success

VALIDATE $? "download catalouge application"

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOGFILE  ## o means we are running so many time scrpt if is not exectued it will executed other wise it showing success

VALIDATE $? "Unzip the catalouge application"

#installing depedencies
npm install &>> $LOGFILE

VALIDATE $? "Installling npm dependencies"

#use absolute path because catalouge.service exist there

cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying catalouge.service file"
 
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reload deamond"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enable the catalouge"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "start the catalouge"

#copying monodb.repo file 

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Install mongodb-client"

mongo --host MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Loading catalouge data into mongodb"