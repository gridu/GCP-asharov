Notes:
- We decided to use Terraform/Ansible stack for creation/provisioning of environment.
- We want to use IaC - infrastructure as code approach, everything should be inside Terraform/Ansible configuration files, manual changes are not allowed

List of tasks:

- [x] Install Ansible / Terraform software locally
* Packer / Terraform / Ansible installed at Docker containers

- [x] Terraform should create a cluster of 3 instances, including internal load balancer with health checks, everything should be done via terraform tf/tfstate files

- [x] Create corresponding inventory describing these machines.

- [x] Create the following playbooks that will use this inventory.

- [x] Place ssh-keys on all machines and connect to the machines using this ssh key
* made by Packer

- [x] Install Apache and start Apache service
* made by Packer

- [x] Ansible should be used to provision ~~HTTP server (Apache) with some~~ simple website ~~inside,
 whole provisioning have to be inside provisioning playbook~~

- [x] Modify website so that it will display a unique identifier (e.g. “Server #1”)

- [x] Provisioning should be performed without modules ‘script’, ‘command’, ‘shell’
every host should display server number/hostname to ensure that load balancer is working

- [x] Finally, user should be able to connect to website in HA mode via internal load balancer IP
