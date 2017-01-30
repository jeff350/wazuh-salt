Install Wazuh-manager and Wazuh-agent with SaltSlack

Salt Master configuration example:

```
# Example:
file_roots:
  base:
    - /srv/salt
    - /srv/formulas

pillar_roots:
  base:
    - /srv/pillar

reactor:
  - 'ossec':
    - /srv/reactor/ossec.sls
```
