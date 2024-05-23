#---------------- 네트워크 생성-----------------------------------------

# VPC 생성
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "VPC"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = var.az-1
  tags = {
    Name = "Public Subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = var.az-2
  tags = {
    Name = "Public Subnet2"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.az-1
  tags = {
    Name = "Private Subnet1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.az-1
  tags = {
    Name = "Private Subnet2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet3_cidr
  availability_zone = var.az-1
  tags = {
    Name = "Private Subnet3"
  }
}

resource "aws_subnet" "private_subnet_4" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet4_cidr
  availability_zone = var.az-2
  tags = {
    Name = "Private Subnet4"
  }
}

resource "aws_subnet" "private_subnet_5" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet5_cidr
  availability_zone = var.az-2
  tags = {
    Name = "Private Subnet5"
  }
}

resource "aws_subnet" "private_subnet_6" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet6_cidr
  availability_zone = var.az-2
  tags = {
    Name = "Private Subnet6"
  }
}

# 라우팅 테이블 생성 및 연결
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_1association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

# EIP 생성
resource "aws_eip" "my_eip1" {
}

resource "aws_eip" "my_eip2" {
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "my_nat_gateway1" {
  allocation_id = aws_eip.my_eip1.id
  subnet_id     = aws_subnet.public_subnet1.id
}

resource "aws_nat_gateway" "my_nat_gateway2" {
  allocation_id = aws_eip.my_eip2.id
  subnet_id     = aws_subnet.public_subnet2.id
}

# 프라이빗 서브넷에 NAT 라우팅 추가
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway1.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway1.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "private_route_table3" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway1.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "private_route_table4" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway2.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "private_route_table5" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway2.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "private_route_table6" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway2.id
  }
  tags = {
    Name = "Private Route Table"
  }
}
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table2.id
}

resource "aws_route_table_association" "private_subnet_3_association" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table3.id
}

resource "aws_route_table_association" "private_subnet_4_association" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.private_route_table4.id
}

resource "aws_route_table_association" "private_subnet_5_association" {
  subnet_id      = aws_subnet.private_subnet_5.id
  route_table_id = aws_route_table.private_route_table5.id
}

resource "aws_route_table_association" "private_subnet_6_association" {
  subnet_id      = aws_subnet.private_subnet_6.id
  route_table_id = aws_route_table.private_route_table6.id
}

# ----------------------------------------------------------------

# ---------------------------보안 그룹-----------------------------
resource "aws_security_group" "external_alb_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "External ALB Security Group"
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.external_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

resource "aws_security_group" "internal_alb_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Internal ALB Security Group"
  }
}

resource "aws_security_group" "was_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.internal_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Was-SG"
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.was_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-SG"
  }
}
#------------------------------------------------------------------------------

# ------------------------시작 템플릿--------------------------------
resource "aws_launch_template" "web_instance_template" {
  name          = "web-instance-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(file("web_userdata.sh"))

  iam_instance_profile {
    name = "TEST"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web"
    }
  }

  network_interfaces {
    security_groups             = [aws_security_group.web_sg.id]
    associate_public_ip_address = false
  }
}

resource "aws_launch_template" "was_instance_template" {
  name          = "was-instance-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(file("was_userdata.sh"))

  iam_instance_profile {
    name = "TEST"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Was"
    }
  }

  network_interfaces {
    security_groups             = [aws_security_group.was_sg.id]
    associate_public_ip_address = false
  }
}
#--------------------------------------------------------------------

#-------------------Web LB-INSTANCE 연결부분---------------------
resource "aws_autoscaling_group" "web_asg" {
  name = "Web-ASG"
  launch_template {
    id      = aws_launch_template.web_instance_template.id
    version = aws_launch_template.web_instance_template.latest_version
  }
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_4.id]

  depends_on = [aws_lb.internal_alb]
}

resource "aws_lb" "external_alb" {
  name               = "external-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.external_alb_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "Web-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.external_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  lb_target_group_arn    = aws_lb_target_group.web_target_group.arn
}
#---------------------------------------------------------------------


