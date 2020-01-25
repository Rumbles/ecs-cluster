# Template the lambda script, zip it up, upload the package to the lambda for task 1

data "template_file" "lambda_task_1" {
  template = file("${path.module}/files/lambda_function.py")
  vars = {
    cluster_name          = var.cluster_name
    placement_expression  = "attribute:ecs.availability-zone in [${join(", ", data.aws_availability_zones.available.names)}]"
    repository_url        = aws_ecr_repository.repo_1.repository_url
    cluster_arn           = aws_ecs_cluster.ecs_cluster.arn
    service_name          = aws_ecs_service.ecs_service_task_1.name
    desired_count         = tonumber(var.task_1_desired_count)
    ecs_task_role         = aws_iam_role.ecs_task_role.arn
    container_port        = "${var.task_1_port}"
    container_protocol    = "${var.task_1_protocol}"
  }
}

resource "local_file" "lambda_task_1" {
  content = data.template_file.lambda_task_1.rendered
  filename = "${path.module}/files/task_1/lambda_function.py"

  depends_on = [
    data.template_file.lambda_task_1
  ]
}

data "archive_file" "lambda_task_1" {
  type        = "zip"
  source_file = "${path.module}/files/task_1/lambda_function.py"
  output_path = "${path.module}/files/task_1/lambda.zip"

  depends_on = [
    local_file.lambda_task_1
  ]
}

resource "aws_lambda_function" "update_lambda_task_1" {
  filename          = "${path.module}/files/task_1/lambda.zip"
  function_name     = "${var.cluster_name}-task-1"
  role              = aws_iam_role.iam_lambda_task_1.arn
  handler           = "lambda_function.lambda_handler"
  source_code_hash  = data.archive_file.lambda_task_1.output_base64sha256

  runtime = "python3.7"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_task_1" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.update_lambda_task_1.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.pipeline_task_1.arn
}

# Template the lambda script, zip it up, upload the package to the lambda for task 2

data "template_file" "lambda_task_2" {
  template = file("${path.module}/files/lambda_function.py")
  vars = {
    cluster_name          = var.cluster_name
    placement_expression  = "attribute:ecs.availability-zone in [${join(", ", data.aws_availability_zones.available.names)}]"
    repository_url        = aws_ecr_repository.repo_2.repository_url
    cluster_arn           = aws_ecs_cluster.ecs_cluster.arn
    service_name          = aws_ecs_service.ecs_service_task_1.name
    desired_count         = tonumber(var.task_2_desired_count)
    ecs_task_role         = aws_iam_role.ecs_task_role.arn
    container_port        = "${var.task_2_port}"
    container_protocol    = "${var.task_2_protocol}"
  }
}

resource "local_file" "lambda_task_2" {
  content = data.template_file.lambda_task_2.rendered
  filename = "${path.module}/files/task_2/lambda_function.py"

  depends_on = [
    data.template_file.lambda_task_2
  ]
}

data "archive_file" "lambda_task_2" {
  type        = "zip"
  source_file = "${path.module}/files/task_2/lambda_function.py"
  output_path = "${path.module}/files/task_2/lambda.zip"

  depends_on = [
    local_file.lambda_task_2
  ]
}

resource "aws_lambda_function" "update_lambda_task_2" {
  filename          = "${path.module}/files/task_2/lambda.zip"
  function_name     = "${var.cluster_name}-task-2"
  role              = aws_iam_role.iam_lambda_task_2.arn
  handler           = "lambda_function.lambda_handler"
  source_code_hash  = data.archive_file.lambda_task_2.output_base64sha256

  runtime = "python3.7"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.update_lambda_task_2.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.pipeline_task_2.arn
}
