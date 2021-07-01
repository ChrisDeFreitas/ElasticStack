# ElasticStack (estack) Configuration
- Definition of ElasticStack: https://www.elastic.co/what-is/elk-stack
- purpose is to monitor network activity, custom applications and logins

I hope the four distinct applications that make up this solution will provide robust documentation and error handling, allowing this effort to be leverage for other purposes.  I have used many  monitoring solutions and found that they all had some fatal flaw that prevented them from being a total solution; typically they would fail silently on some critical feature.  

This is a work in progress and another of my archives of generally useful information that I don't want to lose.  Feel free to use for your own purposes.  

## Denoument
At this point the installation and operation of the components documented here are flawless.  This document covers those aspects of Elastic Stack.  

I'm having problems using Kibana and understanding what the visuals mean.  This is the only fault I found so far, but it applies to all the shipped Dashboards.  If I can't understand what the dashboards are supposed to be telling me, I don't know if I can trust the data without extensive testing!  In a professional setting where you're paid to use the tool that's fine--you do the analysis as quick as you can because the effort will be paid back over time.  But in this situation its a lot of time and effort that can be applied to simpler and more efficient technologies.  
  
  To be precise about the nature of the problem, the dashboard, "[Metricbeat System] Host overview ECS," provides socket data for the estack host for the last 3 days:  

  Inbound Traffic 12.4KB/s  
  Total Transferred 1.9GB  
  
  Where are the numbers coming from?  How are they calculated?  Is it safe to assume it is the median average for three days?  
  
  When you edit the visualization, the "Aggregation-based visualization/Metric" editor is presented. But it is not documented online, and is not "intuitive". And it clearly needs some explanation because (looking at the editor) these two numbers are calculated in an extremely complex manner.  

  The online documentation is fine until you ask yourself: what does this really mean, and do these visualizations meet my monitoring needs?  At this point I can't trust the visualizations, and there is a lot that is irrelevant to my needs.  And my efforts to create custom visualizations have failed spectacurly with truly unsettling results.

  A couple important issues arose in my research:  
	  1. many of the beats and visualizations I'm using are marked experimental.  
		2. Reviewing some of GitHub Kibana notes indicate that Kibana is in the midst of a major re-write.  
	  
	Therefore, Kibana is a moving target until they get the code base stabilized.  For me, I'll be moving onto other projects, perhaps revisiting this effort in a few months to see where Kibana is.  I expect to be completing some of the server monitoring ideas by spinning off a new repo focused on system monitoring with basic tools and scripts.  This project really impressed on me how important it is to have those basic tools and concepts in place before digging into OS issues.

	  
## Sections  
-- Refereneces  
-- Overview  
-- Elastic Search Service  
-- Kibana Service  
-- Kibana Usage    
-- Filebeat Service  
-- Metricbeat Service  
-- Commands and Scripts

## See:  
-- "References" for useful links.  
-- "Overview" to see where I am in the process.  
-- "Commands and Scripts"  

# References
- https://www.xmodulo.com/install-elk-stack-ubuntu.html  
- https://www.elastic.co/what-is/elk-stack  
- Elastic Stack download info: https://www.elastic.co/start  
- YAML format in estack: https://www.elastic.co/guide/en/beats/libbeat/7.13/config-file-format.html

- https://www.elastic.co/guide/en/beats/metricbeat/7.13/filtering-and-enhancing-data.html. 


- Secrets keystore  
-- https://www.elastic.co/guide/en/beats/filebeat/7.13/keystore.html  
-- https://www.elastic.co/guide/en/beats/metricbeat/7.13/keystore.html  


- Network monitoring tools recommended in https://www.binarytides.com/linux-commands-monitor-network/
 that I have used:  
 --  https://linux.die.net/man/8/iftop  
 --  https://linux.die.net/man/8/nethogs is a small 'net top' tool. Instead of breaking the traffic down per protocol or per subnet, it groups bandwidth by process (https://github.com/raboof/nethogs).


- https://www.binarytides.com/linux-top-command/
- https://www.binarytides.com/linux-ss-command/
- https://blog.confirm.ch/tcp-connection-states/

## Development  
- https://www.elastic.co/blog/join-our-elastic-stack-workspace-on-slack  
- https://github.com/elastic  
- https://github.com/elastic/kibana/blob/master/docs/concepts/index.asciidoc  


