{% set hostname=grains['id'] %}
{% if grains['os'] == 'CentOS' and grains['osrelease_info'][0] == 7 %}
wazuh_repo_Centos_7:
  pkgrepo.managed:
    - humanname: Wazuh repository
    - baseurl: https://packages.wazuh.com/3.x/yum/
    - gpgcheck: 1
    - gpgkey: https://packages.wazuh.com/key/GPG-KEY-WAZUH

{% elif grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' %}
wazuh_repo_xenial:
  pkgrepo.managed:
    - humanname: Wazuh repository
    - name: deb https://packages.wazuh.com/3.x/apt/ xenial main
    - dist: xenial
    - gpgcheck: 1
    - key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH
{% elif grains['os'] == 'Ubuntu' and grains['oscodename'] == 'trusty' %}
wazuh_repo_trusty:
  pkgrepo.managed:
    - humanname: Wazuh repository
    - name: deb https://packages.wazuh.com/3.x/apt/ trusty main
    - dist: trusty
    - gpgcheck: 1
    - key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH
{% elif grains['os'] == 'Ubuntu' and grains['oscodename'] == 'bionic' %}
wazuh_repo_bionic:
  pkgrepo.managed:
    - humanname: Wazuh repository
    - name: deb https://packages.wazuh.com/3.x/apt/ bionic main
    - dist: bionic
    - gpgcheck: 1
    - key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH
{% elif grains['os'] == 'Ubuntu' and grains['oscodename'] == 'stretch' %}
wazuh_repo_stretch:
  pkgrepo.managed:
    - humanname: Wazuh repository
    - name: deb https://packages.wazuh.com/3.x/apt/ stretch main
    - dist: stretch
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

{% if {{ pillar['ossec_conf_agent']['register_agent'] }} == 'yes'  %}
{# OSSEC authd agent connects to master and registers its key #}
agent-auth:
  cmd.wait:
    - name: sleep 10 && /var/ossec/bin/agent-auth -m {{ pillar['ossec_conf_agent']['manager_ip'] }} -p 1515
    - onlyif: file -s /var/ossec/etc/client.keys|grep empty
    - watch:
      - cmd: server-auth
{% endif %}

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
