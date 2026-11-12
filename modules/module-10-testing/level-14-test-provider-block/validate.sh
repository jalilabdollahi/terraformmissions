#!/usr/bin/env bash
source "$TM_LIB"

T=tests/pressroom.tftest.hcl
tm_assert_file "$T" "tests/pressroom.tftest.hcl is missing"
grep -q 'configuration_aliases' terraform.tf || tm_fail "terraform.tf must keep declaring configuration_aliases"
grep -q 'local.press' terraform.tf && grep -q 'local.vault' terraform.tf \
  || tm_fail "terraform.tf must declare both the press and vault aliases"

python3 - "$T" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
aliases = sorted(re.findall(r'^provider\s+"local"\s*\{\s*alias\s*=\s*"([^"]+)"', text, re.M | re.S))
if aliases != ["press", "vault"]:
    print("test-file provider aliases are %s, the configuration needs press and vault" % aliases); sys.exit(2)
runs = re.findall(r'^run\s+"([^"]+)"', text, re.M)
if sorted(runs) != ["catalog_number_flows", "master_is_read_only", "sleeve_goes_to_press"]:
    print("the three original runs must remain: %s" % runs); sys.exit(3)
m = re.search(r'run\s+"master_is_read_only".*?providers\s*=\s*\{([^}]*)\}', text, re.S)
if not m or "local.vault" not in m.group(1) or "local.press" not in m.group(1):
    print("master_is_read_only must map both local.press and local.vault"); sys.exit(4)
PY
[[ $? -eq 0 ]] || tm_fail "the provider configuration in the test file does not match the aliases the code requires"

tm_init
tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three runs must pass"
[[ ! -d press && ! -d vault ]] || tm_fail "plan-only runs should not leave press/ or vault/ directories behind"

wreck() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/wreck-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/pressroom.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  (cd "$d" && terraform test -no-color) >"$TM_TMP/wreck.out" 2>&1 && tm_fail "the suite passes although $why"
}
wreck "master logs become writable" 'file_permission = "0400"' 'file_permission = "0644"'
wreck "the sleeve note is filed under the vault" '/press/${var.catalog_no}.txt' '/vault/${var.catalog_no}.txt'
tm_pass "provider aliases line up between the test file and the module, and mutants are caught"
