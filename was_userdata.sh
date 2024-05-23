#!/bin/bash

# 인스턴스 메타데이터 토큰 가져오기
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# 인스턴스 메타데이터로부터 정보 가져오기
export INSTANCE_ID=$(curl -sH "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-id)
export AVAILABILITY_ZONE=$(curl -sH "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/placement/availability-zone)
export SUBNET_ID=$(curl -sH "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -sH "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/mac)/subnet-id)
export RDS_ENDPOINT=$(aws rds describe-db-instances --region ap-northeast-2 --query "DBInstances[0].Endpoint.Address" --output text)

echo "INSTANCE_ID=${INSTANCE_ID}" | sudo tee -a /etc/environment
echo "AVAILABILITY_ZONE=${AVAILABILITY_ZONE}" | sudo tee -a /etc/environment
echo "SUBNET_ID=${SUBNET_ID}" | sudo tee -a /etc/environment

sudo yum update -y
sudo yum install git -y 
sudo yum install python3-pip -y 

# mysqlclient 설치하기위한 과정 amazon linux 2023에서는 다음과 같은 과정을 해야함------
sudo dnf -y localinstall https://dev.mysql.com/get/mysql80-community-release-el9-4.noarch.rpm
sudo dnf -y install mysql mysql-community-client
sudo yum groupinstall 'Development Tools' -y
sudo yum install python3-devel mysql-devel pkgconfig -y
#----------------------------------------------------------------------------------

# WAS 서버 클론
sudo git clone https://github.com/KimHyoSeob/3tier-was
cd 3tier-was
sudo pip3 install -r requirements.txt

sudo sed -i "s/\$INSTANCE_ID/$INSTANCE_ID/g" ./visitor/templates/visitor/visitor.html
sudo sed -i "s/\$AVAILABILITY_ZONE/$AVAILABILITY_ZONE/g" ./visitor/templates/visitor/visitor.html
sudo sed -i "s/\$SUBNET_ID/$SUBNET_ID/g" ./visitor/templates/visitor/visitor.html
sudo sed -i "s/\$RDS_ENDPOINT/$RDS_ENDPOINT/g" ./khs_3tier/settings.py

# DB 마이그레이션 진행
sudo python3 manage.py migrate

# Was 서버 시작
sudo python3 manage.py runserver 0.0.0.0:80
