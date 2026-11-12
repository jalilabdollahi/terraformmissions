#!/usr/bin/env bash
source "$TM_LIB"

KALEIDOSCOPE=$(tm_recall kaleidoscope); CHECKSUM=$(tm_recall checksum)
[[ -n "$KALEIDOSCOPE" && -n "$CHECKSUM" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

# Count real occurrences in the config (comments stripped).
stripped=$(cat ./*.tf | grep -vE '^[[:space:]]*#')
decodes=$(grep -o 'jsondecode(' <<<"$stripped" | grep -c .)
hashes=$(grep -o 'sha256(' <<<"$stripped" | grep -c .)
reads=$(grep -o 'shards\.json' <<<"$stripped" | grep -c .)
[[ "$decodes" == "1" ]] || tm_fail "jsondecode( appears $decodes times in the config; decode the catalogue exactly once"
[[ "$reads" == "1" ]] || tm_fail "shards.json is read in $reads places; read it exactly once"
[[ "$hashes" == "1" ]] || tm_fail "sha256( appears $hashes times in the config; compute the checksum exactly once"
tm_assert_config_has '(^|[[:space:]])locals[[:space:]]*\{' "the shared values belong in a locals block"
for r in north south east west; do
  tm_assert_config_has "\"${r}_index\"" "local_file.${r}_index has to stay"
done
tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"summary"' "local_file.summary has to stay"
tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"audit_stamp"' "local_file.audit_stamp has to stay"

tm_init
tm_validate

# Nothing may change: files and outputs are byte-identical to the originals.
tm_assert_no_changes
tm_apply
[[ "$(cat kaleidoscope/*.txt | shasum | cut -d' ' -f1)" == "$KALEIDOSCOPE" ]] || tm_fail "the generated kaleidoscope files are not identical to the originals"
tm_assert_output checksum "$CHECKSUM"

for r in north south east west; do
  expected=$(jq -r --arg r "$r" '[.shards[] | select(.quadrant==$r)] | length' data/shards.json)
  tm_assert_output_jq quadrant_counts ".${r} == ${expected}" "quadrant_counts.${r} should be ${expected}"
done
tm_pass "the catalogue is decoded and hashed once; all six files and both outputs are unchanged"
