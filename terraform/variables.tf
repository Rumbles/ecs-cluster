variable "cluster_name" {
  description = "The name for all the resources. Only alphanumeric characters and hyphen allowed"
  default = ""
}

variable "aws_region" {
  default     = "eu-west-2"
  description = "The AWS region to use"
}

variable "ssh_key_name" {
  description = "SSH keyto add to instances. Optional"
  default     = ""
}

variable "instance_type_spot" {
  default = "t3.micro"
}

variable "instance_type_ondemand" {
  default = "t3.micro"
}

variable "spot_bid_price" {
  default = "0.0035"
}

variable "min_spot_instances" {
  default     = "1"
  description = "The minimum EC2 spot instances"
}

variable "max_spot_instances" {
  default     = "10"
  description = "The maximum EC2 spot instances"
}

variable "min_ondemand_instances" {
  default     = "0"
  description = "The minimum EC2 ondemand instances"
}

variable "max_ondmand_instances" {
  default     = "10"
  description = "The maximum EC2 ondemand instances"
}

variable "create_iam_service_linked_role" {
  default     = "false"
  description = "Whether or not to create a service-linked role"
}

variable "task_1_desired_count" {
  description = "The desired number of container instances to run of task 1."
  default = 2
}

variable "task_1_port" {
  description = "The port to expose to the load balancer on task 1"
  default = 8080
}

variable "task_1_protocol" {
  description = "The protocol to expose to the load balancer on task 1"
  default = "tcp"
}

variable "task_1_internal" {
  description = "Is task 1 an internal service?"
  default = false
}

variable "task_1_load_balancer_port" {
  description = "The port that task 1 load balancer will listen on"
  default = "80"
}

variable "task_1_load_balancer_protocol" {
  description = "The port that task 1 load balancer will listen on"
  default = "HTTP"
}

variable "task_2_desired_count" {
  description = "The desired number of container instances to run of task 2."
  default = 1
}

variable "task_2_port" {
  description = "The port to expose to the load balancer on task 2"
  default = 8080
}

variable "task_2_protocol" {
  description = "The protocol to expose to the load balancer on task 2"
  default = "tcp"
}

variable "task_2_internal" {
  description = "Is task 1 an internal service?"
  default = true
}

variable "task_2_load_balancer_port" {
  description = "The port that task 1 load balancer will listen on"
  default = "80"
}

variable "task_2_load_balancer_protocol" {
  description = "The port that task 1 load balancer will listen on"
  default = "HTTP"
}
