resource "aws_lb" "Application_Load_Balancer" {
  name               = "ALB-test-shikha-126"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.ALB_TF_SG.id}"]
  subnets         = "${aws_subnet.public_subnet1_ALB.*.id}"

  tags = {
    Environment = "ALB_production"
  }
  depends_on = ["aws_security_group.ALB_TF_SG", "aws_subnet.public_subnet1_ALB"]
}

resource "aws_lb_target_group" "targetgroup_lb" {
  name     = "alb-tg"
  vpc_id   = "${aws_vpc.vpc_ALB.id}"
  port     = 80
  protocol = "HTTP"
  health_check {
      path = "/"
      port = "80"
      protocol = "HTTP"
      healthy_threshold = "5"
      unhealthy_threshold  = "2"
      matcher = "200"
      interval = "5"
      timeout = "4"
    }
  depends_on = ["aws_vpc.vpc_ALB"]
}


resource "aws_lb_target_group_attachment" "attach_targetgroup" {
  count = "${length(var.private_subnet_cidr)}"
  target_group_arn = "${aws_lb_target_group.targetgroup_lb.arn}"
  target_id        = "${element(aws_instance.PublicEC2.*.id, count.index)}"
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.Application_Load_Balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.targetgroup_lb.arn}"

  }
  depends_on = ["aws_lb.Application_Load_Balancer", "aws_lb_target_group.targetgroup_lb"]
}