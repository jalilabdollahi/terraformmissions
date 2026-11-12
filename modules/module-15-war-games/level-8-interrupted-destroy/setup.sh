#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfvars "$TM_TMP/tfvars.new"
cp main.tf "$TM_TMP/main.tf.new"
# Fair weekend: Hall B is up. (The shipped floor plan line only works while the hall exists.)
echo 'hall_b_enabled = true' > terraform.tfvars
tm_apply
tm_record register_id "$(tm_state_attr random_id.exhibitor_register id)"
# Sunday night: the teardown run gets through stand s1 before the runner is killed.
terraform apply -auto-approve -input=false -no-color -destroy \
  -target='module.hall_b[0].terraform_data.rigging["s1"]' >"$TM_LAST_OUT" 2>&1 || exit 1
terraform state rm 'module.hall_b[0].random_pet.stand["s3"]' 'module.hall_b[0].local_file.signage["s3"]' >/dev/null || exit 1
# The killed run left its lock behind, mid-way through s2.
printf 'pid=4242 stand=s2 since=23:41:07\n' > crates/manifest.lock
cp "$TM_TMP/tfvars.new" terraform.tfvars
exit 0
