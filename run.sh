#!/bin/bash

set -e

cd zabbix

read -p "Do you want to skip Docker install? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Skipping Docker install."
else
  echo "Installing Docker..."
  sh install.sh
fi

sh start_zabbix.sh