#-------------------Was LB-INSTANCE 연결부분---------------------
resource "aws_autoscaling_group" "was_asg" {
  name = "Was-ASG"
  launch_template {
    id      = aws_launch_template.was_instance_template.id
    version = aws_launch_template.web_instance_template.latest_version
  }
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_5.id]

  depends_on = [aws_db_instance.db]
}

resource "aws_lb" "internal_alb" {
  name               = "Internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb_sg.id]
  subnets            = [aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_5.id]
}

resource "aws_lb_target_group" "was_target_group" {
  name        = "Was-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  health_check {
    path                = "/visitor/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}

resource "aws_lb_listener" "was_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was_target_group.arn
  }
}

resource "aws_autoscaling_attachment" "was_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.was_asg.name
  lb_target_group_arn    = aws_lb_target_group.was_target_group.arn
}
#---------------------------------------------------------------------

#-----------------Database 생성-----------------------------------
# resource "aws_rds_cluster" "rds_cluster" {
#   cluster_identifier = "rds-cluster"
#   availability_zones = ["ap-northeast-2a", "ap-northeast-2b"]
#   database_name             = var.db_name
#   master_username           = var.db_user
#   master_password           = var.db_password
#   engine                    = var.db_engine
#   allocated_storage         = 5
#   db_cluster_instance_class = var.db_instance_class
# }

# resource "aws_rds_cluster_instance" "cluster_instances" {
#   count              = 2
#   identifier         = "rds-instance-${count.index + 1}"
#   cluster_identifier = aws_rds_cluster.rds_cluster.id
#   instance_class     = var.db_instance_class
#   engine             = aws_rds_cluster.rds_cluster.engine
#   engine_version     = aws_rds_cluster.rds_cluster.engine_version
# }
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_3.id, aws_subnet.private_subnet_6.id]
  tags = {
    Name = "DB Subnet Group"
  }
}

resource "aws_db_instance" "db" {
  identifier           = var.db_identifier
  instance_class       = var.db_instance_class
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  allocated_storage    = var.db_allocated_storage
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

# ----------------모니터링-------------------------------
resource "aws_sns_topic" "notification_topic" {
  name = "Notification-Topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = "stdonly99@gmail.com"
}

# Auto Scaling 그룹에 대한 CPU 사용률 지표 수집 설정
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm" {
  alarm_name          = "WebCPUAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.notification_topic.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "was_cpu_alarm" {
  alarm_name          = "WasCPUAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.notification_topic.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.was_asg.name
  }
}

# -----Cloud Watch 대시보드--------
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = jsonencode({
    "widgets" : [
      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "metrics" : [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${aws_autoscaling_group.web_asg.name}"],
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${aws_autoscaling_group.was_asg.name}"]
          ],
          "period" : 300,
          "stat" : "Average",
          "region" : "${var.region}",
          "title" : "Auto Scaling Group CPU Utilization"
        }
      },
      {
        "type" : "metric",
        "x" : 0,
        "y" : 6,
        "width" : 6,
        "height" : 3,
        "properties" : {
          "metrics" : [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${aws_db_instance.db.identifier}"]
          ],
          "period" : 300,
          "stat" : "Average",
          "region" : "${var.region}",
          "title" : "DB CPU Utilization"
        }
      },
      {
        "type" : "metric",
        "x" : 6,
        "y" : 6,
        "width" : 6,
        "height" : 3,
        "properties" : {
          "metrics" : [
            ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${aws_db_instance.db.identifier}"],
            ["AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", "${aws_db_instance.db.identifier}"]
          ],
          "period" : 300,
          "stat" : "Average",
          "region" : "${var.region}",
          "title" : "DB IOPS"
        }
      },
      {
        "type" : "metric",
        "x" : 0,
        "y" : 9,
        "width" : 6,
        "height" : 3,
        "properties" : {
          "metrics" : [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${aws_db_instance.db.identifier}"]
          ],
          "period" : 300,
          "stat" : "Average",
          "region" : "${var.region}",
          "title" : "DB Free Storage Space"
        }
      }
    ]
  })
}

