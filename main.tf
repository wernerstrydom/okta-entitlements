resource "okta_group" "teams" {
  for_each    = local.teams
  name        = "Department - ${each.value.name}" 
  description = each.value.description
}