# Overview
(see the last section "Commands and Scripts" for more note like info)  

## Test estack Host
- Debian 10   
- VMWare Virtual Machine  
- 1 GB Ram, 50 GB Disk  
- bash, apache2, midnight commander  

## Notes
- changed to a new VM without https://xfce.org/ (needed a cleaner network environment for testing):  
  -- returned to 1 GB RAM because of the reduced load  
  -- successfully installed Elastic and Kibana on new VM following instructions on this page   
	-- Elastic/Java are using 47% RAM, no slowness observed  
	-- reviewed settings docs for Elastic and Kibana, will tweak after test data flowing  
	-- created scripts/login.sh to run "last" and "ss" on login  
	-- created scripts/tcpUsage.sh to list processes and count of established tcp connections  
	-- created scripts/recentApps.sh to list 30 processes recently started  
	-- Apache log and metrics monitoring with estack is running well  
	-- implement system.socket metricset: https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-metricset-system-socket.html  
	-- implement system.service metricset: https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-metricset-system-service.html  
	-- implement system.users metricset: https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-metricset-system-users.html  
  --- implement filebeat.system module: https://www.elastic.co/guide/en/beats/filebeat/7.13/filebeat-module-system.html  

- I've given up trying to create visualizations in Kibana because it requires a lot more time (and probably $$$) than I am willing to spend on this project.  I did experience some disturbing data inconsistencies while generating custom Visualizations, but, if I were using these tools in a professional setting I would follow up with calls to support and/or professional training.   
  
  For now I'm focused on using existing dashboards and visualizations, with the idea that discrepancies will be looked up with manual tools at the OS level (rather than digging through the Kibana data).  

- configured remote Linux system with Metricbeat.system and Filebeat.system  
-- 1. requires estack host configuration steps in "Elastic Search Service/Configure Remote Access"  
      note, did not need to re-configure Filebeat or Metricbeat to use estack host public ip  
-- 2. requires installation steps on remote host for Metricbeat and Filebeat  

## Next  
- verify Metricbeat.System dashboards are accurate   
- determine what "process.cgroups.enabled: true" does. The data can be viewed in Discovery but I thought it would show up in the "[Metricbeat System] Host Services Overview" dashboard, but the Visualizations for "Top Services By Memory Usage", "Top Services By Task Count", and "Service Memory Use Over Time" are empty.  
- setup Windows monitoring  
- implement metricbeat.system.diskio metricset: https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-metricset-system-diskio.html  

## ToDo
- optimize in future: on boot, Kibana establishes 120 TCP4/6 connections to the local ElasticSearch service  
-- after installing and testing Apache monitoring, Kibana has 163 TCP4/6 connections to local Elastic app
- Lookup: while installing Filebeat and Metricbeat got this message:  
"Setting up ML using setup --machine-learning is going to be removed in 8.0.0. Please use the ML app instead."  
- review APM module: https://www.elastic.co/guide/en/kibana/7.13/xpack-apm.html  
- review Winlogbeat module: https://www.elastic.co/guide/en/beats/winlogbeat/7.13/winlogbeat-installation-configuration.html  
- review Elastic Security: https://www.elastic.co/guide/en/kibana/7.13/xpack-siem.html  
-- requires Basic subscription:  https://www.elastic.co/subscriptions, but how to subscribe?  

# Elastic Search Service
https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-repo  
https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html  

- Install as a service:  
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -  
$ sudo apt-get install apt-transport-https  
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list  
$ sudo apt-get update && sudo apt-get install elasticsearch  


- Configure service to start automatically:  
$ sudo systemctl daemon-reload  
$ sudo systemctl enable elasticsearch.service  
  
- Start/stop:  
$ sudo systemctl start elasticsearch.service  
$ sudo systemctl stop elasticsearch.service  
  
- Logs  
	To tail the journal:  
	$ sudo journalctl -f  
		
	To list journal entries for the elasticsearch service:  
	$ sudo journalctl --unit elasticsearch  

	To list journal entries for the elasticsearch service starting from a given time:  
	$ sudo journalctl --unit elasticsearch --since  "2016-10-30 18:17:16"  
		
	View error log:  
	$ sudo tail /var/log/elasticsearch/elasticsearch.log  

