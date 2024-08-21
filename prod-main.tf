provider "aws" {
  region = "us-east-1"
}

# Production VPC
resource "aws_vpc" "production_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "production-vpc"
  }
}

# Public Subnet for Production
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
    Name = "production-public-subnet"
  }
}

# Private Subnet for Production
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  
  tags = {
    Name = "production-private-subnet"
  }
}

# Public Route Table for Production
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "production-public-rt"
  }
}

# Association of Route Table with Public Subnet 
resource "aws_route_table_association" "public_subnets_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Internet Gateway for Production
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "production-ig"
  }
}

# Security Group for Production (SSH and HTTP/HTTPS access)
resource "aws_security_group" "sg_grp" {
  vpc_id      = aws_vpc.production_vpc.id
  name        = "production_sg"
  description = "Security group for production environment"

  # SSH Ingress Rule (Restrict to specific IPs)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with specific IP or CIDR block
  }

  # HTTP Ingress Rule
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS Ingress Rule
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "production-sg"
  }
}
