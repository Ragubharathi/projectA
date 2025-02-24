resource "aws_vpc" "projectA_vpc" {
  cidr_block = var.projectA_cidr
  tags = {
    Name = "PrjectA_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.projectA_vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.projectA_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
    tags = {
      Name = "public_rt"
    }
}


resource "aws_subnet" "public_sub_1" {
  vpc_id = aws_vpc.projectA_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true    
  availability_zone = var.AZ1
  tags = {
    Name = "Public_sub_1"
  }
}

resource "aws_subnet" "public_sub_2" {
  vpc_id = aws_vpc.projectA_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.AZ2
  tags = {
    Name = "public_sub_2"
  }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id = aws_subnet.public_sub_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id = aws_subnet.public_sub_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_sub_1.id
  tags = {
    Name = "Nat_gateway"
  }
}

resource "aws_route_table" "pravite_rt" {
  vpc_id = aws_vpc.projectA_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Private_rt"
  }
}

resource "aws_subnet" "private_sub_1" {
  vpc_id = aws_vpc.projectA_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = var.AZ1
  tags = {
    Name = "Private_sub_1"
  }
}

resource "aws_subnet" "private_sub_2" {
  vpc_id = aws_vpc.projectA_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = var.AZ2
  tags = {
    Name = "Private_sub_2"
  }
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.pravite_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.pravite_rt.id
}