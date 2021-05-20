# ElasticStack
- work in progress
- will contain notes and scripts used to install and configure ElasticStack, estack, for monitoring logins and app executions  


# References
https://www.xmodulo.com/install-elk-stack-ubuntu.html  
https://www.elastic.co/what-is/elk-stack  


# Test Host
- Debian 10 
- VMWare Virtual Machine
- Xfce
- 1 GB Ram, 50 GB Disk

# 1. Elastic Search Daemon
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

Configure daemon:   
https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-configuring  
https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html  

Test daemon up:  
$ curl -X GET "localhost:9200/?pretty"  
Source: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-check-running  

Directory layout:  
https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-layout  

Security settings:  
https://www.elastic.co/guide/en/elasticsearch/reference/current/auditing-settings.html  

# 3. Kabana  

Install:  
https://www.elastic.co/guide/en/kibana/7.12/deb.html#deb-repo  
$ sudo apt-get install apt-transport-https  
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list  
$ sudo apt-get update && sudo apt-get install kibana  
  
Daemon auto-start:  
sudo /bin/systemctl daemon-reload  
sudo /bin/systemctl enable kibana.service  
  
Daemon start/stop:  
sudo systemctl start kibana.service  
sudo systemctl stop kibana.service  
  
Settings:  
https://www.elastic.co/guide/en/kibana/7.12/settings.html  
  
Test daemon up:  
1. Forward port 5601 to local host  
2. Browse:   
http://localhost:5601  
http://localhost:5601/app/kibana_overview#/  

# Apache Log Monitoring  
http://localhost:5601/app/home#/tutorial/apacheLogs  
  
  
  
# Thanks To:  
https://github.com    
https://debian.org    
https://xfce.org   
