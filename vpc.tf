resource "aws_vpc" "projectA_vpc" {
  cidr_block = var.projectA_cidr
  tags = {
    Name = "PrjectA_vpc"
  }
}
