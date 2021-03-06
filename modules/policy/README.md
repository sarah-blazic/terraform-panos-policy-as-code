Palo Alto Networks Panorama Policy Module for Policy as Code
---
This Terraform module allows users to configure policies (NAT and Security Policies) along with tags, address objects, address groups, and services with Palo Alto Networks **PAN-OS** based PA-Series devices.

Usage
---
1. Create a JSON/YAML file to config one or more of the following: tags, address objects, address groups, services, nat rules, and security policy. Please note that the file(s) must adhere to its respective schema.

Below is an example of a JSON file to create Tags.
```json
[
  {
    "name": "trust"
  },
  {
    "name": "untrust",
    "comment": "for untrusted zones",
    "color": "color4"
  },
  {
    "name": "AWS",
    "device_group": "AWS",
    "color": "color8"
  }
]
```

Below is an example of a YAML file to create Tags.
```yaml
---
- name: trust
- name: untrust
  comment: for untrusted zones
  color: color4
- name: AWS
  device_group: AWS
  color: color8
```

2. Create a **"main.tf"** with the panos provider and policy module blocks.
```terraform
provider "panos" {
  hostname = "<panos_address>"
  username = "<admin_username>"
  password = "<admin_password>"
}

module "policy-as-code_policy" {
  source  = "sarah-blazic/policy-as-code/panos//modules/policy"
  version = "0.1.0"

  #for JSON examples: try(jsondecode(file("<*.json>")), {})
  #for YAML examples: try(yamldecode(file("<*.yaml>")), {})
  tags       = try(...decode(file("<tags JSON/YAML>")), {}) # eg. "tags.json"
  services   = try(...decode(file("<services JSON/YAML>")), {})
  addr_group = try(...decode(file("<address groups JSON/YAML>")), {})
  addr_obj   = try(...decode(file("<address objects JSON/YAML>")), {})
  sec        = try(...decode(file("<security policies JSON/YAML>")), {})
  nat        = try(...decode(file("<NAT policies JSON/YAML>")), {})
}
```


4. Run Terraform
```
terraform init
terraform apply
terraform output -json
```

Cleanup
---
```
terraform destroy
```


Requirements
---
* Terraform 0.13+

Providers
---
Name | Version
-----|------
panos | 1.8.3

Compatibility
---
This module is meant for use with **PAN-OS >= 8.0** and **Terraform >= 0.13**

Permissions
---
* In order for the module to work as expected, the hostname, username, and password to the **panos** Terraform provider.

Caveats
---
* Tags, address objects, address groups, and services can be associated to one or more polices on a PAN-OS device. Once any tags, address objects, address groups, or/and services are associated to a policy, it can only be deleted if there are no policies associated with any of those resources. If the users tries to delete any of those resources that are associated with any policy, they will encounter an error. This is a behavior on a PAN-OS device. This module creates, updates and deletes polices with Terraform. If a security profile, tag, address object, address group, and/or service associated to a security policy is deleted from the panorama, the module will throw an error when trying to create the profile. This is the correct and expected behavior as the resource is being used in a policy.

