#!/usr/bin/env bash
source "$TM_LIB"
# Fingerprint the vendored mirror so the validator can prove it was not touched.
find vendor -type f -exec shasum {} \; | sort | shasum | cut -d' ' -f1 > "$TM_TMP/vendor.sum"
tm_record vendor "$(cat "$TM_TMP/vendor.sum")"
