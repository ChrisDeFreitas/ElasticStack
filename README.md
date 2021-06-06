# ElasticStack (estack) Configuration
- Definition of ElasticStack: https://www.elastic.co/what-is/elk-stack
- purpose is to monitor network activity, custom applications and logins

I hope the four distinct applications that make up this solution will provide robust documentation and error handling, allowing this effort to be leverage for other purposes.  I have used many  monitoring solutions and found that they all had some fatal flaw that prevented them from being a total solution; typically they would fail silently on some critical feature.  

This is a work in progress and another of my archives of generally useful information that I don't want to lose.  Feel free to use for your own purposes.  

## Sections  
-- Refereneces  
-- General  
-- Elastic Search Service
-- Elastic Search Admin  
-- Kibana Service  
-- Filebeat Service  
-- Metricbeat Service
-- Apache Monitoring  
-- Commands and Scripts

- See:  
-- "References" for useful links.  
-- "General Notes" to see where I am in the process.  
-- "Commands and Scripts" for ...  

# References
- https://www.xmodulo.com/install-elk-stack-ubuntu.html  
- https://www.elastic.co/what-is/elk-stack  
- Elastic Stack download info: https://www.elastic.co/start  
- Secrets keystore: https://www.elastic.co/guide/en/beats/filebeat/7.13/keystore.html  
- YAML format in estack: https://www.elastic.co/guide/en/beats/libbeat/7.13/config-file-format.html

- Network monitoring tools recommended in https://www.binarytides.com/linux-commands-monitor-network/
 that I have used:  
 --  https://linux.die.net/man/8/iftop  
 --  https://linux.die.net/man/8/nethogs is a small 'net top' tool. Instead of breaking the traffic down per protocol or per subnet, it groups bandwidth by process (https://github.com/raboof/nethogs).


- https://www.binarytides.com/linux-top-command/
- https://www.binarytides.com/linux-ss-command/
- https://blog.confirm.ch/tcp-connection-states/



# General
(see the last section "Commands and scripts" for more note like info)  

## Test Host
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
	-- created scripts/recentApps.sh to 30 processes recently started  
	-- Apache log and metrics monitoring with estack is running well  

## Next  
  - review Metricbeat system monitoring  
  - configure remote Linux system with Metricbeat  
  - setup Windows monitoring  

## ToDo
- optimize in future: on boot, Kibana establishes 59 TCP connections to the local ElasticSearch service  
-- after installing and testing Apache monitoring, Kibana has 73 connections to local Elastic app
- Lookup: while installing Filebeat and Metricbeat got this message:  
"Setting up ML using setup --machine-learning is going to be removed in 8.0.0. Please use the ML app instead."  
- add section: Kibana Admin  
- review APM module: https://www.elastic.co/guide/en/kibana/7.13/xpack-apm.html  
- review Winlogbeat module: https://www.elastic.co/guide/en/beats/winlogbeat/7.13/winlogbeat-installation-configuration.html  
- review Elastic Security: https://www.elastic.co/guide/en/kibana/7.13/xpack-siem.html  

# Elastic Search Service
Source: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-repo 

This process allows elastic search to be run as a daemon:  
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -  
$ sudo apt-get install apt-transport-https  
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list  
$ sudo apt-get update && sudo apt-get install elasticsearch  


Configure service to start automatically:
- To enable journalctl logging, the --quiet option must be removed from the ExecStart command line in the elasticsearch.service file.   
$ sudo /bin/systemctl daemon-reload  
$ sudo /bin/systemctl enable elasticsearch.service  

Start/stop:  
$ sudo systemctl start elasticsearch.service  
$ sudo systemctl stop elasticsearch.service  

To tail the journal:  
$ sudo journalctl -f  

To list journal entries for the elasticsearch service:  
$ sudo journalctl --unit elasticsearch  

To list journal entries for the elasticsearch service starting from a given time:  
$ sudo journalctl --unit elasticsearch --since  "2016-10-30 18:17:16"  


# Elastic Search Admin  

Configure service:   
https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-configuring  
https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html  

Test service up:  
$ curl -X GET "localhost:9200/?pretty"  
Source: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-check-running  

Directory layout:  
https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-layout  

Security settings:  
https://www.elastic.co/guide/en/elasticsearch/reference/current/auditing-settings.html  



# Kibana Service  

Install:  
https://www.elastic.co/guide/en/kibana/7.12/deb.html#deb-repo  
$ sudo apt-get install apt-transport-https  
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list  
$ sudo apt-get update && sudo apt-get install kibana  
  
Auto-start:  
$ sudo /bin/systemctl daemon-reload  
$ sudo /bin/systemctl enable kibana.service  
  
Service start/stop:  
$ sudo systemctl start kibana.service  
$ sudo systemctl stop kibana.service  
  
Settings:  
https://www.elastic.co/guide/en/kibana/7.12/settings.html  
  
Test Service up:  
1. Forward port 5601 to local host  
2. Browse:   
http://localhost:5601  
http://localhost:5601/app/kibana_overview#/  


