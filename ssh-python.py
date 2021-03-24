#!/usr/bin/env python

import paramiko,commands

tt1 = commands.getoutput ("/teste1")
host = commands.getoutput("cat /ip")
print  host
print  tt1

ref_arquivo = open("/ip","r")

string_arquivo = ref_arquivo.read()

ssh = paramiko.SSHClient()

ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

ssh.connect(string_arquivo ,username='root', password='toor')

stdin, stdout, stderr = ssh.exec_command('ifconfig')

p =  stdout.readline() 
print p > tt1

#stdin, stdout, stderr = ssh.exec_command('ifconfig > /teste1')

#ssh.connect('10.240.255.55', username='root', password='toor')
#stdin, stdout, stderr = ssh.exec_command('ifconfig')
#print stdout.readline() > tt1 

ref_arquivo.close()
ssh.close()


