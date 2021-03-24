#! /bin/bash

	for host in `grep "\.8$" /home/quanta/DCOnsentino/db/listaips-disponiveisips`
 	do
 	ping -c 1 $host >/dev/null
  		if [ $? -eq 0 ]
		then
			echo "$host TMS gerenciamento OK" 
 		else 
			ping -c 1 `echo "$host" | sed -r 's/.8$/.1/g'` >/dev/null
			if [ $? -eq 1 ]
			then
				echo "`echo "$host" | sed -r 's/.8$/.1/g'` Meraki Z1 VPN OFFLINE" 
			else
				echo "$host TMS gerenciamento OFFLINE" 
			fi
		fi
	done
sleep 1

# tentarei criar um sumário dos problemas

# echo -n "##### Sumário de problemas #####"
# echo < /home/quanta/DConsentino/tmp/tmpfile | grep "OFFLINE" 

