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
