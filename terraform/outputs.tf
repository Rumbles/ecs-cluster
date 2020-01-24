# Useful info for uploading images and testing the endpoint
output "repo_1_ecr_url" {
  value = aws_ecr_repository.repo_1.repository_url
}

output "repo_2_ecr_url" {
  value = aws_ecr_repository.repo_2.repository_url
}

output "endpoint_url_task_1" {
  value = "http://${aws_lb.application_load_balancer_task_1.dns_name}"
}

output "endpoint_url_task_2" {
  value = "http://${aws_lb.application_load_balancer_task_2.dns_name}"
}
