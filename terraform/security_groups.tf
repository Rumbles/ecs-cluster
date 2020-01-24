# Security groups for EC2 instances and the load balancer
resource "aws_security_group" "ec2_instances" {
  name_prefix = "${var.cluster_name}_ec2_instances_"
  description = "Security group for EC2 instances within the cluster"
  vpc_id      = module.vpc.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_security_group_rule" "allow_ec2_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    local.vpc_cidr
  ]
  security_group_id = aws_security_group.ec2_instances.id
}

resource "aws_security_group_rule" "allow_elb_in" {
  protocol  = "tcp"
  from_port = 32500
  to_port   = 33200
  source_security_group_id = aws_security_group.elb.id
  security_group_id = aws_security_group.ec2_instances.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_ec2_egress_all" {
  security_group_id = aws_security_group.ec2_instances.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group" "elb" {
  name_prefix = "${var.cluster_name}_elb"
  description = "Security group for ELB within the cluster"
  vpc_id      = module.vpc.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_security_group_rule" "allow_elb_http_in" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  to_port           = 80
    cidr_blocks = [
    "0.0.0.0/0"
  ]
  type = "ingress"
}

resource "aws_security_group_rule" "allow_elb_egress_all" {
  security_group_id = aws_security_group.elb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}
