resource "aws_iam_role" "ec2_ssm_role" {
  name = "andrew_ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "andrew_ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "ec2" {
  ami                         = "ami-08cd358d745620807"
  instance_type               = "t2.micro"
  key_name                    = "cp-prince"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main[0].id
  vpc_security_group_ids      = [
    aws_security_group.ec2rule.id,
  ]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  user_data = <<-EOF
    #!/bin/bash
    # Install the SSM Agent
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF

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

  # Allow HTTPS (required for SSM)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

