output "DNS_LB" {
  value = "${aws_lb.Application_Load_Balancer.dns_name}"
}