- Test service up:  
$ curl -X GET "localhost:9200/?pretty"  
Source: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-check-running  

- Configure remote access:  
    
	### 1. stop services  
	$ sudo systemctl stop filebeat  
	$ sudo systemctl stop metricbeat   
	$ sudo systemctl stop kibana  
	$ sudo systemctl stop elasticsearch  
		
	### 2. configure elasticsearch   
	$ sudo nano /etc/elasticsearch/elasticsearch.yml  
	```Bash
	network.host: _site_  
	discovery.seed_hosts: localhost  
	```  
		
	### 3. configure kibana for remote access   
	$ sudo nano /etc/kibana/kibana.yml  
	```Bash
	server.host: 192.168.0.255  
	```  

	### 4. start services  
	$ sudo systemctl start elasticsearch   
	$ sudo systemctl start kibana  
	$ sudo systemctl start filebeat  
	$ sudo systemctl start metricbeat  
  
# Kibana Service  
https://www.elastic.co/guide/en/kibana/7.12/index.html  
https://www.elastic.co/guide/en/kibana/7.12/settings.html  

- Install:  
https://www.elastic.co/guide/en/kibana/7.12/deb.html#deb-repo  
$ sudo apt-get install apt-transport-https  
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list  
$ sudo apt-get update && sudo apt-get install kibana  
  
- Auto-start:  
$ sudo /bin/systemctl daemon-reload  
$ sudo /bin/systemctl enable kibana.service  
  
- Service start/stop:  
$ sudo systemctl start kibana.service  
$ sudo systemctl stop kibana.service  

- Serivce logs:
$ sudo systemctl status kibana
$ sudo journalctl -u kibana

- Test Service up:  
  1. Forward port 5601 to local host  
  2. Browse:   
http://localhost:5601  
http://localhost:5601/app/kibana_overview#/  


# Kibana Usage  
https://www.elastic.co/guide/en/kibana/7.13/index.html  

- Dashboards requiring Metricbeat.system  
  [Metricbeat System] System Overview ECS  
  [Metricbeat System] Host Overview ECS  
  [Metricbeat System] Container Overview ECS  

- Dashboards requiring Filebeat.system  
  [Filebeat System] Syslog dashboard ECS  
  [Filebeat System] Sudo commands ECS  

  [Filebeat System] SSH login attempts ECS  
  [Filebeat System] New users and groups ECS  


# Filebeat Service
https://www.elastic.co/guide/en/beats/filebeat/7.13/filebeat-installation-configuration.html  
https://www.elastic.co/guide/en/beats/filebeat/7.13/command-line-options.html  
https://www.elastic.co/guide/en/beats/filebeat/7.13/configuration-filebeat-options.html  
https://www.elastic.co/guide/en/beats/filebeat/7.13/configuration-filebeat-modules.html  
  
- install:  
$ curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.13.0-amd64.deb  
$ sudo dpkg -i filebeat-7.13.0-amd64.deb  

- (if needed) confiugre remote estack host:  
$ sudo nano /etc/filebeat/filebeat.yml  
```Bash
setup.kibana:  
    host: "192.168.0.255:5601"  
    username: "my_kibana_user"   
    password: "password"  
output.elasticsearch:  
  hosts: ["192.168.0.255:9200"]  
  username: "my_elastic_user"  
  password: "password"  
```

- enable module:  
$ sudo filebeat modules list  
$ sudo filebeat modules enable apache  
$ sudo filebeat modules disable apache  

- start service:  
-- "-e" redirects output to stderr   
$ sudo filebeat setup -e  
$ sudo service filebeat start  

- test:  
$ sudo filebeat test config  
$ sudo filebeat test output  

- launch Kibana:  
-- http://localhost:5601  
-- In the side navigation, click Discover.  
-- -- make sure the predefined filebeat-* index pattern is selected.  
-- -- change the time filter. By default, Kibana shows the last 15 minutes.  
-- In the side navigation, click Dashboard, search on "filebeat"  
-- -- verify the Filebeat dashboard is selected  

- Commands:  
```Bash
(global "-e" option redirects output to stderr for all filebeat commands)  

$ sudo filebeat setup -e  
$ sudo service filebeat start  

# append "-h" for help info
$ sudo filebeat test config
$ sudo filebeat test output

$ sudo filebeat modules list
$ sudo filebeat modules enable apache  
$ sudo filebeat modules disable apache  

$ sudo filebeat keystore add ES_PWD
$ sudo filebeat keystore list
$ sudo filebeat keystore remove ES_PWD
```

