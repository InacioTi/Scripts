#!/usr/bin/env python 
# -*- coding: utf-8 -*-


from zabbix_api import ZabbixAPI
import csv

server = "http://172.26.0.57/zabbix"
username = "Admin" 
password = "zabbix"

zapi = ZabbixAPI(server = server, path="")

zapi.login(username, password)
 
f = csv.reader(open('/tmp/zabbix-importZ1.txt'), delimiter=';')

for [hostname,ip] in f:

	#f.line_num
	zapi.host.create({"host": hostname,
		"interfaces": [ {"type": "1",
 		"main": "1",
		"useip": "1",
		"ip":ip,
		"dns": "",
		"port": "10050"}], 
		"groups": [{ "groupid": "2"}], 
		"templates": [{ "templateid":"10104"}]

	})
