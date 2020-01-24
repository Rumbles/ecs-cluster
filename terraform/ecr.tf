# Create 2 ECR registries
resource "aws_ecr_repository" "repo_1" {
  name                 = "${var.cluster_name}-repo-1"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repo_2" {
  name                 = "${var.cluster_name}-repo-2"
  image_tag_mutability = "MUTABLE"
}
