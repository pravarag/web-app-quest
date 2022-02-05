provider "aws" {
  region = "us-east-2"
  access_key = "${AWS_ACCESS_KEY_ID}"
  secret_key = "${AWS_SECRET_ACCESS_KEY}"
}

resource "aws_vpc" "web-app-vpc" {
  cidr_block = var.vpcCIDRblock
  instance_tenancy = "default"
  enable_dns_support = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames

  tags = {
    Name = "web-app-vpc",
    Owner = "Pravar"
  }
}

resource "aws_subnet" "public-web-app-subnet" {

  vpc_id = aws_vpc.web-app-vpc.id
  cidr_block = var.subnetPublicCIDRblock
  map_public_ip_on_launch = var.mayPublicIP
  availability_zone = var.availabilityZone

  tags = {
    Name = "public-web-app-subnet",
    Owner = "Pravar"
  }
  
}

resource "aws_subnet" "private-web-app-subnet" {
  vpc_id = aws_vpc.web-app-vpc.id
  cidr_block = var.subnetPrivateCIDRblock
  availability_zone = var.availabilityZone

  tags = {
    Name = "private-web-app-subnet",
    Owner = "Pravar"
  }
}


# security group
resource "aws_security_group" "web-app-security_group" {
  vpc_id = aws_vpc.web-app-vpc.id
  name = "web-app-security-group"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws_web_app_security_group",
    Owner = "Pravar"
  }
}


# create VPC Network access control list
resource "aws_network_acl" "web-app-security-ACL" {
  vpc_id = aws_vpc.web-app-vpc.id
  subnet_ids = [ aws_subnet.web-app-public-subnet.id, aws_subnet.web-app-private-subnet.id ]
  
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
tags = {
  Name = "web-app-security-ACL",
  Owner = "Pravar"
}
}


resource "aws_instance" "web-app-instance" {
  ami = ""
  instance_type = ""
  subnet_id = ""
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_vpc.web-app-vpc.id]
  key_name = ""

  root_block_device {
    delete_on_termination = true
    iops = ""
    volume_size =
    volume_type = 
  }

  tags {
    Name = "web-app-instance"
    
  }
  depends_on = [aws_security_group.web-app-security-group]
}
