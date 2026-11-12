#!/usr/bin/env bash
source "$TM_LIB"
# Re-issue the catalogue twice so the state serial climbs, then settle on revision 3.
tm_apply -var revision=1
tm_apply -var revision=2
tm_apply
tm_record serial "$(terraform state pull | jq -r .serial)"
tm_record lineage "$(terraform state pull | jq -r .lineage)"
mkdir -p answers
