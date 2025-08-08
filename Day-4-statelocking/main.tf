resource "aws_instance" "dev" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    tags = {
        Name="devtest"
    }
     iam_instance_profile = aws_iam_instance_profile.ec2_profile.name  //This is a property of the EC2 resource — it tells AWS which instance profile to attach to the instance.
    
 }

//Create IAM ROLE
 resource "aws_iam_role" "ec2_role" {
  name = "my-ec2-role" //name of the role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

//ATTACH POLICIES
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.ec2_role.name //resourcetype.resourcename.attribute{here name}
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

//An instance profile is created whenever you want to attach an IAM role to an EC2 instance
//EC2 instances can’t use IAM roles directly.
//They require an instance profile — a wrapper around one IAM role.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devtest"
  role = aws_iam_role.ec2_role.name //resourcetype.resourcename.attribute {here name}
}

