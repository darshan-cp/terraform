terraform {
  required_providers {
    aws = {
      version = "4.22.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {}


resource "aws_vpc" "prod-vpc" {
  cidr_block = var.cidr_vpc_block
  tags = {
    Name = var.cidr_vpc_block_tag
  }
}


resource "aws_subnet" "prod-subnet-public-a" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subname_cidr_block.subnet_a
  availability_zone = var.cidr_zone[0]
  #assign_ipv6_address_on_creation = "1.2.3.4"
  tags = {
    Name = "prod-subnet-public-a"
  }
}

resource "aws_subnet" "prod-subnet-public-b" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subname_cidr_block.subnet_b
  availability_zone = var.cidr_zone[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "prod-subnet-public-b"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id            = aws_vpc.prod-vpc.id
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id            = aws_vpc.prod-vpc.id
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private" {
  vpc_id            = aws_vpc.prod-vpc.id
  tags = {
    Name = "Private Route Table"
  }
}

# Public Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
 
# Private Route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_internet_gateway.gw.id
}

# Public Route to Public Route Table for Public Subnets
resource "aws_route_table_association" "public" {
  for_each  = aws_subnet.prod-subnet-public-a
  subnet_id = aws_subnet.prod-subnet-public-a.id
 
  route_table_id = aws_route_table.public.id
}
 
# Private Route to Private Route Table for Private Subnets
resource "aws_route_table_association" "private" {
  for_each  = aws_subnet.prod-subnet-public-b
  subnet_id = aws_subnet.prod-subnet-public-b.id
 
  route_table_id = aws_route_table.private.id
}