# ElasticStack (estack) Configuration
- Definition of ElasticStack: https://www.elastic.co/what-is/elk-stack
- purpose is to monitor network activity, custom applications and logins

I hope the four distinct applications that make up this solution will provide robust documentation and error handling, allowing this effort to be leverage for other purposes.  I have used many  monitoring solutions and found that they all had some fatal flaw that prevented them from being a total solution; typically they would fail silently on some critical feature.  

This is a work in progress and another of my archives of generally useful information that I don't want to lose.  Feel free to use for your own purposes.  

### Sections  
See "References" for useful links.  
See "General Notes" to see where I am in the process.  
See "Useful commands and scripts" for ...  

1. Elastic Search Service
2. Elastic Search Admin  
3. Kibana Service  
4. ToDo: Kibana Admin  
5. ToDo: Kibana Usage  

# References
- https://www.xmodulo.com/install-elk-stack-ubuntu.html  
- https://www.elastic.co/what-is/elk-stack  
- Elastic Stack download info: https://www.elastic.co/start  


- Network monitoring tools recommended in https://www.binarytides.com/linux-commands-monitor-network/
 that I have used:  
 --  https://linux.die.net/man/8/iftop  
 --  https://linux.die.net/man/8/nethogs is a small 'net top' tool. Instead of breaking the traffic down per protocol or per subnet, it groups bandwidth by process (https://github.com/raboof/nethogs).


- https://www.binarytides.com/linux-top-command/
- https://www.binarytides.com/linux-ss-command/
- https://blog.confirm.ch/tcp-connection-states/

- Apache Log Monitoring with estack  
http://localhost:5601/app/home#/tutorial/apacheLogs  
  


# Test Host
- Debian 10   
- VMWare Virtual Machine  
- 1 GB Ram, 50 GB Disk  
- bash, apache2  



# General Notes
- see the last section "Useful commands and scripts" for more note like info  

- changed to a new VM without https://xfce.org/ (needed a cleaner network environment for testing):  
  -- returned to 1 GB RAM because of the reduced load  
  -- successfully installed Elastic and Kibana on new VM following instructions on this page   
	-- Elastic/Java are using 47% RAM, no slowness observed  
	-- reviewed settings docs for Elastic and Kibana, will tweak after test data flowing  
	-- created scripts/login.sh to run "last" and "ss" on login  
	-- optimize in future: on boot, Kibana establishes 59 TCP connections to the local ElasticSearch service  

- next:  
-- import Apache log  


# 1. Elastic Search Service
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


# 2. Elastic Search Admin  

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



# 3. Kibana Service  

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


# Useful commands and scripts

```Bash
# free memory	
$ free -h   

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

# count established connections to source port
# based on ElasticStack ports
$ ss sport = :9200 or sport = :9300  |wc -l

# count established connections by pid
# based on current pid of Kibana = 5992
$ sudo ss -tup  |grep pid=5992  |wc -l

# list processes by number of established tcp connections
$ sudo ss -Hptu |awk '{print $7}' |sort |uniq -c -w25 |sort -r

# find process details by pid
$ sudo ps -ax |grep 19414
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


  
	
# Thanks To:  
https://github.com    
https://debian.org    
https://xfce.org   
https://elastic.co
https://xmodulo.com  
https://linux.com  
https://binarytides.com   