Inputs
---
Name | Description | Type | Default | Required
-----|-----|-----|-----|-----
tags | (optional) List of tag objects.<br><br>- `name`: (required) The administrative tag's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `comment`: (optional) The description of the administrataive tag.<br>- `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `color1`. Note that the colors go from 1 to 16.<br><br>Example:<pre><br>[<br>  {<br>        name = "trust"<br>  }<br>  {<br>        name = "untrust"<br>        comment = "for untrusted zones"<br>        color = "color4"<br>  }<br>  {<br>        name = "AWS"<br>        device_group = "AWS"<br>        color = "color8"<br>  }<br>]</pre> |`any`|n/a|yes
services | (optional) List of service objects.<br><br>- `name`: (required) The service object's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the service object.<br>- `protocol`: (required) The type of address object. Valid values are `ip-netmask`, `ip-range`, `fqdn`, or `ip-wildcard` (only available with PAN-OS 9.0+).<br>- `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like `192.168.80.150` or `192.168.80.0/24`.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<pre><br>[<br>    {<br>      name = "azure_int_lb_priv_ip"<br>      type = "ip-netmask"<br>      value = {<br>            "ip-netmask = "10.100.4.40/32"<br>      }<br>      tags = ["trust"]<br>      device_group = "AZURE"<br>    }<br>    {<br>      name = "pa_updates"<br>      type = "fqdn"<br>      value = {<br>            fqdn = "updates.paloaltonetworks.com"<br>      }<br>      description = "palo alto updates"<br>    }<br>    {<br>      name = "ntp1"<br>      type = "ip-range"<br>      value = {<br>            ip-range = "10.0.0.2-10.0.0.10"<br>      }<br>    }<br>]</pre>|`any`|n/a|yes
addr_obj | (optional) List of the address objects.<br><br>- `name`: (required) The address object's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the address object.<br>- `type`: (optional) The type of address object. Valid values are `ip-netmask`, `ip-range`, `fqdn`, or `ip-wildcard` (only available with PAN-OS 9.0+) (default: `ip-netmask`).<br>- `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like `192.168.80.150` or `192.168.80.0/24`.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<pre><br>[<br>    {<br>      name = "azure_int_lb_priv_ip"<br>      type = "ip-netmask"<br>      value = {<br>            "ip-netmask = "10.100.4.40/32"<br>      }<br>      tags = ["trust"]<br>      device_group = "AZURE"<br>    }<br>    {<br>      name = "pa_updates"<br>      type = "fqdn"<br>      value = {<br>            fqdn = "updates.paloaltonetworks.com"<br>      }<br>      description = "palo alto updates"<br>    }<br>    {<br>      name = "ntp1"<br>      type = "ip-range"<br>      value = {<br>            ip-range = "10.0.0.2-10.0.0.10"<br>      }<br>    }<br>]</pre>|`any`|n/a|yes
addr_group | (optional) List of the address group objects.<br><br>- `name`: (required) The address group's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the address group.<br>- `static_addresses`: (optional) The address objects to include in this statically defined address group.<br>- `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `'<tag name>' or ...`.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<pre><br>[<br>    {<br>      name = "static ntp grp"<br>      description": "ntp servers"<br>      static_addresses = ["ntp1", "ntp2"]<br>    }<br>    {<br>      name = "trust and internal grp",<br>      description = "dynamic servers",<br>      dynamic_match = "'trust'and'internal'",<br>      tags = ["trust"]<br>    }<br>]</pre>|`any`|n/a|yes
sec_policy | (optional) List of the Security policy rule objects.<br><br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `rulebase`: (optional) The rulebase for the Security Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).<br>- `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.<br>- `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.<br>- `rules`: (required) The security rule definition. The security rule ordering will match how they appear in the terraform plan file.<ul>- `name`: (required) The security rule's name.</ul><ul>- `description`: (optional) The description of the security rule.</ul><ul>- `type`: (optional) Rule type. Valid values are `universal`, `interzone`, or `intrazone` (default: `universal`).</ul><ul>- `tags`: (optional) List of administrative tags.</ul><ul>- `source_zones`: (optional) List of source zones (default: `any`).</ul><ul>- `negate_source`: (optional) Boolean designating if the source should be negated (default: ```false```).</ul><ul>- `source_users`: (optional) List of source users (default: `any`).</ul><ul>- `hip_profiles`: (optional) List of HIP profiles (default: `any`).</ul><ul>- `destination_zones`: (optional) List of destination zones (default: `any`).</ul><ul>- `destination_addresses`: (optional) List of destination addresses (default: `any`).</ul><ul>- `negate_destination`: (optional) Boolean designating if the destination should be negated (default: `false`).</ul><ul>- `applications`: (optional) List of applications (default: `any`).</ul><ul>- `services`: (optional) List of services (default: `application-default`).</ul><ul>- `category`: (optional) List of categories (default: `any`).</ul><ul>- `action`: (optional) Action for the matched traffic. Valid values are `allow`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `allow`).</ul><ul>- `log_setting`: (optional) Log forwarding profile.</ul><ul>- `log_start`: (optional) Boolean designating if log the start of the traffic flow (default: `false`).</ul><ul>- `log_end`: (optional) Boolean designating if log the end of the traffic flow (default: `true`).</ul><ul>- `disabled`: (optional) Boolean designating if the security policy rule is disabled (default: `false`).</ul><ul>- `schedule`: (optional) The security rule schedule.</ul><ul>- `icmp_unreachable`: (optional) Boolean enabling ICMP unreachable (default: `false`).</ul><ul>- `disable_server_response_inspection`: (optional) Boolean disabling server response inspection (default: `false`).</ul><ul>-`profile_setting`: (optional) The profile setting. Valid values are `none`, `group`, or `profiles` (default: `none`).</ul><ul>- `group`: (optional) Profile setting: `Group` - The group profile name.</ul><ul>- `virus`: (optional) Profile setting: `Profiles` - Input the desired antivirus profile name.</ul><ul>- `spyware`: (optional) Profile setting: `Profiles` - Input the desired anti-spyware profile name.</ul><ul>- `vulnerability`: (optional) Profile setting: `Profiles` - Input the desired vulnerability profile name.</ul><ul>- `url_filtering`: (optional) Profile setting: `Profiles` - Input the desired URL filtering profile name.</ul><ul>- `file_blocking`: (optional) Profile setting: `Profiles` - Input the desired File-Blocking profile name.</ul><ul>- `wildfire_analysis`: (optional) Profile setting: `Profiles` - Input the desired Wildfire Analysis profile name.</ul><ul>- `data_filtering`: (optional) Profile setting: `Profiles` - Input the desired Data Filtering profile name.</ul><ul>-`target`: (optional) The target firewall.<ul>-`serial`: (required) The serial no. of the firewall.<br>-`vsys_list`: (optional) The vsys list.</ul></ul><br><br>Example:<pre><br>[<br>    {<br>      rulebase = "pre-rulebase"<br>      rules = [<br>            {<br>              name = "Outbound Block Rule"<br>              description = "Block outbound sessions with destination address matching one of the Palo Alto Networks external dynamic lists for high risk and known malicious IP addresses."<br>              source_zones = ["any"]<br>              source_addresses = ["any"]<br>              destination_zones = ["any"]<br>              destination_addresses = [<br>                    "panw-highrisk-ip-list",<br>                    "panw-known-ip-list",<br>                    "panw-bulletproof-ip-list"<br>              ]<br>              action = "deny"<br>            }<br>      ]<br>    }<br>]</pre>|`any`|n/a|yes
nat_policy | (optional) List of the NAT policy rule objects.<br><br><br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `rulebase`: (optional) The rulebase for the NAT Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).<br>- `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.<br>- `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.<br>- `rules`: (required) The NAT rule definition. The NAT rule ordering will match how they appear in the terraform plan file.<ul>- `name`: (required) The NAT rule's name.<br>- `description`: (optional) The description of the NAT rule.<br>- `type`: (optional) NAT type. Valid values are `ipv4`, `nat64`, or `nptv6` (default: `ipv4`).<br>- `tags`: (optional) List of administrative tags.<br>- `disabled`: (optional) Boolean designating if the security policy rule is disabled (default: `false`).<br><br><br>-`target`: (optional) The target firewall.<ul>-`serial`: (required) The serial no. of the firewall.<br>-`vsys_list`: (optional) The vsys list.</ul></ul><ul>- `original_packet`: (required) The original packet specification.<ul>- `source_zones`: (optional) List of source zones (default: `any`).</ul><ul>- `destination_zone`: (optional) The destination zone (default: `any`).</ul><ul>- `destination_interface`: (optional) Egress interface from the lookup (default: `any`).</ul><ul>- `service`: (optional) Service for the original packet (default: `any`).</ul><ul>- `source_addresses`: (optional) List of source addresses (default: `any`).</ul><ul>- `destination_addresses`: (optional) List of destination addresses (default: `any`).</ul><br><br>- `translated_packet`: (required) The translated packet specifications.<ul>- `source`: (optional) The source specification. Valid values are `none`, `dynamic_ip_port`, `dynamic_ip`, or `static_ip` (default: `none`).<ul><br>- `dynamic_ip_and_port`: (optional) Dynamic IP and port source translation specification.<ul>- `translated_addresses`: (optional) Not functional if `interface_address` is configured. List of translated addresses.</ul><ul>- `interface_address`: (optional) Not functional if `translated_addresses` is configured. Interface address source translation type specifications.<ul>- `interface`: (required) The interface.<br>- `ip_address`: (optional) The IP address.</ul></ul><br>- `dynamic_ip`: (optional) Dynamic IP source translation specification.<ul>- `translated_addresses`: (optional) The list of translated addresses.<br>- `fallback`: (optional) The fallback specifications (default: `none`).<ul>- `translated_addresses`: (optional) Not functional if `interface_address` is configured. List of translated addresses.<br>- `interface_address`: (optional) Not functional if `translated address` is configured. The interface address fallback specifications.<ul>- `interface`: (required) Source address translated fallback interface.<br>- `type`: (optional) Type of interface fallback. Valid values are `ip` or `floating` (default: `ip`).<br>- `ip_address`: (optional) IP address of the fallback interface.</ul></ul></ul><br>- `static_ip`: (optional) Static IP source translation specifications.<ul>- `translated_address`: (required) The statically translated source address.<br>- `bi_directional`: (optional) Boolean enabling bi-directional source address translation (default: `false`).</ul></ul><br>- `destination`: (optional) The destination specification. Valid values are `none`, `static_translation`, or `dynamic_translation` (default: `none`).<ul><br>- `static_translation`: (optional) Specifies a static destination NAT.<ul>- `address`: (required) Destination address translation address.<br>- `port`: (optional) Integer destination address translation port number.</ul><br>- `dynamic_translation`: (optional) Specify a dynamic destination NAT. Only available for PAN-OS 8.1+.<ul>- `address`: (required) Destination address translation address.<br>- `port`: (optional) Integer destination address translation port number.<br>- `distribution`: (optional) Distribution algorithm for destination address pool. Valid values are `round-robin`, `source-ip-hash`, `ip-modulo`, `ip-hash`, or `least-sessions` (default: `round-robin`). Only available for PAN-OS 8.1+.</ul></ul></ul></ul><br><br>Example:<pre><br>[<br>    {<br>      device_group = "AWS"<br>      rules = [<br>            {<br>              name = "rule1"<br>              original_packet = {<br>                    source_zones = ["trust"]<br>                    destination_zone = "untrust"<br>                    destination_interface = "any"<br>                    source_addresses = ["google_dns1"]<br>                    destination_addresses = ["any"]<br>              }<br>              translated_packet = {<br>                    source = "dynamic_ip"<br>                    translated_addresses = ["google_dns1", "google_dns2"]<br>                    destination = "static_translation"<br>                    static_translation = {<br>                      address = "10.2.3.1"<br>                      port = 5678<br>                    }<br>              }<br>            }<br>            {<br>              name = "rule2"<br>              original_packet = {<br>                    source_zones = ["untrust"]<br>                    destination_zone = "trust"<br>                    destination_interface = "any"<br>                    source_addresses = ["any"]<br>                    destination_addresses = ["any"]<br>              }<br>              translated_packet = {<br>                    source = "static_ip<br>                    static_ip = {<br>                      translated_address = "192.168.1.5"<br>                      bi_directional = true<br>                    }<br>                    destination = "none"<br>              }<br>            }<br>            {<br>                name = "rule3"<br>                original_packet = {<br>                  source_zones = ["dmz"]<br>                  destination_zone = "dmz"<br>                  destination_interface = "any"<br>                  source_addresses = ["any"]<br>                  destination_addresses = ["any"]<br>                }<br>                translated_packet = {<br>                  source = "dynamic_ip_and_port"<br>                  interface_address = {<br>                    interface = "ethernet1/5"<br>                  }<br>                  destination = "none"<br>                }<br>            }<br>            {<br>              name = "rule4"<br>              original_packet = {<br>                    source_zones = ["dmz"]<br>                    destination_zone = "dmz"<br>                    destination_interface = "any"<br>                    source_addresses = ["any"]<br>                    destination_addresses = ["trust and internal grp"]<br>              }<br>              translated_packet = {<br>                    source = "dynamic_ip"<br>                    translated_addresses = ["localnet"]<br>                    fallback = {<br>                      translated_addresses = ["ntp1"]<br>                    }<br>                    destination = "dynamic_translation"<br>                    dynamic_translation = {<br>                      address = "localnet"<br>                      port = 1234<br>                    }<br>              }<br>            }<br>      ]<br>    }<br>]</pre>|`any`|n/a|yes

Outputs
---
Name | Description
-----|-----
created_tags | Shows the tags that were created.
created_services |Shows the services that were created.
created_addr_obj |Shows the address objects that were created.
created_addr_group |Shows the address groups that were created.
created_sec |Shows the security policies that were created.
created_nat |Shows the NAT policies that were created.
