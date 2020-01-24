# ECS Cluster role and permissions
data "aws_iam_policy_document" "ecs_role_definition" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name_prefix        = "${var.cluster_name}-ecs-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role_definition.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "ecs_instance_role_policy_doc" {
  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:StartTask",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs_role_permissions" {
  name_prefix = "${var.cluster_name}-ecs-cluster-policy"
  description = "These policies allow the ECS instances to do certain actions like pull images from ECR"
  path        = "/"
  policy      = data.aws_iam_policy_document.ecs_instance_role_policy_doc.json
}

resource "aws_iam_policy_attachment" "ecs_instance_role_policy_attachment" {
  name = "${var.cluster_name}-ecs-cluster-iam-policy-attachment"
  roles = [
    aws_iam_role.ecs_role.name
  ]
  policy_arn = aws_iam_policy.ecs_role_permissions.arn
}

# Task role
data "aws_iam_policy_document" "ecs_task_role_definition" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.ecs_private_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name     = "${var.cluster_name}-ecs-task-role"
  assume_role_policy  = data.aws_iam_policy_document.ecs_task_role_definition.json

  force_detach_policies = true
}

resource "aws_iam_policy_attachment" "ecs_task_role_policy_attachment" {
  name = "${var.cluster_name}-ecs-task-iam-policy-attachment"
  roles = [
    aws_iam_role.ecs_task_role.name
  ]
  policy_arn = aws_iam_policy.ecs_service_role_permissions.arn
}

resource "aws_iam_policy" "ecs_service_role_permissions" {
  name_prefix = "${var.cluster_name}-ecs-task-iam-policy"
  description = "These policies allow the ECS task to do required jobs"
  path        = "/"
  policy      = data.aws_iam_policy_document.ecs_task_role_policy.json
}

# ECS Auto scaling role and permissions
data "aws_iam_policy_document" "ecs_scaling_role_definition" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_scaling_role" {
  name_prefix        = "${var.cluster_name}-ecs-s-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_scaling_role_definition.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "ecs_scaling_role_policy_doc" {
  statement {
    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs_scaling_role_permissions" {
  name_prefix = "${var.cluster_name}-ecs-scaling-policy"
  description = "These policies allow the ECS to auto scale"
  path        = "/"
  policy      = data.aws_iam_policy_document.ecs_scaling_role_policy_doc.json
}

resource "aws_iam_policy_attachment" "ecs_scaling_role_policy_attachment" {
  name = "${var.cluster_name}-ecs-scaling-iam-policy-attachment"
  roles = [
    aws_iam_role.ecs_scaling_role.name
  ]
  policy_arn = aws_iam_policy.ecs_scaling_role_permissions.arn
}
