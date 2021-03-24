#!/bin/bash


for host in `cat /lista8`
do 
   sshpass -p 'L4t4m4dm1n' ssh administrator@$host 'sudo cat /root/.ssh/authorized_keys | grep "root@NOCmicro" '
	if [ $? -eq 0 ]
	   then
	     echo "LinuxNOC pubkey already inserted on $host" >> /home/lista-ip/ok-pubkey
	else 
	

#sshpass -p 'L4t4m4dm1n' ssh administrator@10.228.192.8 'sudo su ; sleep 1 ; echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxqRF2OqGUJ7afL9xDcFR8+oLKnYg5XdT0wKvvRAAE2n92H1zII+SXifN2RnuFKEtmxGNAbw/hw4cKWnsKc0K9YaFjYC4fsRSNG7iv02CdZ2xmGezh1deKIeilKSie/fUasbBXUoqulAkhRrfOoHIAvLhyqDrk3R7hYHyFvKZEf1afWp0cM/vfVQy1W/AnGEJVW3gD1k//182ZYoWAuNrCWt11QHbsoaSF27GZoyf3nlYdLEU+x3pSlDhvwNfFR19BHrjGZK0s+C84TOciaguI5FycfkodlWvFPU6YeOtE5rs2Nzr24/Tftgc7GJu01dNfnO9QwGusm+cViLQMyTUSQ== root@quanta.quanta.sp" >> /root/.ssh/authorized_keys'  
	
        echo "$host Verificar" >> /home/lista-ip/erro-pubkey
	fi
sleep 2

done
