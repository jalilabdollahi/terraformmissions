#!/usr/bin/env bash
source "$TM_LIB"
# the cert as it exists today: valid for only 6 hours, with no renewal window
tm_apply
tm_record serial "$(openssl x509 -in pki/charger.pem -noout -serial)"
