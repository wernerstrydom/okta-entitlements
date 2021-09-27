resource "okta_group" "teams" {
  for_each    = local.teams
  name        = "Department - ${each.value.name}" 
  description = each.value.description
}

resource "okta_group_rule" "teams" {
    for_each    = local.teams
  name              = "Department - ${each.value.name}" 
  status            = "ACTIVE"
  group_assignments = [okta_group.teams[each.key].id]
  expression_value  = "user.department==\"${each.value.name}\""
}
