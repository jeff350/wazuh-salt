ossec_conf_agent:
  manager_ip: 192.168.212.136
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
  localfiles:
    - format: 'syslog'
      location: '/var/log/messages'
    - format: 'syslog'
      location: '/var/log/secure'
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
  localfiles_agent:
    - format: 'syslog'
      location: '/var/log/messages_manager'
    - format: 'syslog'
      location: '/var/log/secure'

