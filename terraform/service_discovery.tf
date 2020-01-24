resource "aws_service_discovery_private_dns_namespace" "dns_namespace" {
  name        = "${aws_ecs_cluster.ecs_cluster.name}.local"
  description = "Service discovery for ECS cluster ${aws_ecs_cluster.ecs_cluster.name}"
  vpc         = module.vpc.vpc_id
}
