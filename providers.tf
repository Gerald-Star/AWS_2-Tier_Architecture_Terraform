
# ? congifure the provider AWS
# ! Go to Terraform documentation and search for AWS provider

# * provider block is used to configure the provider
# * source is the source of the provider # AWS
# * version is the version of the provider - AWS
# * profile is the profile name of the aws account
# * region is the region of the aws account
# * ~> is the version constraint operator
# * version 5.0 is the version of the provider
# * required_providers is the required provider block
# * aws is the provider name

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "AWSIAM"
}


