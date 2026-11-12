#!/usr/bin/env bash
source "$TM_LIB"
# The original registration.
tm_apply
CODE=$(tm_output_raw cabinet_code)
tm_record code "$CODE"
# A technician imports the same object under a second address using a temporary block, then deletes the block.
cat >dup_tmp.tf <<'EOF'
resource "random_integer" "cabinet_dup" {
  min = 100
  max = 999
}
EOF
if ! terraform import -input=false -no-color random_integer.cabinet_dup "$CODE,100,999" >"$TM_TMP/import.txt" 2>&1; then
  cat "$TM_TMP/import.txt"; exit 1
fi
rm -f dup_tmp.tf
exit 0
