#!/usr/bin/env bash
# Prints the chamber humidity from the survey readings as a flat JSON object of strings.
here="$(cd "$(dirname "$0")" && pwd)"
h=$(grep '^humidity_pct=' "$here/../survey/readings.txt" | cut -d= -f2)
printf '{"humidity_pct":"%s"}\n' "$h"
