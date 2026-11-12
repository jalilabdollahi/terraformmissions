"""Shared credential check for the Brannock quota tooling (do not edit: owned by fisheries-platform)."""
import hashlib
import os
import sys
import time

SALT = "brannock-quay-2023"
REGIONS = ("north-sea", "irish-sea", "celtic-sea", "channel")
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
LOG = os.path.join(ROOT, "logs", "quota-lookup.log")
TOKEN_FILE = os.path.join(ROOT, ".credentials", "quota-token")


def log(msg):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    with open(LOG, "a") as fh:
        fh.write("%s %s\n" % (time.strftime("%Y-%m-%dT%H:%M:%S"), msg))


def load_token():
    env = os.environ.get("QUOTA_TOKEN")
    if env:
        return env.strip(), "env QUOTA_TOKEN"
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE) as fh:
            return fh.read().strip(), ".credentials/quota-token"
    return None, "none"


def refuse(tool, code, reason):
    log("%s REFUSED code=%d %s" % (tool, code, reason))
    sys.stderr.write("quota registry refused the request (code %d); details in logs/quota-lookup.log\n" % code)
    sys.exit(1)


def authenticate(tool, region):
    token, source = load_token()
    if token is None:
        refuse(tool, 40, "no credential found (looked in env QUOTA_TOKEN and .credentials/quota-token)")
    parts = token.split(".")
    if len(parts) != 4 or parts[0] != "qr1":
        refuse(tool, 41, "token from %s is malformed" % source)
    _, scope, exp, sig = parts
    good = hashlib.sha256(("%s.%s.%s" % (scope, exp, SALT)).encode()).hexdigest()[:10]
    if sig != good:
        refuse(tool, 42, "token from %s has an invalid signature" % source)
    if exp < time.strftime("%Y%m%d"):
        refuse(tool, 43, "token from %s expired on %s" % (source, exp))
    if scope != "prod":
        refuse(tool, 44, "token scope '%s' is not accepted by the production registry" % scope)
    if region not in REGIONS:
        refuse(tool, 45, "unknown region '%s'; the registry serves: %s" % (region, ", ".join(REGIONS)))
    log("%s ok region=%s token_source=%s scope=%s exp=%s" % (tool, region, source, scope, exp))
