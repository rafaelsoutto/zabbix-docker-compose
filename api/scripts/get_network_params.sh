#!/bin/bash

function deploy_zabbix_agent() {
  for ip in "$@"; do

    echo "trying to ssh into $ip"

    if nc $ip 22; then
      if sshpass -p "ubuntu" ssh -o StrictHostKeyChecking=no ubuntu@"$ip" "echo Connection successful"; then
        sshpass -p "ubuntu" scp -o StrictHostKeyChecking=no ./zabbix_agent.sh ubuntu@"$ip":~
        sshpass -p "ubuntu" ssh -o StrictHostKeyChecking=no ubuntu@"$ip" "bash ~/zabbix_agent.sh"

      elif sshpass -p "windows" ssh -o StrictHostKeyChecking=no windows@"$ip" "echo Connection successful"; then
        sshpass -p "windows" scp -o StrictHostKeyChecking=no ./zabbix_agent.sh windows@"$ip":~
        sshpass -p "windows" ssh -o StrictHostKeyChecking=no windows@"$ip" "bash ~/zabbix_agent.sh"

      elif ssh -i api/key.pem -o StrictHostKeyChecking=no ubuntu@"$ip" "echo Connection successful"; then
        scp -i api/key.pem -o StrictHostKeyChecking=no ./zabbix_agent.sh ubuntu@"$ip":~
        ssh -i api/key.pem -o StrictHostKeyChecking=no ubuntu@"$ip" "bash ~/zabbix_agent.sh"
      fi
  else
    echo "Port 22 is not open on $ip"
  fi
done
}

# Get the IP address and netmask of the first active network interface
export interface=$(ip addr | awk '/state UP/ {print $2; exit}')
export ipconfig=$(ifconfig "${interface%?}")
export ip_address=$(echo "$ipconfig" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
export netmask=$(echo "$ipconfig" | grep -oP '(?<=netmask\s)\d+(\.\d+){3}')

export network=$(ipcalc -n "$ip_address" "$netmask" | grep Network | awk '{print $2}')


# Scan the network for live hosts and save the output to a variable
export scan_output=$(sudo nmap -sP $network)

# Initialize an empty list to store the IP addresses
ip_list=()

# Loop through each line of the scan output
while read -r line; do
    # Check if the line contains an IP address
    if [[ $line =~ ([0-9]{1,3}\.){3}[0-9]{1,3} ]]; then
        # Extract the IP address and add it to the list
        ip_address=${BASH_REMATCH[0]}
        ip_list+=("$ip_address")
    fi
done <<< "$scan_output"

# Print the list of IP addresses
echo ${ip_list[@]}

deploy_zabbix_agent ${ip_list[@]}