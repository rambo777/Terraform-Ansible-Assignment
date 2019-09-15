provider "aws" {
  region = "us-east-1"
}
##==============================================VPC-MODULE=====================================================
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Jenkins-VPC"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]



  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "jenkins-vpc"
  }
}


##==============================================SECURITY-GROUPS=====================================================

resource "aws_security_group" "ssh_bastion" {
  name        = "ssh_bastion"
  description = "SSH bastion"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.ssh_bastion.id}"]
    self        = true
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = ["${aws_security_group.loadbalancer-sg.id}"]
    self        = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "loadbalancer-sg" {
  name        = "lb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

##==============================================MACHINES=====================================================
## -- bastion server in public subnet:
resource "aws_instance" "bastion" {
  ami           = "ami-07d0cf3af28718ef8"
  count         = "1"
  instance_type = "t2.micro"
  key_name      = "deployer-key"
  vpc_security_group_ids = ["${aws_security_group.ssh_bastion.id}"]

  subnet_id     = "${element(module.vpc.public_subnets, 0)}"

  connection {
    host = "${self.public_ip}"
    user = "ubuntu"
      private_key = "${file("terraform.pem")}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }
}
## -- bastion server in private subnet:
resource "aws_instance" "jenkins-private" {
  ami           = "ami-07d0cf3af28718ef8"
  instance_type = "t2.small"
  key_name      = "deployer-key"
  connection {
    user         = "ubuntu"
    host         = "${self.private_ip}"
      private_key = "${file("terraform.pem")}"
      bastion_host = "${aws_instance.bastion.0.public_ip}"
  }

  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]

  subnet_id     = "${element(module.vpc.private_subnets, 0)}"

  provisioner "file" {
    source      = "ansible.sh"
    destination = "/tmp/ansible.sh"
  }
  provisioner "file" {
    source      = "terraform.pem"
    destination = "/tmp/terraform.pem"
  }
  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }
  provisioner "file" {
    source      = "provision.yml"
    destination = "/tmp/provision.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ansible.sh",
        "chmod +x /tmp/jenkins.sh",
        "chmod +x /tmp/provision.yml",
        "chmod 400 /tmp/terraform.pem",
      "bash /tmp/ansible.sh",
        "ansible-playbook /tmp/provision.yml --private-key=terraform.pem"

    ]
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }
}
##==============================================SSH-KEY-PAIRS=====================================================
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiGtn3Qqha2zLjGHDmw/DYN40VMXlZTUgU1jUfRL55b4AZCdy+86uxz9wgnqFzVWeFd1sfIkzqkG6vqWsYO6jvy/VwbBeaeKEGds0o9bU3mwY+wjyWNbAyeE3I7Y+yh65FwMI/y1f88mAMgdtGmhoKs5vEpA/2j8yW3eJXOFeRc+V4qHsya5kUIDl8Ph8Om3HCGEjtMk9wv6L+Mu3NhA1eEp0ab/piD9Y7OL/yeaFVQnnvunK0Swj8yJklSK7UqW+Hi4V1W4pFv3Xk++ACD8ldvGTFcThzh++TIvdZfNOg2vCPUjLSdNoSGXgHSH/Ym/oUy0xD7eJeyHavZw2cEZDB terraform"
}
##==============================================LOAD-BALANCERS=====================================================
resource "aws_elb" "jenkins-lb" {
  name               = "jenkins-lb"
  subnets            = ["${module.vpc.public_subnets[0]}", "${module.vpc.public_subnets[1]}" ]
  security_groups    = ["${aws_security_group.loadbalancer-sg.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }



  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "tcp:8080"
    interval            = 10
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "jenkins-elb"
  }
}
resource "aws_elb_attachment" "jenkins-lb" {
  elb      = "${aws_elb.jenkins-lb.id}"
  instance = "${aws_instance.jenkins-private.id}"
}
