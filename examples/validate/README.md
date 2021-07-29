Palo Alto Networks Panorama Modules Validation
---
It is recommended that the user uses the Github actions in conjunction with the Rego and JSON schemas located in this Folder. These tools help insure that the JSON file inputs are formatted correctly for the Terraform process.

Usage
---
1. Add validate folder, which contains the Rego and JSON schemas to validate the JSON text.

2. Add **tlint.yml**, **"opa.yml"**, and **"validate.yml"** to .github/workflows with changes to file paths in opa.yml and validate.yml depending on the repo.
* **tlint.yml** : checks to see if the Terraform has errors (like illegal instance types) for Major Cloud providers (AWS/Azure/GCP), warns about deprecated syntax, unused declarations, and enforces best practices, naming conventions.
```yaml
name: terraform-lint

on: [push, pull_request]

jobs:
  delivery:

    runs-on: ubuntu-latest

    steps:
    - name: Check out code
      uses: actions/checkout@main
    - name: Lint Terraform
      uses: actionshub/terraform-lint@main

```

* **opa.yml** : checks JSON for duplicate names.
```yaml
name: Check for JSON duplicates
on: [push]

jobs:
  opa_eval:
    runs-on: ubuntu-latest
    name: Open Policy Agent
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Evaluate OPA Basic Policy w/tags
      id: opa_eval_tags_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/tags.json #path to tags file

    - name: Print Results of Basic Policy tags
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_tags_basic.outputs.opa_results }}

    - name: Evaluate OPA Basic Policy w/sec_ex
      id: opa_eval_sec_ex_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/sec_policy.json #path to security policy file

    - name: Print Results Basic policy sec_ex
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_sec_ex_basic.outputs.opa_results }}
       
    - name: Evaluate OPA json example w/addr_obj
      id: opa_eval_addr_obj
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/json_example/json/addr_obj.json #path to address objects file

    - name: Print Results addr_obj
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_addr_obj.outputs.opa_results }}

    - name: Evaluate OPA json example w/addr_group
      id: opa_eval_addr_group
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/json_example/json/addr_group.json #path to address groups file

    - name: Print Results addr_group
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_addr_group.outputs.opa_results }}

    - name: Evaluate OPA json example w/NAT
      id: opa_eval_NAT
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/json_example/json/nat.json #path to nat security policy file

    - name: Print Results json example nat
      run: |
        echo $opa_results | jq -r '.result[].expressions[].value'
      env:
        opa_results: ${{ steps.opa_eval_NAT.outputs.opa_results }}

    - name: Evaluate OPA Basic Policy w/anti_spyware
      id: opa_eval_antispyware_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/spyware.json
        
    - name: Evaluate OPA json example w/sevices
      id: opa_eval_service
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/json_example/json/services.json #path to services file

    - name: Print Results json example services
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_service.outputs.opa_results }}

    - name: Print Results Basic policy antispyware
      run: |
        echo $opa_results | jq -r '.result[].expressions[].value'
      env:
        opa_results: ${{ steps.opa_eval_antispyware_basic.outputs.opa_results }}

    - name: Evaluate OPA Basic Policy w/antivirus
      id: opa_eval_antivirus_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/antivirus.json

    - name: Print Results basic policy antivirus
      run: |
        echo $opa_results | jq -r '.result[].expressions[].value'
      env:
        opa_results: ${{ steps.opa_eval_antivirus_basic.outputs.opa_results }}

    - name: Evaluate OPA Basic Policy w/file_blocking
      id: opa_eval_file_blocking_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/file_blocking.json

    - name: Print Results basic policy file blocking
      run: |
        echo $opa_results | jq -r '.result[].expressions[].value'
      env:
        opa_results: ${{ steps.opa_eval_file_blocking_basic.outputs.opa_results }}

    - name: Evaluate OPA Basic Policy w/vulnerability
      id: opa_eval_vulnerability_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/vulnerability.json

    - name: Print Results basic policy vulnerability
      run: |
        echo $opa_results | jq -r '.result[].expressions[].value'
      env:
        opa_results: ${{ steps.opa_eval_vulnerability_basic.outputs.opa_results }}

    - name: Evaluate OPA Basic Policy w/wildfire
      id: opa_eval_wildfire_basic
      uses: migara/test-action@master
      with:
        tests: ./examples/validate/opa/panos.rego
        policy: ./examples/basic_policy/iron_skillet/wildfire.json

    - name: Print Results basic policy wildfire
      run: |
        echo $opa_results | jq -r '.result[].expressions[].value'
      env:
        opa_results: ${{ steps.opa_eval_wildfire_basic.outputs.opa_results }}

```

* **validate.yml** : checks to see if JSON validates against the provided schemas (located in the validate folder).
```yaml
name: Validate JSONs

on: [pull_request, push]

jobs:
  verify-json-validation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1

      - name: Validate tags JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/tags_schema.json
          jsons: ./examples/json_example/json/tags.json,examples/basic_policy/iron_skillet/tags.json #path to tags file

      - name: Validate address objects JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/addr_obj_schema.json
          jsons: ./examples/json_example/json/addr_obj.json #path to address objects file

      - name: Validate address group JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/addr_group_schema.json
          jsons: ./examples/json_example/json/addr_group.json #path to address groups file

      - name: Validate nat JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/NAT_schema.json
          jsons: ./examples/json_example/json/nat.json #path to NAT policy file

      - name: Validate security policy JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/sec_policy_schema.json
          jsons: ./examples/json_example/json/sec_policy.json,examples/basic_policy/iron_skillet/sec_policy.json  #path to security policy file

      - name: Validate services JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/services_schema.json
          jsons: ./examples/json_example/json/services.json #path to services file

      - name: Validate anti spyware JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/anti_spyware_schema.json
          jsons: ./examples/json_example/json/spyware.json,./examples/basic_policy/iron_skillet/spyware.json # change this to the anti-spyware JSON path

      - name: Validate antivirus JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/antivirus_schema.json
          jsons: ./examples/json_example/json/antivirus.json,./examples/basic_policy/iron_skillet/antivirus.json # change this to the antivirus JSON path

      - name: Validate file blocking JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/file_blocking_schema.json
          jsons: ./examples/json_example/json/file_blocking.json,./examples/basic_policy/iron_skillet/file_blocking.json # change this to the file-blocking JSON path

      - name: Validate vulnerability JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/vulnerability_schema.json
          jsons: ./examples/json_example/json/vulnerability.json,./examples/basic_policy/iron_skillet/vulnerability.json # # change this to the vulnerability JSON path

      - name: Validate wildfire analysis JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./examples/validate/schemas/wildfire_schema.json
          jsons: ./examples/json_example/json/wildfire.json,./examples/basic_policy/iron_skillet/wildfire.json # change this to the wildfire JSON path
```
