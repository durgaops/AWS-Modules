variable "dashboards" {
  description = "List of { name, body } where body is dashboard JSON string"
  type = list(object({
    name = string
    body = string
  }))
  default = []
}
