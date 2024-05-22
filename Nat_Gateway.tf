
# Terraform aws_nat_gateway resource to create a NAT Gateway in AWS

# ? The NAT Gateway requires an Elastic IP address to function
# ? allocate an Elastic IP address
# ? This is a public IP address that can be used to access the internet

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = "dev_nat_gateway_eip"
  }
}



# Terraform aws_nat_gateway resource to create a NAT Gateway in public subnet az1

# ? create a NAT Gateway in the public subnet az1
# ? This is used to allow instances in the private subnet to access the internet
# ? To get the subnet_id, reference the public subnet az1 resource block on the vpc

resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "nat_gateway_az1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.igw]
}



# * Terraform aws create a route table resource block

# create a private route table az1 and add route through the nat_gateway_az1


resource "aws_route_table" "private-route_table_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
}

  tags = {
    Name = "dev_private_route_table_az1"
  }
}

# *Terraform aws association subnet route table

# ? associate the private route table az1 with the private subnet az1 route table association
# ? This allows the private subnet to route traffic through the NAT Gateway
# ! reference the subnet_id from the subnet az1 and route table resources -from vpc.tf
# ! reference the route_table_id from the private_route_table-az1.id - from the route table resource block here



resource "aws_route_table_association" "private_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private-route_table_az1.id
}



# * Terraform aws create associate private subnet route table az2 resource block

# ? associate the private route table az2 with the private subnet az2 route table association
# ? This allows the private subnet to route traffic through the NAT Gateway
# ! reference the subnet_id from the subnet az2 and route table resources -from vpc.tf
# ! reference the route_table_id from the private_route_table-az1.id - from the route table resource block here


resource "aws_route_table_association" "private_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private-route_table_az1.id
}


# Terraform aws_nat_gateway resource to create a NAT Gateway in public subnet az2