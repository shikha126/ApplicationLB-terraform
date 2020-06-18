resource "aws_instance" "PublicEC2" {
  count = "${length(var.private_subnet_cidr)}"
  ami =   "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.SG_public_SG.id}"]
  subnet_id = "${aws_subnet.public_subnet1_ALB[count.index].id}"
  key_name = "newkpdp"
  tags = {
    Name = "${format("PublicEC2-%d", count.index+1)}"
  }
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hi Friend I am public EC2!!!! : $(hostname -f)" > /var/www/html/index.html
                EOF
  depends_on = ["aws_vpc.vpc_ALB","aws_subnet.public_subnet1_ALB","aws_security_group.SG_public_SG"]
}


resource "aws_instance" "PrivateEC2" {
  count = "${length(var.private_subnet_cidr)}"
  ami =   "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.SG_private_SG.id}"]

  subnet_id = "${aws_subnet.private_subnet2_ALB[count.index].id}"
  key_name = "newkpdp"
  tags = {
    Name = "${format("PrivateEC2-%d", count.index+1)}"
  }
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hi Friend I am private EC2!!!! : $(hostname -f)" > /var/www/html/index.html
                EOF
  depends_on = ["aws_vpc.vpc_ALB","aws_subnet.private_subnet2_ALB","aws_security_group.SG_private_SG"]
}