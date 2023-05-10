#!/bin/bash

set -e

source env-variables.sh

sudo docker-compose pull
sudo docker-compose up -d

echo -e "\e[32mZabbix is running on port 8080. To access it, use localhost:8080 if you are running it on your machine, or access the machine instance IP you are running Zabbix on.\e[0m"