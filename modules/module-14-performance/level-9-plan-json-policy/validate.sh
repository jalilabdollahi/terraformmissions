#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file policy/check.sh "policy/check.sh is missing"
tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"manifest"' "the manifest resource has to stay"

FIX="$TM_TMP/fixtures"
mkdir -p "$FIX"

# plan <name> <resource_changes-json-array>
mkplan() { printf '{"format_version":"1.2","resource_changes":%s}\n' "$2" > "$FIX/$1.json"; }

OK_CREATE='{"address":"local_file.m[\"a\"]","type":"local_file","change":{"actions":["create"],"before":null,"after":{"filename":"./bonded/a.txt","file_permission":"0640","content":"x"}}}'

mkplan good_create "[$OK_CREATE]"
mkplan good_update '[{"address":"local_file.m","type":"local_file","change":{"actions":["update"],"before":{"filename":"./bonded/a.txt","file_permission":"0644"},"after":{"filename":"bonded/a.txt","file_permission":"0600"}}}]'
mkplan noop_old_perm '[{"address":"local_file.old","type":"local_file","change":{"actions":["no-op"],"before":{"filename":"./legacy/old.txt","file_permission":"0777"},"after":{"filename":"./legacy/old.txt","file_permission":"0777"}}}]'
mkplan data_read '[{"address":"data.local_file.x","mode":"data","type":"local_file","change":{"actions":["read"],"before":null,"after":{"filename":"./elsewhere/x.txt"}}}]'
mkplan unrelated_create '[{"address":"terraform_data.t","type":"terraform_data","change":{"actions":["create"],"before":null,"after":{"input":"x"}}}]'
printf '{"format_version":"1.2"}\n' > "$FIX/no_changes_key.json"
mkplan mixed_ok "[$OK_CREATE,{\"address\":\"terraform_data.t\",\"type\":\"terraform_data\",\"change\":{\"actions\":[\"no-op\"],\"before\":{},\"after\":{}}}]"

mkplan bad_delete '[{"address":"local_file.m","type":"local_file","change":{"actions":["delete"],"before":{"filename":"./bonded/a.txt","file_permission":"0640"},"after":null}}]'
mkplan bad_replace '[{"address":"local_file.m","type":"local_file","change":{"actions":["delete","create"],"before":{"filename":"./bonded/a.txt","file_permission":"0640"},"after":{"filename":"./bonded/a.txt","file_permission":"0640"}}}]'
mkplan bad_replace_cbd '[{"address":"local_file.m","type":"local_file","change":{"actions":["create","delete"],"before":{"filename":"./bonded/a.txt","file_permission":"0640"},"after":{"filename":"./bonded/a.txt","file_permission":"0640"}}}]'
mkplan bad_delete_other '[{"address":"terraform_data.t","type":"terraform_data","change":{"actions":["delete"],"before":{},"after":null}}]'
mkplan bad_world_readable '[{"address":"local_file.m","type":"local_file","change":{"actions":["create"],"before":null,"after":{"filename":"./bonded/a.txt","file_permission":"0644"}}}]'
mkplan bad_default_perm '[{"address":"local_file.m","type":"local_file","change":{"actions":["create"],"before":null,"after":{"filename":"./bonded/a.txt","file_permission":"0777"}}}]'
mkplan bad_null_perm '[{"address":"local_file.m","type":"local_file","change":{"actions":["create"],"before":null,"after":{"filename":"./bonded/a.txt"}}}]'
mkplan bad_update_perm '[{"address":"local_file.m","type":"local_file","change":{"actions":["update"],"before":{"filename":"./bonded/a.txt","file_permission":"0600"},"after":{"filename":"./bonded/a.txt","file_permission":"0666"}}}]'
mkplan bad_traversal '[{"address":"local_file.m","type":"local_file","change":{"actions":["create"],"before":null,"after":{"filename":"./bonded/../etc/cron.d/x","file_permission":"0600"}}}]'
mkplan bad_outside '[{"address":"local_file.m","type":"local_file","change":{"actions":["create"],"before":null,"after":{"filename":"./out/a.txt","file_permission":"0600"}}}]'
mkplan bad_one_of_two "[$OK_CREATE,{\"address\":\"local_file.z\",\"type\":\"local_file\",\"change\":{\"actions\":[\"create\"],\"before\":null,\"after\":{\"filename\":\"./bonded/z.txt\",\"file_permission\":\"0666\"}}}]"
echo 'this is not json' > "$FIX/garbage.json"

expect() { # expect <fixture> <exit code> <message>
  local out code
  out=$(bash policy/check.sh "$FIX/$1.json" 2>&1); code=$?
  if [[ "$code" != "$2" ]]; then
    tm_fail "policy/check.sh exited $code on '$1' (expected $2): $3"
  fi
  if [[ "$2" == "1" ]]; then
    grep -q 'VIOLATION' <<<"$out" || tm_fail "on '$1' the script must print a VIOLATION line"
  fi
}

expect good_create 0 "a compliant create must pass"
expect good_update 0 "an update that tightens permissions inside bonded/ must pass"
expect noop_old_perm 0 "unchanged objects are not checked (R2/R3 apply to create/update only)"
expect data_read 0 "data source reads are not checked"
expect unrelated_create 0 "creating a non-file resource is fine"
expect no_changes_key 0 "a plan with no resource_changes has nothing to violate"
expect mixed_ok 0 "a compliant mix must pass"

expect bad_delete 1 "R1: plain deletion"
expect bad_replace 1 "R1: replacement (delete then create) is a deletion too"
expect bad_replace_cbd 1 "R1: create-before-destroy replacement is a deletion too"
expect bad_delete_other 1 "R1 applies to every resource type"
expect bad_world_readable 1 "R2: 0644 gives read access to others"
expect bad_default_perm 1 "R2: the 0777 default must be rejected"
expect bad_null_perm 1 "R2: a missing file_permission is a violation"
expect bad_update_perm 1 "R2 applies to the 'after' values of updates"
expect bad_traversal 1 "R3: '..' in the filename"
expect bad_outside 1 "R3: files must live inside bonded/"
expect bad_one_of_two 1 "one bad resource among good ones must still fail the plan"

expect garbage 2 "R4: invalid JSON must exit 2"
bash policy/check.sh "$FIX/does-not-exist.json" >/dev/null 2>&1; code=$?
[[ "$code" == "2" ]] || tm_fail "policy/check.sh exited $code on a missing file (expected 2)"
bash policy/check.sh >/dev/null 2>&1; code=$?
[[ "$code" == "2" ]] || tm_fail "policy/check.sh exited $code with no argument (expected 2)"

# The real plan of this workspace must be compliant, and must contain real work.
tm_init
tm_plan_json
creates=$(jq '[.resource_changes[]? | select(.change.actions == ["create"])] | length' "$TM_TMP/plan.json")
[[ "$creates" -ge 4 ]] || tm_fail "the workspace plan creates $creates manifests; the four bonded casks must be planned"
bash policy/check.sh "$TM_TMP/plan.json" >"$TM_TMP/real.out" 2>&1; code=$?
if [[ "$code" != "0" ]]; then
  sed 's/^/   │ /' "$TM_TMP/real.out"
  tm_fail "the real plan of this workspace is compliant but policy/check.sh returned $code"
fi

tm_pass "policy/check.sh accepts $(ls "$FIX" | grep -c '^\(good\|noop\|data\|unrelated\|no_changes\|mixed\)') compliant plans, rejects every violation and fails closed"
