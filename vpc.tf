resource "aws_vpc" "vpc_ALB" {
  cidr_block       = "${var.cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "vpc_ALB"
  }
}

resource "aws_internet_gateway" "IGW_ALB" {
  vpc_id = "${aws_vpc.vpc_ALB.id}"
  tags = {
    Name = "IGW_ALB"
  }
}

resource "aws_eip" "EIP_ALB" {
  vpc = true
    
  }

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = "${aws_eip.EIP_ALB.id}"
  subnet_id     = "${aws_subnet.public_subnet1_ALB[0].id}"

  tags = {
    Name = "gw NAT"
  }
  depends_on = ["aws_eip.EIP_ALB", "aws_subnet.public_subnet1_ALB"]
}






