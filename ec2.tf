resource aws_instance "ec2"{
  ami = "ami-08cd358d745620807"
  instance_type = "t2.micro"
  key_name = "cp-prince"
  associate_public_ip_address = true
  subnet_id = aws_subnet.main[0].id
  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]

  tags = {
    name = "Andrew EC2 troubleshooting instance"
  }
  depends_on = [
    aws_subnet.main
  ]
}

resource "aws_security_group" "ec2rule" {
  name        = "Andrew ec2rule security group"
  description = "ec2 rule secgroup description"
  vpc_id      = aws_vpc.andrew_vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow me in to EC2"
  }
}