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

