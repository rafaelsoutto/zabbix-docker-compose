#!/bin/bash

# parse command-line arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        --ip=*)
            ZABBIX_SERVER_IP="${1#*=}"
            shift
            ;;
        *)
            echo "$(tput setaf 1)ERROR: Invalid argument: $1$(tput sgr0)"
            exit 1
            ;;
    esac
done

echo "statinging"

sudo apt update
wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
sudo dpkg -i zabbix-release_5.0-1+focal_all.deb
sudo apt install -y zabbix-agent

sudo apt update

sudo apt install -y net-tools
interface=$(ip addr | awk '/state UP/ {print $2; exit}')
echo $interface
ipconfig=$(ifconfig "${interface%?}")
echo $ipconfig
local_ip_address=$(echo "$ipconfig" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo $local_ip_address

# Update zabbix_agentd.conf file
sudo sed -i "s/^Server=.*$/Server=$ZABBIX_SERVER_IP/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=.*$/ServerActive=$ZABBIX_SERVER_IP/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=.*$/Hostname=$local_ip_address/g" /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent
sudo systemctl status zabbix-agent