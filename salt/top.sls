base:
  '*':
    - requirements
  'manager*':
    - wazuh-manager
    - wazuh-api
    - filebeat
  'agent*':
    - wazuh-agent
