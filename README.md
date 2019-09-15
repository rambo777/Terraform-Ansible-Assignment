# Terraform-Ansible-Assignment

Prerequisites
  - awscli installation
    https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
  - terraform installation
    https://learn.hashicorp.com/terraform/getting-started/install.html
    
# COMMANDS
Clone the repository
  - git clone https://github.com/rambo777/Terraform-Ansible-Assignment.git
Install terraform module plugin
  - terraform init
Execute terraform configuration
  - terraform apply
Remove terraform results from aws
  - terraform destroy

Note - Jenkins end point will be displayed after the execution is completed in output variable.
## Final Output will look like this
##  Apply complete! Resources: 24 added, 0 changed, 0 destroyed.
==================================================================================================================================
Outputs:

###I---------------------------------------COPY-PASTE-THIS-URL-BROWSER-TO-VIEW-JENKINS---------------------------------------I = [
  "jenkins-lb-1300472141.us-east-1.elb.amazonaws.com",
]
azs = [
  [
    "us-east-1a",
    "us-east-1b",
  ],
]
bastion-hostip = [
  "18.206.221.94",
]
:
:
====================================================================================================================================
# REFERENCES 
- TERRAFORM BASICS
  https://www.terraform.io/docs/cli-index.html

- VPC MODULE (for vpc creation)
  https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.15.0

- PROVISIONER  (for communication with jenkins in private subnet via bastion host)
  https://www.terraform.io/docs/provisioners/connection.html
  https://www.terraform.io/docs/provisioners/file.html
  https://www.terraform.io/docs/provisioners/remote-exec.html
  
 -ANSIBLE BASICS
