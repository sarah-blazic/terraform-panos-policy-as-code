Palo Alto Networks Panorama Security Profiles Module for Policy as Code
---
This Terraform module allows users to configure security profiles (Antivirus, Anti-Spyware, File-Blocking, Vulnerability, and Wildfire-Analysis) with Palo Alto Networks **PAN-OS** based PA-Series devices.

Usage
---
1. Create a JSON/YAML file to config one or more security profile. Please note that the file(s) must adhere to its respective schema located in the validate folder.

Below is an example of a JSON file to create a File-Blocking security profile.
```json
[
  {
    "name": "ex1",
    "device_group": "AWS",
    "description": "ex1 file blocking security profile",
    "rule": [
      {
        "name": "rule1",
        "direction": "upload",
        "applications": [
          "any"
        ],
        "file_types": [
          "msp"
        ]
      }
    ]
  }
]
```

Below is an example of a YAML file to create a File-Blocking security profile.
```yaml
---
- name: ex1
  device_group: AWS
  description: ex1 file blocking security profile
  rule:
  - name: rule1
    direction: upload
    applications:
    - any
    file_types:
    - msp
```

2. Create a **"main.tf"** with the panos provider and security profile module blocks.
```terraform
provider "panos" {
  hostname = "<panos_address>"
  username = "<admin_username>"
  password = "<admin_password>"
}

module "policy-as-code_security-profiles" {
  source  = "sarah-blazic/policy-as-code/panos//modules/security-profiles"
  version = "0.1.0"

  #for JSON files: try(jsondecode(file("<*.json>")), {})
  #for YAML files: try(yamldecode(file("<*.yaml>")), {})
  antivirus     = try(...decode(file("<antivirus JSON/YAML>")), {}) # eg. "antivirus.json"
  file_blocking = try(...decode(file("<file-blocking JSON/YAML>")), {})
  wildfire      = try(...decode(file("<wildfire analysis JSON/YAML>")), {})
  vulnerability = try(...decode(file("<vulnerability JSON/YAML>")), {})
  spyware       = try(...decode(file("<anti-spyware JSON/YAML>")), {})
}
```


3. Run Terraform
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
* Security profiles can be associated to one or more polices on a PAN-OS device. Once a security profile is associated to a policy, it can only be deleted if there are no policies associated with that security profiles. If the users tries to delete a security profile that is associated with any policy, they will encounter an error. This is a behavior on a PAN-OS device. This module creates, updates and deletes security profiles with Terraform. If a tag associated to a security profile is deleted from the panorama, the module will throw an error when trying to create the profile. This is the correct and expected behavior as the profile is being used in a policy.


