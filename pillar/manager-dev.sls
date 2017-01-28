ossec_server_config:
  mail_to:
    - jose@wazuh.com
  mail_smtp_server: localhost
  mail_from: ossec@wazuh.com
  frequency_check: 72000
  ignore_files:
    - /etc/mtab
    - /etc/mnttab
    - /etc/hosts.deny
  directories:
    - check_all: 'yes'
      dirs: /etc,/usr/bin,/usr/sbin
    - check_all: 'yes'
      dirs: /bin,/sbin
  globals:
    - '127.0.0.1'
    - '192.168.2.1'
  localfiles:
    - format: 'syslog'
      location: '/var/log/messages'
    - format: 'syslog'
      location: '/var/log/secure'
  connection: 'secure'
  log_level: 1
  email_level: 7
  commands:
    - name: 'host-deny'
      executable: 'host-deny.sh'
      expect: 'srcip'
      timeout_allowed: 'yes'
  active_responses:
    - command: 'host-deny'
      location: 'local'
      level: 6
      timeout: 600
  localfiles_manager:
    - format: 'syslog'
      location: '/var/log/messages_manager'
    - format: 'syslog'
      location: '/var/log/secure'


shared_agents:
  - type: os
    type_value: linux
    frequency_check: 71200
    ignore_files:
      - /etc/mtab
      - /etc/mnttab
      - /etc/hosts.deny
      - /etc/mail/statistics
      - /etc/svc/volatile
    directories:
      - check_all: yes
        dirs: /etc,/usr/bin,/usr/sbin
      - check_all: yes
        dirs: /bin,/sbin
    localfiles:
      - format: 'syslog'
        location: '/var/log/messages'
      - format: 'syslog'
        location: '/var/log/secure'
      - format: 'syslog'
        location: '/var/log/maillog'
      - format: 'apache'
        location: '/var/log/httpd/error_log'
      - format: 'apache'
        location: '/var/log/httpd/access_log'
      - format: 'apache'
        location: '/var/ossec/logs/active-responses.log'
