#!/usr/bin/env bash
# Terraform's external data source sends the `query` map to this program as one JSON
# object on standard input, and expects one flat JSON object of strings on stdout.

input=$(cat)
bird=$(printf '%s' "$input" | jq -r '.bird // empty')
weight=$(printf '%s' "$input" | jq -r '.weight_g // empty')
pct=$(printf '%s' "$input" | jq -r '.target_pct // empty')

if [ -z "$bird" ] || [ -z "$weight" ] || [ -z "$pct" ]; then
  echo "flying-weight.sh: query must contain bird, weight_g and target_pct (got: $input)" >&2
  exit 1
fi

jq -n --arg bird "$bird" --argjson w "$weight" --argjson p "$pct" '
  ($w * $p / 100 | round) as $fly
  | {
      bird: $bird,
      flying_weight_g: ($fly | tostring),
      grams_to_lose: (([$w - $fly, 0] | max) | tostring),
      advice: (if $w > $fly then "hold back the next feed" else "ready to fly" end)
    }'
