terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
    region = "eu-central-1"
}

resource "aws_vpc" "this" {
  cidr_block = "10.100.0.0/16"
  tags = {
    name = "upgra-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.100.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    name = "Upgrad_public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.100.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    name = "Upgrad_public-2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.100.3.0/24"
  availability_zone = "eu-central-1a"

  tags ={
    name = "Upgrade-Private-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.100.4.0/24" 
  availability_zone = "eu-central-1b"

  tags ={
    name = "Upgrade-Private-2"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    name = "Internet Gateway"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
  tags = {
    name = "UPgrade_NAT"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = "Public Route Table"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    name = "Private Route Table"
  }
}


resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}



resource "aws_security_group" "allow-ssh" {
  name = "Allow -ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "Allow SSH"
    from_port = 2
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ALLOW HTTP"
    from_port = 80 
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Allow-SSH"
  }
}
