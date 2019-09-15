# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = ["${module.vpc.vpc_cidr_block}"]
}


# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}

# AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = ["${module.vpc.azs}"]
}
# LB
output "I---------------------------------------COPY-PASTE-THIS-URL-BROWSER-TO-VIEW-JENKINS---------------------------------------I" {
  description = "The DNS name of the load balancer."
  value =  ["${aws_elb.jenkins-lb.dns_name}"]
}

# bastion host ip
output "bastion-hostip" {
  description = "The DNS name of the load balancer."
  value =  ["${aws_instance.bastion.0.public_ip}"]
}
# jenkins private ip
output "jenkins-private-ip" {
  description = "The DNS name of the load balancer."
  value =  ["${aws_instance.bastion.0.public_ip}"]
}
