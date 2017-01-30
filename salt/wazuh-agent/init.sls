{% if grains['os'] == 'CentOS' and grains['osrelease_info'][0] == 7 %}
wazuh_repo_Centos_7:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - Wazuh
    - baseurl: https://packages.wazuh.com/yum/el/$releasever/$basearch
    - gpgcheck: 1
    - gpgkey: https://packages.wazuh.com/key/GPG-KEY-WAZUH

{% elif grains['os'] == 'Ubuntu'  and grains['oscodename'] == 'xenial' %}
wazuh_repo_xenial:
  pkgrepo.managed:
    - humanname: Wazuh_Repo
    - name: deb http://packages.wazuh.com.s3-website-us-west-1.amazonaws.com/apt xenial main
    - dist: xenial
    - gpgcheck: 1
    - key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH
{% endif %}

wazuh-agent:
  pkg.installed: []
  service.running:
    - watch:
      - file: /var/ossec/etc/ossec.conf
    - require:
      - pkg: wazuh-agent

{# Use events/reactor system to start up the ossec-authd process on the OSSEC master #}
server-auth:
  cmd.run:
    - name: salt-call event.fire_master 'ossec-auth-start' 'ossec'
    - onlyif: file -s /var/ossec/etc/client.keys|grep empty || test ! -f /var/ossec/etc/client.keys 

{# OSSEC authd agent connects to master and registers its key #}
agent-auth:
  cmd.wait:
    - name: sleep 10 && /var/ossec/bin/agent-auth -m {{ pillar['ossec_conf_agent']['manager_ip'] }} -p 1515
    - onlyif: file -s /var/ossec/etc/client.keys|grep empty
    - watch:
      - cmd: server-auth

{# We are done creating our key so lets shut down the ossec-auth process on the master using reactor #}
server-auth-shutdown:
  cmd.wait:
    - name: salt-call event.fire_master 'ossec-auth-stop' 'ossec'
    - watch:
      - cmd: agent-auth

/var/ossec/etc/ossec.conf:
  file.managed:
    - source: salt://wazuh-agent/files/ossec.conf
    - user: root
    - template: jinja
    - group: ossec
    - mode: 440

{# Start the OSSEC services on the agent #}
wazuh-service:
  service.running:
    - enable: True
    - name: wazuh-agent
    - watch:
      - file: /var/ossec/etc/ossec.conf
      - cmd: agent-auth
    - require:
      - cmd: server-auth-shutdown
