#!/usr/bin/env bash
source "$TM_LIB"

T=tests/panel.tftest.hcl
tm_assert_file "$T" "tests/panel.tftest.hcl is missing"
for r in tile_area frieze_area panel_total; do
  tm_assert_config_has "^run[[:space:]]+\"$r\"" "run \"$r\" is missing"
done
tm_assert_config_has 'tile_cm2[[:space:]]*==[[:space:]]*3468' "the tile area assertion (3468) is gone"
tm_assert_config_has 'frieze_cm2[[:space:]]*==[[:space:]]*7400' "the frieze area assertion (7400) is gone"

# every module source in the test file must be an existing local directory
python3 - "$T" <<'PY'
import os, re, sys
text = open(sys.argv[1]).read()
srcs = re.findall(r'module\s*\{\s*source\s*=\s*"([^"]+)"', text)
if len(srcs) != 2:
    print("expected two module blocks, found %d" % len(srcs)); sys.exit(2)
for s in srcs:
    if not s.startswith("./") or not os.path.isfile(os.path.join(s, "main.tf")):
        print("module source %s does not point at a module directory" % s); sys.exit(3)
if len(set(srcs)) != 2:
    print("the two runs must test two different modules"); sys.exit(4)
PY
[[ $? -eq 0 ]] || tm_fail "a module source in the test file is not a usable ./ path to an existing module directory"

tm_init "terraform init failed - are the module sources valid?"
tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three runs must pass"

cut() {
  local why="$1" file="$2" old="$3" new="$4" d="$TM_TMP/cut-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/$file" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  (cd "$d" && terraform init -no-color && terraform test -no-color) >"$TM_TMP/cut.out" 2>&1 \
    && tm_fail "the suite passes although $why"
}
cut "tile grout allowance is wrong" modules/tile/main.tf '(var.edge_cm + 2) * (var.edge_cm + 2)' '(var.edge_cm + 1) * (var.edge_cm + 1)'
cut "frieze corners are forgotten" modules/frieze/main.tf ' + 4 * var.strip_cm * var.strip_cm' ''
tm_pass "both helper modules are tested at their own boundary and mutants are caught"
