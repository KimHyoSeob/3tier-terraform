#!/bin/bash

# 패키지 설치
sudo yum update -y
sudo yum install -y git nginx

# 인스턴스 메타데이터 토큰 가져오기
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# 인스턴스 메타데이터로부터 정보 가져오기
export INSTANCE_ID=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
export AVAILABILITY_ZONE=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
export SUBNET_ID=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/mac)/subnet-id)
export INTERNAL_LB_DNS=$(aws elbv2 describe-load-balancers --region ap-northeast-2 --names Internal-alb --query "LoadBalancers[0].DNSName" --output text)

# 환경 변수 설정
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee -a /etc/environment
echo "AVAILABILITY_ZONE=$AVAILABILITY_ZONE" | sudo tee -a /etc/environment
echo "SUBNET_ID=$SUBNET_ID" | sudo tee -a /etc/environment


# 정적 웹 페이지 클론
git clone https://github.com/KimHyoSeob/3tier-web

# 정적 웹 파일을 nginx 디렉토리로 복사
sudo cp -r 3tier-web/. /usr/share/nginx/html/

# Nginx 설정 파일을 옮기기
sudo cp 3tier-web/nginx.conf /etc/nginx/.

sudo sed -i "s/\$INSTANCE_ID/$INSTANCE_ID/g" /usr/share/nginx/html/home.html
sudo sed -i "s/\$AVAILABILITY_ZONE/$AVAILABILITY_ZONE/g" /usr/share/nginx/html/home.html
sudo sed -i "s/\$SUBNET_ID/$SUBNET_ID/g" /usr/share/nginx/html/home.html
sudo sed -i "s/\$INTERNAL_LB_DNS/$INTERNAL_LB_DNS/g" /etc/nginx/nginx.conf

# Nginx 재시작
sudo systemctl restart nginx

