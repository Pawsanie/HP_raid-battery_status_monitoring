#!/bin/bash

#The script checks the motherboard battery status using HP "ssacli" and passes the received data to the zabbix agent.

#Runs HP "ssacli" to look up information about batteries:
HP="sudo hpssacli ctrl all show config detail"

#Error count as default:
errors_count=x

#Checks the status of the motherboard battery:
            for i in $($HP | grep "Battery/Capacitor Status:" | cut -d ' ' -f6 | awk {'print $0'})
            do
            errors_count=$(echo $i 2>/dev/null | awk {'print $0'})
        if [ "$errors_count" == OK ]
                then
#If the status is "OK":
                        let "errors_count = (( $errors_count + 0 ))"
#If the status is "other":
        else
        let "errors_count = (( $errors_count + 1 ))"
#Battery status:
                BS=$($HP | grep "Battery/Capacitor Status:" | awk {'print $0'})
#If there are problems with the motherboard batteries, then the agent sends information about the problematic power source to the zabbix server as an argument.
                echo $BS. $3
        fi
            done
#Check for problematic power supplies:
if [ "$errors_count" == 0 ]
then
#If there are no problems with the motherboard batteries, then the agent sends "OK" to the zabbix server as an argument.
echo ОК $3

fi
