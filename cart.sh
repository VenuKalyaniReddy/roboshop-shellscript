#!/bi/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

VALIDATE() {
if [ $1 -ne 0 ]
then
    echo -e "$2 ......$R FAILED $N"
    exit 1
else
    echo -e "$2 ......$R SUCCESS $N"
fi
}

if [ $? -ne 0 ]
then
    echo -e "ERROR::Script started root user"
    exit 1
else
    echo "you are root user"
fi

dnf module disable nodejs -y
VALIDATE $? "Disable current nodejs"

dnf module enable nodejs:18 -y
VALIDATE $? "Enable current nodejs"

dnf install nodejs -y
VALIDATE $? "Install nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    echo -e "create roboshop user"
    useradd roboshop
else
    echo -e "roboshop user already created"
fi

mkdir -p /app
VALIDATE $? "craeting app directory"

cd /app 
VALIDATE $? "Enter into app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "Download cart application into app directory"

unzip -o /tmp/cart.zip
VALIDATE $? "Unzip the directory"

npm install 
VALIDATE $? "Install the dependencies"

cp /home/centos/roboshop-shellscript/cart.service /etc/systemd/system/cart.service
VALIDATE $? "copying the cart.service file"

systemctl daemon-reload
VALIDATE $? "realod-deamond"

systemctl enable cart 
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"


