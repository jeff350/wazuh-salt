base:
  '*':
    - requirements
  'manager1*':
    - wazuh-manager
    - wazuh-api
  'manager2*':
    - wazuh-agent
