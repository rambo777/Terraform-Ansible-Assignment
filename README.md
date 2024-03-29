# Terraform-Ansible-Assignment

Prerequisites
  - awscli installation
    https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
  - terraform installation
    https://learn.hashicorp.com/terraform/getting-started/install.html
    
# COMMANDS
  - Clone the repository :
    git clone https://github.com/rambo777/Terraform-Ansible-Assignment.git
  - Install terraform module plugin :
    terraform init
  - Execute terraform configuration :
    terraform apply
  - Remove terraform results from aws :
    terraform destroy<br>

Note - Jenkins end point will be displayed after the execution is completed in output variable.<br>
## Final Output will look like this
###  Apply complete! Resources: 24 added, 0 changed, 0 destroyed.
Outputs:

------------------COPY-PASTE-THIS-URL-BROWSER-TO-VIEW-JENKINS-----------------------<br>
[
  "jenkins-lb-1300472141.us-east-1.elb.amazonaws.com",
]<br>
azs = [
  [
    "us-east-1a",
    "us-east-1b",
  ],
]<br>
bastion-hostip = [
  "18.206.221.94",
]<br>
:<br>

# REFERENCES 
- TERRAFORM BASICS
  https://www.terraform.io/docs/cli-index.html

- VPC MODULE (for vpc creation)
  https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.15.0

- PROVISIONER  (for communication with jenkins in private subnet via bastion host)
  https://www.terraform.io/docs/provisioners/connection.html
  https://www.terraform.io/docs/provisioners/file.html
  https://www.terraform.io/docs/provisioners/remote-exec.html
  
- ANSIBLE BASICS
  https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html
  https://stackoverflow.com/questions/21160776/how-to-execute-a-shell-script-on-a-remote-server-using-ansible
  https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html
  https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
  https://docs.ansible.com/ansible/latest/user_guide/playbooks.html
  
- JENKINS INSTALLATION
  https://pkg.jenkins.io/debian-stable/
