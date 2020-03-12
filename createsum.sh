#! /bin/bash

echo -e "<!DOCTYPE html>\n<html>\n<body>\n" >> /home/DConsentino/tmp/pingresultSum.html
echo -e "##### Sumário de dispositivos inacessíveis #####" >> /home/DConsentino/tmp/pingresultSum.html

# print only TMS offline
echo -e "<p>### Sumário de Meraki Z1 inacessíveis ###</p>" >> /home/DConsentino/tmp/pingresultSum.html

for m in `grep "OFFLINE" /home/DConsentino/tmp/pingresult.txt`
        do
        if [ `echo "$m" | cut -d- -f2` = Meraki ]
                then
                echo "<br>$m</br>" >> /home/DConsentino/tmp/pingresultSum.html
        fi
done

# print only TMS offline
echo -e "<p>### Sumário de TMS gerenciamento inacessíveis ###</p>" >> /home/DConsentino/tmp/pingresultSum.html

for t in `grep "OFFLINE" /home/DConsentino/tmp/pingresult.txt`
        do
        if [ `echo "$t" | cut -d- -f2` = TMS ]
                then
                echo "<br>$t</br>" >> /home/DConsentino/tmp/pingresultSum.html
        fi
done

sleep 1
echo -e "\n</body>\n</html>" >> /home/DConsentino/tmp/pingresultSum.html

