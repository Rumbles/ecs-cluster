module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "VPC of cluster ${var.cluster_name}"
  cidr = "10.0.8.0/21"

  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2]
  ]
  private_subnets = [
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24"
  ]
  public_subnets = [
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24"
  ]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true
  create_vpc         = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
locals {
  public_subnet_ids = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  vpc_cidr = module.vpc.vpc_cidr_block
}
