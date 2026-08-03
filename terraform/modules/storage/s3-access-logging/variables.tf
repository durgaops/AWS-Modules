variable "source_bucket_id" {
  type = string
}

variable "target_bucket_id" {
  type = string
}

variable "target_prefix" {
  type    = string
  default = "s3-access-logs/"
}

variable "tags" {
  type    = map(string)
  default = {}
}
