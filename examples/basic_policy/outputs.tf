#policy
output "tags" {
  value = module.policy-as-code_policy.created_tags
}

output "security" {
  value = module.policy-as-code_policy.created_sec
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