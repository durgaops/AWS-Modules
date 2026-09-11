variable "zone_name" {
  type = string
}

variable "vpc_ids" {
  description = "VPCs associated to this private zone"
  type        = list(string)
}

variable "comment" {
  type    = string
  default = "Managed private hosted zone"
}

variable "records" {
  type = map(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    records = list(string)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
