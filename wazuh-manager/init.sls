wazuh_repo:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - Wazuh
    - baseurl: http://ossec.wazuh.com/el/$releasever/$basearch
    - gpgcheck: 1
    - gpgkey: http://ossec.wazuh.com/key/RPM-GPG-KEY-OSSEC

wazuh-manager:
  pkg.installed: []
  service.running:
    - watch:
      - file: /var/ossec/etc/ossec.conf
    - require:
      - pkg: wazuh-manager

/var/ossec/etc/ossec.conf:
  file.managed:
    - source: salt://wazuh-manager/files/ossec.conf
    - user: root
    - group: ossec
    - mode: 640

