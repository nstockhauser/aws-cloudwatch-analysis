

################################# DATA - UBUNTU IMAGE (LATEST) #################################


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}




################################# Hackin Environment #################################

################################# VPC | SUBNET | IGW #################################
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.name_tag
  }
}


resource "aws_subnet" "subnet" {
  cidr_block              = var.vpc_subnet_cidr_block
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.name_tag
  }

}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name_tag
  }
}


################################# ROUTING | ASSOCIATION #################################
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.name_tag
  }
}


resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}



################################# SECURITY GROUPS #################################
#Instance SG's#
resource "aws_security_group" "lab-sg" {
  name   = "lab"
  vpc_id = aws_vpc.vpc.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["76.23.51.109/32"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name_tag
  }
}


