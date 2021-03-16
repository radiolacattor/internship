//Provider
provider "aws" {}

//VPC subnet
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "public_eu_central_1a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Public Subnet eu-central-1a"
  }
}

resource "aws_subnet" "public_eu_central_1b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Public Subnet eu-central-1b"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = {
    Name = "Public Subnets Route Table for My VPC"
  }
}

resource "aws_route_table_association" "my_vpc_eu-central-1a_public" {
  subnet_id = aws_subnet.public_eu_central_1a.id
  route_table_id = aws_route_table.my_vpc_public.id
}

resource "aws_route_table_association" "my_vpc_eu-central-1b_public" {
  subnet_id = aws_subnet.public_eu_central_1b.id
  route_table_id = aws_route_table.my_vpc_public.id
}
//ASG
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound connections"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP Security Group"
  }
}
//ALC
resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = "ami-0de9f803fcac87f46" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"

  security_groups = [ aws_security_group.allow_http.id ]
  associate_public_ip_address = true

  user_data = <<EOF
  #!/bin/bash
  sudo amazon-linux-extras install nginx1
  myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>Web Server with IP: $myip<h2><br>Build by Terraform" > /usr/share/nginx/html/index.html
  sudo service nginx start
  chkconfig nginx on 
  EOF  
  lifecycle {
    create_before_destroy = true
  }
}
//ELB
resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
  aws_security_group.elb_http.id
  ]
  subnets = [
  aws_subnet.public_eu_central_1a.id,
  aws_subnet.public_eu_central_1b.id
  ]

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}
//AutoScallingGroup
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"

  min_size             = 1
  desired_capacity     = 1
  max_size             = 2
  
  health_check_type    = "ELB"
  load_balancers = [
  aws_elb.web_elb.id
  ]

  launch_configuration = aws_launch_configuration.web.name

  enabled_metrics = [
  "GroupMinSize",
  "GroupMaxSize",
  "GroupDesiredCapacity",
  "GroupInServiceInstances",
  "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
  aws_subnet.public_eu_central_1a.id,
  aws_subnet.public_eu_central_1b.id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}

output "elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}
//AutoscalingPolicy
# ASG Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

# Cloudwatch
resource "aws_cloudwatch_metric_alarm" "cloudwatch_high" {
  alarm_name = "cloudwatch_high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"

  metric_name = "NetworkPacketsIn"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "10000"
  alarm_description = "This metric monitors ec2 CPU for high utilization on agent hosts"
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_low" {
  alarm_name = "cloudwatch_low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"

  metric_name = "NetworkPacketsIn"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "8000"
  alarm_description = "This metric monitors ec2 CPU for low utilization on agent hosts"
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

