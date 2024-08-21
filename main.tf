provider "aws" {
  region = "us-east-1"
}

# Frontend VPC
resource "aws_vpc" "frontend_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "development-fe-vpc"
  }
}

# Public Subnet for Frontend
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.frontend_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
    Name = "development-fe-public-subnet"
  }
}

# Private Subnet for Frontend (optional, remove if not needed)
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.frontend_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  
  tags = {
    Name = "development-fe-private-subnet"
  }
}

# Public Route Table for Frontend
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.frontend_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "development-fe-public-rt"
  }
}

# Association of Route Table with Public Subnet 
resource "aws_route_table_association" "public_subnets_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Internet Gateway for Frontend
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.frontend_vpc.id

  tags = {
    Name = "development-fe-ig"
  }
}

# Security Group for Frontend (SSH and HTTP access)
resource "aws_security_group" "sg_grp" {
  vpc_id      = aws_vpc.frontend_vpc.id
  name        = "frontend_http_access"
  description = "sg for frontend development"

  # SSH Ingress Rule
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # HTTP Ingress Rule
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "development-fe-sg"
  }
}
