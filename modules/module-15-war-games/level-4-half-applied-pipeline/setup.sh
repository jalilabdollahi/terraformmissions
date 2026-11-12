#!/usr/bin/env bash
source "$TM_LIB"
chmod +x scripts/handshake.sh
# The pipeline run: the ash handshake is rejected (typo in the kiln name), so the apply dies midway.
terraform apply -auto-approve -input=false -no-color >"$TM_TMP/apply1.txt" 2>&1
[[ $? -ne 0 ]] || { echo "setup: expected the first apply to fail"; exit 1; }
for l in oak pine ash; do tm_record "tag_$l" "$(tm_state_attr "random_integer.tag[\"$l\"]" result)"; done
tm_record run_oak "$(tm_state_attr 'terraform_data.kiln_run["oak"]' id)"
tm_record run_pine "$(tm_state_attr 'terraform_data.kiln_run["pine"]' id)"
tm_record run_ash_failed "$(terraform state show 'terraform_data.kiln_run["ash"]' | sed -n 's/^ *id *= *"\(.*\)"/\1/p')"
# The runner was killed before it flushed everything: pine's tag never reached state.
terraform state rm 'random_integer.tag["pine"]' >/dev/null
# On-call, in a hurry, tainted the pine run although its handshake had been acknowledged.
terraform taint 'terraform_data.kiln_run["pine"]' >/dev/null
exit 0
