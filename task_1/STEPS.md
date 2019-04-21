1) Configure GCP account: make JSON key and place it to local env
  - export GCE_PROJECT_ID, GCE_CREDENTIALS
  - autorize in gcloud by the next command: `gcloud auth login`
2) Go to the Packer directory
  - Execute `export SSH_PUBKEY`. This key will be used for access to servers via SSH.
  - Run build by the next command: `packer build template.json`.
3) Go to the Terraform directory
  - Change values in `backend.tf` and `terraform.tfvars`
  - Deploy infra by `terraform apply`
  - Copy IP of LB from output
  - Generate Ansible inventory by the next command: `bash generate_inventory.sh <SSH_KEY_PATH>`
4) Go to the Ansible directory
  - Put website to servers by the next command: `ansible-playbook -v -i inventory httpd.yaml`
5) Execute bash sript for test LB:
  - `bash check.sh <LB>`
