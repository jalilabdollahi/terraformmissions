#!/usr/bin/env bash
# Prints the borehole depth from the survey readings as a flat JSON object of strings.
here="$(cd "$(dirname "$0")" && pwd)"
depth=$(grep '^depth_m=' "$here/../survey/readings.txt" | cut -d= -f2)
printf '{"depth_m":"%s"}\n' "$depth"
