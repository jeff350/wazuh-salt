nodejs_repo:
  pkgrepo.managed:
    - humanname: Node.js Packages for Enterprise Linux 7 - $basearch
    - baseurl: https://rpm.nodesource.com/pub_6.x/el/7/$basearch
    - gpgcheck: 1
    - gpgkey: https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL

nodejs.packages:
  pkg.installed:
    - fromrepo: nodejs_repo
    - pkgs:
      - nodejs

wazuh-api.packages:
  pkg.installed:
    - pkgs:
      - wazuh-api
