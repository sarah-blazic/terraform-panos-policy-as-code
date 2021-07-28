terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
    }
  }
  required_version = ">= 0.13"
}

provider "panos" {
  hostname = var.hostname
  username = var.user
  password = var.password
}

module "policy-as-code_policy" {
  source  = "sarah-blazic/policy-as-code/panos//modules/policy"
  version = "0.1.0"

  tags       = try(jsondecode(file("./iron_skillet/tags.json")), {})
  sec_policy = try(jsondecode(file("./iron_skillet/sec_policy.json")), {})
}

module "policy-as-code_security-profiles" {
  source  = "sarah-blazic/policy-as-code/panos//modules/security-profiles"
  version = "0.1.0"

  antivirus     = try(jsondecode(file("./iron_skillet/antivirus.json")), {})
  file_blocking = try(jsondecode(file("./iron_skillet/file_blocking.json")), {})
  wildfire      = try(jsondecode(file("./iron_skillet/wildfire.json")), {})
  vulnerability = try(jsondecode(file("./iron_skillet/vulnerability.json")), {})
  spyware       = try(jsondecode(file("./iron_skillet/spyware.json")), {})
}