#create Load balancer resource
resource "aws_lb" "elb" {
  name               = "Application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_rule.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  tags = {
    Name = "Application-lb"
  }
}

#Create A  target group

resource "aws_lb_target_group" "elb_tg" {
  name     = "Application-elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id


  tags = {
    Name = "Application-elb-tg"
  }
  #Health checks 
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    interval            = 100
    timeout             = 60
    path                = "/"
  }
}
#Aws load-balancer target group attachment
resource "aws_lb_target_group_attachment" "elb_tg" {
  count            = length(aws_instance.ec2_instances.*.id)
  target_group_arn = aws_lb_target_group.elb_tg.arn
  target_id        = aws_instance.ec2_instances.*.id[count.index]
  port             = 80
}


#AWS load-balancer listener

resource "aws_lb_listener" "elb-listener" {
load_balancer_arn = aws_lb.elb.arn
port = "80"
protocol = "HTTP"

default_action {
  type = "forward"
  target_group_arn = aws_lb_target_group.elb_tg.arn
}
}


