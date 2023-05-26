# ansible-znas
Ansible script that sets up NAS server with multiple users, Samba shared folders, Sonarr, qBittorrent, Borg Backup, Syncthing.

Steps:

1. Install Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
2. Run `ansible-galaxy collection install -r requirements.yml` in console to install required modules
3. Copy inventory.sample.yml as inventory.yml and change values inside
4. Copy backup.sample.sh as backup.sh and change values inside
5. Copy host_vars/znas.sample.yml as host_vars/znas.yml and change values inside
6. Match the number of users in samba.yml under path vars.samba_users to number of users in your znas.yml
7. Verify that you can do SSH connection to your server
8. Run the Ansible against your server
   1. `ansible-playbook -i inventory.yml all.yml` for all updates
   2. or `ansible-playbook -i inventory.yml system.yml` for only one section
