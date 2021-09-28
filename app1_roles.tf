data "okta_group" "app1_users" {
  name = "AppRole - App1 - Users"
}

resource "okta_group_rule" "app1_users" {
  name   = "AppRole - App1 - Users"
  status = "ACTIVE"
  group_assignments = [
    data.okta_group.app1_users.id
  ]
  expression_value = "isMemberOfAnyGroup(\"${okta_group.departments["sales"].id}\", \"${okta_group.departments["eng"].id}\")"
}

data "okta_group" "app1_billing" {
  name = "AppRole - App1 - Billing"
}

resource "okta_group_rule" "app1_admins" {
  name   = "AppRole - App1 - Admins"
  status = "ACTIVE"
  group_assignments = [
    data.okta_group.app1_billing.id
  ]
  expression_value = "isMemberOfAnyGroup(\"${okta_group.departments["finance"].id}\")"
}


data "okta_group" "app1_admins" {
  name = "AppRole - App1 - Admins"
}

resource "okta_group_rule" "app1_admins" {
  name   = "AppRole - App1 - Admins"
  status = "ACTIVE"
  group_assignments = [
    data.okta_group.app1_admins.id
  ]
  expression_value = "isMemberOfAnyGroup(\"${okta_group.departments["it"].id}\")"
}
