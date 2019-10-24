ossec_conf_agent:
  manager_ip: 172.16.0.15
  manager_port: 1514
  protocol: tcp


  osquery:
    - disabled: 'yes'
    - run_daemon: 'yes'
    - log_path: '/var/log/osquery/osqueryd.results.log'
    - config_path: '/etc/osquery/osquery.conf'
    - add_labels: 'yes'

  syscheck:
    syscheck_frequency_check: 72000
    ignore_files:
      - /etc/mnttab
    directories:
      - check_all: 'yes'
        dirs: /etc,/usr/bin,/usr/sbin
      - check_all: 'yes'
        dirs: /bin,/sbin
      - check_all: 'yes'
        dirs: '/home'
        recursion_level: 2
        whodata: 'yes'
        realtime: 'no'

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

