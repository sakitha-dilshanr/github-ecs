#vpc
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      "Name" = "ecs-vpc"
    }
  }

#public Subnet
resource "aws_subnet" "public" {
    cidr_block = var.public_subnet_cidr[count.index]
    vpc_id = aws_vpc.this.id
    availability_zone = var.availability_zones[count.index]
    tags = {
      "Name" = "public-subnet-${count.index + 1}"
    }
}

#private Subnet
resource "aws_subnet" "private" {
    cidr_block = var.private_subnet_cidr[count.index]
    vpc_id = aws_vpc.this.id
    availability_zone = var.availability_zones[count.index]
    tags = {
      "Name" = "private-subnet-${count.index + 1}"
    }
  }

#internet gateway id
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "ecs-igw"
    }
}

#public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block =    "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.this.id"
  }
}

#associate public routes
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public )
    subnet_id = aws_subnet.public [count.index].id
    route_table_id = aws_route_table.public.id
  

}