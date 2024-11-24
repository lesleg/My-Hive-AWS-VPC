//resource "aws_key_pair" "deployer" {
//key_name   = "terraform_deployer"
//public_key = "${file(var.public_key_path)}"
//}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "terraform-example-web-instance"
  image_id      = lookup(var.amis, var.region)
  instance_type = var.instance_type
  key_name      = "cp-prince"
  // Alternatively, if you want to use the dynamically set key pair, you can uncomment the following line and comment out the static key_name above
  // key_name      = aws_key_pair.deployer.id

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.default.id]
  }

  user_data = base64encode(data.template_file.provision.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_autoscaling_group" "autoscaling_group" {
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  target_group_arns    = [aws_alb_target_group.group.arn]
  vpc_zone_identifier  = aws_subnet.main.*.id

  tag {
    key                 = "Name"
    value               = "terraform-example-autoscaling-group"
    propagate_at_launch = true
  }
}

# Define the IAM role
resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy" "ec2_instance_connect_policy" {  # [Added]
  name = "EC2InstanceConnectPolicy"
  role = aws_iam_role.ssm_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2-instance-connect:SendSSHPublicKey"  # [Added]
        ],
        Resource = "*"
      }
    ]
  })
}



