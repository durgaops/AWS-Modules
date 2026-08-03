variable "name" {
  description = "Name tag for the instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size (GiB)"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "kms_key_id" {
  description = "KMS key ARN/ID for EBS encryption"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Associate a public IP"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the instance"
  type        = map(string)
  default     = {}
}
