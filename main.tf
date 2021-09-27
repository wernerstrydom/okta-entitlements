resource "okta_group" "teams" {
  for_each    = local.teams
  name        = "Department - ${each.value.name}"
  description = each.value.description
}

//
// This simply says that if the department field is set in a user's profile
// they will be assigned to the right group.
//
resource "okta_group_rule" "teams" {
  for_each          = local.teams
  name              = "Department - ${each.value.name}"
  status            = "ACTIVE"
  group_assignments = [okta_group.teams[each.key].id]
  expression_value  = "user.department==\"${each.value.name}\""
}

//
// It's a garbage in, garbage out world. So we want a group which tells us
// whether the department field is invalid, so someone in people operations
// can fix it, or if the department name has changed, update the automation.
//
locals {
  // Let's create an expression for each department
  department_expression = [
    for k, v in local.departments : "user.department != \"${v.name}\""
  ]
  // Let's combine the expressions 
  departments_expression = join(" and ", local.department_expression)
}

resource "okta_group_rule" "invalid_teams" {
  name              = "Validation - Department"
  status            = "ACTIVE"
  group_assignments = [okta_group.teams[each.key].id]
  expression_value  = "user.department==\"${each.value.name}\""
}