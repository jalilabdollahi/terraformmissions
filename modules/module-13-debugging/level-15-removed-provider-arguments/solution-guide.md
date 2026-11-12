# Walkthrough - Spillway Gate Certificates

1. `terraform validate` reports `Invalid Configuration for Read-Only Attribute` for `key_algorithm` on two resources.
2. Confirm in the schema what changed:
   ```bash
   terraform providers schema -json | jq '.provider_schemas["registry.terraform.io/hashicorp/tls"].resource_schemas.tls_cert_request.block.attributes.key_algorithm'
   ```
   It is `"computed": true` with no `"optional"`/`"required"`: it can be read, never set. The provider's upgrade guide for 4.0 says
   the algorithm is now detected from the private key.
3. Remove `key_algorithm` from `tls_cert_request.spillway` and `tls_self_signed_cert.spillway`.
4. `terraform apply`. `terraform plan` is clean. `check`.

Do not "fix" it by pinning the old provider (`= 3.4.0`): the mission is to move forward.
