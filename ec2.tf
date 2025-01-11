# IAM Role for EC2 to use Systems Manager (SSM)
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

# Attach SSM policy to the role
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "andrew_ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# Security Group for EC2 instance
resource "aws_security_group" "ec2rule" {
  name        = "andrew-ec2rule-sg"
  description = "Security group for troubleshooting EC2 instance"
  vpc_id      = aws_vpc.andrew_vpc.id

  # Allow outbound traffic to ALB target instances (Port 80)
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound HTTPS traffic (required for SSM)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "andrew-ec2rule-sg"
  }
}

# EC2 Instance for Troubleshooting
resource "aws_instance" "ec2" {
  ami                         = "ami-08cd358d745620807" # Replace with the appropriate AMI ID
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main[0].id # Use a subnet in the same VPC as the ALB
  vpc_security_group_ids      = [aws_security_group.ec2rule.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF

  tags = {
    Name = "Andrew EC2 troubleshooting instance"
  }

  depends_on = [
    aws_subnet.main
  ]
}


