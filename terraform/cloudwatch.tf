# CloudWatch rule and use it to trigger the lambda for task 1
resource "aws_cloudwatch_event_rule" "pipeline_task_1" {
  name        = "${var.cluster_name}-task-1"
  description = "Detect new image and trigger lambda for task 1"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ecr"
  ],
  "detail": {
    "eventName": [
      "PutImage"
    ],
    "requestParameters": {
      "repositoryName": [
        "${var.cluster_name}-repo-1"
      ]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda_task_1" {
  rule      = aws_cloudwatch_event_rule.pipeline_task_1.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.update_lambda_task_1.arn
}

# CloudWatch rule and use it to trigger the lambda for task 2
resource "aws_cloudwatch_event_rule" "pipeline_task_2" {
  name        = "${var.cluster_name}-task-2"
  description = "Detect new image and trigger lambda for task 2"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ecr"
  ],
  "detail": {
    "eventName": [
      "PutImage"
    ],
    "requestParameters": {
      "repositoryName": [
        "${var.cluster_name}-repo-2"
      ]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda_task_2" {
  rule      = aws_cloudwatch_event_rule.pipeline_task_2.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.update_lambda_task_2.arn
}
