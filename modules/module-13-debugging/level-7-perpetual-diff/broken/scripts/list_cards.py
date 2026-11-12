#!/usr/bin/env python3
"""Lists the trading cards held in the society cabinet (a set, so no inherent order)."""
import json
import sys

sys.stdin.read()
cards = {"ember-drake-1993", "tidepool-knight-1996", "moss-golem-1991", "star-pilot-1999", "iron-owl-1994"}
print(json.dumps({"names": ",".join(cards)}))
