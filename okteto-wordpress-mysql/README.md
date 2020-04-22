# okteto-wordpress-mysql
Example of running [wordpress-mysql](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
on [okteto-cloud](https://cloud.okteto.com/) using pure terraform

Prerequisites
* [Terraform > 0.12](https://www.terraform.io/downloads.html)
* [Okteto Cloud account](https://cloud.okteto.com/#/login)

Steps:
1. Clone repo: `git clone git@github.com:jhole89/terraform-k8s-example.git`
2. Change to this directory: `cd okteto-wordpress-mysql`
3. Initialise terraform: `terraform init`
4. Copy tfvars template: `cp terraform.tfvars.template terraform.tfvars`
5. Fill in `terraform.tfvars` with Okteto values (found in your `okteto-kube.config` - make sure your
`okteto-kube.config` is also in your `~/.kube/config`)
6. Apply terraform plan: `terraform apply --auto-approve` - you should see the following output
    ```
    Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    frontend_url = https://wordpress-jhole89.cloud.okteto.net/
    ```
6. The plan outputs the `url` exposed through the kubernetes service. You can now hit the 
endpoint using any web browser and set up your wordpress instance.
7. Once no longer required you can remove all resources: `terraform destroy --auto-approve`
