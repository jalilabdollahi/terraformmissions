#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
# Remember the identity of every tag so the validator can prove none was re-created.
terraform show -json | jq -r '[.values.root_module.resources[] | .values.id] | sort | join(",")' > "$TM_TMP/ids"
tm_record ids "$(shasum "$TM_TMP/ids" | cut -d' ' -f1)"