Inputs
---
Name | Description | Type | Default | Required
-----|-----|-----|-----|-----
antivirus | (optional) List of the Antivirus Profile objects.<br><br>- `name`: (required) Identifier of the Antivirus security profile.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the Antivirus profile.<br>- `packet_capture`: (optional) Boolean that enables packet capture (default: `false`).<br>- `threat_exceptions`: (optional) A string list of threat exceptions.<br><br><br>- `decoder`: (optional) List of objects following the decoder specifications.<ul>- `name`: (required) Decoder name.</ul><ul>- `actions`: (optional) Decoder action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).</ul><ul>- `wildfire_action`: (optional) Wildfire action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).</ul><ul>- `machine_learning_action`: (optional) Only available with PAN-OS 10.0+, machine learning action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).</ul><br><br><br>- `application_exception`: (optional) List of objects following the application exception specifications.<ul>- `application`: (required) The application name.<br>- `action`: (optional) The action performed when approached with the application exception. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).</ul><br><br><br>- `machine_learning_model`: (optional) List of objects following the machine learning model specifications.<ul>- `model`: (required) The model.<br>- `action`: (required) The action for the machine learning model to perform. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).</ul><br><br><br>- `machine_learning_exception`: (optional) List of objects following the machine learning exception specifications.<ul>- `name`: (required) Partial hash of file included in the machine learning exception.<br>- `description`: (optional) The description of the exception.<br>- `filename`: (optional) The filename for the exception</ul><br><br>Example:<br><pre><br>[<br>    {<br>      name = "Alert-Only-AV"<br>      decoder: [<br>            {<br>              name = "http"<br>              action = "alert"<br>              wildfire_action = "alert"<br>              machine_learning = "alert"<br>            }<br>      ]<br>      machine_learning_model = [<br>            {<br>              model = "Windows Executables"<br>              action = "enable"<br>            }<br>            {<br>              model = "PowerShell Script 1"<br>              action = "enable"<br>            }<br>      <br>    }<br>]<br></pre><br> |`any`|n/a|no
spyware | (optional)  List of the Anti-Spyware Profile objects.<br><br>- `name`: (required) Identifier of the Anti-Spyware security profile.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the Anti-Spyware profile.<br>- `packet_capture`: (optional) Packet capture setting for PAN-OS 8.X only). Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>- `sinkhole_ipv4_address`: (optional) IPv4 sinkhole address.<br>- `sinkhole_ipv6_address`: (optional) IPv6 sinkhole address.<br>- `threat_exceptions`: (optional) A string list of threat exceptions.<br><br><br>- `botnet_list`: (optional) List of objects following the botnet specifications.<ul>- `name`: (required) Botnet name.<br>- `actions`: (optional) Botnet action. Valid values are `allow`, `alert`, `block`, `default`, or `sinkhole` (default: `default`).<br>- `packet_capture`: (optional) Packet capture setting for PAN-OS 9.0+. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).</ul><br><br><br>- `dns_category`: (optional) List of objects following the DNS category specifications for PAN-OS 10.0+.<ul>- `name`: (required) DNS category name.</ul><ul>- `action`: (optional) DNS category action. Valid values are `default`, `allow`, `alert`, `drop`, `block`, or `sinkhole` (default: `default`).</ul><ul>- `log_level`: (optional) Logging level. Valid values are `default`, `none`, `low`, `informational`, `medium`, `high`, or `critical` (default: `default`).</ul><ul>- `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).</ul><br><br><br>- `white_list`: (optional) List of objects following the white list specifications.<ul>- `name`: (required) White list object name.<br>- `description`: (optional) Description of the white list.</ul><br><br><br>- `rule`: (optional) List of objects following the rule specifications.<ul>- `name`: (required) Rule name.</ul><ul>- `threat_name`: (optional) Threat name.</ul><ul>- `category`: (optional) Category for the anti-spyware policy (default: `any`).</ul><ul>- `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).</ul><ul>- `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).</ul><ul>- `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.</ul><ul>- `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.</ul><br><br><br>- `exception`: (optional) List of objects following the exceptions specifications.<ul>- `name`: (required) Threat name for the exception. You can use the `panos_predefined_threat` data source to discover the various names available to use.</ul><ul>- `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).</ul><ul>- `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).</ul><ul>- `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.</ul><ul>- `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.</ul><ul>- `exempt_ips`: (optional) List of exempt IPs.</ul><br><br>Example:<br><pre><br>[<br>  {<br>      name = "Outbound-AS"<br>      device_group = "shared"<br>      botnet_list = [<br>          {<br>              name = "default-paloalto-dns"<br>              action = "sinkhole"<br>              packet_capture = "single-packet"<br>          }<br>      ]<br>      dns_category = [<br>          {<br>              name = "pan-dns-sec-benign"<br>          }<br>          {<br>              name = "pan-dns-sec-cc"<br>              action = "sinkhole"<br>              packet_capture = "single-packet"<br>          }<br>      ]<br>      sinkhole_ipv4_address = "72.5.65.111"<br>      sinkhole_ipv6_address = "2600:5200::1"<br>      rule = [<br>            {<br>              name = "Block-Critical-High-Medium"<br>              action = "reset-both"<br>              severities = ["critical","high","medium"]<br>              packet_capture = "single-packet"<br>            }<br>            {<br>              name = "Default-Low-Info"<br>              severities = ["low","informational"]<br>              packet_capture = "disable"<br>            }<br>       ]<br>    }<br>]<br></pre><br>| `any`| n/a | no
file_blocking | (optional) List of the File-Blocking Profile objects.<br><br>- `name`: (required) Identifier of the File-blocking security profile.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the File-blocking profile.<br><br><br>- `rule`: (optional) List of objects following the rule specifications.<ul>- `name`: (required) Rule name.</ul><ul>- `applications`: (optional) List of applications (default: `any`).</ul><ul>- `file_types`: (optional) File types included in the file-blocking rule.</ul><ul>- `direction`: (optional) Direction for the file-blocking rule to flow. Valid values are `both`, `upload`, or `download` (default: `both`).</ul><ul>- `action`: (optional) Action for the policy to take. Valid values are `alert`, `block`, or `continue` (default: `alert`).</ul><br><br>Example:<br><pre><br>[<br>    {<br>      name = "Outbound-FB"<br>      rule = [<br>            {<br>              name = "Alert-All"<br>              applications = ["any"]<br>              file_types = ["any"]<br>              direction = "both"<br>              action = "alert"<br>            }<br>            {<br>              name = "Block"<br>              applications = ["any"]<br>              file_types = [<br>                    "7z",<br>                    "bat",<br>                    "chm",<br>                    "class",<br>                    "cpl",<br>                    "dll",<br>                    "hlp",<br>                    "hta",<br>                    "jar",<br>                    "ocx",<br>                    "pif",<br>                    "scr",<br>                    "torrent",<br>                    "vbe",<br>                    "wsf"<br>              ]<br>              direction = "both"<br>              action = "block"<br>            }<br>      ]<br>    }<br>]<br></pre><br> | `any` | n/a | no
vulnerability_file | (optional) List of the Vulnerability Profile objects.<br><br>- `name`: (required) Identifier of the Vulnerability security profile.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the vulnerability profile.<br><br><br>- `rule`: (optional) List of objects following the rule specifications.<ul>- `name`: (required) Rule name.</ul><ul>- `threat_name`: (optional) Threat name.</ul><ul>- `cves`: (optional) List of CVEs (default: `any`).</ul><ul>- `host`: (optional) The host. Valid values are `any`, `client`, or `server` (default: `any`).</ul><ul>- `vendor_ids`: (optional) List of vendor IDs (default: `any`).</ul><ul>- `category`: (optional) Category for the file-blocking policy (default: `any`).</ul><ul>- `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).</ul><ul>- `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).</ul><ul>- `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).</ul><ul>- `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.</ul><ul>- `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.</ul><br><br><br>- `exception`: (optional) List of objects following the exceptions specifications.<ul>- `name`: (required) Threat name for the exception. You can use the `panos_predefined_threat` data source to discover the various names available to use.</ul><ul>- `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).</ul><ul>- `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).</ul><ul>- `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.</ul><ul>- `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.</ul><ul>- `exempt_ips`: (optional) List of exempt IPs.</ul><ul>- `time_interval`: (optional) Time interval integer.</ul><ul>- `time_threshold`: (optional) Time threshold integer.</ul><ul>- `time_track_by`: (optional) Time track by setting. Valid values are `source`, `destination`, or `source-and-destination`.</ul><br><br>Example:<br><pre><br>[<br>    {<br>      name = "Outbound-VP"<br>          rule = [<br>                    {<br>                       name = "Block-Critical-High-Medium"<br>                       action = "reset-both"<br>                       vendor_ids = ["any"]<br>                       severities = ["critical","high","medium"]<br>                       cves = ["any"]<br>                       threat_name = "any"<br>                       host = "any"<br>                       category = "any"<br>                       packet_capture = "single-packet"<br>                   }<br>                   {<br>                       name = "Default-Low-Info"<br>                       action = "default"<br>                       vendor_ids = ["any"]<br>                       severities = ["low","informational"]<br>                       cves = ["any"]<br>                       threat_name = "any"<br>                       host = "any"<br>                       category = "any"<br>                       packet_capture = "disable"<br>                    }<br>              ]<br>        }<br>]<br></pre><br> |`any`|n/a|no
wildfire_file | (optional) List of the Wildfire Analysis Profile objects.<br><br>- `name`: (required) Identifier of the Wildfire Analysis security profile.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the Wildfire Analysis profile.<br><br>- `rule`: (optional) List of objects following the rule specifications.<ul>- `name`: (required) Rule name.</ul><ul>- `applications`: (optional) List of applications (default: `any`).</ul><ul>- `file_types`: (optional) List of file types (default: `any`).</ul><ul>- `direction`: (optional) Direction for the wildfire analysis policy. Valid values are `both`, `upload`, or `download` (default: `both`).</ul><ul>- `analysis`: (optional) Analysis setting. Valid values are `public-cloud` or `private-cloud` (default: `public-cloud`).</ul><br>Example:<br><pre><br>[<br>  {<br>        name = "Outbound-WF"<br>        rule = [<br>          {<br>                name = "Forward-All"<br>                applications = ["any"]<br>                file_types = ["any"]<br>                direction = "both"<br>                analysis = "public-cloud"<br>          }<br>        ]<br>  }<br>]<br></pre><br>|`any`|n/a|no


Outputs
---
Name | Description
-----|-----
created_antivirus_prof | Shows the antivirus security profiles that were created.
created_spyware_prof |Shows the anti-spyware security profiles that were created.
created_file_blocking_prof |Shows the file blocking security profiles that were created.
created_vulnerability_prof |Shows the vulnerability security profiles that were created.
created_wildfire_prof |Shows the wildfire analysis security profiles that were created.
