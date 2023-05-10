#!/bin/bash

function deploy_zabbix_agent() {
    for ip in "$@"; do

      echo "trying to SSH into $ip"

        # Try SSH with login credentials ubuntu/ubuntu
        sshpass -p 'ubuntu' ssh ubuntu@$ip "echo 'SSH connection with login credentials ubuntu/ubuntu successful' && \
            scp ../zabbix_agent.sh ubuntu@$ip:/home/ubuntu && \
            ssh ubuntu@$ip 'sudo chmod +x /home/ubuntu/zabbix_agent.sh && /home/ubuntu/zabbix_agent.sh' && exit" \
            && continue

        # Try SSH with login credentials windows/windows
        sshpass -p 'windows' ssh windows@$ip "echo 'SSH connection with login credentials windows/windows successful' && \
            scp /path/to/zabbix_agent.sh windows@$ip:/home/windows && \
            ssh windows@$ip 'sudo chmod +x /home/windows/zabbix_agent.sh && /home/windows/zabbix_agent.sh' && exit" \
            && continue

        # Try SSH with key.pem certificate
        ssh -i "../key.pem" ubuntu@$ip "echo 'SSH connection with key.pem certificate successful' && \
             scp ../zabbix_agent.sh ubuntu@$ip:/home/ubuntu && \
             ssh ubuntu@$ip 'sudo chmod +x /home/ubuntu/zabbix_agent.sh && /home/ubuntu/zabbix_agent.sh' && exit" \
            && continue

        echo "Could not deploy zabbix agent to $ip"
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
echo $ip_list

deploy_zabbix_agent $ip_list
