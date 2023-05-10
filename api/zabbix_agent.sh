#!/bin/bash

# parse command-line arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        --ip=*)
            ZABBIX_SERVER_IP="${1#*=}"
            shift
            ;;
    esac
done

sudo apt update
wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
sudo dpkg -i zabbix-release_5.0-1+focal_all.deb
sudo apt install zabbix-agent
sudo systemctl status zabbix-agent

sudo apt update

sudo apt install -y net-tools
export interface=$(ip addr | awk '/state UP/ {print $2; exit}')
export ipconfig=$(ifconfig "${interface%?}")
export local_ip_address=$(echo "$ipconfig" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

sudo sed -i 's/^Server=.*/Server=<${ZABBIX_SERVER_IP}>/g' /etc/zabbix/zabbix_agentd.conf
sudo sed -i 's/^ServerActive=.*/ServerActive=<${ZABBIX_SERVER_IP}>/g' /etc/zabbix/zabbix_agentd.conf
sudo sed -i 's/^Hostname=.*/Hostname=<${local_ip_address}>/g' /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent