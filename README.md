# Wazuh-Salt

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://wazuh.com/community/join-us-on-slack/)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/wazuh)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.wazuh.com)
[![Documentation](https://img.shields.io/badge/web-view-green.svg)](https://wazuh.com)

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