## System Module  
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-module-system.html  

## Apache Log Monitoring
http://127.0.0.1:5601/app/home#/tutorial/apacheLogs  
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-module-apache.html  


# Metric Beat Service
https://www.elastic.co/beats/metricbeat  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/metricbeat-installation-configuration.html  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/setting-up-and-running.html  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/command-line-options.html  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/keystore.html  
(global "-e" option redirects output to stderr for all Metricbeat commands)  


- install:  
$ curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.13.1-amd64.deb  
$ sudo dpkg -i metricbeat-7.13.1-amd64.deb   

- (if needed) setup remote estack host:  
$ sudo nano /etc/metricbeat/metricbeat.yml  
```Bash
setup.kibana:  
  host: "192.168.0.255:5601"   
  username: "my_kibana_user"  
  password: "password"  
output.elasticsearch:  
  hosts: ["192.168.0.255:9200"]  
  username: "my_elastic_user"  
  password: "password"  
```
  
- enable modules:  
-- https://www.elastic.co/guide/en/beats/metricbeat/7.13/command-line-options.html#modules-command  
-- system module enabled by default  
$ sudo metricbeat modules list  
$ sudo metricbeat modules enable apache mysql  
$ sudo metricbeat modules disable apache  

- test:  
-- append "-h" for help info  
$ sudo metricbeat -e test config  
$ sudo metricbeat -e test modules system apache  
$ sudo metricbeat -e test output  

- auto-start:  
$ sudo systemctl daemon-reload  
$ sudo systemctl enable metricbeat  

- start service:  
-- "-e" redirects output to stderr   
$ sudo metricbeat setup -e  
$ sudo service metricbeat start 

- edit service settings  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/running-with-systemd.html  
-- running as root is default for systemd services  
$ sudo nano /etc/metricbeat/metricbeat.yml  
$ sudo nano /etc/systemd/system/metricbeat.service.d  
-- apply changes:  
$ sudo systemctl daemon-reload  
$ sudo systemctl restart metricbeat  

- log file:
$ sudo tail /var/log/metricbeat


- launch Kibana:  
-- http://localhost:5601  
-- In the side navigation, click Discover.  
-- -- make sure the predefined metricbeat-* index pattern is selected.  
-- In the side navigation, click Dashboard, search for "[Metricbeat System]"  
-- -- Dash boards for System, Host and Containers can be accessed within the dashboard

## System Module  
https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-system.html  
$ sudo nano /etc/metricbeat/modules.d/system.yml  

Enable data for service reporting, requires:  
https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-metricset-system-service.html  
$ sudo nano /etc/metricbeat/modules.d/system.yml  
```Bash
	# Enable collection of cgroup metrics from processes on Linux.
	# allows monitoring of process' cpu, memory etc
  process.cgroups.enabled: true
	
	# Filter systemd services by status or sub-status
  #service.state_filter: ["active"]
	
	# Filter systemd services based on a name pattern
	#service.pattern_filter: ["ssh*", "nfs*"]
```

## Apache Metrics Module  
http://127.0.0.1:5601/app/home#/tutorial/apacheMetrics  
https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-module-apache.html  


# Commands and Scripts

```Bash
# free memory	
$ free -h   

# find process details by pid (with command line)
$ sudo ps -ax |grep 19414

# display top 10 cpu consumers
$ sudo ps -e --sort -pcpu -o "%cpu %mem pri f stat pid ppid class rtprio ni pri psr start user comm time tty" | head -n 10

# display top 10 memory consumers
$ sudo ps -e --sort -pmem -o "%cpu %mem pri f stat pid ppid class rtprio ni pri psr start user comm time tty" | head -n 10

# display 30 recently started apps
# note: to get startup commandline add "command" to headers argument (after tty and before last ")
$ sudo ps -e --sort -start -o "%cpu %mem pri f stat pid ppid class rtprio ni pri psr start user comm time tty" | tail -n 30  
```

```Bash
# list last 10 logins  
$ sudo last -10 -F -i

# of the last 30 logins, exclude userName  
$ sudo last -30 -F -i | grep -v userName  
```

