# How To Use Terraform Documentation for Providers Configuration - Use Case 'AWS Configuration'

# What is Terraform?

## What is Terraform Configuration

## What is Terraform Provider

Link https://registry.terraform.io/browse/providers

## What is Terraform block?


## Description of the Terraform block


## How to create Terraform internet gateway

Search with this keyword 'Terraform create internet gateway'

Direct Terraform Documentation to see 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

Resource: aws_internet_gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}




# NAT GATEWAY

## First create the Elastic IP Address
Link to create the Elastic IP Address

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

Single EIP associated with an instance

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  domain   = "vpc"
}

## Second step - create the nat gateway

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "gw NAT"
  }

  ##To ensure proper ordering, it is recommended to add an explicit dependency  on the Internet Gateway for the VPC.

  depends_on = [aws_internet_gateway.example]
}