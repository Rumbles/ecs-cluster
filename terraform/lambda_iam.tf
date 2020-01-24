# Lambda role policy
data "aws_iam_policy_document" "lambda_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "lambda.amazonaws.com",
      ]
      type = "Service"
    }
  }
}

# Lambda task role and IAM policy task 1

resource "aws_iam_role" "iam_lambda_task_1" {
  name = "${var.cluster_name}_lambda_task_1"

  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy.json
}

resource "aws_iam_policy" "lambda_policy_task_1" {
  name    = "${var.cluster_name}_lambda_task_1"
  policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.cluster_name}-task-1:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages",
                "ecr:DescribeRepositories",
                "ecs:RegisterTaskDefinition",
                "ecs:UpdateService",
                "ecs:DescribeTaskDefinition"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-ecs-task-role"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy_task_1" {
  role       = aws_iam_role.iam_lambda_task_1.name
  policy_arn = aws_iam_policy.lambda_policy_task_1.arn
}

# Lambda task role and IAM policy task 1

resource "aws_iam_role" "iam_lambda_task_2" {
  name = "${var.cluster_name}_lambda_task_2"

  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy.json
}

resource "aws_iam_policy" "lambda_policy_task_2" {
  name    = "${var.cluster_name}_lambda_task_2"
  policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.cluster_name}-task-2:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages",
                "ecr:DescribeRepositories",
                "ecs:RegisterTaskDefinition",
                "ecs:UpdateService",
                "ecs:DescribeTaskDefinition"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-ecs-task-role"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy_task_2" {
  role       = aws_iam_role.iam_lambda_task_2.name
  policy_arn = aws_iam_policy.lambda_policy_task_2.arn
}
