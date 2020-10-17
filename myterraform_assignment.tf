provider "aws" {
  version = "~> 3.0"
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "mynewgateway"
  }
}

resource "aws_route_table" "route1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygateway.id
  }

  tags = {
    Name = "mynewroutetable"
  }
}

resource "aws_route_table_association" "assoc1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route1.id
}

resource "aws_route_table_association" "assoc2" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.route1.id
}
