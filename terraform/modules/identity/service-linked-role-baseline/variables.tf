variable "service_linked_roles" {
  description = "List of { aws_service_name, description?, custom_suffix? }"
  type        = list(any)
  default = [
    { aws_service_name = "autoscaling.amazonaws.com", description = "EC2 Auto Scaling SLR" },
    { aws_service_name = "elasticloadbalancing.amazonaws.com", description = "ELB SLR" },
    { aws_service_name = "eks.amazonaws.com", description = "EKS SLR" }
  ]
}

variable "owner" {
  type    = string
  default = "Cloud Platform"
}

variable "tags" {
  type    = map(string)
  default = {}
}
