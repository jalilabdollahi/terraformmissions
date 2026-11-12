# Runbook — Indigo Row Sorter Bump

## 1. Triage
```bash
terraform init
# Error: locked provider registry.terraform.io/hashicorp/tls 3.4.0 does not match configured version constraint ~> 4.0
```
The constraint moved but `.terraform.lock.hcl` still pins 3.4.0 (and local 2.4.0).

## 2. Snapshot before touching anything
```bash
terraform state pull > pre-upgrade.tfstate
cp .terraform.lock.hcl pre-upgrade.lock.hcl
```
Once the 4.x provider applies, the state schema is upgraded and 3.x can no longer read it.

## 3. Upgrade
```bash
terraform init -upgrade
terraform validate
```
`validate` now fails: `key_algorithm` (on `tls_self_signed_cert` and `tls_cert_request`) and
`ca_key_algorithm` (on `tls_locally_signed_cert`) are read-only in 4.x. Delete those lines.

## 4. Read the plan, do not just apply it
```bash
terraform plan
```
Three certificate-type resources are replaced because new arguments with defaults
(`set_subject_key_id`, `set_authority_key_id`, `is_ca_certificate`) appear as "forces replacement" against
the state written by 3.x. Check the list: `tls_private_key.ca` and `tls_private_key.sorter` are NOT in it.
Reissuing certificates over the same keys is safe because the sorters pin keys, not certificates.
If a private key were in the replace list you would stop here.

## 5. Apply and verify
```bash
terraform apply
terraform plan                                         # No changes
openssl verify -CAfile pki/ca.pem pki/sorter.pem      # pki/sorter.pem: OK
```
