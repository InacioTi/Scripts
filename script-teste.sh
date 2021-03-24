#!/bin/bash

for host in `cat /lista8`
do

ping -c 1 $host >/dev/null

    if [ $? -eq 0 ]

	then
	

  sshpass -p "L4t4m4dm1n"  parallel-ssh -h /lista8 -l root  -o /home/lista-ip/pasta-output-chat-script  -A  "grep -i chat_email /aam-lms/bin/cinema_services.cfg"  >> /home/lista-ip/error-chat-script

	
			

	 else
        	echo "$host inacessivel" >> /home/lista-ip/host-off
    fi

done

#cat * /home/lista-ip/pasta-output-chat-script /home/lista-ip/output-chat-script
