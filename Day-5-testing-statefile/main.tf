//Create a VPC

/*resource "aws_vpc" "name" {

    cidr_block = "10.0.0.0/16"
    tags = {
      Name ="dev-vpc"
    }
  
}

//Creation of subnets
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id ///calling the resource we use the resource type plus resource name
    cidr_block = "10.0.0.0/24"
    tags = {
      Name ="dev-subnet"
    }
  
}

//Creation of private subnets we didnt add any subnet association here
resource "aws_subnet" "name2" {
    vpc_id = aws_vpc.name.id ///calling the resource we use the resource type plus resource name
    cidr_block = "10.0.1.0/24"
    tags = {
      Name ="dev-subnet"
    }
  
}

//Creation of IGW and attach to VPOC\
resource "aws_internet_gateway" "name" {
vpc_id = aws_vpc.name.id // attach to VPC ID
 tags = {
      Name ="dev-igw"
    }
  
}
//Creation of routetable and edit routes
resource "aws_route_table" "name" {
vpc_id = aws_vpc.name.id
route  {
    cidr_block = "0.0.0.0/16"
    gateway_id = aws_internet_gateway.name.id

}
  
}
//Creation of subnet Association
resource "aws_route_table_association" "name" {
   subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.name.id
  
}
//Creation of SG Group

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags ={
    Name ="dev_sg"
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

//Creation of servers

resource "aws_instance" "name" {

  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  
}

//creation of nat gateway and variables*/

/******************************THE ONE I CREATED*****************/
//Creation of VPC
resource "aws_vpc" "testVPC" {

  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "testVPC"
  }
  
}

//creation of subnets
resource "aws_subnet" "testsubnet1" {
  vpc_id = aws_vpc.testVPC.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "testsubnet1"
  }
   
}

//creation of elastic ip

resource "aws_eip" "nat" {
  domain = "vpc"
}

//creation of private subnet
resource "aws_subnet" "privatesubnet1" {
  vpc_id = aws_vpc.testVPC.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "testsubnet2"
  }
  map_public_ip_on_launch = false

}

//creation of natgateway
resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.privatesubnet1.id
  tags = {
    Name = "testnatgateway"
  }
  
}
//creation of private route table
resource "aws_route_table" "privateroutetable" {
  vpc_id = aws_vpc.testVPC.id
   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.name.id
  }
}

//association from subnet to private table
resource "aws_route_table_association" "privateroutetable" {
  subnet_id = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.privateroutetable.id
  
}
//creation of igw
resource "aws_internet_gateway" "testigw" {
  vpc_id = aws_vpc.testVPC.id
  tags = {
    Name = "testigw"
  }
  
}

//creation of routetable
resource "aws_route_table" "testpublicroute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testigw.id
  }

}

//creation from routetable to subnet(route table association)
resource "aws_route_table_association" "rtassociation" {
  subnet_id = aws_subnet.testsubnet1.id
  route_table_id = aws_route_table.testpublicroute.id

}


//create of security group
resource "aws_security_group" "sg" {
vpc_id = aws_vpc.testVPC.id
  name = "sg"
   tags ={
    Name ="test_sg"
  }
ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}

resource "aws_key_pair" "shared" { //Creates an AWS EC2 key pair in your AWS account.
  key_name   = "shared-ec2-key" //key_name → The name you’ll see in AWS Console’s Key Pairs list.
                               //(You’ll use this name when launching EC2s.)
  public_key = var.ssh_key   //public_key → The actual public key data you pass to AWS so that it can inject it into ~/.ssh/authorized_keys on your EC2 instances.
}

//creation of EC2 servers
resource "aws_instance" "test_ec1" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.testsubnet1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags ={
    Name ="test_ec1"
  }
  key_name = aws_key_pair.shared.key_name  
} //When launching an EC2 in Terraform, you reference this key pair’s name.
//AWS will then place the public key in the EC2’s authorized_keys file so that anyone with the matching private key can SSH into the instance.

//creation of EC2 servers
resource "aws_instance" "test_ec2" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.testsubnet1.id
   associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = aws_key_pair.shared.key_name
  tags ={
    Name ="test_ec2"
  }

}
