wazuh_repo:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - Wazuh
    - baseurl: https://packages.wazuh.com/yum/el/$releasever/$basearch
    - gpgcheck: 1
    - gpgkey: https://packages.wazuh.com/key/GPG-KEY-WAZUH

/var/ossec/etc/ossec.conf:
  file.managed:
    - source: salt://wazuh-agent/files/ossec.conf
    - user: root
    - template: jinja
    - group: ossec
    - mode: 440

{# Use events/reactor system to start up the ossec-authd process on the OSSEC master #}
server-auth:
  cmd.run:
    - name: salt-call event.fire_master 'ossec-auth-start' 'ossec'
    - unless: stat /var/ossec/etc/client.keys

{# OSSEC authd agent connects to master and registers its key #}
agent-auth:
  cmd.wait:
    - name: sleep 1 && /var/ossec/bin/agent-auth -m {{ pillar['ossec_conf_agent']['manager_ip'] }} -p 1515
    - unless: stat /var/ossec/etc/client.keys
    - watch:
      - cmd: server-auth

{# We are done creating our key so lets shut down the ossec-auth process on the master using reactor #}
server-auth-shutdown:
  cmd.wait:
    - name: salt-call event.fire_master 'ossec-auth-stop' 'ossec'
    - watch:
      - cmd: agent-auth

{# Start the OSSEC services on the agent #}
ossec-service:
  service.running:
    - enable: True
    - name: wazuh-agent
    - watch:
      - file: /var/ossec/etc/ossec.conf
    - require:
      - cmd: server-auth-shutdown
