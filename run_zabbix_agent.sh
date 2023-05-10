#!/bin/bash

set -e

read -p "Do you want to skip ZABBIX install? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Skipping ZABBIX install."
else
  echo "Installing ZABBIX..."
  bash api/scripts/dependencies_install.sh
fi

source api/scripts/get_network_params.sh