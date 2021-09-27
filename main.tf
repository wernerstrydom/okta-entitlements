resource "okta_group" "departments" {
  for_each    = local.departments
  name        = "Department - ${each.value.name}"
  description = each.value.description
}

//
// This simply says that if the department field is set in a user's profile
// they will be assigned to the right group.
//
resource "okta_group_rule" "departments" {
  for_each          = local.departments
  name              = "Department - ${each.value.name}"
  status            = "ACTIVE"
  group_assignments = [okta_group.departments[each.key].id]
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

resource "okta_group" "invalid_departments" {
  name        = "Validation - Missing Department"
  description = "Folks with the wrong department profile field"
}


resource "okta_group_rule" "invalid_departments" {
  name              = "Validation - Missing Department"
  status            = "ACTIVE"
  group_assignments = [okta_group.invalid_departments.id]
  expression_value  = local.departments_expression
}