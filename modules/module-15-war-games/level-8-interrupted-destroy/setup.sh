#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfvars "$TM_TMP/tfvars.new"
cp main.tf "$TM_TMP/main.tf.new"
# Festival weekend: Field B is up. (The shipped site plan line only works while the field is rigged.)
echo 'field_b_enabled = true' > terraform.tfvars
tm_apply
tm_record register_id "$(tm_state_attr random_id.client_register id)"
# Sunday night: the teardown run gets through marquee m1 before the runner is killed.
terraform apply -auto-approve -input=false -no-color -destroy \
  -target='module.field_b[0].terraform_data.rigging["m1"]' >"$TM_LAST_OUT" 2>&1 || exit 1
terraform state rm 'module.field_b[0].random_pet.marquee["m3"]' 'module.field_b[0].local_file.tags["m3"]' >/dev/null || exit 1
# The killed run left its lock behind, mid-way through m2.
printf 'pid=4242 marquee=m2 since=23:41:07\n' > crates/manifest.lock
cp "$TM_TMP/tfvars.new" terraform.tfvars
exit 0
