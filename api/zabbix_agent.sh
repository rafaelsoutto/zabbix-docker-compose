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

sudo apt update -y
sudo apt install -y zabbix-agent --assume-yes
sudo apt install -y net-tools

sudo apt update
interface=$(ip addr | awk '/state UP/ {print $2; exit}')
echo $interface
ipconfig=$(ifconfig "${interface%?}")
echo $ipconfig
local_ip_address=$(echo "$ipconfig" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo $local_ip_address

# Update zabbix_agentd.conf file
sudo sed -i "s/^Server=.*$/Server=$ZABBIX_SERVER_IP,127.0.0.1/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=.*$/ServerActive=$ZABBIX_SERVER_IP,127.0.0.1/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=.*$/Hostname=$local_ip_address/g" /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent
sudo systemctl status zabbix-agent

curl -X POST -H 'Content-Type: application/json' -d '{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "'"$local_ip_address"'",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "'"$local_ip_address"'",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "2"
            }
        ],
        "templates": [
            {
                "templateid": "10001"
            }
        ],
        "inventory_mode": 1,
        "inventory": {
            "location_lat": "56.95387",
            "location_lon": "24.22067"
        }
    },
    "auth": "a8c283eff692a7abcfc77748c53a8a7140e979b3da86ea3a3042ee615bec36f4",
    "id": "1"
}' http://${ZABBIX_SERVER_IP}:8080/api_jsonrpc.php