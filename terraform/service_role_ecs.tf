resource "aws_iam_service_linked_role" "ecs" {
  custom_suffix    = var.cluster_name
  aws_service_name = "ecs.amazonaws.com"

  count = var.create_iam_service_linked_role == "true" ? 1 : 0
}
