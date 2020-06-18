resource "aws_route_table" "public_routetable" {
  vpc_id = "${aws_vpc.vpc_ALB.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW_ALB.id}"
  }
  tags = {
    Name = "public_route_table"
  }
  depends_on = ["aws_vpc.vpc_ALB", "aws_internet_gateway.IGW_ALB"]
}

resource "aws_route_table_association" "RT_association_public" {
  count = "${length(var.public_subnet_names)}"
  subnet_id = "${element(aws_subnet.public_subnet1_ALB.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_routetable.id}"
  depends_on = ["aws_subnet.public_subnet1_ALB", "aws_route_table.public_routetable"]
}

resource "aws_route_table" "private_routetable" {
  vpc_id = "${aws_vpc.vpc_ALB.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.NAT_GW.id}"
  }
  tags = {
    Name = "private_routetable"
  }
  depends_on = ["aws_vpc.vpc_ALB", "aws_nat_gateway.NAT_GW"]
}

resource "aws_route_table_association" "RT_association_private" {
  count = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet2_ALB.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_routetable.id}"
  depends_on = ["aws_subnet.private_subnet2_ALB","aws_route_table.private_routetable"]
}

