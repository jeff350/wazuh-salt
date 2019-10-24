{% if data['data'] == 'ossec-auth-start' %}
ossec-auth-start:
  local.cmd.run:
    - tgt: 'manager1'
    - arg:
      - /var/ossec/bin/ossec-authd -p 1515 >/dev/null 2>&1 &
{% endif %}
