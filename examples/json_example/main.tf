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

  tags       = try(jsondecode(file("./json/tags.json")), {})
  services   = try(jsondecode(file("./json/services.json")), {})
  addr_group = try(jsondecode(file("./json/addr_group.json")), {})
  addr_obj   = try(jsondecode(file("./json/addr_obj.json")), {})
  sec_policy = try(jsondecode(file("./json/sec_policy_demo.json")), {})
  nat_policy = try(jsondecode(file("./json/nat.json")), {})
}

module "policy-as-code_security-profiles" {
  source  = "sarah-blazic/policy-as-code/panos//modules/security-profiles"
  version = "0.1.0"

  antivirus     = try(jsondecode(file("./json/antivirus.json")), {})
  file_blocking = try(jsondecode(file("./json/file_blocking.json")), {})
  wildfire      = try(jsondecode(file("./json/wildfire.json")), {})
  vulnerability = try(jsondecode(file("./json/vulnerability.json")), {})
  spyware       = try(jsondecode(file("./json/spyware.json")), {})
}