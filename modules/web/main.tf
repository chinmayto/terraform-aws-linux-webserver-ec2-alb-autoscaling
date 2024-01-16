####################################################
# Get latest Amazon Linux 2 AMI
####################################################
data "aws_ami" "amazon-linux-ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["CT_Auto_Scaling_Webhost"]
  }
}

####################################################
# Create Launch Template Resource
####################################################
resource "aws_launch_template" "aws-launch-template" {
  image_id               = data.aws_ami.amazon-linux-ami.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  vpc_security_group_ids = var.security_group_ec2
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.naming_prefix}-ec2"
    })
  }
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.naming_prefix}-asg"
    })
  }
}

####################################################
# Create auto scaling group
####################################################
resource "aws_autoscaling_group" "aws-autoscaling-group" {
  #  name                = "${var.project_name}-ASG-Group"
  vpc_zone_identifier = tolist(var.public_subnets)
  desired_capacity    = 1
  max_size            = 4
  min_size            = 1

  launch_template {
    id      = aws_launch_template.aws-launch-template.id
    version = aws_launch_template.aws-launch-template.latest_version
  }
}

####################################################
# Create target tracking scaling policy for average CPU utilization
####################################################
resource "aws_autoscaling_policy" "avg_cpu_scaling_policy" {
  name                   = "avg_cpu_scaling_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.aws-autoscaling-group.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
  estimated_instance_warmup = 180
}
