resource "aws_launch_configuration" "ASG_LC" {
  name_prefix          = "ASG_LC-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.ALB_TF_SG.id}"]
  associate_public_ip_address = true
 
  key_name = "newkpdp"
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hi Friend I am EC2 using Autoscaling!!!! : $(hostname -f)" > /var/www/html/index.html
                EOF


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ASG_tf_sg" {
  name = "my_asg_tf_${aws_launch_configuration.ASG_LC.name}"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "ELB"
  desired_capacity          = 1
  
  launch_configuration      = "${aws_launch_configuration.ASG_LC.name}"
  vpc_zone_identifier       = "${aws_subnet.public_subnet1_ALB.*.id}"
  target_group_arns         = ["${aws_lb_target_group.targetgroup_lb.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}

