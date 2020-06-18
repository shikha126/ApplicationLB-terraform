resource "aws_subnet" "public_subnet1_ALB" {
  count = "${length(var.public_subnet_cidr)}"
  vpc_id     = "${aws_vpc.vpc_ALB.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availibity_zone, count.index)}"
  tags = {
    Name = "${element(var.public_subnet_names, count.index)}"
  }
  map_public_ip_on_launch = true

  depends_on = ["aws_vpc.vpc_ALB"]
}

resource "aws_subnet" "private_subnet2_ALB" {
  count = "${length(var.private_subnet_cidr)}"
  vpc_id     = "${aws_vpc.vpc_ALB.id}"
  cidr_block = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availibity_zone, count.index)}"
  tags = {
    Name = "${element(var.private_subnet_names, count.index)}"
  }
  
  depends_on = ["aws_vpc.vpc_ALB"]
}