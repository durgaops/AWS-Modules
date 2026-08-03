package org.controls

# Example OPA API policy for change management
default allow = false

allow {
  input.actor.role == "platform-admin"
  input.change.environment != "prod"
}

allow {
  input.actor.role == "platform-admin"
  input.change.environment == "prod"
  input.change.approvals[_].status == "approved"
  count(input.change.approvals) >= 2
}
