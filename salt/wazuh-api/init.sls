nodejs_repo:
  pkgrepo.managed:
    - humanname: Node.js Packages for Enterprise Linux 7 - $basearch
    - baseurl: https://rpm.nodesource.com/pub_4.x/el/7/$basearch
    - gpgcheck: 1
    - gpgkey: https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL

nodejs.packages:
  pkg.installed:
    - fromrepo: nodejs_repo
    - pkgs:
      - nodejs

python-pip.packages:
  pkg.installed:
    - pkgs:
      - python-pip

xmljson:
  pip.installed:
    - name: xmljson

wazuh-api:
  archive.extracted:
    - name: /var/ossec/
    - source: https://github.com/wazuh/wazuh-API/archive/v1.2.1.tar.gz
    - source_hash: md5=4531ea1bbd9d62f3b601001d997f1e52
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /var/ossec/api/

mv /var/ossec/wazuh-API-1.2.1 /var/ossec/api:
  cmd.run:
    - unless: stat /var/ossec/api

npm install:
  cmd.run:
    - cwd: /var/ossec/api
    - unless: stat /var/ossec/api/node_modules

run install_api_service:
  cmd.run:
    - name: /var/ossec/api/scripts/install_daemon.sh
    - unless: stat /etc/systemd/system/wazuh-api.service

wazuh-api-service:
  service.running:
    - name: wazuh-api
    - enable: True
    - reload: True 
