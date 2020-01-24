# IAM role to be applied to the ec2 instances used to running the ECS cluster
resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name_prefix = var.cluster_name
  role        = aws_iam_role.ecs_role.name
}

resource "aws_iam_role_policy" "service_policy" {
  name    = "ecsServicePolicy"
  role    = aws_iam_role.ecs_role.name
  policy  = file("${path.module}/files/ec2-iam.json")
}
