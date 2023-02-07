# HP raid/battery status monitoring.

Monitoring scripts solve the problem of not being able to otherwise get the necessary data on some old [HP-iLO](https://www.hpe.com/emea_europe/en/hpe-integrated-lights-out-ilo.html) servers.

It's specifically about:
* :atm:A status of the raids of physical disks.
* :abacus:Status of logical disks.
* :battery:Motherboard battery status.

## Disclaimer:
:warning:**Using** some or all of the elements of this code, **You** assume **responsibility for any consequences!**<br>

:warning:The **licenses** for the technologies on which the code **depends** are subject to **change by their authors**.<br>

:warning:Please note that these monitoring scripts are intended for servers **Hewlett Packard** and uses the **"hpssacli"** utility.<br>
:warning:This means that you **may need a paid subscription or license or their equivalent** to use HP software on your machines.<br><br>

___

## Required:
The monitoring code is written in bash and obviously depends on it.<br>
**Bash** [GPL-3.0 license]:
* :octocat:[Bash GitHub](https://github.com/gitGNU/gnu_bash)
* :bookmark_tabs:[Bash internet page](https://www.gnu.org/software/bash/)

## Required Applications:
**Zabbix** [GPL-2.0 license]:
* :octocat:[Zabbix GitHub](https://github.com/zabbix/zabbix)
* :bookmark_tabs:[Zabbix internet page](https://www.zabbix.com/)

Despite the fact that you can easily change the work of scripts for any kind of monitoring, <br>
the configurations and templates in the repository are designed to work with Zabbix.

**HPE Smart Storage Administrator Client (HP-ssacli)**:
* :bookmark_tabs:[Hewlett Packard Enterprise internet page](https://www.hpe.com/)
* :bookmark_tabs:[HPE-ssacli internet page](https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=5409145&tab=driversAndSoftware)

Monitoring is based on parsing output to the terminal from the "hpssacli" application.<br>
**Without this application**, the work of scripts is **not possible**.<br>
:warning:**Additional charges may apply** to use the app.:warning:<br>
Read more on the manufacturer's [official website](https://www.hpe.com/)

**Ansible** [GPL-3.0 license / proprietary (See developer site)]:
* :octocat:[Ansible GitHub](https://github.com/ansible/ansible)
* :bookmark_tabs:[Ansible internet page](https://www.ansible.com/)

For deployment with ansible, if necessary.

## Preparing Zabbix agent for monitoring:
1) Copy the files from the "Scripts" folder to the specified folder on your monitored node.
```text
/etc/zabbix/zabbix_agentd.d/scripts/
```
2) Copy the files from the "Zabbix-Agent_configs" folder to the specified folder on your monitored node.
```text
/etc/zabbix/zabbix_agentd.d/
```
3) Restart the zabbix agent on the monitored node.<br>
**As an example with bash on CenOs7 servers:**<br>
```bash
systemctl restart zabbix-agent
```
## Preparing Zabbix server for monitoring:
Apply template "zbx_raid_battery_templates.xml" to Zabbix server.<br>
**File location:**<br>
**./**:open_file_folder:HP_raid-battery_status_monitoring<br>
   └── :file_folder:Zabbix-Server_Template<br>
            └── :page_facing_up:zbx_raid_battery_templates.xml

You can read more about this in the [official documentation](https://www.zabbix.com/documentation/6.0/en/manual/xml_export_import/templates#importing).

## Deployment monitoring with Ansible:
Copy the contents of folders "**Scripts**" and "**Zabbix-Agent_configs**" to "files" folder of "**copying-monitoring-scripts**" ansible role.<br>
**"files" folder of role location:**<br>
**./**:open_file_folder:HP_raid-battery_status_monitoring<br>
   └── :file_folder:Ansible-Playbook<br>
            └── :file_folder:roles<br>
                     └── :file_folder:copying-monitoring-scripts<br>
                              └── :file_folder:files<br>

Then fill in the hosts file for the ansible playbook with the actual data.<br>
**"hosts" file location:**<br>
**./**:open_file_folder:HP_raid-battery_status_monitoring<br>
   └── :file_folder:Ansible-Playbook<br>
            └── :file_folder:Inventory<br>
                     └── :page_facing_up:hosts<br>
**Example of hosts file in 'Inventory' folder':**
```text
[group_hpraid_search]
0.0.0.0
your.dns_name.domen

[group_hpraid_search:vars]
ansible_user=user_name
ansible_ssh_pass=user_password
```
Run the ansible playbook:<br>
```bash
ansible-playbook raid-battary_zabbix.yml
```

***

**Thank you** for your interest in my work.<br><br>
