#!bin/bash

ID =$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.aidevops.website

TIMESTAMP= $(date +%F-%H-%M-%S)
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

dnf module disable nodejs -y $LOGFILE
VALIDATE $? "disable the current nodejs"

dnf module enable nodejs:18 -y $LOGFILE
VALIDATE  $? "enable nodejs18"

dnf install nodejs -y  $LOGFILE
VALIDATE $? "Installing nodejs"

id =roboshop

if [$? -ne 0 ]
then 
    useradd roboshop $LOGFILE
    VALIDATE $? "roboshop user added"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE $? "app directory created"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "download user application"

cd /app 
unzip /tmp/user.zip &>> $LOGFILE
VALIDATE $? "unzip the user application"

npm install &>> $LOGFILE
VALIDATE $? "install dependencies"

cp /home/roboshop-shellscript/user.service /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "copying the user.service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reload daemon"

systemctl enable user  &>> $LOGFILE
VALIDATE $? "enable the user"

systemctl start user &>> $LOGFILE
VALIDATE $? "start the user"

cp /home/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copying the mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Instal mongodb client"

mongo --host $MONGODB_HOST  </app/schema/user.js &>> $LOGFILE
VALIDATE $? "loading the schema"