#!/bin/bash

ZABBIX_SERVER_IP=3.83.160.132

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
    "auth": "7e9c0d525e728d02f19cb6c2f75761a44af2fa5e802a051c5119ba226951000c",
    "id": "1"
}' http://${ZABBIX_SERVER_IP}:8080/api_jsonrpc.php