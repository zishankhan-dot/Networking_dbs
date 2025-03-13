# README - Terraform + Ansible + GitHub Runner Automation  

## Overview  
This setup automates the provisioning of an Azure infrastructure using Terraform, followed by software configuration using Ansible, and local automation with GitHub Runner.  

Terraform provisions:  
- **1 Resource Group**  
- **1 Virtual Network**  
- **2 Subnets** (Public & Private)  
- **1 Static Public IP**  
- **2 Network Interfaces (NICs)**  
- **2 Network Security Groups (NSGs)** (Associated with NICs)  
- **1 Virtual Machine** (Ubuntu latest image)  

Ansible is executed **after** Terraform completes to:  
- Install **Docker**  
- Pull the **Apache HTTP Server** image  
- Upload `index.html` from `/webpage/`  
- Serve the webpage using **Docker**  

## Prerequisites  

### 1. Generate SSH Key  
Run the following command to create an SSH key pair:  
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```
- Upload the **private key** to **GitHub Secrets**  
- Copy the **public key** to `~/.ssh/` on your local system  

### 2. Upload Webpage  
Place your `index.html` in:  
```
/webpage/index.html
```

### 3. Install Dependencies on Local Runner  
Ensure the GitHub Runner has:  
```bash
sudo apt update && sudo apt install -y unzip nodejs
```

## Terraform Workflow  

### 1. Initialize Terraform  
```bash
terraform init
```

### 2. Apply Terraform Configuration  
```bash
terraform apply -auto-approve
```
- This will create `instruction.ini`, which Ansible will use to SSH into the VM.  
- Terraform state is cached in the runner by default (can be disabled in `.github/workflows/terraform` by commenting the relevant lines).  

### 3. Terraform Output  
Terraform outputs are stored in `output.tf` and include:  
- **Public IP** of the VM  
- **Resource group & networking details**  

## Ansible Workflow  
Once Terraform completes, run:  
```bash
ansible-playbook -i instruction.ini playbook.yml
```
This will:  
- SSH into the VM  
- Install Docker  
- Pull the **Apache HTTP Server** image  
- Deploy `index.html` from `/webpage/`  

## Notes  
- The `main.tf` file also generates `instruction.ini` dynamically.  
- Ensure **Ansible** is installed on your local system.  
- If the Terraform state should **not** be cached, modify `.github/workflows/terraform`.  

## Cleanup  
To destroy resources:  
```bash
terraform destroy -auto-approve
```  

This setup ensures seamless provisioning, configuration, and hosting of a static website using Terraform, Ansible, and GitHub Runner.



testRUN-1
