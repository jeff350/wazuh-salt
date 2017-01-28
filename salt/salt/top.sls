base:
  '*':
    - requirements
  'manager*':
    - wazuh-manager
    - wazuh-api
  'agent*':
    - wazuh-agent
