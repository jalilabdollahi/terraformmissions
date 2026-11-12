#!/usr/bin/env bash
source "$TM_LIB"
terraform apply -auto-approve -target=local_file.route_chart
