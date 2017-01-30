{% set hostname=grains['id'] %}

wazuh_repo:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - Wazuh
    - baseurl: https://packages.wazuh.com/yum/el/$releasever/$basearch
    - gpgcheck: 1
    - gpgkey: https://packages.wazuh.com/key/GPG-KEY-WAZUH

wazuh-manager:
  pkg.installed: []
  service.running:
    - watch:
      - file: /var/ossec/etc/ossec.conf
      - file: /var/ossec/etc/rules/local_rules.xml
    - require:
      - pkg: wazuh-manager

/var/ossec/etc/ossec.conf:
  file.managed:
    - source: salt://wazuh-manager/files/ossec.conf
    - user: root
    - template: jinja
    - group: ossec
    - mode: 640

/var/ossec/etc/shared/agent.conf:
  file.managed:
    - source: salt://wazuh-manager/files/agent.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644

rules-config:
  file.managed:
    - name: /var/ossec/etc/rules/local_rules.xml
    - user: root
    - group: ossec
    - mode: 550
    - source: salt://wazuh-manager/files/local_rules.xml

ssl-key:
  cmd.run:
    - name: openssl genrsa -out /var/ossec/etc/sslmanager.key 2048
    - unless: stat /var/ossec/etc/sslmanager.key

ssl-cert:
  cmd.run:
    - name: openssl req -subj
            '/CN={{ hostname }}
            /C={{ pillar['service-openssl']['countrynamedefault'] -}}
            /ST={{ pillar['service-openssl']['stateorprovincenamedefault'] -}}
            /O={{ pillar['service-openssl']['orgnamedefault'] }}'
            -new -x509 -key /var/ossec/etc/sslmanager.key
            -out /var/ossec/etc/sslmanager.cert
            -days 730
    - unless: stat /var/ossec/etc/sslmanager.cert
    - onlyif: stat /var/ossec/etc/sslmanager.key

