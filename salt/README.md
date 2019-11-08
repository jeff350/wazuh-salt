Install Wazuh-manager and Wazuh-agent with SaltSlack

### Setting up the environment

1. Install salt-master and salt-minions where necessary.

2. Point minions to the Salt master, edit `/etc/salt/minion` and restart minions.
```
master: <MASTER-IP>
```

3. In the Salt master, accept the minions incoming keys:

```
salt-key -A
```

4. Test connection with the minions:
```
salt '*' test.ping
```

5. Clone the wazuh-salt repository:

```
git clone https://github.com/wazuh/wazuh-salt
```

6. Set file_roots, edit `/etc/salt/master` file:

```
file_roots:
  base:
    - /home/vagrant/wazuh-salt/salt
    - /srv/formulas

pillar_roots:
  base:
    - /home/vagrant/wazuh-salt/pillar
```

7. Modify the `top.sls` file to point minions:

```
base:
  '*':
    - requirements
  'manager':
    - wazuh-manager
    - wazuh-api
    - filebeat
  'agents*':
    - wazuh-agent
```

8. Install Wazuh manager:

```
salt 'manager' state.apply
```

9. Install wazuh agents:

```
salt 'agents*' state.apply
```
