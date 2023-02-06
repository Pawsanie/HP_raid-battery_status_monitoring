#!/bin/bash

#The script checks the status of logical disks using HP "ssacli" and passes the received data to the zabbix agent.

#Runs HP "ssacli" to look up information about logical disks:
HP="sudo hpssacli ctrl all show config detail"

#Error count as default:
errors_count=0

#Checks the status of logical disks:
            for i in $($HP | grep -A 8 "Logical Drive: " | grep "Status:" | cut -d ' ' -f11 | awk {'print $0'})
            do
            state1=$(echo $i 2>/dev/null | awk {'print $0'})
        if [ "$state1" == OK ]
                then
#If the status is "OK":
                        let "errors_count = (( $errors_count + 0 ))"
#If the status is "other":
        else
        let "errors_count = (( $errors_count + 1 ))"
#Name of the problem disk:
                DN=$($HP | grep -A 12 "Logical Drive: " | grep "$i" | grep "Disk Name:" | cut -d ' ' -f12 | awk {'print $0'})
#Labeling the logical disk:
                LDL=$($HP | grep -A 14 "Logical Drive: " | grep "$i" | grep "Logical Drive Label:" | sed 's/Logical Drive Label: //g' | awk {'print $0'})
#Unique identificator:
                UI=$($HP | grep -A 11 "Logical Drive: " | grep "$i" | grep "Unique Identifier:" | cut -d ' ' -f12 | awk {'print $0'})
#Problem disk status:
                LDS=$($HP | grep -A 8 "Logical Drive: " | grep "$i" | grep "Status:" | sed 's/Status: //g' | awk {'print $0'})
#Logical disk size:
                LS=$($HP | grep -A 1 "Logical Drive: " | grep "$i" | grep "Size:" | cut -d ' ' -f12,13 | awk {'print $0'})
#If problems with logical disks are detected, the agent will send information about the problematic devices to the server:
                echo Fixed problem with logical disk: $DN: logical disk status: $LDS. Disc label: $LDL. Logical disk size: $LS. Unique ID: $UI. $3
        fi
            done
#Checking for problematic devices:
if [ "$errors_count" == 0 ]
then
#If there are no problems with logical drives, then the agent sends "OK" to the zabbix server as the argument:
echo ОК $3
fi
