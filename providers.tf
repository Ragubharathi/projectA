provider "aws" {
  region = var.projectA_region
}

resource "aws_vpc" "projectA_vpc" {
  cidr = var.projectA_vpc
  Tags  = {
    Name = "ProjectA_VPC"
  }
}





