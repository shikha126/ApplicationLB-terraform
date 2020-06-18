resource "aws_security_group" "SG_public_SG" {
  name        = "ec2_SG_public_SG"
  description = "ec2_SG_public_SG"
  vpc_id      = "${aws_vpc.vpc_ALB.id}"


  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.ALB_TF_SG.id}"]
  }

   ingress {
    description = "allow HTTP"
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
    Name = "TCP allow"
  }

  depends_on = ["aws_vpc.vpc_ALB","aws_security_group.ALB_TF_SG"]
}

resource "aws_security_group" "SG_private_SG" {
  name        = "ec2_SG_private_SG"
  description = "ec2_SG_private_SG"
  vpc_id      = "${aws_vpc.vpc_ALB.id}"  
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      security_groups = ["${aws_security_group.SG_public_SG.id}"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TCP allow"
  }
}

resource "aws_security_group" "ALB_TF_SG" {
  name        = "ALB_SG"
  description = "ALB_SG"
  vpc_id      = "${aws_vpc.vpc_ALB.id}"  
  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ALB traffic"
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB traffic"
  }
}