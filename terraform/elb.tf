# Application load balancer, target group and listener for task 1
resource "aws_lb" "application_load_balancer_task_1" {
  name               = "${var.cluster_name}-task-1"
  internal           = var.task_1_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  lifecycle {
    prevent_destroy = false
    ignore_changes = [id, name, tags]
  }
  depends_on = [
    aws_security_group.elb
  ]
}

resource "aws_lb_target_group" "load_balancer_target_group_task_1" {
  name     = "${var.cluster_name}-task-1"
  port     = var.task_1_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    interval                = "30"
    path                    = "/"
    protocol                = "HTTP"
    timeout                 = "5"
    healthy_threshold       = "2"
    unhealthy_threshold     = "2"
    matcher                 = "200"
  }
  lifecycle {
    ignore_changes = [id, name, tags]
  }
  depends_on = [
    aws_lb.application_load_balancer_task_1
  ]
}

resource "aws_lb_listener" "load_balancer_listener_task_1" {
  load_balancer_arn = aws_lb.application_load_balancer_task_1.arn
  port              = var.task_1_load_balancer_port
  protocol          = var.task_1_load_balancer_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group_task_1.arn
  }
  lifecycle {
    ignore_changes = [id, load_balancer_arn]
  }
}

# Application load balancer, target group and listener for task 2
resource "aws_lb" "application_load_balancer_task_2" {
  name               = "${var.cluster_name}-task-2"
  internal           = var.task_2_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  lifecycle {
    prevent_destroy = false
    ignore_changes = [id, name, tags]
  }
  depends_on = [
    aws_security_group.elb
  ]
}

resource "aws_lb_target_group" "load_balancer_target_group_task_2" {
  name     = "${var.cluster_name}-task-2"
  port     = var.task_2_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    interval                = "30"
    path                    = "/"
    protocol                = "HTTP"
    timeout                 = "5"
    healthy_threshold       = "2"
    unhealthy_threshold     = "2"
    matcher                 = "200"
  }
  lifecycle {
    ignore_changes = [id, name, tags]
  }
  depends_on = [
    aws_lb.application_load_balancer_task_2
  ]
}

resource "aws_lb_listener" "load_balancer_listener_task_2" {
  load_balancer_arn = aws_lb.application_load_balancer_task_2.arn
  port              = var.task_2_load_balancer_port
  protocol          = var.task_2_load_balancer_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group_task_2.arn
  }
  lifecycle {
    ignore_changes = [id, load_balancer_arn]
  }
}
