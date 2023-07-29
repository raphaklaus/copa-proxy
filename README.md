# Proxy Server

Copy `.sample.env.config.cjs` to `.env.config.cjs` with the credentials needed.

* Terraform it with:
  * `cd terraform/`
  * `terraform init`
  * `terraform apply` 
* Provision with Ansible, in the root directory: `ansible-playground -i terraform/hosts playbook.yml`
