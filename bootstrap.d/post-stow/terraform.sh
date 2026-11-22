#!/bin/sh
# Terraform refuses to start if plugin_cache_dir (terraform/.terraformrc) is missing.
mkdir -p "$HOME/.terraform.d/plugin-cache"
