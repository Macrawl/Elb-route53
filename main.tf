#create a vpc 
resource "aws_vpc" "vpc" {
  cidr_block           = "14.1.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}
# Associate public subnet1 to the public route table
resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

#Associate public subnet2 to the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

#create two subnets 

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet2_cidr_block
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}


