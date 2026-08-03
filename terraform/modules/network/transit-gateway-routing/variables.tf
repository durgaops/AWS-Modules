variable "transit_gateway_id" { type = string }

variable "route_tables" {
  description = "Map of RT name => { static_routes = [...], tags = {} }"
  type        = any
  default     = {}
}

variable "associations" {
  description = "Map => { attachment_id, route_table_key }"
  type = map(object({
    attachment_id   = string
    route_table_key = string
  }))
  default = {}
}

variable "propagations" {
  description = "Map => { attachment_id, route_table_key }"
  type = map(object({
    attachment_id   = string
    route_table_key = string
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
