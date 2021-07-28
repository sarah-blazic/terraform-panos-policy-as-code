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

  tags       = try(jsondecode(file("./yaml/tags.yml")), {})
  services   = try(jsondecode(file("./yaml/services.yml")), {})
  addr_group = try(jsondecode(file("./yaml/addr_group.yml")), {})
  addr_obj   = try(jsondecode(file("./yaml/addr_obj.yml")), {})
  sec_policy = try(jsondecode(file("./yaml/sec_policy_demo.yml")), {})
  nat_policy = try(jsondecode(file("./yaml/nat.yml")), {})
}

module "policy-as-code_security-profiles" {
  source  = "sarah-blazic/policy-as-code/panos//modules/security-profiles"
  version = "0.1.0"

  antivirus     = try(jsondecode(file("./yaml/antivirus.yml")), {})
  file_blocking = try(jsondecode(file("./yaml/file_blocking.yml")), {})
  wildfire      = try(jsondecode(file("./yaml/wildfire.yml")), {})
  vulnerability = try(jsondecode(file("./yaml/vulnerability.yml")), {})
  spyware       = try(jsondecode(file("./yaml/spyware.yml")), {})
}