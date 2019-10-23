{% set hostname=grains['id'] %}

{% if grains['os'] == 'CentOS' and grains['osrelease_info'][0] == 7 %}
repo_elk:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - ELK
    - baseurl: https://artifacts.elastic.co/packages/7.x/yum
    - gpgcheck: 1
    - gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch

{% elif grains['os'] == 'Ubuntu'  and grains['oscodename'] == 'xenial' %}
repo_elk:
  pkgrepo.managed:
    - humanname: Filebeat_Repo
    - name: deb https://artifacts.elastic.co/packages/7.x/apt stable main
    - dist: xenial
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

{% elif grains['os'] == 'Ubuntu'  and grains['oscodename'] == 'trusty' %}
repo_elk:
  pkgrepo.managed:
    - humanname: Filebeat_Repo
    - name: deb https://artifacts.elastic.co/packages/7.x/apt stable main
    - dist: xenial
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
{% endif %}

filebeat:
  pkg.installed: []
  service.running:
    - watch:
      - file: /etc/filebeat/filebeat.yml
      - file: /etc/filebeat/wazuh_template.yml
    - require:
      - pkg: filebeat

/etc/filebeat/filebeat.yml:
  file.managed:
    - source: salt://filebeat/files/filebeat.yml
    - user: root
    - template: jinja
    - group: root
    - mode: 640

/etc/filebeat/wazuh_template.yml:
  file.managed:
    - source: salt://filebeat/files/wazuh_template.yml
    - user: root
    - template: jinja
    - group: root
    - mode: 640
