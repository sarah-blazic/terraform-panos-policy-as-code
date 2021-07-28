#policy
output "tags" {
  value = module.policy-as-code_policy.created_tags
}

output "address_obj" {
  value = module.policy-as-code_policy.created_addr_obj
}

output "address_group" {
  value = module.policy-as-code_policy.created_addr_group
}

output "services" {
  value = module.policy-as-code_policy.created_services
}

output "security" {
  value = module.policy-as-code_policy.created_sec
}

output "nat" {
  value = module.policy-as-code_policy.created_nat
}

#security profiles
output "antivirus" {
  value = module.policy-as-code_security-profiles.created_antivirus_prof
}

output "spyware" {
  value = module.policy-as-code_security-profiles.created_spyware_prof
}

output "file_block" {
  value = module.policy-as-code_security-profiles.created_file_blocking_prof
}

output "vulnerability" {
  value = module.policy-as-code_security-profiles.created_vulnerability_prof
}

output "wildfire" {
  value = module.policy-as-code_security-profiles.created_wildfire_prof
}