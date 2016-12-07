# mongodb

[![Build Status](https://travis-ci.org/infOpen/ansible-role-mongodb.svg?branch=master)](https://travis-ci.org/infOpen/ansible-role-mongodb)

Install mongodb package.

## Requirements

This role requires Ansible 2.1 or higher,
and platform requirements are listed in the metadata file.

## Testing

This role has some testing methods.

To use locally testing methods, you need to install Docker and/or Vagrant and Python requirements:

* Create and activate a virtualenv
* Install requirements

```
pip install -r requirements_dev.txt
```

### Automatically with Travis

Tests runs automatically on Travis on push, release, pr, ... using docker testing containers

### Locally with Docker

You can use Docker to run tests on ephemeral containers.

```
make test-docker
```

### Locally with Vagrant

You can use Vagrant to run tests on virtual machines.

```
make test-vagrant
```

## Role Variables

### Default role variables

``` yaml
# Choice your MongoDB edition
# Possible choices:
# * org (community)
# * enterprise
mongodb_edition: 'org'
mongodb_version: '3.2'


# MongoDB APT installation variables
mongodb_apt_keyserver: "{{ _mongodb_apt_keyserver | default ('') }}"
mongodb_apt_key: "{{ _mongodb_apt_key | default('') }}"
mongodb_apt_file_name: "mongodb-{{ mongodb_edition }}.list"
mongodb_apt_file_mode: '0644'
mongodb_apt_entries: "{{ _mongodb_apt_entries | default([]) }}"
mongodb_apt_update_cache: True
mongodb_apt_cache_valid_time: 3600
mongodb_apt_force: True


# MongoDB packages
mongodb_additional_packages: "{{ _mongodb_additional_packages }}"
mongodb_packages_all: "{{ _mongodb_packages_all }}"
mongodb_packages_server: "{{ _mongodb_packages_server }}"
mongodb_packages_mongos: "{{ _mongodb_packages_mongos }}"
mongodb_packages_shell: "{{ _mongodb_packages_shell }}"
mongodb_packages_tools: "{{ _mongodb_packages_tools }}"


# Roles to install
mongodb_install_additional: True
mongodb_install_all: True
mongodb_install_server: True
mongodb_install_mongos: True
mongodb_install_shell: True
mongodb_install_tools: True


# Default instance management
mongodb_default_instance: "{{ _mongodb_default_instance }}"
mongodb_default_instance_disabled: True
mongodb_default_instance_removed: False


# Main user
mongodb_user: "{{ _mongodb_user }}"
mongodb_group: "{{ _mongodb_group }}"


# Paths
mongodb_base_folders_paths:
  config: "{{ _mongodb_os_base_config_path }}/mongodb"
  data: "{{ _mongodb_os_base_data_path }}/mongodb"
  log: "{{ _mongodb_os_base_log_path }}/mongodb"
  logrotate: "{{ _mongodb_os_base_logrotate_path }}"
  upstart: "{{ _mongodb_os_base_upstart_path | default('') }}"
  run: "{{ _mongodb_os_base_run_path }}/mongodb"
  systemd_services: "{{ _mongodb_os_base_systemd_services_path | default('') }}"


# MongoDB configuration
mongodb_instances:
  - type: 'mongod'
    config: "{{ _mongodb_config_mongod }}"
    state: 'present'
    enabled: True


# Services management
mongodb_is_upstart_management: "{{ _mongodb_is_upstart_management | default(False) }}"
mongodb_is_systemd_management: "{{ _mongodb_is_systemd_management | default(False) }}"


# Logrotate management
# Create option is manage inside template
mongodb_logrotate_options:
  - 'daily'
  - 'dateext'
  - 'dateformat _%Y-%m-%d'
  - 'rotate 31'
  - 'copytruncate'
  - 'compress'
  - 'delaycompress'
  - 'missingok'
```

## How ...

### Install all packages

Only set ***mongodb_install_all*** to ***True***, and role will use meta package.
It is the default value without custom settings

### Only install some roles

1. Set ***mongodb_install_all*** to ***False***
2. Set needed roles to ***True*** and ***False*** to others for these items:
```yaml
mongodb_install_server: True
mongodb_install_mongos: True
mongodb_install_shell: True
mongodb_install_tools: True
```

## Dependencies

None

## Example Playbook

    - hosts: servers
      roles:
         - { role: infOpen.mongodb }

## License

MIT

## Author Information

Alexandre Chaussier (for Infopen company)
- http://www.infopen.pro
- a.chaussier [at] infopen.pro

