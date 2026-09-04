variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "key_name" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "user_data_base64" {
  type    = string
  default = null
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "detailed_monitoring" {
  type    = bool
  default = false
}

variable "ebs_optimized" {
  type    = bool
  default = true
}

variable "disable_api_termination" {
  type    = bool
  default = false
}

variable "imds_http_tokens" {
  type    = string
  default = "required"
}

variable "imds_hop_limit" {
  type    = number
  default = 1
}

variable "root_volume_size" {
  type    = number
  default = 30
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "root_delete_on_termination" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
