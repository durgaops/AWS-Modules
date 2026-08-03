variable "vpc_id" {
  type = string
}

variable "route_tables" {
  description = "Map of RT name => { routes = [...], tags = {} }"
  type        = any
  default     = {}
}

variable "associations" {
  description = "Map of association name => { subnet_id, route_table_key }"
  type = map(object({
    subnet_id       = string
    route_table_key = string
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
