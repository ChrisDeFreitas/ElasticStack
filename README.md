# ElasticStack (estack) Configuration
- definition of ElasticStack: https://www.elastic.co/what-is/elk-stack
- this repository contains notes and scripts used to install and configure ElasticStack on a Debian 10 virtual machine.
- hope to monitor network activity, custom applications and logins
- expect that the search and archiving features will be leveraged to support custom applications
- this is another of my archives of generally useful information that I don't want to lose 
- work in progress...


# References
https://www.xmodulo.com/install-elk-stack-ubuntu.html  
https://www.elastic.co/what-is/elk-stack  


# Test Host
- Debian 10 
- VMWare Virtual Machine
- Xfce
- 2 GB Ram, 50 GB Disk



# 0. General
- after the initial installation of ElasticSearch and Kibana the VM slowed down substantially.  The slowness is also affecting other applications on the host computer.  I expect it is due to the JVM and the system requiring general optimization.  As fresh install there are probably services that should be turned off and the estack components do require tuning for the environment.  But I also expect that the JVM is 80% of the problem.
-- after disabling a bunch of services xfce was still slow.
-- updated to 2 GB RAM resolved slowness; still need to configure JVM and new apps and test again with 1 GB RAM.


# 1. Elastic Search Service
Source: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-repo 

This process allows elastic search to be run as a daemon:  
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -  
$ sudo apt-get install apt-transport-https  
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list  
$ sudo apt-get update && sudo apt-get install elasticsearch  


Configure deamon to start automatically:
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



# 3. Kabana Service  

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

Apache Log Monitoring  
http://localhost:5601/app/home#/tutorial/apacheLogs  
  

```Bash
#Status of all services
$ sudo systemctl  
$ sudo systemctl --type=service 
$ sudo systemctl --type=service --state=active
# list startup services only (https://www.linux.com/topic/desktop/cleaning-your-linux-startup-process/)
$ sudo systemctl list-unit-files --type=service | grep enabled
```  

```Bash
#Disabled services
$ sudo systemctl stop    avahi-daemon.socket
$ sudo systemctl disable avahi-daemon.socket
$ sudo systemctl stop    avahi-daemon.service
$ sudo systemctl disable avahi-daemon.service
$ sudo systemctl stop    ModemManager.service
$ sudo systemctl disable ModemManager.service
$ sudo systemctl stop    dbus-org.freedesktop.ModemManager1.service
$ sudo systemctl disable dbus-org.freedesktop.ModemManager1.service
$ sudo systemctl stop    dbus-org.freedesktop.nm-dispatcher.service
$ sudo systemctl disable dbus-org.freedesktop.nm-dispatcher.service
$ sudo systemctl stop    dbus-org.freedesktop.timesync1.service
$ sudo systemctl disable dbus-org.freedesktop.timesync1.service
$ sudo systemctl stop    wpa_supplicant.service
$ sudo systemctl disable wpa_supplicant.service
$ sudo systemctl stop    dbus-fi.w1.wpa_supplicant1.service
$ sudo systemctl disable dbus-fi.w1.wpa_supplicant1.service
$ sudo systemctl stop    pppd-dns.service
$ sudo systemctl disable pppd-dns.service
```  

```Bash
#Service ports
$ sudo netstat -ltup | grep java
$ sudo netstat -ltup | grep kibana
```  



  
# Thanks To:  
https://github.com    
https://debian.org    
https://xfce.org   
https://elastic.co
https://xmodulo.com
https://www.linux.com