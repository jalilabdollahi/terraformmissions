#!/usr/bin/env bash
# Run once when a CI agent boots, before any terraform command.
mkdir -p "$HOME/.terraform.d/plugin-cache"
