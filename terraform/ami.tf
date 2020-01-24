# Find the latest ECS AMI
data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-*"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }

  owners = [
    "amazon"
  ]
}