```Bash
#Status of all services
$ sudo systemctl  
$ sudo systemctl --type=service 
$ sudo systemctl --type=service --state=active
# list startup services only (https://www.linux.com/topic/desktop/cleaning-your-linux-startup-process/)
$ sudo systemctl list-unit-files --type=service | grep enabled

#Disable service
$ sudo systemctl stop SERVICENAME
$ sudo systemctl disable SERVICENAME
```  

```Bash
#Service ports
# requires: $ sudo apt install net-tools
# better to use "ss" because pre-installed in Debian
$ sudo netstat -ltup | grep java
$ sudo netstat -ltup | grep kibana

# ss switches
# -H = hide column headers  
# -n  = do not resolve hostnames or port numbers (use 22 instead of ssh)
# -o  = display timer data
# state established = only display established connections
# exclude established = exclude established connections
# sport > :1024 =  dislay source ports above 1024
# -l, state listening = report on listening ports
# -p, --process = include pid, requires root access
# -tu, --query=inet, --tcp --udp = display data for tcp and udp connections (all equal)

# summary of port activity 
$ ss -s

# all listening internet ports with pid
$ sudo ss -ltup 

# tcp connections by port number
#   dport = destination/remote port
#   sport = source/local port
$ ss -t '( dport = :22 or sport = :22 )'

# count established connections by source port
# based on ElasticStack ports
$ ss sport = :9200 or sport = :9300  |wc -l

# count established connections by pid
# based on current pid of Kibana = 5992
$ sudo ss -tup  |grep pid=5992  |wc -l

# list processes by number of established tcp connections
$ sudo ss -Hptu |awk '{print $7}' |sort |uniq -c -w25 |sort -r
```

## login.sh
```Bash
#!/bin/bash

## login.sh
## call from ~/.profile

echo 
echo ss --summary:
ss -sH

echo ss --listening --query=inet:
ss -ltuH

echo 
echo Last 10 logins with reboots etc:
last -10 -F -i -x
```

## login_remote.sh
```Bash
#!/bin/bash

## login_remote.sh
## list network stats from remote system
## assume: ssh server configured in ~/.ssh/ssh_config

remoteHost=192.168.0.255
echo Network stats for $remoteHost - 
echo 

ssh $remoteHost '\
echo ss --summary:; ss -sH; \
echo ss --listening --query=inet:; ss -ltuH; \
echo ;\
echo Last 10 logins with reboots etc:; last -10 -F -i -x ;\
'
```

## recentApps.sh
```Bash
#!/bin/bash
echo
echo 30 recently started apps:
echo
echo start time user comm tty pid ppid %cpu %mem pri class pri psr 
sudo ps -e --sort=-start -o "start time user comm tty pid ppid %cpu %mem pri class pri psr " | tail -n 30  | sort -r
```  
	
## recentApps_remote.sh
```Bash
#!/bin/bash

## recentApps_remote.sh
## list 30 recently started apps on remote system
## assume: ssh server configured in ~/.ssh/ssh_config

remoteHost=192.168.0.255
echo 30 recently started apps on $remoteHost - 
echo 

ssh -t $remoteHost '\
sudo echo ;\
echo start time user comm tty pid ppid %cpu %mem pri class pri psr  ;\
sudo ps -e --sort=-start -o "start time user comm tty pid ppid %cpu %mem pri class pri psr " | tail -n 30  | sort -r ;\
'
```  
	
## tcpUsage.sh
```Bash
#!/bin/bash

echo
echo List processes and count of established connections:
sudo ss -Hptu |awk '{print $7}' |sort |uniq -c -w25 |sort -r
```

## tcpUsage_remote.sh
```Bash
#!/bin/bash

## tcpUsage_remote.sh
## list processes and count of established connections on remote system
## assume: ssh server configured in ~/.ssh/ssh_config

remoteHost=192.168.0.255
echo List processes and count of established connections on $remoteHost - 
echo 

ssh -t $remoteHost 'sudo ss -Hptu |awk "{print $7}" |sort |uniq -c -w25 |sort -r '
```

# Thanks To  
https://github.com    
https://debian.org    
https://xfce.org   
https://midnight-commander.org  
https://elastic.com  
https://xmodulo.com  
https://linux.com  
https://binarytides.com   
https://linux.die.net  