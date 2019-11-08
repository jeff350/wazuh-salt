Install Wazuh-manager and Wazuh-agent and filebeat with SaltSlack

Salt Master configuration example:

```
# Example:
file_roots:
  base:
    - /home/vagrant/wazuh-salt/salt
    - /home/vagrant/wazuh-salt/formulas

pillar_roots:
  base:
    - /home/vagrant/wazuh-salt/pillar

reactor:
  - 'ossec':
    - /home/vagrant/wazuh-salt/reactor/ossec.sls
```
