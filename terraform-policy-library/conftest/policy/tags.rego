package terraform.tags

required_tags := {"Environment", "Owner", "CostCenter"}

deny[msg] {
  rc := input.resource_changes[_]
  rc.mode == "managed"
  rc.change.actions[_] != "delete"
  tags := object.get(rc.change.after, "tags", {})
  missing := required_tags - {t | tags[t]}
  count(missing) > 0
  msg := sprintf("%s.%s missing required tags: %v", [rc.type, rc.name, missing])
}
