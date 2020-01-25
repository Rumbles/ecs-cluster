# ECR cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# Capacity providers

resource "aws_ecs_capacity_provider" "spot_ecs_capacity_provider" {
  name = "${var.cluster_name}-spot"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_cluster_spot.arn

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}

resource "aws_ecs_capacity_provider" "ondemand_ecs_capacity_provider" {
  name = "${var.cluster_name}-ondemand"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_cluster_ondemand.arn

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}

# Service and capacity provider for task 1
resource "aws_ecs_task_definition" "task_1" {
  family                = "${var.cluster_name}-task-1"
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  container_definitions = <<EOF
[
    {
        "name": "${var.cluster_name}",
        "image": "${aws_ecr_repository.repo_1.repository_url}:latest",
        "cpu": 128,
        "memoryReservation": 128,
        "portMappings": [
            {
              "containerPort": ${var.task_1_port},
              "protocol": "${var.task_1_protocol}"
            }
        ],
        "command": [
            "nginx", "-g", "daemon off;"
        ],
        "essential": true
    }
]
EOF

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", data.aws_availability_zones.available.names)}]"
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_service" "ecs_service_task_1" {
  name            = "${var.cluster_name}-task-1"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_1.arn
  desired_count   = var.task_1_desired_count
  depends_on      = [aws_iam_role_policy.service_policy]

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 400

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.load_balancer_target_group_task_1.arn
    container_name   = var.cluster_name
    container_port   = var.task_1_port
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", data.aws_availability_zones.available.names)}]"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

# ECS Task scaling policy
resource "aws_appautoscaling_target" "ecs_target_task_1" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service_task_1.name}"
  role_arn           = aws_iam_role.ecs_scaling_role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_task_1" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_task_1.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_task_1.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_task_1.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# Service and capacity provider for task 2
resource "aws_ecs_task_definition" "task_2" {
  family                = "${var.cluster_name}-task-2"
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  container_definitions = <<EOF
[
    {
        "name": "${var.cluster_name}",
        "image": "${aws_ecr_repository.repo_2.repository_url}:latest",
        "cpu": 128,
        "memoryReservation": 128,
        "portMappings": [
            {
                "containerPort": ${var.task_2_port},
                "protocol": "${var.task_2_protocol}"
            }
        ],
        "command": [
            "nginx", "-g", "daemon off;"
        ],
        "essential": true
    }
]
EOF

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", data.aws_availability_zones.available.names)}]"
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_service" "ecs_service_task_2" {
  name            = "${var.cluster_name}-task-2"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_2.arn
  desired_count   = var.task_2_desired_count
  depends_on      = [aws_iam_role_policy.service_policy]

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 400

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.load_balancer_target_group_task_2.arn
    container_name   = var.cluster_name
    container_port   = var.task_2_port
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", data.aws_availability_zones.available.names)}]"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

# ECS Task scaling policy
resource "aws_appautoscaling_target" "ecs_target_task_2" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service_task_2.name}"
  role_arn           = aws_iam_role.ecs_scaling_role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_task_2" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_task_2.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_task_2.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_task_2.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
