__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
# Networking_dbs
This is for Networking Assignment-DBS-MSC ISC  

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

~by ZISHAN HASSAN KHAN

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

README: Automation Workflow for Ansible Playbook and Terraform
__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
Purpose
This automation workflow provisions a virtual machine (VM) in Azure using Terraform and configures it as a web server running Apache inside a Docker container using an Ansible playbook.
__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
Overview of the Workflow


Terraform Module:

Creates Azure resources: Resource Group, Virtual Network, Subnets (Public/Private), Public IP, Network Interfaces, Network Security Groups.

Deploys an Ubuntu-based Linux VM with both public and private IPs.

Generates an Ansible inventory file containing the public IP for VM configuration.


Ansible Playbook:

Connects to the VM via SSH (using the public IP and a private SSH key).

Updates the operating system, installs Docker, and deploys an Apache web server inside a Docker container.

Copies a sample website to the Apache server.

Terraform Steps
Resource Group Creation:

Creates a new Azure Resource Group for organizing resources.

Networking:

Configures a Virtual Network with public and private subnets.

Associates subnets with appropriate Network Security Groups (NSGs) for controlling traffic.

VM Deployment:

Provisions a Linux VM with SSH key-based authentication.

Attaches the public and private network interfaces.

Ansible Inventory File:

Outputs a dynamically generated inventory file pointing to the public IP of the VM.

Ansible Steps
Update and Prepare Environment:

Updates Ubuntu packages.

Installs and configures Docker.

Apache Web Server Deployment:

Pulls the Apache Docker image from Docker Hub.

Deploys the container with port mapping (80:80).

Website Hosting:

Copies website files from the host to the container.

Usage Instructions
Run terraform init and terraform apply to provision Azure infrastructure.

Navigate to the ansible directory and execute the playbook:

bash
ansible-playbook -i inventory.ini playbook.yml
Access the deployed website using the public IP.
