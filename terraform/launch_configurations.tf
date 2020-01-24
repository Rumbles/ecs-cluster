# Two launch configs, one for spot one for on demand
resource "aws_launch_configuration" "ecs_config_launch_config_spot" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_spot"
  image_id                    = data.aws_ami.ecs.id
  instance_type               = var.instance_type_spot
  spot_price                  = var.spot_bid_price
  enable_monitoring           = true
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"spot\"} >> /etc/ecs/ecs.config
EOF
  security_groups = [
    aws_security_group.ec2_instances.id
  ]
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_instance_profile.arn
}

resource "aws_launch_configuration" "ecs_config_launch_config_ondemand" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_ondemand"
  image_id                    = data.aws_ami.ecs.id
  instance_type               = var.instance_type_ondemand
  enable_monitoring           = true
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"ondemand\"} >> /etc/ecs/ecs.config
EOF
  security_groups = [
    aws_security_group.ec2_instances.id
  ]
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_instance_profile.arn
}
