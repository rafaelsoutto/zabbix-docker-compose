#!/bin/bash

export MYSQL_DATABASE=zabbix
export MYSQL_USER=zabbix
export MYSQL_PASSWORD=zabbix
export MYSQL_ROOT_PASSWORD=root_pwd
export MYSQL_PROXY_DATABASE=zabbix_proxy
export ZBX_SERVER_HOST=zabbix-server
export ZBX_SERVER_NAME=Composed installation
export ZBX_ALLOWEDIP=zabbix-server
export ZBX_JAVAGATEWAY_ENABLE=true
export ZBX_STARTJAVAPOLLERS=5
export ZBX_ENABLE_SNMP_TRAPS=true