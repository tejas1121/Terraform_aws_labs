resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "MyVPC"
    }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {  
    Name = "PublicSubnet"
  } 
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}
  
}

resource "aws_route_table_association" "public_rt_assoc" {
  route_table_id         = aws_route_table.public_rt.id
  subnet_id              = aws_subnet.public_subnet.id
}

