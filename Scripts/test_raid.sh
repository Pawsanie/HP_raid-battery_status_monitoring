#!/bin/bash

#The script checks the status of physical disks using HP "ssacli" and passes the received data to the zabbix agent.

#Runs HP "ssacli" to find information about the server's physical disks:
HP="sudo hpssacli ctrl all show config detail"

#Error count as default:
errors_count=x

#Checks the status of physical disks:
            for i in $($HP | grep physicaldrive | cut -d ' ' -f16 | sed 's/)//g' | awk {'print $0'})
            do
            errors_count=$(echo $i 2>/dev/null | awk {'print $0'})
        if [ "$errors_count" == OK ]
                then
#If the status is "OK":
                        let "errors_count = (( $errors_count + 0 ))"
#If the status is "Failed":
        else
        let "errors_count = (( $errors_count + 1 ))"
#Name of the problem disk:
                N=$($HP | grep "physicaldrive" | grep Failed | cut -d ' ' -f8 | awk {'print $0'})
#Port of the problem disk:
                DP=$($HP | $GB | grep -A 1 "physicaldrive $N" | grep "Port:" | cut -d ' ' -f11 | awk {'print $0'})
#Box of the problem disk:
                DB=$($HP | grep -A 2 "physicaldrive $N" | grep "Box:" | cut -d ' ' -f11 | awk {'print $0'})
#Problem disk compartment:
                DBa=$($HP | grep -A 3 "physicaldrive $N" | grep "Bay:" | cut -d ' ' -f11 | awk {'print $0'})
#Interface of the problem disk:
                DI=$($HP | grep -A 7 "physicaldrive $N" | grep "Interface" | cut -d ' ' -f12 | awk {'print $0'})
#Serial number of the problem disk:
                DN=$($HP | grep -A 12 "physicaldrive $N" | grep "Serial" | cut -d ' ' -f12 | awk {'print $0'})
#Model of the problem disk:
                DM=$($HP | grep -A 13 "physicaldrive $N" | grep "Model:" | cut -d ' ' -f11,17 | awk {'print $0'})
#Reason for last failure:
                ER=$($HP | grep -P -A 5 "physicaldrive $N" | grep "Last Failure Reason:" | sed 's/Last Failure Reason: //g' | awk {'print $0'})
#Current temperature in Celsius:
                CT=$($HP | grep -A 14 "physicaldrive $N" | grep "Current Temperature (C):" | cut -d ' ' -f13 | awk {'print $0'})
#Maximum temperature in Celsius:
                MT=$($HP | grep -A 15 "physicaldrive $N" | grep "Maximum Temperature (C):" | cut -d ' ' -f13 | awk {'print $0'})
#If there are problems with physical disks, then the agent sends information about the problem device to the zabbix server as an argument:
                echo Disk problem detected: $N: Serial number: $DN. Model: $DM. Interface: $DI. Current temperature: $CT Celsius degrees. Maximum temperature: $MT Celsius degrees. Port: $DP. Box: $DB. Compartment: $DBa. Reason of last failure: $ER. $3
        fi
            done
#Checking for problematic devices:
if [ "$errors_count" == 0 ]
then
#If there are no problems with physical disks, then the agent sends "OK" to the zabbix server as an argument:
echo ОК $3

fi
