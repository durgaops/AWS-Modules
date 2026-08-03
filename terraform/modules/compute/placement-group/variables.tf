variable "name" { type = string }
variable "strategy" {
  description = "cluster, partition, or spread"
  type        = string
  default     = "spread"
}
variable "partition_count" {
  type    = number
  default = null
}
variable "spread_level" {
  type    = string
  default = "rack"
}
variable "tags" {
  type    = map(string)
  default = {}
}
