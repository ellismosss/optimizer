#!/bin/bash
# Product janitor checks, called by company-os/scripts/janitor/run. Model: epc/tests/janitor.sh (one "ok   name" line per check, non-zero exit on any FAIL).
#
# This repo tracks exactly one file: optimizer-version.json, a version pointer used for
# the storefront's update check. The actual Optimizer extension source (TypeScript,
# Ableton Extensions SDK — see TECH-STACK.md) has not been located on this machine or
# under this GitHub account (EVEAAA-8/20, still open); this script only covers what is
# actually tracked here, which is not the product's source.
set -u; cd "$(dirname "$0")/.."; fail=0
run() { local name=$1; shift; if out=$("$@" 2>&1); then echo "ok   $name"; else echo "FAIL $name"; echo "$out" | tail -15 | sed 's/^/     /'; fail=1; fi; }

version_json_valid() {
  python3 -c '
import json, sys
try:
    data = json.load(open("optimizer-version.json", "rb"))
except (OSError, ValueError) as e:
    sys.exit("optimizer-version.json: %s" % e)
for key in ("version", "url"):
    if not isinstance(data.get(key), str) or not data[key]:
        sys.exit("optimizer-version.json: missing or empty required field %r" % key)
'
}

run "json: optimizer-version.json is well-formed" version_json_valid
exit $fail
