#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"archive_file"' "the bundle must be built with the archive_file data source"

check_bundle() {
  # $1 = expected sorted member list (JSON)
  python3 - "$1" <<'PY' || return 1
import hashlib, json, pathlib, sys, zipfile
expected = json.loads(sys.argv[1])
z = pathlib.Path("dist/bureau.zip")
if not z.is_file():
    print("dist/bureau.zip does not exist"); sys.exit(1)
names = sorted(n for n in zipfile.ZipFile(z).namelist() if not n.endswith("/"))
if names != expected:
    print("zip members are %s, expected %s" % (names, expected)); sys.exit(1)
PY
}

tm_apply
msg=$(check_bundle '["airmail.txt","coil-stamps.txt","definitives/penny-black.txt"]') || tm_fail "$msg"

sha=$(python3 -c 'import hashlib;print(hashlib.sha256(open("dist/bureau.zip","rb").read()).hexdigest())')
size=$(python3 -c 'import os;print(os.path.getsize("dist/bureau.zip"))')
tm_assert_output bundle_sha256 "$sha"
tm_assert_output bundle_size "$size"
tm_assert_file_contains dist/receipt.txt "SHA-256: $sha" "the receipt must carry the hex SHA-256 of the zip"

# New files: a real label is bundled, the draft is not, and the checksum follows.
cp labels/label-draft.tmp "$TM_TMP/draft.orig"
trap 'rm -f labels/definitives/lighthouses.txt; cp "$TM_TMP/draft.orig" labels/label-draft.tmp' EXIT
printf 'Lighthouse Set\nissued: 2023-07-07\nperf: 12\n' > labels/definitives/lighthouses.txt
printf 'unfinished\n' > labels/label-draft.tmp
tm_apply
msg=$(check_bundle '["airmail.txt","coil-stamps.txt","definitives/lighthouses.txt","definitives/penny-black.txt"]') || tm_fail "$msg"
sha2=$(python3 -c 'import hashlib;print(hashlib.sha256(open("dist/bureau.zip","rb").read()).hexdigest())')
[[ "$sha2" != "$sha" ]] || tm_fail "the bundle did not change after adding a label"
tm_assert_output bundle_sha256 "$sha2"
tm_assert_file_contains dist/receipt.txt "SHA-256: $sha2" "the receipt did not follow the new bundle"
tm_pass "the bundle holds the finished labels and the receipt carries its SHA-256"
