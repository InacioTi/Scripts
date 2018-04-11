#!/usr/bin/env python 
# -*- coding: utf-8 -*-


from zabbix_api import ZabbixAPI
import csv


server = "http://172.20.20.8/zabbix"
username = "Admin" 
password = "zabbix"

zapi = ZabbixAPI(server = server, path="")

zapi.login(username, password)
 
f = csv.reader(open('/root/zabbix-imporTMS.txt'), delimiter=';')

for [hostname,ip] in f:

	#f.line_num
	zapi.host.create({"host": hostname,
		"interfaces": [ {"type": "1",
 		"main": "1",
		"useip": "1",
		"ip":ip,
		"dns": "",
		"port": "10050"}], 
		"groups": [{ "groupid": "10"}], 
		"templates": [{ "templateid":"10105"}]

	})
