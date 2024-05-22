
# * create a custom VPC resource block and it's components

# ? aws_vpc is the resource type
# ? vpc is the resource name ( these two are user defined)
# ! ( combine the resource type and resource name - use as the vpc_id in the internet gateway resource)

# terraform aws create vpc resource block

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr  # ? get the cidr block from the variable vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "dev_vpc"
  }
}
  
# ? terraform aws create internet gateway

# * create an internet gateway and attach it to the vpc
# * get the vpc id from the vpc resource (aws_vpc.vpc.id)
# ! use this as the gateway_id in the route table resource

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "dev_igw"
  }
}


# ? terraform aws create subnet resource block

# * create public subnet az1 variable and reference it on the resource block
# * create availability zone variable for az1 and reference it on the resource block
# ? create a subnet az1 in the vpc
# ! don't forget to reference the vpc id from the vpc resource
# ! don't forget to reference the subnet cidr from the variable

resource "aws_subnet" "public_subnet_az1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = var.availability_zone_us_east_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_public_subnet_az1"
  }
}


# ? create public subnet az2 resource block

# * create public subnet variable for az2 and reference it in the aws_subnet resource
# * create availability zone variable for az2 and reference it in the aws_subnet resource


resource aws_subnet public_subnet_az2 {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = var.availability_zone_us_east_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_public_subnet_az2"
  }
}



# ? terraform aws create route table resource block

# ? create a route table in the vpc
# ? create a gateway route in the route table
# * reference the vpc id from the vpc resource
# * create a route table resource block and reference the vpc id from the vpc resource
# * create a route table association resource block and reference the route table id and subnet id
# * get the gateway_id from the internet gateway resource

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dev_public_route_table"
  }
}



# ? create a route table association, associate it to the public subnet az1

# ! reference the subnet id and route table id from the subnet az1 and route table resources
# "aws_subnet" "public_subnet_az1"
# "aws_route_table" "public_route_table"


resource "aws_route_table_association" "public_subnet-az1_route_table_association" {
  subnet_id = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}



# ? create a route table association, associate it to the public subnet az2

# ! reference the subnet id and route table id from the subnet az2 and route table resources
# "aws_subnet" "public_subnet_az2"
# "aws_route_table" "public_route_table"

resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}




# ? terraform aws create private subnet az1 resource block

# ? create a private subnet in the vpc
# * create a private subnet az1 variable and reference it in the aws_subnet resource
# ! don't forget to reference the vpc id from the vpc resource
# ! don't forget to reference the subnet cidr from the variable


resource  "aws_subnet" "private_subnet_az1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_az1_cidr
  availability_zone = var.availability_zone_us_east_1a
  map_public_ip_on_launch = false

  tags = {
    Name = "dev_private_subnet_az1"
  
  }
}




# ? terraform aws create private subnet az2 resource block

# ? create a private subnet in the vpc
# * create a private subnet az1 variable and reference it in the aws_subnet resource
# ! don't forget to reference the vpc id from the vpc resource
# ! don't forget to reference the subnet cidr from the variable


resource "aws_subnet" "private_subnet_az2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_az2_cidr
  availability_zone = var.availability_zone_us_east_1b
  map_public_ip_on_launch = false

  tags = {
    Name = "dev_private_subnet_az2"
  
  }
}





# create a folder named NatGateway
# ? terraform aws create security group resource block