# Filebeat Service
https://www.elastic.co/guide/en/beats/filebeat/7.13/filebeat-installation-configuration.html  
https://www.elastic.co/guide/en/beats/filebeat/7.13/command-line-options.html  
https://www.elastic.co/guide/en/beats/filebeat/7.13/configuration-filebeat-options.html  


- install:  
$ curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.13.0-amd64.deb  
$ sudo dpkg -i filebeat-7.13.0-amd64.deb  

- configure localhost:  
-- currently using defaults found in file  
$ sudo nano /etc/filebeat/filebeat.yml  
-- output.elasticsearch:  
  hosts: ["<es_url>"]  
  username: "elastic"  
  password: "<password>"  

- (if needed) setup remote kibana settings:  
-- setup.kibana:  
    host: "mykibanahost:5601"  
    username: "my_kibana_user"   
    password: "{pwd}"  

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

# Metric Beat Service

https://www.elastic.co/guide/en/beats/metricbeat/7.13/metricbeat-installation-configuration.html  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/setting-up-and-running.html  
https://www.elastic.co/guide/en/beats/metricbeat/7.13/command-line-options.html  
(global "-e" option redirects output to stderr for all Metricbeat commands)  


- install:  
$ curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.13.1-amd64.deb  
$ sudo dpkg -i metricbeat-7.13.1-amd64.deb   

- configure local host:  
-- currently using defaults found in file)
$ sudo nano /etc/metricbeat/metricbeat.yml  
-- output.elasticsearch:  
  hosts: ["<es_url>"]  
  username: "elastic"  
  password: "<password>"  

- (if needed) setup remote kibana:  
-- setup.kibana:  
  host: "<kibana_url>"   
	username: "my_kibana_user"  
  password: "{pwd}"  

- enable modules:  
-- https://www.elastic.co/guide/en/beats/metricbeat/7.13/command-line-options.html#modules-command
-- system module enabled by default  
$ sudo metricbeat modules list  
$ sudo metricbeat modules enable apache mysql  
$ sudo metricbeat modules disable apache  

- test:  
-- append "-h" for help info  
$ sudo metricbeat test config  
$ sudo metricbeat test modules system cpu  

- start service:  
-- "-e" redirects output to stderr   
$ sudo metricbeat setup -e  
$ sudo service metricbeat start  

- launch Kibana:  
-- http://localhost:5601  
-- In the side navigation, click Discover.  
-- -- make sure the predefined metricbeat-* index pattern is selected.  
-- In the side navigation, click Dashboard, search on "metric" 
-- -- verify the Metricbeat dashboard is selected 

# Apache Monitoring

## Apache Log Monitoring
url: http://127.0.0.1:5601/app/home#/tutorial/apacheLogs  

- install Filebeat service:   
-- see above  

- enable module:  
$ sudo filebeat modules enable apache  

- ??? start service: ???  
$ sudo filebeat setup -e  
$ sudo service filebeat start  

- test  
$ sudo filebeat test config  
$ sudo filebeat test output  

- launch Kibana:  
-- http://localhost:5601  
-- In the side navigation, click Discover.  
-- -- make sure the predefined filebeat-* index pattern is selected.  
-- -- change the time filter. By default, Kibana shows the last 15 minutes.  
-- In the side navigation, click Dashboard and filter on "apache"  
-- -- verify the Filebeat dashboard is selected  

## Apache Metrics Monitoring
url: http://127.0.0.1:5601/app/home#/tutorial/apacheMetrics  

- install Metricbeat service:  
-- see above  

- enable apache module  
$ sudo metricbeat modules enable apache  

- ??? start service: ???  
$ sudo metricbeat setup -e  
$ sudo service metricbeat start  

 - launch Kibana:  
-- http://localhost:5601  
-- In the side navigation, click Discover.  
-- -- make sure the predefined metricbeat-* index pattern is selected.  
-- -- change the time filter. By default, Kibana shows the last 15 minutes.  
-- In the side navigation, click Dashboard and filter on "apache"  
-- -- verify the Metricbeat dashboard is selected  

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

```Bash
## login.sh
## call from ~/.profile

#!/bin/bash
echo 
echo ss --summary:
ss -sH

echo ss --listening --query=inet:
ss -ltuH

echo 
echo Last 10 logins with reboots etc:
last -10 -F -i -x
```

```Bash
## recentApps.sh

#!/bin/bash
echo
echo 30 recently started apps - MUST be run as root:
echo
echo start time user comm tty pid ppid %cpu %mem pri class pri psr 
ps -e --sort=-start -o "start time user comm tty pid ppid %cpu %mem pri class pri psr " | tail -n 30  | sort -r
```  
	
```Bash
## tcpUsage.sh

#!/bin/bash
echo
echo List processes and count of established connections - MUST be run as root:
ss -Hptu |awk '{print $7}' |sort |uniq -c -w25 |sort -r
```

# Thanks To:  
https://github.com    
https://debian.org    
https://xfce.org   
https://midnight-commander.org  
https://elastic.com  
https://xmodulo.com  
https://linux.com  
https://binarytides.com   