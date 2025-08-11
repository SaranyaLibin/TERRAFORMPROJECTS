/*variable "vpc_name" {

 default = "testVPC"   
  
}

variable "vpc_cidr" {
    default="10.0.0.0/16"
  
}

//creation of subnets

variable "publicsubnet_cidr" {
     default="10.0.0.0/24"
  
}
variable "public_subnet_name" {

  default="testsubnet1"
}

//creation of private subnet

variable "privatesubnet_cidr" {
     default="10.0.2.0/24"
  
}
variable "private_subnet_name" {

  default="testsubnet2"
}

//creation of natgateway
variable "nat_gateway_name" {
  default = "testnatgateway"
}

//creation of private route table
variable "rt_cidr_block" {
    default = "0.0.0.0/0"
  
}

//creation of igw
variable "gateway_name" {
  default = "testigw"
}


//creation of EC2 servers
variable "ami_id_ec1" {
  default = "ami-08a6efd148b1f7504"
}

variable "instance_type_ec1" {
  default  = "t2.micro"
}


//creation of EC2 servers
variable "ami_id_ec2" {
  default = "ami-08a6efd148b1f7504"
}
variable "instance_type_ec2" {
  default  = "t2.micro"
}*/

variable "ssh_key" {
   description = "Your SSH public key (e.g., ssh-rsa AAAA...)"
  type        = string
}




